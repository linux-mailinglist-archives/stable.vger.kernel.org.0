Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E124C643450
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiLETo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbiLEToN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:44:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350052B24E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:41:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7704B81202
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B80C433D6;
        Mon,  5 Dec 2022 19:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269286;
        bh=PwHPMkixSlqQNB1Q0aAuZhoSgXg9ieQAVGWaldHFnew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On6nelDZ/1cCAPJjEQNKBosCiZbhMi/75h2zep0yCGHB9Ukyym9gImAkCc3Y0P+/l
         gZ4mM1Zz6P3G0aQRByWivYEaTuAK7NB/KddICBPwfA6a6MadXzHk922cG6TXpVZdGa
         3jOlxPmZzwbtusAmjXfEKl0w66OEv81GvDbgDajo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martijn Coenen <maco@android.com>,
        Todd Kjos <tkjos@google.com>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.4 071/153] binder: defer copies of pre-patched txn data
Date:   Mon,  5 Dec 2022 20:09:55 +0100
Message-Id: <20221205190810.758404003@linuxfoundation.org>
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

commit 09184ae9b5756cc469db6fd1d1cfdcffbf627c2d upstream.

BINDER_TYPE_PTR objects point to memory areas in the
source process to be copied into the target buffer
as part of a transaction. This implements a scatter-
gather model where non-contiguous memory in a source
process is "gathered" into a contiguous region in
the target buffer.

The data can include pointers that must be fixed up
to correctly point to the copied data. To avoid making
source process pointers visible to the target process,
this patch defers the copy until the fixups are known
and then copies and fixeups are done together.

There is a special case of BINDER_TYPE_FDA which applies
the fixup later in the target process context. In this
case the user data is skipped (so no untranslated fds
become visible to the target).

Reviewed-by: Martijn Coenen <maco@android.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20211130185152.437403-5-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[cmllamas: fix trivial merge conflict]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |  299 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 274 insertions(+), 25 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2636,7 +2636,246 @@ err_fd_not_accepted:
 	return ret;
 }
 
