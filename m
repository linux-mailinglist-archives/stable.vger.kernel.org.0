Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78574EA34
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 16:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfFUOGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 10:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfFUOGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jun 2019 10:06:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5805C21537;
        Fri, 21 Jun 2019 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561125960;
        bh=ZHlWvIMRoPEmCWe8NQ/aThS4K5P8emF0jK0nPiSlmaU=;
        h=Subject:To:From:Date:From;
        b=vEwqQbmVHtl/+FUjMWvSbApUsRFzahW8jEXRJK9YeoRlGoYh3X5IUpvaOMaQxNABn
         Uf/+w1hhasP3HMKkwNqy0bR/QDQH52XBDXrhpTrQ1LMfIsneYpO+yGRfUhSdqkima1
         h49JySw1UmwcwcK4+bBtTaK0TRSxEW54j0ZpSAsY=
Subject: patch "VMCI: Fix integer overflow in VMCI handle arrays" added to char-misc-testing
To:     vdasa@vmware.com, aditr@vmware.com, gregkh@linuxfoundation.org,
        jhansen@vmware.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 21 Jun 2019 16:05:50 +0200
Message-ID: <156112595023813@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    VMCI: Fix integer overflow in VMCI handle arrays

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 1c2eb5b2853c9f513690ba6b71072d8eb65da16a Mon Sep 17 00:00:00 2001
From: Vishnu DASA <vdasa@vmware.com>
Date: Fri, 24 May 2019 15:13:10 +0000
Subject: VMCI: Fix integer overflow in VMCI handle arrays

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
 drivers/misc/vmw_vmci/vmci_context.c      | 80 +++++++++++++----------
 drivers/misc/vmw_vmci/vmci_handle_array.c | 38 +++++++----
 drivers/misc/vmw_vmci/vmci_handle_array.h | 29 +++++---
 include/linux/vmw_vmci_defs.h             | 11 +++-
 4 files changed, 99 insertions(+), 59 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
index 300ed69fe2c7..16695366ec92 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -21,6 +21,9 @@
 #include "vmci_driver.h"
 #include "vmci_event.h"
 
+/* Use a wide upper bound for the maximum contexts. */
+#define VMCI_MAX_CONTEXTS 2000
+
 /*
  * List of current VMCI contexts.  Contexts can be added by
  * vmci_ctx_create() and removed via vmci_ctx_destroy().
@@ -117,19 +120,22 @@ struct vmci_ctx *vmci_ctx_create(u32 cid, u32 priv_flags,
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
@@ -204,7 +210,7 @@ static int ctx_fire_notification(u32 context_id, u32 priv_flags)
 	 * We create an array to hold the subscribers we find when
 	 * scanning through all contexts.
 	 */
-	subscriber_array = vmci_handle_arr_create(0);
+	subscriber_array = vmci_handle_arr_create(0, VMCI_MAX_CONTEXTS);
 	if (subscriber_array == NULL)
 		return VMCI_ERROR_NO_MEM;
 
@@ -623,20 +629,26 @@ int vmci_ctx_add_notification(u32 context_id, u32 remote_cid)
 
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
@@ -721,8 +733,7 @@ static int vmci_ctx_get_chkpt_doorbells(struct vmci_ctx *context,
 					u32 *buf_size, void **pbuf)
 {
 	struct dbell_cpt_state *dbells;
-	size_t n_doorbells;
-	int i;
+	u32 i, n_doorbells;
 
 	n_doorbells = vmci_handle_arr_get_size(context->doorbell_array);
 	if (n_doorbells > 0) {
@@ -860,7 +871,8 @@ int vmci_ctx_rcv_notifications_get(u32 context_id,
 	spin_lock(&context->lock);
 
 	*db_handle_array = context->pending_doorbell_array;
-	context->pending_doorbell_array = vmci_handle_arr_create(0);
+	context->pending_doorbell_array =
+		vmci_handle_arr_create(0, VMCI_MAX_GUEST_DOORBELL_COUNT);
 	if (!context->pending_doorbell_array) {
 		context->pending_doorbell_array = *db_handle_array;
 		*db_handle_array = NULL;
@@ -942,12 +954,11 @@ int vmci_ctx_dbell_create(u32 context_id, struct vmci_handle handle)
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
@@ -1083,15 +1094,16 @@ int vmci_ctx_notify_dbell(u32 src_cid,
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
@@ -1118,13 +1130,11 @@ int vmci_ctx_qp_create(struct vmci_ctx *context, struct vmci_handle handle)
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
diff --git a/drivers/misc/vmw_vmci/vmci_handle_array.c b/drivers/misc/vmw_vmci/vmci_handle_array.c
index c527388f5d7b..de7fee7ead1b 100644
--- a/drivers/misc/vmw_vmci/vmci_handle_array.c
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.c
@@ -8,24 +8,29 @@
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
@@ -36,27 +41,34 @@ void vmci_handle_arr_destroy(struct vmci_handle_arr *array)
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
@@ -66,7 +78,7 @@ struct vmci_handle vmci_handle_arr_remove_entry(struct vmci_handle_arr *array,
 						struct vmci_handle entry_handle)
 {
 	struct vmci_handle handle = VMCI_INVALID_HANDLE;
-	size_t i;
+	u32 i;
 
 	for (i = 0; i < array->size; i++) {
 		if (vmci_handle_is_equal(array->entries[i], entry_handle)) {
@@ -101,7 +113,7 @@ struct vmci_handle vmci_handle_arr_remove_tail(struct vmci_handle_arr *array)
  * Handle at given index, VMCI_INVALID_HANDLE if invalid index.
  */
 struct vmci_handle
-vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, size_t index)
+vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, u32 index)
 {
 	if (unlikely(index >= array->size))
 		return VMCI_INVALID_HANDLE;
@@ -112,7 +124,7 @@ vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, size_t index)
 bool vmci_handle_arr_has_entry(const struct vmci_handle_arr *array,
 			       struct vmci_handle entry_handle)
 {
-	size_t i;
+	u32 i;
 
 	for (i = 0; i < array->size; i++)
 		if (vmci_handle_is_equal(array->entries[i], entry_handle))
diff --git a/drivers/misc/vmw_vmci/vmci_handle_array.h b/drivers/misc/vmw_vmci/vmci_handle_array.h
index bd1559a548e9..96193f85be5b 100644
--- a/drivers/misc/vmw_vmci/vmci_handle_array.h
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.h
@@ -9,32 +9,41 @@
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
diff --git a/include/linux/vmw_vmci_defs.h b/include/linux/vmw_vmci_defs.h
index 606504bf376a..fefb5292403b 100644
--- a/include/linux/vmw_vmci_defs.h
+++ b/include/linux/vmw_vmci_defs.h
@@ -62,9 +62,18 @@ enum {
 
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
-- 
2.22.0


