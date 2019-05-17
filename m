Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2AE21FA7
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 23:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfEQVbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 17:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfEQVbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 17:31:46 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1680E216C4;
        Fri, 17 May 2019 21:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558128705;
        bh=Xp0A73MyI6t11UkQ36w8Z6GbRdbhWQDQ22XLL2W2imM=;
        h=Date:From:To:Subject:From;
        b=Iz4Dyron113fd6jVTTiE82KdcNjya91KdHWQPBj/iUhxyWtbl/xhn4V5jJXfnmxBS
         1QNBZ6XmRxijq7XvMeDxQpMnueIbohOqIda9c/S+4PUyF9JnvvSW+Pq7rQLOWFA+2Z
         Cqfx1sxWSVUrS/Ztj03WRawH0oB1kFING4eQNTsE=
Date:   Fri, 17 May 2019 14:31:44 -0700
From:   akpm@linux-foundation.org
To:     tj@kernel.org, stable@vger.kernel.org,
        jiufei.xue@linux.alibaba.com, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 5/7] fs/writeback.c: use rcu_barrier() to wait for
 inflight wb switches going into workqueue when umount
Message-ID: <20190517213144.W2Thz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: fs/writeback.c: use rcu_barrier() to wait for inflight wb switches going into workqueue when umount

synchronize_rcu() didn't wait for call_rcu() callbacks, so inode wb switch
may not go to the workqueue after synchronize_rcu().  Thus previous
scheduled switches was not finished even flushing the workqueue, which
will cause a NULL pointer dereferenced followed below.

VFS: Busy inodes after unmount of vdd. Self-destruct in 5 seconds.  Have a nice day...
BUG: unable to handle kernel NULL pointer dereference at 0000000000000278
[<ffffffff8126a303>] evict+0xb3/0x180
[<ffffffff8126a760>] iput+0x1b0/0x230
[<ffffffff8127c690>] inode_switch_wbs_work_fn+0x3c0/0x6a0
[<ffffffff810a5b2e>] worker_thread+0x4e/0x490
[<ffffffff810a5ae0>] ? process_one_work+0x410/0x410
[<ffffffff810ac056>] kthread+0xe6/0x100
[<ffffffff8173c199>] ret_from_fork+0x39/0x50

Replace the synchronize_rcu() call with a rcu_barrier() to wait for all
pending callbacks to finish.  And inc isw_nr_in_flight after call_rcu() in
inode_switch_wbs() to make more sense.

Link: http://lkml.kernel.org/r/20190429024108.54150-1-jiufei.xue@linux.alibaba.com
Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Acked-by: Tejun Heo <tj@kernel.org>
Suggested-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/fs-writeback.c~fs-writeback-use-rcu_barrier-to-wait-for-inflight-wb-switches-going-into-workqueue-when-umount
+++ a/fs/fs-writeback.c
@@ -523,8 +523,6 @@ static void inode_switch_wbs(struct inod
 
 	isw->inode = inode;
 
-	atomic_inc(&isw_nr_in_flight);
-
 	/*
 	 * In addition to synchronizing among switchers, I_WB_SWITCH tells
 	 * the RCU protected stat update paths to grab the i_page
@@ -532,6 +530,9 @@ static void inode_switch_wbs(struct inod
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
+
+	atomic_inc(&isw_nr_in_flight);
+
 	goto out_unlock;
 
 out_free:
@@ -901,7 +902,11 @@ restart:
 void cgroup_writeback_umount(void)
 {
 	if (atomic_read(&isw_nr_in_flight)) {
-		synchronize_rcu();
+		/*
+		 * Use rcu_barrier() to wait for all pending callbacks to
+		 * ensure that all in-flight wb switches are in the workqueue.
+		 */
+		rcu_barrier();
 		flush_workqueue(isw_wq);
 	}
 }
_
