Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F228C25A69
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 00:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfEUWn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 18:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfEUWn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 18:43:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB7B92184B;
        Tue, 21 May 2019 22:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558478637;
        bh=BDTqBY98gwfc/zufw9LKEQ457obIX01gojH2UsjGsNo=;
        h=Date:From:To:Subject:From;
        b=lVHTt+JlCi5Omdq3DvSDlJyJxu4Twgwlvjv+z/Yv9aF7gllE+i9oQooHGj/WWqbhe
         nH8iZN9J6C2UjOJM6SRdwPNp2kTBAT28UdU6Ifmo1lIKYu2k17tsdQHRZDgFJFW0A3
         jq/e/1lxnsrDTD80u0DjXISXnVcP3IsWp3KZg0YI=
Date:   Tue, 21 May 2019 15:43:57 -0700
From:   akpm@linux-foundation.org
To:     jiufei.xue@linux.alibaba.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, tj@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?fs-writeback-use-rcu=5Fbarrier-to-wait-for-inflight-wb-swi?=
 =?US-ASCII?Q?tches-going-into-workqueue-when-umount.patch?= removed from
 -mm tree
Message-ID: <20190521224357.6O-AURWTz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/writeback.c: use rcu_barrier() to wait for inflight wb switches going into workqueue when umount
has been removed from the -mm tree.  Its filename was
     fs-writeback-use-rcu_barrier-to-wait-for-inflight-wb-switches-going-into-workqueue-when-umount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jiufei.xue@linux.alibaba.com are


