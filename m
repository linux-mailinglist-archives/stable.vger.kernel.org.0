Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9C5419A8F
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbhI0RKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236232AbhI0RIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:08:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A25BD611C0;
        Mon, 27 Sep 2021 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762415;
        bh=yiU3V10sL6s+tJFwFK47L0eCG6b2WvQGVdeBLXpLV5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbpiuPDPtF2dTo8eHjFO6H4L65iowyYPOQL8WtnZtnnrPMwYC/L/p5QUj/anDvl2w
         CZEk6qnFAawnBYNoY/OxXuZ/BTh93S1l16EUffp7wjt21PJKMANva/ZIfg3tLXBhTZ
         V5oIRoQuP8fYXQ18nVq592b9sAZrwiHEa4WK6qkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martijn Coenen <maco@android.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.10 014/103] binder: make sure fd closes complete
Date:   Mon, 27 Sep 2021 19:01:46 +0200
Message-Id: <20210927170226.207536534@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
@@ -2236,6 +2236,7 @@ static void binder_deferred_fd_close(int
 }
 
 static void binder_transaction_buffer_release(struct binder_proc *proc,
+					      struct binder_thread *thread,
 					      struct binder_buffer *buffer,
 					      binder_size_t failed_at,
 					      bool is_failure)
@@ -2395,8 +2396,16 @@ static void binder_transaction_buffer_re
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
@@ -3465,7 +3474,7 @@ err_bad_parent:
 err_copy_data_failed:
 	binder_free_txn_fixups(t);
 	trace_binder_transaction_failed_buffer_release(t->buffer);
-	binder_transaction_buffer_release(target_proc, t->buffer,
+	binder_transaction_buffer_release(target_proc, NULL, t->buffer,
 					  buffer_offset, true);
 	if (target_node)
 		binder_dec_node_tmpref(target_node);
@@ -3542,7 +3551,9 @@ err_invalid_target_handle:
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
@@ -3570,7 +3581,7 @@ binder_free_buf(struct binder_proc *proc
 		binder_node_inner_unlock(buf_node);
 	}
 	trace_binder_transaction_buffer_release(buffer);
-	binder_transaction_buffer_release(proc, buffer, 0, false);
+	binder_transaction_buffer_release(proc, thread, buffer, 0, false);
 	binder_alloc_free_buf(&proc->alloc, buffer);
 }
 
@@ -3771,7 +3782,7 @@ static int binder_thread_write(struct bi
 				     proc->pid, thread->pid, (u64)data_ptr,
 				     buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
-			binder_free_buf(proc, buffer);
+			binder_free_buf(proc, thread, buffer);
 			break;
 		}
 
@@ -4459,7 +4470,7 @@ retry:
 			buffer->transaction = NULL;
 			binder_cleanup_transaction(t, "fd fixups failed",
 						   BR_FAILED_REPLY);
-			binder_free_buf(proc, buffer);
+			binder_free_buf(proc, thread, buffer);
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
 				     "%d:%d %stransaction %d fd fixups failed %d/%d, line %d\n",
 				     proc->pid, thread->pid,


