Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAB4579BE0
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbiGSMdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240301AbiGSMcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAC570981;
        Tue, 19 Jul 2022 05:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC9B61790;
        Tue, 19 Jul 2022 12:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D04C341C6;
        Tue, 19 Jul 2022 12:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232736;
        bh=1Qub2fswFuzzoeBd0ixISFLs/Kq4vBg+9VYfqpwwPpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z51z73qxldXzdexEnGhZLxb8kAx6/RLPlYwBiHtQT9ZZaWRP10FbqgsVNzOUJQBBo
         KRIzLeLvywYug0ftbdj2tdE+7NRjyRTvby3/X8s5YF2b5Gw+JaqqGau+LKUu//tvJX
         qLUYyuK7PJE3r81TEV/bN3i37bBGKkUb9h1DOU+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 028/167] xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks
Date:   Tue, 19 Jul 2022 13:52:40 +0200
Message-Id: <20220719114659.450856104@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit cd6f79d1fb324968a3bae92f82eeb7d28ca1fd22 ]

Brian reported a null pointer dereference failure during unmount in
xfs/006. He tracked the problem down to the AIL being torn down
before a log shutdown had completed and removed all the items from
the AIL. The failure occurred in this path while unmount was
proceeding in another task:

 xfs_trans_ail_delete+0x102/0x130 [xfs]
 xfs_buf_item_done+0x22/0x30 [xfs]
 xfs_buf_ioend+0x73/0x4d0 [xfs]
 xfs_trans_committed_bulk+0x17e/0x2f0 [xfs]
 xlog_cil_committed+0x2a9/0x300 [xfs]
 xlog_cil_process_committed+0x69/0x80 [xfs]
 xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
 xlog_force_shutdown+0xdf/0x150 [xfs]
 xfs_do_force_shutdown+0x5f/0x150 [xfs]
 xlog_ioend_work+0x71/0x80 [xfs]
 process_one_work+0x1c5/0x390
 worker_thread+0x30/0x350
 kthread+0xd7/0x100
 ret_from_fork+0x1f/0x30

This is processing an EIO error to a log write, and it's
triggering a force shutdown. This causes the log to be shut down,
and then it is running attached iclog callbacks from the shutdown
context. That means the fs and log has already been marked as
xfs_is_shutdown/xlog_is_shutdown and so high level code will abort
(e.g. xfs_trans_commit(), xfs_log_force(), etc) with an error
because of shutdown.

The umount would have been blocked waiting for a log force
completion inside xfs_log_cover() -> xfs_sync_sb(). The first thing
for this situation to occur is for xfs_sync_sb() to exit without
waiting for the iclog buffer to be comitted to disk. The
above trace is the completion routine for the iclog buffer, and
it is shutting down the filesystem.

xlog_state_shutdown_callbacks() does this:

{
        struct xlog_in_core     *iclog;
        LIST_HEAD(cb_list);

        spin_lock(&log->l_icloglock);
        iclog = log->l_iclog;
        do {
                if (atomic_read(&iclog->ic_refcnt)) {
                        /* Reference holder will re-run iclog callbacks. */
                        continue;
                }
                list_splice_init(&iclog->ic_callbacks, &cb_list);
>>>>>>           wake_up_all(&iclog->ic_write_wait);
>>>>>>           wake_up_all(&iclog->ic_force_wait);
        } while ((iclog = iclog->ic_next) != log->l_iclog);

        wake_up_all(&log->l_flush_wait);
        spin_unlock(&log->l_icloglock);

>>>>>>  xlog_cil_process_committed(&cb_list);
}

This wakes any thread waiting on IO completion of the iclog (in this
case the umount log force) before shutdown processes all the pending
callbacks.  That means the xfs_sync_sb() waiting on a sync
transaction in xfs_log_force() on iclog->ic_force_wait will get
woken before the callbacks attached to that iclog are run. This
results in xfs_sync_sb() returning an error, and so unmount unblocks
and continues to run whilst the log shutdown is still in progress.

Normally this is just fine because the force waiter has nothing to
do with AIL operations. But in the case of this unmount path, the
log force waiter goes on to tear down the AIL because the log is now
shut down and so nothing ever blocks it again from the wait point in
xfs_log_cover().

Hence it's a race to see who gets to the AIL first - the unmount
code or xlog_cil_process_committed() killing the superblock buffer.

To fix this, we just have to change the order of processing in
xlog_state_shutdown_callbacks() to run the callbacks before it wakes
any task waiting on completion of the iclog.

Reported-by: Brian Foster <bfoster@redhat.com>
Fixes: aad7272a9208 ("xfs: separate out log shutdown callback processing")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -487,7 +487,10 @@ out_error:
  * Run all the pending iclog callbacks and wake log force waiters and iclog
  * space waiters so they can process the newly set shutdown state. We really
  * don't care what order we process callbacks here because the log is shut down
- * and so state cannot change on disk anymore.
+ * and so state cannot change on disk anymore. However, we cannot wake waiters
+ * until the callbacks have been processed because we may be in unmount and
+ * we must ensure that all AIL operations the callbacks perform have completed
+ * before we tear down the AIL.
  *
  * We avoid processing actively referenced iclogs so that we don't run callbacks
  * while the iclog owner might still be preparing the iclog for IO submssion.
@@ -501,7 +504,6 @@ xlog_state_shutdown_callbacks(
 	struct xlog_in_core	*iclog;
 	LIST_HEAD(cb_list);
 
-	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
 	do {
 		if (atomic_read(&iclog->ic_refcnt)) {
@@ -509,14 +511,16 @@ xlog_state_shutdown_callbacks(
 			continue;
 		}
 		list_splice_init(&iclog->ic_callbacks, &cb_list);
+		spin_unlock(&log->l_icloglock);
+
+		xlog_cil_process_committed(&cb_list);
+
+		spin_lock(&log->l_icloglock);
 		wake_up_all(&iclog->ic_write_wait);
 		wake_up_all(&iclog->ic_force_wait);
 	} while ((iclog = iclog->ic_next) != log->l_iclog);
 
 	wake_up_all(&log->l_flush_wait);
-	spin_unlock(&log->l_icloglock);
-
-	xlog_cil_process_committed(&cb_list);
 }
 
 /*
@@ -583,11 +587,8 @@ xlog_state_release_iclog(
 		 * pending iclog callbacks that were waiting on the release of
 		 * this iclog.
 		 */
-		if (last_ref) {
-			spin_unlock(&log->l_icloglock);
+		if (last_ref)
 			xlog_state_shutdown_callbacks(log);
-			spin_lock(&log->l_icloglock);
-		}
 		return -EIO;
 	}
 
@@ -3904,7 +3905,10 @@ xlog_force_shutdown(
 	wake_up_all(&log->l_cilp->xc_start_wait);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
 	spin_unlock(&log->l_cilp->xc_push_lock);
+
+	spin_lock(&log->l_icloglock);
 	xlog_state_shutdown_callbacks(log);
+	spin_unlock(&log->l_icloglock);
 
 	return log_error;
 }


