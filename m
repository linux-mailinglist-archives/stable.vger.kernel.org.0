Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F01264344D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbiLEToP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbiLETn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:43:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6A42612B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:41:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B829E61309
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BD7C433D6;
        Mon,  5 Dec 2022 19:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269278;
        bh=wBgM5C2fMrorL+3C2DHS6bN/CSF4PervGuN4BMJs2Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLmfcSllyaydUx3fDTBJFwl/o2/XJfw8Aba4aqrwgs8Wq2eUXyL/q6QAy2pyPqebQ
         DZ3gSDhtd/qguXIjnb48g7p2OuEj/ntMPGbQ1Q4Xmhv9qv8hCpowQfOOCcg3Lm2KO1
         8qTa0SCiYLXHN2x8UnoR4Yrwz43842QkdD4w7iNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martijn Coenen <maco@android.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.4 069/153] binder: avoid potential data leakage when copying txn
Date:   Mon,  5 Dec 2022 20:09:53 +0100
Message-Id: <20221205190810.702861985@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit 6d98eb95b450a75adb4516a1d33652dc78d2b20c upstream.

Transactions are copied from the sender to the target
first and objects like BINDER_TYPE_PTR and BINDER_TYPE_FDA
are then fixed up. This means there is a short period where
the sender's version of these objects are visible to the
target prior to the fixups.

Instead of copying all of the data first, copy data only
after any needed fixups have been applied.

Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Reviewed-by: Martijn Coenen <maco@android.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20211130185152.437403-3-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[cmllamas: fix trivial merge conflict]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   94 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 70 insertions(+), 24 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2013,15 +2013,21 @@ static void binder_cleanup_transaction(s
 /**
  * binder_get_object() - gets object and checks for valid metadata
  * @proc:	binder_proc owning the buffer
+ * @u:		sender's user pointer to base of buffer
  * @buffer:	binder_buffer that we're parsing.
  * @offset:	offset in the @buffer at which to validate an object.
  * @object:	struct binder_object to read into
  *
- * Return:	If there's a valid metadata object at @offset in @buffer, the
+ * Copy the binder object at the given offset into @object. If @u is
+ * provided then the copy is from the sender's buffer. If not, then
+ * it is copied from the target's @buffer.
+ *
+ * Return:	If there's a valid metadata object at @offset, the
  *		size of that object. Otherwise, it returns zero. The object
  *		is read into the struct binder_object pointed to by @object.
  */
 static size_t binder_get_object(struct binder_proc *proc,
+				const void __user *u,
 				struct binder_buffer *buffer,
 				unsigned long offset,
 				struct binder_object *object)
@@ -2031,10 +2037,16 @@ static size_t binder_get_object(struct b
 	size_t object_size = 0;
 
 	read_size = min_t(size_t, sizeof(*object), buffer->data_size - offset);
-	if (offset > buffer->data_size || read_size < sizeof(*hdr) ||
-	    binder_alloc_copy_from_buffer(&proc->alloc, object, buffer,
-					  offset, read_size))
+	if (offset > buffer->data_size || read_size < sizeof(*hdr))
 		return 0;
+	if (u) {
+		if (copy_from_user(object, u + offset, read_size))
+			return 0;
+	} else {
+		if (binder_alloc_copy_from_buffer(&proc->alloc, object, buffer,
+						  offset, read_size))
+			return 0;
+	}
 
 	/* Ok, now see if we read a complete object. */
 	hdr = &object->hdr;
@@ -2107,7 +2119,7 @@ static struct binder_buffer_object *bind
 					  b, buffer_offset,
 					  sizeof(object_offset)))
 		return NULL;
-	object_size = binder_get_object(proc, b, object_offset, object);
+	object_size = binder_get_object(proc, NULL, b, object_offset, object);
 	if (!object_size || object->hdr.type != BINDER_TYPE_PTR)
 		return NULL;
 	if (object_offsetp)
