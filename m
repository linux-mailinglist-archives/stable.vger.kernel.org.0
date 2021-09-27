Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4424199F1
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhI0RFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235779AbhI0RF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:05:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32FC960F3A;
        Mon, 27 Sep 2021 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762228;
        bh=eMrAGugYg/5rQWoFUzfyk4o2zjkOsj8fpBoskmh4PV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNJhuOoZfId0U/cGznHIeaV741Hbf3Y/G93xthrgxOToQZRpPQ9ywqrKRhyx8G+Zz
         2FKRbdNc4oULjVIk7/C8DU0Q1L1F0xb7+TTdbRhhvJ6eSTxIj3n8jlRSRtIvqMvjM0
         gbgF08N2mRHv+EO6TvK2n2wITGMdmI8veNe2suQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martijn Coenen <maco@android.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.4 11/68] binder: make sure fd closes complete
Date:   Mon, 27 Sep 2021 19:02:07 +0200
Message-Id: <20210927170220.324232120@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit 5fdb55c1ac9585eb23bb2541d5819224429e103d upstream.

During BC_FREE_BUFFER processing, the BINDER_TYPE_FDA object
cleanup may close 1 or more fds. The close operations are
completed using the task work mechanism -- which means the thread
needs to return to userspace or the file object may never be
dereferenced -- which can lead to hung processes.

Force the binder thread back to userspace if an fd is closed during
BC_FREE_BUFFER handling.

Fixes: 80cd795630d6 ("binder: fix use-after-free due to ksys_close() during fdget()")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Martijn Coenen <maco@android.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20210830195146.587206-1-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2239,6 +2239,7 @@ static void binder_deferred_fd_close(int
 }
 
 static void binder_transaction_buffer_release(struct binder_proc *proc,
+					      struct binder_thread *thread,
 					      struct binder_buffer *buffer,
 					      binder_size_t failed_at,
 					      bool is_failure)
@@ -2398,8 +2399,16 @@ static void binder_transaction_buffer_re
 						&proc->alloc, &fd, buffer,
 						offset, sizeof(fd));
 				WARN_ON(err);
-				if (!err)
+				if (!err) {
 					binder_deferred_fd_close(fd);
+					/*
+					 * Need to make sure the thread goes
+					 * back to userspace to complete the
+					 * deferred close
+					 */
+					if (thread)
+						thread->looper_need_return = true;
+				}
 			}
 		} break;
 		default:
@@ -3469,7 +3478,7 @@ err_bad_parent:
 err_copy_data_failed:
 	binder_free_txn_fixups(t);
 	trace_binder_transaction_failed_buffer_release(t->buffer);
-	binder_transaction_buffer_release(target_proc, t->buffer,
+	binder_transaction_buffer_release(target_proc, NULL, t->buffer,
 					  buffer_offset, true);
 	if (target_node)
 		binder_dec_node_tmpref(target_node);
@@ -3546,7 +3555,9 @@ err_invalid_target_handle:
  * Cleanup buffer and free it.
  */
 static void
-binder_free_buf(struct binder_proc *proc, struct binder_buffer *buffer)
+binder_free_buf(struct binder_proc *proc,
+		struct binder_thread *thread,
+		struct binder_buffer *buffer)
 {
 	binder_inner_proc_lock(proc);
 	if (buffer->transaction) {
@@ -3574,7 +3585,7 @@ binder_free_buf(struct binder_proc *proc
 		binder_node_inner_unlock(buf_node);
 	}
 	trace_binder_transaction_buffer_release(buffer);
-	binder_transaction_buffer_release(proc, buffer, 0, false);
+	binder_transaction_buffer_release(proc, thread, buffer, 0, false);
 	binder_alloc_free_buf(&proc->alloc, buffer);
 }
 
@@ -3775,7 +3786,7 @@ static int binder_thread_write(struct bi
 				     proc->pid, thread->pid, (u64)data_ptr,
 				     buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
-			binder_free_buf(proc, buffer);
+			binder_free_buf(proc, thread, buffer);
 			break;
 		}
 
@@ -4463,7 +4474,7 @@ retry:
 			buffer->transaction = NULL;
 			binder_cleanup_transaction(t, "fd fixups failed",
 						   BR_FAILED_REPLY);
-			binder_free_buf(proc, buffer);
+			binder_free_buf(proc, thread, buffer);
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
 				     "%d:%d %stransaction %d fd fixups failed %d/%d, line %d\n",
 				     proc->pid, thread->pid,