-static int binder_translate_fd_array(struct binder_fd_array_object *fda,
+/**
+ * struct binder_ptr_fixup - data to be fixed-up in target buffer
+ * @offset	offset in target buffer to fixup
+ * @skip_size	bytes to skip in copy (fixup will be written later)
+ * @fixup_data	data to write at fixup offset
+ * @node	list node
+ *
+ * This is used for the pointer fixup list (pf) which is created and consumed
+ * during binder_transaction() and is only accessed locally. No
+ * locking is necessary.
+ *
+ * The list is ordered by @offset.
+ */
+struct binder_ptr_fixup {
+	binder_size_t offset;
+	size_t skip_size;
+	binder_uintptr_t fixup_data;
+	struct list_head node;
+};
+
+/**
+ * struct binder_sg_copy - scatter-gather data to be copied
+ * @offset		offset in target buffer
+ * @sender_uaddr	user address in source buffer
+ * @length		bytes to copy
+ * @node		list node
+ *
+ * This is used for the sg copy list (sgc) which is created and consumed
+ * during binder_transaction() and is only accessed locally. No
+ * locking is necessary.
+ *
+ * The list is ordered by @offset.
+ */
+struct binder_sg_copy {
+	binder_size_t offset;
+	const void __user *sender_uaddr;
+	size_t length;
+	struct list_head node;
+};
+
+/**
+ * binder_do_deferred_txn_copies() - copy and fixup scatter-gather data
+ * @alloc:	binder_alloc associated with @buffer
+ * @buffer:	binder buffer in target process
+ * @sgc_head:	list_head of scatter-gather copy list
+ * @pf_head:	list_head of pointer fixup list
+ *
+ * Processes all elements of @sgc_head, applying fixups from @pf_head
+ * and copying the scatter-gather data from the source process' user
+ * buffer to the target's buffer. It is expected that the list creation
+ * and processing all occurs during binder_transaction() so these lists
+ * are only accessed in local context.
+ *
+ * Return: 0=success, else -errno
+ */
+static int binder_do_deferred_txn_copies(struct binder_alloc *alloc,
+					 struct binder_buffer *buffer,
+					 struct list_head *sgc_head,
+					 struct list_head *pf_head)
+{
+	int ret = 0;
+	struct binder_sg_copy *sgc, *tmpsgc;
+	struct binder_ptr_fixup *pf =
+		list_first_entry_or_null(pf_head, struct binder_ptr_fixup,
+					 node);
+
+	list_for_each_entry_safe(sgc, tmpsgc, sgc_head, node) {
+		size_t bytes_copied = 0;
+
+		while (bytes_copied < sgc->length) {
+			size_t copy_size;
+			size_t bytes_left = sgc->length - bytes_copied;
+			size_t offset = sgc->offset + bytes_copied;
+
+			/*
+			 * We copy up to the fixup (pointed to by pf)
+			 */
+			copy_size = pf ? min(bytes_left, (size_t)pf->offset - offset)
+				       : bytes_left;
+			if (!ret && copy_size)
+				ret = binder_alloc_copy_user_to_buffer(
+						alloc, buffer,
+						offset,
+						sgc->sender_uaddr + bytes_copied,
+						copy_size);
+			bytes_copied += copy_size;
+			if (copy_size != bytes_left) {
+				BUG_ON(!pf);
+				/* we stopped at a fixup offset */
+				if (pf->skip_size) {
+					/*
+					 * we are just skipping. This is for
+					 * BINDER_TYPE_FDA where the translated
+					 * fds will be fixed up when we get
+					 * to target context.
+					 */
+					bytes_copied += pf->skip_size;
+				} else {
+					/* apply the fixup indicated by pf */
+					if (!ret)
+						ret = binder_alloc_copy_to_buffer(
+							alloc, buffer,
+							pf->offset,
+							&pf->fixup_data,
+							sizeof(pf->fixup_data));
+					bytes_copied += sizeof(pf->fixup_data);
+				}
+				list_del(&pf->node);
+				kfree(pf);
+				pf = list_first_entry_or_null(pf_head,
+						struct binder_ptr_fixup, node);
+			}
+		}
+		list_del(&sgc->node);
+		kfree(sgc);
+	}
+	BUG_ON(!list_empty(pf_head));
+	BUG_ON(!list_empty(sgc_head));
+
+	return ret > 0 ? -EINVAL : ret;
+}
+
+/**
+ * binder_cleanup_deferred_txn_lists() - free specified lists
+ * @sgc_head:	list_head of scatter-gather copy list
+ * @pf_head:	list_head of pointer fixup list
+ *
+ * Called to clean up @sgc_head and @pf_head if there is an
+ * error.
+ */
+static void binder_cleanup_deferred_txn_lists(struct list_head *sgc_head,
+					      struct list_head *pf_head)
+{
+	struct binder_sg_copy *sgc, *tmpsgc;
+	struct binder_ptr_fixup *pf, *tmppf;
+
+	list_for_each_entry_safe(sgc, tmpsgc, sgc_head, node) {
+		list_del(&sgc->node);
+		kfree(sgc);
+	}
+	list_for_each_entry_safe(pf, tmppf, pf_head, node) {
+		list_del(&pf->node);
+		kfree(pf);
+	}
+}
+
+/**
+ * binder_defer_copy() - queue a scatter-gather buffer for copy
+ * @sgc_head:		list_head of scatter-gather copy list
+ * @offset:		binder buffer offset in target process
+ * @sender_uaddr:	user address in source process
+ * @length:		bytes to copy
+ *
+ * Specify a scatter-gather block to be copied. The actual copy must
+ * be deferred until all the needed fixups are identified and queued.
+ * Then the copy and fixups are done together so un-translated values
+ * from the source are never visible in the target buffer.
+ *
+ * We are guaranteed that repeated calls to this function will have
+ * monotonically increasing @offset values so the list will naturally
+ * be ordered.
+ *
+ * Return: 0=success, else -errno
+ */
+static int binder_defer_copy(struct list_head *sgc_head, binder_size_t offset,
+			     const void __user *sender_uaddr, size_t length)
+{
+	struct binder_sg_copy *bc = kzalloc(sizeof(*bc), GFP_KERNEL);
+
+	if (!bc)
+		return -ENOMEM;
+
+	bc->offset = offset;
+	bc->sender_uaddr = sender_uaddr;
+	bc->length = length;
+	INIT_LIST_HEAD(&bc->node);
+
+	/*
+	 * We are guaranteed that the deferred copies are in-order
+	 * so just add to the tail.
+	 */
+	list_add_tail(&bc->node, sgc_head);
+
+	return 0;
+}
+
+/**
+ * binder_add_fixup() - queue a fixup to be applied to sg copy
+ * @pf_head:	list_head of binder ptr fixup list
+ * @offset:	binder buffer offset in target process
+ * @fixup:	bytes to be copied for fixup
+ * @skip_size:	bytes to skip when copying (fixup will be applied later)
+ *
+ * Add the specified fixup to a list ordered by @offset. When copying
+ * the scatter-gather buffers, the fixup will be copied instead of
+ * data from the source buffer. For BINDER_TYPE_FDA fixups, the fixup
+ * will be applied later (in target process context), so we just skip
+ * the bytes specified by @skip_size. If @skip_size is 0, we copy the
+ * value in @fixup.
+ *
+ * This function is called *mostly* in @offset order, but there are
+ * exceptions. Since out-of-order inserts are relatively uncommon,
+ * we insert the new element by searching backward from the tail of
+ * the list.
+ *
+ * Return: 0=success, else -errno
+ */
+static int binder_add_fixup(struct list_head *pf_head, binder_size_t offset,
+			    binder_uintptr_t fixup, size_t skip_size)
+{
+	struct binder_ptr_fixup *pf = kzalloc(sizeof(*pf), GFP_KERNEL);
+	struct binder_ptr_fixup *tmppf;
+
+	if (!pf)
+		return -ENOMEM;
+
+	pf->offset = offset;
+	pf->fixup_data = fixup;
+	pf->skip_size = skip_size;
+	INIT_LIST_HEAD(&pf->node);
+
+	/* Fixups are *mostly* added in-order, but there are some
+	 * exceptions. Look backwards through list for insertion point.
+	 */
+	list_for_each_entry_reverse(tmppf, pf_head, node) {
+		if (tmppf->offset < pf->offset) {
+			list_add(&pf->node, &tmppf->node);
+			return 0;
+		}
+	}
+	/*
+	 * if we get here, then the new offset is the lowest so
+	 * insert at the head
+	 */
+	list_add(&pf->node, pf_head);
+	return 0;
+}
+
+static int binder_translate_fd_array(struct list_head *pf_head,
+				     struct binder_fd_array_object *fda,
 				     const void __user *sender_ubuffer,
 				     struct binder_buffer_object *parent,
 				     struct binder_buffer_object *sender_uparent,
@@ -2648,6 +2887,7 @@ static int binder_translate_fd_array(str
 	binder_size_t fda_offset;
 	const void __user *sender_ufda_base;
 	struct binder_proc *proc = thread->proc;
+	int ret;
 
 	fd_buf_size = sizeof(u32) * fda->num_fds;
 	if (fda->num_fds >= SIZE_MAX / sizeof(u32)) {
@@ -2679,9 +2919,12 @@ static int binder_translate_fd_array(str
 				  proc->pid, thread->pid);
 		return -EINVAL;
 	}
+	ret = binder_add_fixup(pf_head, fda_offset, 0, fda->num_fds * sizeof(u32));
+	if (ret)
+		return ret;
+
 	for (fdi = 0; fdi < fda->num_fds; fdi++) {
 		u32 fd;
-		int ret;
 		binder_size_t offset = fda_offset + fdi * sizeof(fd);
 		binder_size_t sender_uoffset = fdi * sizeof(fd);
 
@@ -2695,7 +2938,8 @@ static int binder_translate_fd_array(str
 	return 0;
 }
 
-static int binder_fixup_parent(struct binder_transaction *t,
+static int binder_fixup_parent(struct list_head *pf_head,
+			       struct binder_transaction *t,
 			       struct binder_thread *thread,
 			       struct binder_buffer_object *bp,
 			       binder_size_t off_start_offset,
@@ -2741,14 +2985,7 @@ static int binder_fixup_parent(struct bi
 	}
 	buffer_offset = bp->parent_offset +
 			(uintptr_t)parent->buffer - (uintptr_t)b->user_data;
-	if (binder_alloc_copy_to_buffer(&target_proc->alloc, b, buffer_offset,
-					&bp->buffer, sizeof(bp->buffer))) {
-		binder_user_error("%d:%d got transaction with invalid parent offset\n",
-				  proc->pid, thread->pid);
-		return -EINVAL;
-	}
-
-	return 0;
+	return binder_add_fixup(pf_head, buffer_offset, bp->buffer, 0);
 }
 
 /**
@@ -2884,8 +3121,12 @@ static void binder_transaction(struct bi
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	char *secctx = NULL;
 	u32 secctx_sz = 0;
+	struct list_head sgc_head;
+	struct list_head pf_head;
 	const void __user *user_buffer = (const void __user *)
 				(uintptr_t)tr->data.ptr.buffer;
+	INIT_LIST_HEAD(&sgc_head);
+	INIT_LIST_HEAD(&pf_head);
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -3402,8 +3643,8 @@ static void binder_transaction(struct bi
 				return_error_line = __LINE__;
 				goto err_bad_parent;
 			}
-			ret = binder_translate_fd_array(fda, user_buffer,
-							parent,
+			ret = binder_translate_fd_array(&pf_head, fda,
+							user_buffer, parent,
 							&user_object.bbo, t,
 							thread, in_reply_to);
 			if (!ret)
@@ -3435,19 +3676,14 @@ static void binder_transaction(struct bi
 				return_error_line = __LINE__;
 				goto err_bad_offset;
 			}
-			if (binder_alloc_copy_user_to_buffer(
-						&target_proc->alloc,
-						t->buffer,
-						sg_buf_offset,
-						(const void __user *)
-							(uintptr_t)bp->buffer,
-						bp->length)) {
-				binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
-						  proc->pid, thread->pid);
-				return_error_param = -EFAULT;
+			ret = binder_defer_copy(&sgc_head, sg_buf_offset,
+				(const void __user *)(uintptr_t)bp->buffer,
+				bp->length);
+			if (ret) {
 				return_error = BR_FAILED_REPLY;
+				return_error_param = ret;
 				return_error_line = __LINE__;
-				goto err_copy_data_failed;
+				goto err_translate_failed;
 			}
 			/* Fixup buffer pointer to target proc address space */
 			bp->buffer = (uintptr_t)
@@ -3456,7 +3692,8 @@ static void binder_transaction(struct bi
 
 			num_valid = (buffer_offset - off_start_offset) /
 					sizeof(binder_size_t);
-			ret = binder_fixup_parent(t, thread, bp,
+			ret = binder_fixup_parent(&pf_head, t,
+						  thread, bp,
 						  off_start_offset,
 						  num_valid,
 						  last_fixup_obj_off,
@@ -3496,6 +3733,17 @@ static void binder_transaction(struct bi
 		return_error_line = __LINE__;
 		goto err_copy_data_failed;
 	}
+
+	ret = binder_do_deferred_txn_copies(&target_proc->alloc, t->buffer,
+					    &sgc_head, &pf_head);
+	if (ret) {
+		binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
+				  proc->pid, thread->pid);
+		return_error = BR_FAILED_REPLY;
+		return_error_param = ret;
+		return_error_line = __LINE__;
+		goto err_copy_data_failed;
+	}
 	tcomplete->type = BINDER_WORK_TRANSACTION_COMPLETE;
 	t->work.type = BINDER_WORK_TRANSACTION;
 
@@ -3562,6 +3810,7 @@ err_bad_object_type:
 err_bad_offset:
 err_bad_parent:
 err_copy_data_failed:
+	binder_cleanup_deferred_txn_lists(&sgc_head, &pf_head);
 	binder_free_txn_fixups(t);
 	trace_binder_transaction_failed_buffer_release(t->buffer);
 	binder_transaction_buffer_release(target_proc, NULL, t->buffer,


