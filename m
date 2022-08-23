Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7115359E011
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353602AbiHWKPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353312AbiHWKNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:13:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A149A7C31D;
        Tue, 23 Aug 2022 01:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D3C461524;
        Tue, 23 Aug 2022 08:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C9FC433C1;
        Tue, 23 Aug 2022 08:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245163;
        bh=cQg3fPWkkIsSmtVG4VO2rLOB3NlOMKkRDjzQ1j4JfCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwKzxoX7QSBgzuuGcrOrwYDWMlXXiFGhoiYjy7KWeCjnyO/RG7jh3SxTeorxxE7Xm
         SUt7hZ6FDYgPi+ep4XoQP5N1RHOEesa0opZsj/3P5Lz0nT12InlKa5hUvy0/xk9cNr
         2vHyPlsXnbYUj8R8x3PicWSfzMaSaBkKk1/d5thQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 236/244] xfs: flush inodegc workqueue tasks before cancel
Date:   Tue, 23 Aug 2022 10:26:35 +0200
Message-Id: <20220823080107.452202766@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 6191cf3ad59fda5901160633fef8e41b064a5246 ]

The xfs_inodegc_stop() helper performs a high level flush of pending
work on the percpu queues and then runs a cancel_work_sync() on each
of the percpu work tasks to ensure all work has completed before
returning.  While cancel_work_sync() waits for wq tasks to complete,
it does not guarantee work tasks have started. This means that the
_stop() helper can queue and instantly cancel a wq task without
having completed the associated work. This can be observed by
tracepoint inspection of a simple "rm -f <file>; fsfreeze -f <mnt>"
test:

	xfs_destroy_inode: ... ino 0x83 ...
	xfs_inode_set_need_inactive: ... ino 0x83 ...
	xfs_inodegc_stop: ...
	...
	xfs_inodegc_start: ...
	xfs_inodegc_worker: ...
	xfs_inode_inactivating: ... ino 0x83 ...

The first few lines show that the inode is removed and need inactive
state set, but the inactivation work has not completed before the
inodegc mechanism stops. The inactivation doesn't actually occur
until the fs is unfrozen and the gc mechanism starts back up. Note
that this test requires fsfreeze to reproduce because xfs_freeze
indirectly invokes xfs_fs_statfs(), which calls xfs_inodegc_flush().

When this occurs, the workqueue try_to_grab_pending() logic first
tries to steal the pending bit, which does not succeed because the
bit has been set by queue_work_on(). Subsequently, it checks for
association of a pool workqueue from the work item under the pool
lock. This association is set at the point a work item is queued and
cleared when dequeued for processing. If the association exists, the
work item is removed from the queue and cancel_work_sync() returns
true. If the pwq association is cleared, the remove attempt assumes
the task is busy and retries (eventually returning false to the
caller after waiting for the work task to complete).

To avoid this race, we can flush each work item explicitly before
cancel. However, since the _queue_all() already schedules each
underlying work item, the workqueue level helpers are sufficient to
achieve the same ordering effect. E.g., the inodegc enabled flag
prevents scheduling any further work in the _stop() case. Use the
drain_workqueue() helper in this particular case to make the intent
a bit more self explanatory.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1872,28 +1872,20 @@ xfs_inodegc_worker(
 }
 
 /*
- * Force all currently queued inode inactivation work to run immediately, and
- * wait for the work to finish. Two pass - queue all the work first pass, wait
- * for it in a second pass.
+ * Force all currently queued inode inactivation work to run immediately and
+ * wait for the work to finish.
  */
 void
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
-	struct xfs_inodegc	*gc;
-	int			cpu;
-
 	if (!xfs_is_inodegc_enabled(mp))
 		return;
 
 	trace_xfs_inodegc_flush(mp, __return_address);
 
 	xfs_inodegc_queue_all(mp);
-
-	for_each_online_cpu(cpu) {
-		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-		flush_work(&gc->work);
-	}
+	flush_workqueue(mp->m_inodegc_wq);
 }
 
 /*
@@ -1904,18 +1896,12 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
-	struct xfs_inodegc	*gc;
-	int			cpu;
-
 	if (!xfs_clear_inodegc_enabled(mp))
 		return;
 
 	xfs_inodegc_queue_all(mp);
+	drain_workqueue(mp->m_inodegc_wq);
 
-	for_each_online_cpu(cpu) {
-		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-		cancel_work_sync(&gc->work);
-	}
 	trace_xfs_inodegc_stop(mp, __return_address);
 }
 


