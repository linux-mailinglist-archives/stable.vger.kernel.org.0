Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B724144C7E6
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhKJS4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:56:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233715AbhKJSyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:54:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19728619EA;
        Wed, 10 Nov 2021 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570148;
        bh=CF0B4qdBRt2TJVQY65TiIf6oSFnUxWCikjLAXxCIRsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2sX9/RoI3Nkm1sJ7gMsMhwOX/amyylma+Korxfq/C4NyuhoLOiIguHpV6TDRjzV8
         EZ2N3TTR+MUwTTkMSpsIXWC2x1dMoqp0bzOmnuAxVGnlgn0y2RXASec8nyY923Etng
         2fUfLu3LXWbwOReF5edAS9xGKad1YP6gK6gdZ0ZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.14 13/24] binder: dont detect sender/target during buffer cleanup
Date:   Wed, 10 Nov 2021 19:44:05 +0100
Message-Id: <20211110182003.753890524@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
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
@@ -1870,7 +1870,7 @@ static void binder_transaction_buffer_re
 		binder_dec_node(buffer->target_node, 1, 0);
 
 	off_start_offset = ALIGN(buffer->data_size, sizeof(void *));
-	off_end_offset = is_failure ? failed_at :
+	off_end_offset = is_failure && failed_at ? failed_at :
 				off_start_offset + buffer->offsets_size;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
@@ -1956,9 +1956,8 @@ static void binder_transaction_buffer_re
 			binder_size_t fd_buf_size;
 			binder_size_t num_valid;
 
-			if (proc->tsk != current->group_leader) {
+			if (is_failure) {
 				/*
-				 * Nothing to do if running in sender context
 				 * The fd fixups have not been applied so no
 				 * fds need to be closed.
 				 */
@@ -3176,6 +3175,7 @@ err_invalid_target_handle:
  * binder_free_buf() - free the specified buffer
  * @proc:	binder proc that owns buffer
  * @buffer:	buffer to be freed
+ * @is_failure:	failed to send transaction
  *
  * If buffer for an async transaction, enqueue the next async
  * transaction from the node.
@@ -3185,7 +3185,7 @@ err_invalid_target_handle:
 static void
 binder_free_buf(struct binder_proc *proc,
 		struct binder_thread *thread,
-		struct binder_buffer *buffer)
+		struct binder_buffer *buffer, bool is_failure)
 {
 	binder_inner_proc_lock(proc);
 	if (buffer->transaction) {
@@ -3213,7 +3213,7 @@ binder_free_buf(struct binder_proc *proc
 		binder_node_inner_unlock(buf_node);
 	}
 	trace_binder_transaction_buffer_release(buffer);
-	binder_transaction_buffer_release(proc, thread, buffer, 0, false);
+	binder_transaction_buffer_release(proc, thread, buffer, 0, is_failure);
 	binder_alloc_free_buf(&proc->alloc, buffer);
 }
 
@@ -3415,7 +3415,7 @@ static int binder_thread_write(struct bi
 				     proc->pid, thread->pid, (u64)data_ptr,
 				     buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
-			binder_free_buf(proc, thread, buffer);
+			binder_free_buf(proc, thread, buffer, false);
 			break;
 		}
 
@@ -4108,7 +4108,7 @@ retry:
 			buffer->transaction = NULL;
 			binder_cleanup_transaction(t, "fd fixups failed",
 						   BR_FAILED_REPLY);
-			binder_free_buf(proc, thread, buffer);
+			binder_free_buf(proc, thread, buffer, true);
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
 				     "%d:%d %stransaction %d fd fixups failed %d/%d, line %d\n",
 				     proc->pid, thread->pid,


