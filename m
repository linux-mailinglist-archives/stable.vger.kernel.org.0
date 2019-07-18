Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9766C65F
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391367AbfGRDQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391514AbfGRDPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:15:23 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27BF2077C;
        Thu, 18 Jul 2019 03:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419722;
        bh=WRKsRcxRnLCVFZC0iAHmJsRgj1HP6SOWOkbYJloZzs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQcaXz3YvQiLb2pgXoio2vmomRKhSr0Wn5uhM0MazYtDKwySCKCNZtmE8W1XU2LP/
         Mj2Yh8B87gsS639GbsoLSCMewPSR9cl5eX0QNK8sydel4AIwKOKTYCophfeA53ztra
         SRjcMRc7EmS13VSpm1+k3s2+BkCBfQ04WCYsclW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishnu Dasa <vdasa@vmware.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [PATCH 4.4 26/40] VMCI: Fix integer overflow in VMCI handle arrays
Date:   Thu, 18 Jul 2019 12:02:22 +0900
Message-Id: <20190718030049.267542241@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishnu DASA <vdasa@vmware.com>

commit 1c2eb5b2853c9f513690ba6b71072d8eb65da16a upstream.

The VMCI handle array has an integer overflow in
vmci_handle_arr_append_entry when it tries to expand the array. This can be
triggered from a guest, since the doorbell link hypercall doesn't impose a
limit on the number of doorbell handles that a VM can create in the
hypervisor, and these handles are stored in a handle array.

In this change, we introduce a mandatory max capacity for handle
arrays/lists to avoid excessive memory usage.

Signed-off-by: Vishnu Dasa <vdasa@vmware.com>
Reviewed-by: Adit Ranadive <aditr@vmware.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/vmw_vmci/vmci_context.c      |   80 ++++++++++++++++--------------
 drivers/misc/vmw_vmci/vmci_handle_array.c |   38 +++++++++-----
 drivers/misc/vmw_vmci/vmci_handle_array.h |   29 +++++++---
 include/linux/vmw_vmci_defs.h             |   11 +++-
 4 files changed, 99 insertions(+), 59 deletions(-)

--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -28,6 +28,9 @@
 #include "vmci_driver.h"
 #include "vmci_event.h"
 
+/* Use a wide upper bound for the maximum contexts. */
+#define VMCI_MAX_CONTEXTS 2000
+
 /*
  * List of current VMCI contexts.  Contexts can be added by
  * vmci_ctx_create() and removed via vmci_ctx_destroy().
@@ -124,19 +127,22 @@ struct vmci_ctx *vmci_ctx_create(u32 cid
 	/* Initialize host-specific VMCI context. */
 	init_waitqueue_head(&context->host_context.wait_queue);
 
-	context->queue_pair_array = vmci_handle_arr_create(0);
+	context->queue_pair_array =
+		vmci_handle_arr_create(0, VMCI_MAX_GUEST_QP_COUNT);
 	if (!context->queue_pair_array) {
 		error = -ENOMEM;
 		goto err_free_ctx;
 	}
 
-	context->doorbell_array = vmci_handle_arr_create(0);
+	context->doorbell_array =
+		vmci_handle_arr_create(0, VMCI_MAX_GUEST_DOORBELL_COUNT);
 	if (!context->doorbell_array) {
 		error = -ENOMEM;
 		goto err_free_qp_array;
 	}
 
