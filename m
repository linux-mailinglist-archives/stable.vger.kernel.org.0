Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0C42360C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389609AbfETM3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389975AbfETM3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:29:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9679920645;
        Mon, 20 May 2019 12:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355394;
        bh=onfGMYicXDP3MCBWfPIOJpbs01/cprEgL1AT+ll7nso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTI65A+CHpCnNq6O7dwPIFcsf0GrYQlyGCx62rIknslYdlSJBu2OhulVAZyOpJa+n
         zh/71XCFRpTZhpPaFrbOATkwGLauu2c39/NlHy5iuSv0wRw+r68xL7TO9HMy0ualZ+
         nR4jmQDiefD9eEx+7Z75Ho41GxyJbLSoco1cYClw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.0 100/123] fs/writeback.c: use rcu_barrier() to wait for inflight wb switches going into workqueue when umount
Date:   Mon, 20 May 2019 14:14:40 +0200
Message-Id: <20190520115251.686329530@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
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


