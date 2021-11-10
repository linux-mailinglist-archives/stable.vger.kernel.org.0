Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D28744C7A9
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhKJSyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:54:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233322AbhKJSwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:52:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5B361241;
        Wed, 10 Nov 2021 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570079;
        bh=9JlpnTwZKhhA1Y9I8SvjaZr6wkbw3NCjEl/pWlPAgAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDiNW5SbJhyHk54jHbOsZpUp1Je5stZneM3ddf4aNFw0izZ/zuzFnVH54ckNh5RBQ
         PamMrPcSR0Q+qMs7sHFAY4PZV10gv4kueeGGAanSfX5EOc4fbBCLfb+21YSCdwOsJ8
         WMnpRPMR5+Kb9nLn3noO5hZ6kK2CMuSAQue+wt7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.4 06/17] binder: dont detect sender/target during buffer cleanup
Date:   Wed, 10 Nov 2021 19:43:45 +0100
Message-Id: <20211110182002.408349335@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.206203228@linuxfoundation.org>
References: <20211110182002.206203228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit 32e9f56a96d8d0f23cb2aeb2a3cd18d40393e787 upstream.

When freeing txn buffers, binder_transaction_buffer_release()
attempts to detect whether the current context is the target by
comparing current->group_leader to proc->tsk. This is an unreliable
test. Instead explicitly pass an 'is_failure' boolean.

Detecting the sender was being used as a way to tell if the
transaction failed to be sent.  When cleaning up after
failing to send a transaction, there is no need to close
the fds associated with a BINDER_TYPE_FDA object. Now
'is_failure' can be used to accurately detect this case.

Fixes: 44d8047f1d87 ("binder: use standard functions to allocate fds")
Cc: stable <stable@vger.kernel.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20211015233811.3532235-1-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2257,7 +2257,7 @@ static void binder_transaction_buffer_re
 		binder_dec_node(buffer->target_node, 1, 0);
 
 	off_start_offset = ALIGN(buffer->data_size, sizeof(void *));
-	off_end_offset = is_failure ? failed_at :
+	off_end_offset = is_failure && failed_at ? failed_at :
 				off_start_offset + buffer->offsets_size;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
@@ -2343,9 +2343,8 @@ static void binder_transaction_buffer_re
 			binder_size_t fd_buf_size;
 			binder_size_t num_valid;
 
-			if (proc->tsk != current->group_leader) {
+			if (is_failure) {
 				/*
-				 * Nothing to do if running in sender context
 				 * The fd fixups have not been applied so no
 				 * fds need to be closed.
 				 */
@@ -3548,6 +3547,7 @@ err_invalid_target_handle:
  * binder_free_buf() - free the specified buffer
  * @proc:	binder proc that owns buffer
  * @buffer:	buffer to be freed
+ * @is_failure:	failed to send transaction
  *
  * If buffer for an async transaction, enqueue the next async
  * transaction from the node.
@@ -3557,7 +3557,7 @@ err_invalid_target_handle:
 static void
 binder_free_buf(struct binder_proc *proc,
 		struct binder_thread *thread,
-		struct binder_buffer *buffer)
+		struct binder_buffer *buffer, bool is_failure)
 {
 	binder_inner_proc_lock(proc);
 	if (buffer->transaction) {
@@ -3585,7 +3585,7 @@ binder_free_buf(struct binder_proc *proc
 		binder_node_inner_unlock(buf_node);
 	}
 	trace_binder_transaction_buffer_release(buffer);
-	binder_transaction_buffer_release(proc, thread, buffer, 0, false);
+	binder_transaction_buffer_release(proc, thread, buffer, 0, is_failure);
 	binder_alloc_free_buf(&proc->alloc, buffer);
 }
 
@@ -3786,7 +3786,7 @@ static int binder_thread_write(struct bi
 				     proc->pid, thread->pid, (u64)data_ptr,
 				     buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
-			binder_free_buf(proc, thread, buffer);
+			binder_free_buf(proc, thread, buffer, false);
 			break;
 		}
 
@@ -4474,7 +4474,7 @@ retry:
 			buffer->transaction = NULL;
 			binder_cleanup_transaction(t, "fd fixups failed",
 						   BR_FAILED_REPLY);
-			binder_free_buf(proc, thread, buffer);
+			binder_free_buf(proc, thread, buffer, true);
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
 				     "%d:%d %stransaction %d fd fixups failed %d/%d, line %d\n",
 				     proc->pid, thread->pid,


