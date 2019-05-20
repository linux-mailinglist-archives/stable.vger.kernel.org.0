Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D912723758
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbfETMYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388821AbfETMY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FBA821479;
        Mon, 20 May 2019 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355068;
        bh=ycNscqJZV8YNkDTJQJ3tWYn2NGAC0HG7tA/dy/+VuWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQdIe/s3pSg4LiqXcxuyZjLxeAivn5pnqoMxHNNcj+lSw2ou74FaTzuOBTSreEDp5
         Sc9kg5lHpVykUviL+1WsdVNFqXPtdR3Oxvk92LP5WE836VJb/NpzVQQJZPee9DdvWk
         fmLJc0YK2d3YtelOlK4SXIIL53WaAolNpxAj34I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 083/105] fs/writeback.c: use rcu_barrier() to wait for inflight wb switches going into workqueue when umount
Date:   Mon, 20 May 2019 14:14:29 +0200
Message-Id: <20190520115252.996154732@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiufei Xue <jiufei.xue@linux.alibaba.com>

commit ec084de929e419e51bcdafaafe567d9e7d0273b7 upstream.

synchronize_rcu() didn't wait for call_rcu() callbacks, so inode wb
switch may not go to the workqueue after synchronize_rcu().  Thus
previous scheduled switches was not finished even flushing the
workqueue, which will cause a NULL pointer dereferenced followed below.

  VFS: Busy inodes after unmount of vdd. Self-destruct in 5 seconds.  Have a nice day...
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000278
    evict+0xb3/0x180
    iput+0x1b0/0x230
    inode_switch_wbs_work_fn+0x3c0/0x6a0
    worker_thread+0x4e/0x490
    ? process_one_work+0x410/0x410
    kthread+0xe6/0x100
    ret_from_fork+0x39/0x50

Replace the synchronize_rcu() call with a rcu_barrier() to wait for all
pending callbacks to finish.  And inc isw_nr_in_flight after call_rcu()
in inode_switch_wbs() to make more sense.

Link: http://lkml.kernel.org/r/20190429024108.54150-1-jiufei.xue@linux.alibaba.com
Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Acked-by: Tejun Heo <tj@kernel.org>
Suggested-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs-writeback.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -530,8 +530,6 @@ static void inode_switch_wbs(struct inod
 
 	isw->inode = inode;
 
-	atomic_inc(&isw_nr_in_flight);
-
 	/*
 	 * In addition to synchronizing among switchers, I_WB_SWITCH tells
 	 * the RCU protected stat update paths to grab the i_page
@@ -539,6 +537,9 @@ static void inode_switch_wbs(struct inod
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
+
+	atomic_inc(&isw_nr_in_flight);
+
 	goto out_unlock;
 
 out_free:
@@ -908,7 +909,11 @@ restart:
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


