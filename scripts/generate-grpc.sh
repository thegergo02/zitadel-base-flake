#!/bin/sh
set -xeu

echo "Generating GRPC code..."

# generate go stub and grpc code for all files
protoc \
  -I=${PROTO_INC_PATH} \
  --go_out $GOPATH/src \
  --go-grpc_out $GOPATH/src \
  $(find ${PROTO_ZITADEL_PATH} -iname *.proto)

# generate authoptions code from templates
go-bindata \
  -pkg main \
  -prefix internal/protoc/protoc-gen-authoption \
  -o ${ZITADEL_PATH}/internal/protoc/protoc-gen-authoption/templates.gen.go \
  ${ZITADEL_PATH}/internal/protoc/protoc-gen-authoption/templates

#AUTHOPTION_PATH=${ZITADEL_PATH}/internal/protoc/protoc-gen-authoption
#pushd ${AUTHOPTION_PATH}
#go generate generate.go
#go-bindata -pkg main -o templates.gen.go templates
#go generate authoption.go
#protoc -I. -I$GOPATH/src --go-grpc_out=$GOPATH/src authoption/options.proto
#go build .
#popd
#PATH=${AUTHOPTION_PATH}:$PATH

# output folder for openapi v2
mkdir -p ${OPENAPI_PATH}
mkdir -p ${DOCS_PATH}

# generate additional output
protoc \
  -I=${PROTO_INC_PATH} \
  --grpc-gateway_out ${GOPATH}/src \
  --grpc-gateway_opt logtostderr=true \
  --openapiv2_out ${OPENAPI_PATH} \
  --openapiv2_opt logtostderr=true \
  --authoption_out ${GRPC_PATH}/admin \
  --validate_out=lang=go:${GOPATH}/src \
  ${PROTO_ZITADEL_PATH}/admin.proto
# authoptions are generated into the wrong folder
mv ${ZITADEL_PATH}/pkg/grpc/admin/zitadel/* ${ZITADEL_PATH}/pkg/grpc/admin
rm -r ${ZITADEL_PATH}/pkg/grpc/admin/zitadel
protoc \
  -I=${PROTO_INC_PATH} \
  --grpc-gateway_out ${GOPATH}/src \
  --grpc-gateway_opt logtostderr=true \
  --grpc-gateway_opt allow_delete_body=true \
  --openapiv2_out ${OPENAPI_PATH} \
  --openapiv2_opt logtostderr=true \
  --openapiv2_opt allow_delete_body=true \
  --authoption_out ${GRPC_PATH}/management \
  --validate_out=lang=go:${GOPATH}/src \
  ${PROTO_ZITADEL_PATH}/management.proto
# authoptions are generated into the wrong folder
mv ${ZITADEL_PATH}/pkg/grpc/management/zitadel/* ${ZITADEL_PATH}/pkg/grpc/management
rm -r ${ZITADEL_PATH}/pkg/grpc/management/zitadel
protoc \
  -I=${PROTO_INC_PATH} \
  --grpc-gateway_out ${GOPATH}/src \
  --grpc-gateway_opt logtostderr=true \
  --grpc-gateway_opt allow_delete_body=true \
  --openapiv2_out ${OPENAPI_PATH} \
  --openapiv2_opt logtostderr=true \
  --openapiv2_opt allow_delete_body=true \
  --authoption_out=${GRPC_PATH}/auth \
  --validate_out=lang=go:${GOPATH}/src \
  ${PROTO_ZITADEL_PATH}/auth.proto
# authoptions are generated into the wrong folder
mv ${ZITADEL_PATH}/pkg/grpc/auth/zitadel/* ${ZITADEL_PATH}/pkg/grpc/auth
rm -r ${ZITADEL_PATH}/pkg/grpc/auth/zitadel
## generate docs
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,auth.md \
  ${PROTO_ZITADEL_PATH}/auth.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,management.md \
  ${PROTO_ZITADEL_PATH}/management.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,admin.md \
  ${PROTO_ZITADEL_PATH}/admin.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,action.md \
  ${PROTO_ZITADEL_PATH}/action.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,app.md \
  ${PROTO_ZITADEL_PATH}/app.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,auth_n_key.md \
  ${PROTO_ZITADEL_PATH}/auth_n_key.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,change.md \
  ${PROTO_ZITADEL_PATH}/change.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,idp.md \
  ${PROTO_ZITADEL_PATH}/idp.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,member.md \
  ${PROTO_ZITADEL_PATH}/member.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,message.md \
  ${PROTO_ZITADEL_PATH}/message.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,metadata.md \
  ${PROTO_ZITADEL_PATH}/metadata.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,object.md \
  ${PROTO_ZITADEL_PATH}/object.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,options.md \
  ${PROTO_ZITADEL_PATH}/options.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,org.md \
  ${PROTO_ZITADEL_PATH}/org.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,policy.md \
  ${PROTO_ZITADEL_PATH}/policy.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,project.md \
  ${PROTO_ZITADEL_PATH}/project.proto
  protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,text.md \
  ${PROTO_ZITADEL_PATH}/text.proto
protoc \
  -I=${PROTO_INC_PATH} \
  --doc_out=${DOCS_PATH} --doc_opt=${PROTO_ZITADEL_PATH}/docs/zitadel-md.tmpl,user.md \
  ${PROTO_ZITADEL_PATH}/user.proto

echo "Generated GRPC code."
