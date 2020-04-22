Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F1F1B3FF9
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbgDVKmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730108AbgDVKUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:20:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D713820784;
        Wed, 22 Apr 2020 10:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550832;
        bh=Gqglel3VWWVrZC/6kFFL/p3h0vWJ/7YVXMFCIsSMLSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4qnvhANLA7v5hyDerw9ZCAnRdV9muTuG8faT0RU9Z2o4hriYLxVwh0PlLmXN9Jx0
         5zltJvDCC+7YEh1xXXAarj8Tsu6R2wT1jsHN1tkYM09Cb/lvkCsJbyTr+SAeDgYwpp
         VK5d+R3PjzIaJqhH+DnUPwIe5lnAfjkRWRt2rKPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/118] ACPICA: Fixes for acpiExec namespace init file
Date:   Wed, 22 Apr 2020 11:57:25 +0200
Message-Id: <20200422095045.304634195@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

[ Upstream commit 9a1ae80412dcaa67a29eecf19de44f32b5f1c357 ]

This is the result of squashing the following ACPICA commit ID's:
6803997e5b4f3635cea6610b51ff69e29d251de3
f31cdf8bfda22fe265c1a176d0e33d311c82a7f7

This change fixes several problems with the support for the
acpi_exec namespace init file (-fi option). Specifically, it
fixes AE_ALREADY_EXISTS errors, as well as various seg faults.

Link: https://github.com/acpica/acpica/commit/f31cdf8b
Link: https://github.com/acpica/acpica/commit/6803997e
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/acnamesp.h |  2 ++
 drivers/acpi/acpica/dbinput.c  | 16 +++++++---------
 drivers/acpi/acpica/dswexec.c  | 33 ++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/dswload.c  |  2 --
 drivers/acpi/acpica/dswload2.c | 35 ++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/nsnames.c  |  6 +-----
 drivers/acpi/acpica/utdelete.c |  9 +++++----
 7 files changed, 83 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/acpica/acnamesp.h b/drivers/acpi/acpica/acnamesp.h
index 7da1864798a0e..ecaa28733dc61 100644
--- a/drivers/acpi/acpica/acnamesp.h
+++ b/drivers/acpi/acpica/acnamesp.h
@@ -256,6 +256,8 @@ u32
 acpi_ns_build_normalized_path(struct acpi_namespace_node *node,
 			      char *full_path, u32 path_size, u8 no_trailing);
 
+void acpi_ns_normalize_pathname(char *original_path);
+
 char *acpi_ns_get_normalized_pathname(struct acpi_namespace_node *node,
 				      u8 no_trailing);
 
diff --git a/drivers/acpi/acpica/dbinput.c b/drivers/acpi/acpica/dbinput.c
index 55a7e10998d87..1ef053585bbb8 100644
--- a/drivers/acpi/acpica/dbinput.c
+++ b/drivers/acpi/acpica/dbinput.c
@@ -464,16 +464,14 @@ char *acpi_db_get_next_token(char *string,
 		return (NULL);
 	}
 
-	/* Remove any spaces at the beginning */
+	/* Remove any spaces at the beginning, ignore blank lines */
 