-	context->pending_doorbell_array = vmci_handle_arr_create(0);
+	context->pending_doorbell_array =
+		vmci_handle_arr_create(0, VMCI_MAX_GUEST_DOORBELL_COUNT);
 	if (!context->pending_doorbell_array) {
 		error = -ENOMEM;
 		goto err_free_db_array;
@@ -211,7 +217,7 @@ static int ctx_fire_notification(u32 con
 	 * We create an array to hold the subscribers we find when
 	 * scanning through all contexts.
 	 */
-	subscriber_array = vmci_handle_arr_create(0);
+	subscriber_array = vmci_handle_arr_create(0, VMCI_MAX_CONTEXTS);
 	if (subscriber_array == NULL)
 		return VMCI_ERROR_NO_MEM;
 
@@ -630,20 +636,26 @@ int vmci_ctx_add_notification(u32 contex
 
 	spin_lock(&context->lock);
 
-	list_for_each_entry(n, &context->notifier_list, node) {
-		if (vmci_handle_is_equal(n->handle, notifier->handle)) {
-			exists = true;
-			break;
+	if (context->n_notifiers < VMCI_MAX_CONTEXTS) {
+		list_for_each_entry(n, &context->notifier_list, node) {
+			if (vmci_handle_is_equal(n->handle, notifier->handle)) {
+				exists = true;
+				break;
+			}
 		}
-	}
 
-	if (exists) {
-		kfree(notifier);
-		result = VMCI_ERROR_ALREADY_EXISTS;
+		if (exists) {
+			kfree(notifier);
+			result = VMCI_ERROR_ALREADY_EXISTS;
+		} else {
+			list_add_tail_rcu(&notifier->node,
+					  &context->notifier_list);
+			context->n_notifiers++;
+			result = VMCI_SUCCESS;
+		}
 	} else {
-		list_add_tail_rcu(&notifier->node, &context->notifier_list);
-		context->n_notifiers++;
-		result = VMCI_SUCCESS;
+		kfree(notifier);
+		result = VMCI_ERROR_NO_MEM;
 	}
 
 	spin_unlock(&context->lock);
@@ -728,8 +740,7 @@ static int vmci_ctx_get_chkpt_doorbells(
 					u32 *buf_size, void **pbuf)
 {
 	struct dbell_cpt_state *dbells;
-	size_t n_doorbells;
-	int i;
+	u32 i, n_doorbells;
 
 	n_doorbells = vmci_handle_arr_get_size(context->doorbell_array);
 	if (n_doorbells > 0) {
@@ -867,7 +878,8 @@ int vmci_ctx_rcv_notifications_get(u32 c
 	spin_lock(&context->lock);
 
 	*db_handle_array = context->pending_doorbell_array;
-	context->pending_doorbell_array = vmci_handle_arr_create(0);
+	context->pending_doorbell_array =
+		vmci_handle_arr_create(0, VMCI_MAX_GUEST_DOORBELL_COUNT);
 	if (!context->pending_doorbell_array) {
 		context->pending_doorbell_array = *db_handle_array;
 		*db_handle_array = NULL;
@@ -949,12 +961,11 @@ int vmci_ctx_dbell_create(u32 context_id
 		return VMCI_ERROR_NOT_FOUND;
 
 	spin_lock(&context->lock);
-	if (!vmci_handle_arr_has_entry(context->doorbell_array, handle)) {
-		vmci_handle_arr_append_entry(&context->doorbell_array, handle);
-		result = VMCI_SUCCESS;
-	} else {
+	if (!vmci_handle_arr_has_entry(context->doorbell_array, handle))
+		result = vmci_handle_arr_append_entry(&context->doorbell_array,
+						      handle);
+	else
 		result = VMCI_ERROR_DUPLICATE_ENTRY;
-	}
 
 	spin_unlock(&context->lock);
 	vmci_ctx_put(context);
@@ -1090,15 +1101,16 @@ int vmci_ctx_notify_dbell(u32 src_cid,
 			if (!vmci_handle_arr_has_entry(
 					dst_context->pending_doorbell_array,
 					handle)) {
-				vmci_handle_arr_append_entry(
+				result = vmci_handle_arr_append_entry(
 					&dst_context->pending_doorbell_array,
 					handle);
-
-				ctx_signal_notify(dst_context);
-				wake_up(&dst_context->host_context.wait_queue);
-
+				if (result == VMCI_SUCCESS) {
+					ctx_signal_notify(dst_context);
+					wake_up(&dst_context->host_context.wait_queue);
+				}
+			} else {
+				result = VMCI_SUCCESS;
 			}
-			result = VMCI_SUCCESS;
 		}
 		spin_unlock(&dst_context->lock);
 	}
@@ -1125,13 +1137,11 @@ int vmci_ctx_qp_create(struct vmci_ctx *
 	if (context == NULL || vmci_handle_is_invalid(handle))
 		return VMCI_ERROR_INVALID_ARGS;
 
-	if (!vmci_handle_arr_has_entry(context->queue_pair_array, handle)) {
-		vmci_handle_arr_append_entry(&context->queue_pair_array,
-					     handle);
-		result = VMCI_SUCCESS;
-	} else {
+	if (!vmci_handle_arr_has_entry(context->queue_pair_array, handle))
+		result = vmci_handle_arr_append_entry(
+			&context->queue_pair_array, handle);
+	else
 		result = VMCI_ERROR_DUPLICATE_ENTRY;
-	}
 
 	return result;
 }
--- a/drivers/misc/vmw_vmci/vmci_handle_array.c
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.c
@@ -16,24 +16,29 @@
 #include <linux/slab.h>
 #include "vmci_handle_array.h"
 
-static size_t handle_arr_calc_size(size_t capacity)
+static size_t handle_arr_calc_size(u32 capacity)
 {
-	return sizeof(struct vmci_handle_arr) +
+	return VMCI_HANDLE_ARRAY_HEADER_SIZE +
 	    capacity * sizeof(struct vmci_handle);
 }
 
-struct vmci_handle_arr *vmci_handle_arr_create(size_t capacity)
+struct vmci_handle_arr *vmci_handle_arr_create(u32 capacity, u32 max_capacity)
 {
 	struct vmci_handle_arr *array;
 
+	if (max_capacity == 0 || capacity > max_capacity)
+		return NULL;
+
 	if (capacity == 0)
-		capacity = VMCI_HANDLE_ARRAY_DEFAULT_SIZE;
+		capacity = min((u32)VMCI_HANDLE_ARRAY_DEFAULT_CAPACITY,
+			       max_capacity);
 
 	array = kmalloc(handle_arr_calc_size(capacity), GFP_ATOMIC);
 	if (!array)
 		return NULL;
 
 	array->capacity = capacity;
+	array->max_capacity = max_capacity;
 	array->size = 0;
 
 	return array;
@@ -44,27 +49,34 @@ void vmci_handle_arr_destroy(struct vmci
 	kfree(array);
 }
 
-void vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
-				  struct vmci_handle handle)
+int vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
+				 struct vmci_handle handle)
 {
 	struct vmci_handle_arr *array = *array_ptr;
 
 	if (unlikely(array->size >= array->capacity)) {
 		/* reallocate. */
 		struct vmci_handle_arr *new_array;
-		size_t new_capacity = array->capacity * VMCI_ARR_CAP_MULT;
-		size_t new_size = handle_arr_calc_size(new_capacity);
+		u32 capacity_bump = min(array->max_capacity - array->capacity,
+					array->capacity);
+		size_t new_size = handle_arr_calc_size(array->capacity +
+						       capacity_bump);
+
+		if (array->size >= array->max_capacity)
+			return VMCI_ERROR_NO_MEM;
 
 		new_array = krealloc(array, new_size, GFP_ATOMIC);
 		if (!new_array)
-			return;
+			return VMCI_ERROR_NO_MEM;
 
-		new_array->capacity = new_capacity;
+		new_array->capacity += capacity_bump;
 		*array_ptr = array = new_array;
 	}
 
 	array->entries[array->size] = handle;
 	array->size++;
+
+	return VMCI_SUCCESS;
 }
 
 /*
@@ -74,7 +86,7 @@ struct vmci_handle vmci_handle_arr_remov
 						struct vmci_handle entry_handle)
 {
 	struct vmci_handle handle = VMCI_INVALID_HANDLE;
-	size_t i;
+	u32 i;
 
 	for (i = 0; i < array->size; i++) {
 		if (vmci_handle_is_equal(array->entries[i], entry_handle)) {
@@ -109,7 +121,7 @@ struct vmci_handle vmci_handle_arr_remov
  * Handle at given index, VMCI_INVALID_HANDLE if invalid index.
  */
 struct vmci_handle
-vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, size_t index)
+vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, u32 index)
 {
 	if (unlikely(index >= array->size))
 		return VMCI_INVALID_HANDLE;
@@ -120,7 +132,7 @@ vmci_handle_arr_get_entry(const struct v
 bool vmci_handle_arr_has_entry(const struct vmci_handle_arr *array,
 			       struct vmci_handle entry_handle)
 {
-	size_t i;
+	u32 i;
 
 	for (i = 0; i < array->size; i++)
 		if (vmci_handle_is_equal(array->entries[i], entry_handle))
--- a/drivers/misc/vmw_vmci/vmci_handle_array.h
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.h
@@ -17,32 +17,41 @@
 #define _VMCI_HANDLE_ARRAY_H_
 
 #include <linux/vmw_vmci_defs.h>
+#include <linux/limits.h>
 #include <linux/types.h>
 
-#define VMCI_HANDLE_ARRAY_DEFAULT_SIZE 4
-#define VMCI_ARR_CAP_MULT 2	/* Array capacity multiplier */
-
 struct vmci_handle_arr {
-	size_t capacity;
-	size_t size;
+	u32 capacity;
+	u32 max_capacity;
+	u32 size;
+	u32 pad;
 	struct vmci_handle entries[];
 };
 
-struct vmci_handle_arr *vmci_handle_arr_create(size_t capacity);
+#define VMCI_HANDLE_ARRAY_HEADER_SIZE				\
+	offsetof(struct vmci_handle_arr, entries)
+/* Select a default capacity that results in a 64 byte sized array */
+#define VMCI_HANDLE_ARRAY_DEFAULT_CAPACITY			6
+/* Make sure that the max array size can be expressed by a u32 */
+#define VMCI_HANDLE_ARRAY_MAX_CAPACITY				\
+	((U32_MAX - VMCI_HANDLE_ARRAY_HEADER_SIZE - 1) /	\
+	sizeof(struct vmci_handle))
+
+struct vmci_handle_arr *vmci_handle_arr_create(u32 capacity, u32 max_capacity);
 void vmci_handle_arr_destroy(struct vmci_handle_arr *array);
-void vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
-				  struct vmci_handle handle);
+int vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
+				 struct vmci_handle handle);
 struct vmci_handle vmci_handle_arr_remove_entry(struct vmci_handle_arr *array,
 						struct vmci_handle
 						entry_handle);
 struct vmci_handle vmci_handle_arr_remove_tail(struct vmci_handle_arr *array);
 struct vmci_handle
-vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, size_t index);
+vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, u32 index);
 bool vmci_handle_arr_has_entry(const struct vmci_handle_arr *array,
 			       struct vmci_handle entry_handle);
 struct vmci_handle *vmci_handle_arr_get_handles(struct vmci_handle_arr *array);
 
-static inline size_t vmci_handle_arr_get_size(
+static inline u32 vmci_handle_arr_get_size(
 	const struct vmci_handle_arr *array)
 {
 	return array->size;
--- a/include/linux/vmw_vmci_defs.h
+++ b/include/linux/vmw_vmci_defs.h
@@ -75,9 +75,18 @@ enum {
 
 /*
  * A single VMCI device has an upper limit of 128MB on the amount of
- * memory that can be used for queue pairs.
+ * memory that can be used for queue pairs. Since each queue pair
+ * consists of at least two pages, the memory limit also dictates the
+ * number of queue pairs a guest can create.
  */
 #define VMCI_MAX_GUEST_QP_MEMORY (128 * 1024 * 1024)
+#define VMCI_MAX_GUEST_QP_COUNT  (VMCI_MAX_GUEST_QP_MEMORY / PAGE_SIZE / 2)
+
+/*
+ * There can be at most PAGE_SIZE doorbells since there is one doorbell
+ * per byte in the doorbell bitmap page.
+ */
+#define VMCI_MAX_GUEST_DOORBELL_COUNT PAGE_SIZE
 
 /*
  * Queues with pre-mapped data pages must be small, so that we don't pin