@@ -2172,7 +2184,8 @@ static bool binder_validate_fixup(struct
 		unsigned long buffer_offset;
 		struct binder_object last_object;
 		struct binder_buffer_object *last_bbo;
-		size_t object_size = binder_get_object(proc, b, last_obj_offset,
+		size_t object_size = binder_get_object(proc, NULL, b,
+						       last_obj_offset,
 						       &last_object);
 		if (object_size != sizeof(*last_bbo))
 			return false;
@@ -2285,7 +2298,7 @@ static void binder_transaction_buffer_re
 		if (!binder_alloc_copy_from_buffer(&proc->alloc, &object_offset,
 						   buffer, buffer_offset,
 						   sizeof(object_offset)))
-			object_size = binder_get_object(proc, buffer,
+			object_size = binder_get_object(proc, NULL, buffer,
 							object_offset, &object);
 		if (object_size == 0) {
 			pr_err("transaction release %d bad object at offset %lld, size %zd\n",
@@ -2852,6 +2865,7 @@ static void binder_transaction(struct bi
 	binder_size_t off_start_offset, off_end_offset;
 	binder_size_t off_min;
 	binder_size_t sg_buf_offset, sg_buf_end_offset;
+	binder_size_t user_offset = 0;
 	struct binder_proc *target_proc = NULL;
 	struct binder_thread *target_thread = NULL;
 	struct binder_node *target_node = NULL;
@@ -2866,6 +2880,8 @@ static void binder_transaction(struct bi
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	char *secctx = NULL;
 	u32 secctx_sz = 0;
+	const void __user *user_buffer = (const void __user *)
+				(uintptr_t)tr->data.ptr.buffer;
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -3179,19 +3195,6 @@ static void binder_transaction(struct bi
 
 	if (binder_alloc_copy_user_to_buffer(
 				&target_proc->alloc,
-				t->buffer, 0,
-				(const void __user *)
-					(uintptr_t)tr->data.ptr.buffer,
-				tr->data_size)) {
-		binder_user_error("%d:%d got transaction with invalid data ptr\n",
-				proc->pid, thread->pid);
-		return_error = BR_FAILED_REPLY;
-		return_error_param = -EFAULT;
-		return_error_line = __LINE__;
-		goto err_copy_data_failed;
-	}
-	if (binder_alloc_copy_user_to_buffer(
-				&target_proc->alloc,
 				t->buffer,
 				ALIGN(tr->data_size, sizeof(void *)),
 				(const void __user *)
@@ -3234,6 +3237,7 @@ static void binder_transaction(struct bi
 		size_t object_size;
 		struct binder_object object;
 		binder_size_t object_offset;
+		binder_size_t copy_size;
 
 		if (binder_alloc_copy_from_buffer(&target_proc->alloc,
 						  &object_offset,
@@ -3245,8 +3249,27 @@ static void binder_transaction(struct bi
 			return_error_line = __LINE__;
 			goto err_bad_offset;
 		}
-		object_size = binder_get_object(target_proc, t->buffer,
-						object_offset, &object);
+
+		/*
+		 * Copy the source user buffer up to the next object
+		 * that will be processed.
+		 */
+		copy_size = object_offset - user_offset;
+		if (copy_size && (user_offset > object_offset ||
+				binder_alloc_copy_user_to_buffer(
+					&target_proc->alloc,
+					t->buffer, user_offset,
+					user_buffer + user_offset,
+					copy_size))) {
+			binder_user_error("%d:%d got transaction with invalid data ptr\n",
+					proc->pid, thread->pid);
+			return_error = BR_FAILED_REPLY;
+			return_error_param = -EFAULT;
+			return_error_line = __LINE__;
+			goto err_copy_data_failed;
+		}
+		object_size = binder_get_object(target_proc, user_buffer,
+				t->buffer, object_offset, &object);
 		if (object_size == 0 || object_offset < off_min) {
 			binder_user_error("%d:%d got transaction with invalid offset (%lld, min %lld max %lld) or object.\n",
 					  proc->pid, thread->pid,
@@ -3258,6 +3281,11 @@ static void binder_transaction(struct bi
 			return_error_line = __LINE__;
 			goto err_bad_offset;
 		}
+		/*
+		 * Set offset to the next buffer fragment to be
+		 * copied
+		 */
+		user_offset = object_offset + object_size;
 
 		hdr = &object.hdr;
 		off_min = object_offset + object_size;
@@ -3353,9 +3381,14 @@ static void binder_transaction(struct bi
 			}
 			ret = binder_translate_fd_array(fda, parent, t, thread,
 							in_reply_to);
-			if (ret < 0) {
+			if (!ret)
+				ret = binder_alloc_copy_to_buffer(&target_proc->alloc,
+								  t->buffer,
+								  object_offset,
+								  fda, sizeof(*fda));
+			if (ret) {
 				return_error = BR_FAILED_REPLY;
-				return_error_param = ret;
+				return_error_param = ret > 0 ? -EINVAL : ret;
 				return_error_line = __LINE__;
 				goto err_translate_failed;
 			}
@@ -3425,6 +3458,19 @@ static void binder_transaction(struct bi
 			goto err_bad_object_type;
 		}
 	}
+	/* Done processing objects, copy the rest of the buffer */
+	if (binder_alloc_copy_user_to_buffer(
+				&target_proc->alloc,
+				t->buffer, user_offset,
+				user_buffer + user_offset,
+				tr->data_size - user_offset)) {
+		binder_user_error("%d:%d got transaction with invalid data ptr\n",
+				proc->pid, thread->pid);
+		return_error = BR_FAILED_REPLY;
+		return_error_param = -EFAULT;
+		return_error_line = __LINE__;
+		goto err_copy_data_failed;
+	}
 	tcomplete->type = BINDER_WORK_TRANSACTION_COMPLETE;
 	t->work.type = BINDER_WORK_TRANSACTION;
 


