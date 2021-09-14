Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5C240A705
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 09:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240413AbhINHDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 03:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240363AbhINHDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 03:03:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FB90610CE;
        Tue, 14 Sep 2021 07:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631602947;
        bh=yXYi+BjWtYnyzEVfz9wiPHGzIG0rUCnpf/gNvApjxH0=;
        h=Subject:To:From:Date:From;
        b=V6tKciTw/aLoXbcAFKNucD9Pjon+zYOeysw/gWiHWobOhtmoCCwDXqQkQwgfjRf0q
         h4/ZKkhTUv5lYz4mMPRuDo1cGucVhi44307b4emiHXZRg0WTRwg3idvxTHyFvPSVTB
         f0kMCQANY/G3qz+TH6kc6zYqJNz/tusg58I+y5cc=
Subject: patch "binder: make sure fd closes complete" added to char-misc-linus
To:     tkjos@google.com, christian.brauner@ubuntu.com,
        gregkh@linuxfoundation.org, maco@android.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 09:02:24 +0200
Message-ID: <163160294423170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: make sure fd closes complete

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5fdb55c1ac9585eb23bb2541d5819224429e103d Mon Sep 17 00:00:00 2001
From: Todd Kjos <tkjos@google.com>
Date: Mon, 30 Aug 2021 12:51:46 -0700
Subject: binder: make sure fd closes complete

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
 drivers/android/binder.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 1a68c2f590cf..9edacc8b9768 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1852,6 +1852,7 @@ static void binder_deferred_fd_close(int fd)
 }
 
 static void binder_transaction_buffer_release(struct binder_proc *proc,
+					      struct binder_thread *thread,
 					      struct binder_buffer *buffer,
 					      binder_size_t failed_at,
 					      bool is_failure)
@@ -2011,8 +2012,16 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
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
@@ -3104,7 +3113,7 @@ static void binder_transaction(struct binder_proc *proc,
 err_copy_data_failed:
 	binder_free_txn_fixups(t);
 	trace_binder_transaction_failed_buffer_release(t->buffer);
-	binder_transaction_buffer_release(target_proc, t->buffer,
+	binder_transaction_buffer_release(target_proc, NULL, t->buffer,
 					  buffer_offset, true);
 	if (target_node)
 		binder_dec_node_tmpref(target_node);
@@ -3183,7 +3192,9 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -3211,7 +3222,7 @@ binder_free_buf(struct binder_proc *proc, struct binder_buffer *buffer)
 		binder_node_inner_unlock(buf_node);
 	}
 	trace_binder_transaction_buffer_release(buffer);
-	binder_transaction_buffer_release(proc, buffer, 0, false);
+	binder_transaction_buffer_release(proc, thread, buffer, 0, false);
 	binder_alloc_free_buf(&proc->alloc, buffer);
 }
 
@@ -3413,7 +3424,7 @@ static int binder_thread_write(struct binder_proc *proc,
 				     proc->pid, thread->pid, (u64)data_ptr,
 				     buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
-			binder_free_buf(proc, buffer);
+			binder_free_buf(proc, thread, buffer);
 			break;
 		}
 
@@ -4106,7 +4117,7 @@ static int binder_thread_read(struct binder_proc *proc,
 			buffer->transaction = NULL;
 			binder_cleanup_transaction(t, "fd fixups failed",
 						   BR_FAILED_REPLY);
-			binder_free_buf(proc, buffer);
+			binder_free_buf(proc, thread, buffer);
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
 				     "%d:%d %stransaction %d fd fixups failed %d/%d, line %d\n",
 				     proc->pid, thread->pid,
-- 
2.33.0