-	if (*string == ' ') {
-		while (*string && (*string == ' ')) {
-			string++;
-		}
+	while (*string && isspace(*string)) {
+		string++;
+	}
 
-		if (!(*string)) {
-			return (NULL);
-		}
+	if (!(*string)) {
+		return (NULL);
 	}
 
 	switch (*string) {
@@ -551,7 +549,7 @@ char *acpi_db_get_next_token(char *string,
 
 		/* Find end of token */
 
-		while (*string && (*string != ' ')) {
+		while (*string && !isspace(*string)) {
 			string++;
 		}
 		break;
diff --git a/drivers/acpi/acpica/dswexec.c b/drivers/acpi/acpica/dswexec.c
index d75aae3045958..a68237b97c4c8 100644
--- a/drivers/acpi/acpica/dswexec.c
+++ b/drivers/acpi/acpica/dswexec.c
@@ -16,6 +16,9 @@
 #include "acinterp.h"
 #include "acnamesp.h"
 #include "acdebug.h"
+#ifdef ACPI_EXEC_APP
+#include "aecommon.h"
+#endif
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dswexec")
@@ -329,6 +332,10 @@ acpi_status acpi_ds_exec_end_op(struct acpi_walk_state *walk_state)
 	u32 op_class;
 	union acpi_parse_object *next_op;
 	union acpi_parse_object *first_arg;
+#ifdef ACPI_EXEC_APP
+	char *namepath;
+	union acpi_operand_object *obj_desc;
+#endif
 
 	ACPI_FUNCTION_TRACE_PTR(ds_exec_end_op, walk_state);
 
@@ -537,6 +544,32 @@ acpi_status acpi_ds_exec_end_op(struct acpi_walk_state *walk_state)
 
 			status =
 			    acpi_ds_eval_buffer_field_operands(walk_state, op);
+			if (ACPI_FAILURE(status)) {
+				break;
+			}
+#ifdef ACPI_EXEC_APP
+			/*
+			 * acpi_exec support for namespace initialization file (initialize
+			 * buffer_fields in this code.)
+			 */
+			namepath =
+			    acpi_ns_get_external_pathname(op->common.node);
+			status = ae_lookup_init_file_entry(namepath, &obj_desc);
+			if (ACPI_SUCCESS(status)) {
+				status =
+				    acpi_ex_write_data_to_field(obj_desc,
+								op->common.
+								node->object,
+								NULL);
+				if ACPI_FAILURE
+					(status) {
+					ACPI_EXCEPTION((AE_INFO, status,
+							"While writing to buffer field"));
+					}
+			}
+			ACPI_FREE(namepath);
+			status = AE_OK;
+#endif
 			break;
 
 		case AML_TYPE_CREATE_OBJECT:
diff --git a/drivers/acpi/acpica/dswload.c b/drivers/acpi/acpica/dswload.c
index 4bcf15bf03ded..6cf93fae4d07f 100644
--- a/drivers/acpi/acpica/dswload.c
+++ b/drivers/acpi/acpica/dswload.c
@@ -14,7 +14,6 @@
 #include "acdispat.h"
 #include "acinterp.h"
 #include "acnamesp.h"
-
 #ifdef ACPI_ASL_COMPILER
 #include "acdisasm.h"
 #endif
@@ -399,7 +398,6 @@ acpi_status acpi_ds_load1_end_op(struct acpi_walk_state *walk_state)
 	union acpi_parse_object *op;
 	acpi_object_type object_type;
 	acpi_status status = AE_OK;
-
 #ifdef ACPI_ASL_COMPILER
 	u8 param_count;
 #endif
diff --git a/drivers/acpi/acpica/dswload2.c b/drivers/acpi/acpica/dswload2.c
index 935a8e2623e4b..15d92bf15f0b6 100644
--- a/drivers/acpi/acpica/dswload2.c
+++ b/drivers/acpi/acpica/dswload2.c
@@ -15,6 +15,9 @@
 #include "acinterp.h"
 #include "acnamesp.h"
 #include "acevents.h"
+#ifdef ACPI_EXEC_APP
+#include "aecommon.h"
+#endif
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dswload2")
@@ -373,6 +376,10 @@ acpi_status acpi_ds_load2_end_op(struct acpi_walk_state *walk_state)
 	struct acpi_namespace_node *new_node;
 	u32 i;
 	u8 region_space;
+#ifdef ACPI_EXEC_APP
+	union acpi_operand_object *obj_desc;
+	char *namepath;
+#endif
 
 	ACPI_FUNCTION_TRACE(ds_load2_end_op);
 
@@ -466,6 +473,11 @@ acpi_status acpi_ds_load2_end_op(struct acpi_walk_state *walk_state)
 		 * be evaluated later during the execution phase
 		 */
 		status = acpi_ds_create_buffer_field(op, walk_state);
+		if (ACPI_FAILURE(status)) {
+			ACPI_EXCEPTION((AE_INFO, status,
+					"CreateBufferField failure"));
+			goto cleanup;
+			}
 		break;
 
 	case AML_TYPE_NAMED_FIELD:
@@ -604,6 +616,29 @@ acpi_status acpi_ds_load2_end_op(struct acpi_walk_state *walk_state)
 		case AML_NAME_OP:
 
 			status = acpi_ds_create_node(walk_state, node, op);
+			if (ACPI_FAILURE(status)) {
+				goto cleanup;
+			}
+#ifdef ACPI_EXEC_APP
+			/*
+			 * acpi_exec support for namespace initialization file (initialize
+			 * Name opcodes in this code.)
+			 */
+			namepath = acpi_ns_get_external_pathname(node);
+			status = ae_lookup_init_file_entry(namepath, &obj_desc);
+			if (ACPI_SUCCESS(status)) {
+
+				/* Detach any existing object, attach new object */
+
+				if (node->object) {
+					acpi_ns_detach_object(node);
+				}
+				acpi_ns_attach_object(node, obj_desc,
+						      obj_desc->common.type);
+			}
+			ACPI_FREE(namepath);
+			status = AE_OK;
+#endif
 			break;
 
 		case AML_METHOD_OP:
diff --git a/drivers/acpi/acpica/nsnames.c b/drivers/acpi/acpica/nsnames.c
index 370bbc8677453..c717fff7d9b57 100644
--- a/drivers/acpi/acpica/nsnames.c
+++ b/drivers/acpi/acpica/nsnames.c
@@ -13,9 +13,6 @@
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsnames")
 
-/* Local Prototypes */
-static void acpi_ns_normalize_pathname(char *original_path);
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ns_get_external_pathname
@@ -30,7 +27,6 @@ static void acpi_ns_normalize_pathname(char *original_path);
  *              for error and debug statements.
  *
  ******************************************************************************/
-
 char *acpi_ns_get_external_pathname(struct acpi_namespace_node *node)
 {
 	char *name_buffer;
@@ -411,7 +407,7 @@ char *acpi_ns_build_prefixed_pathname(union acpi_generic_state *prefix_scope,
  *
  ******************************************************************************/
 
-static void acpi_ns_normalize_pathname(char *original_path)
+void acpi_ns_normalize_pathname(char *original_path)
 {
 	char *input_path = original_path;
 	char *new_path_buffer;
diff --git a/drivers/acpi/acpica/utdelete.c b/drivers/acpi/acpica/utdelete.c
index eee263cb7beb0..c365faf4e6cd4 100644
--- a/drivers/acpi/acpica/utdelete.c
+++ b/drivers/acpi/acpica/utdelete.c
@@ -452,13 +452,13 @@ acpi_ut_update_ref_count(union acpi_operand_object *object, u32 action)
  *
  * FUNCTION:    acpi_ut_update_object_reference
  *
- * PARAMETERS:  object              - Increment ref count for this object
- *                                    and all sub-objects
+ * PARAMETERS:  object              - Increment or decrement the ref count for
+ *                                    this object and all sub-objects
  *              action              - Either REF_INCREMENT or REF_DECREMENT
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Increment the object reference count
+ * DESCRIPTION: Increment or decrement the object reference count
  *
  * Object references are incremented when:
  * 1) An object is attached to a Node (namespace object)
@@ -492,7 +492,7 @@ acpi_ut_update_object_reference(union acpi_operand_object *object, u16 action)
 		}
 
 		/*
-		 * All sub-objects must have their reference count incremented
+		 * All sub-objects must have their reference count updated
 		 * also. Different object types have different subobjects.
 		 */
 		switch (object->common.type) {
@@ -559,6 +559,7 @@ acpi_ut_update_object_reference(union acpi_operand_object *object, u16 action)
 					break;
 				}
 			}
+
 			next_object = NULL;
 			break;
 
-- 
2.20.1



