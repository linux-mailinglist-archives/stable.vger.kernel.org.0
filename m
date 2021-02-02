Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7193930C496
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbhBBP40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235253AbhBBPMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A0EC64F70;
        Tue,  2 Feb 2021 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278407;
        bh=QEaEtUdgOwqKhjqXpL8Ve8WrJNYFJPvtx5Ol4GMzAww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdGb6c1ZlHQtvYng7x2dxV7szjJuFWD/KcwQA1IYWwDWatxZpIYFDH/d9a5i/aYs2
         8r1tioxFvikMP6ebK1BLUXBLjkMQUXI3dQXVHWHMfUoFMYgw0OAApsxs0yV4NuUYXI
         uIxzg8VB+c9jVr4logmaUK71FUyS028vS1cXP9Z8AxYcC2d6gz/uidxI1sIesncGF8
         XfPvhigP4NaUb8tz6lrxkOIgOqeB/g0UNmnD8s1CzmoIM/+ZBXCsc+l1N9OG1vA8Kl
         lA1XBGOP4vLqE9zZQl8rlJhHUVtNzFcWiNo/EpuGHWKFzR7uTY1Kj3EyeTYaNMk06+
         rWxKsfPPzLXAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baolin Wang <baolin.wang@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/25] blk-cgroup: Use cond_resched() when destroy blkgs
Date:   Tue,  2 Feb 2021 10:06:14 -0500
Message-Id: <20210202150615.1864175-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 6c635caef410aa757befbd8857c1eadde5cc22ed ]

On !PREEMPT kernel, we can get below softlockup when doing stress
testing with creating and destroying block cgroup repeatly. The
reason is it may take a long time to acquire the queue's lock in
the loop of blkcg_destroy_blkgs(), or the system can accumulate a
huge number of blkgs in pathological cases. We can add a need_resched()
check on each loop and release locks and do cond_resched() if true
to avoid this issue, since the blkcg_destroy_blkgs() is not called
from atomic contexts.

[ 4757.010308] watchdog: BUG: soft lockup - CPU#11 stuck for 94s!
[ 4757.010698] Call trace:
[ 4757.010700]  blkcg_destroy_blkgs+0x68/0x150
[ 4757.010701]  cgwb_release_workfn+0x104/0x158
[ 4757.010702]  process_one_work+0x1bc/0x3f0
[ 4757.010704]  worker_thread+0x164/0x468
[ 4757.010705]  kthread+0x108/0x138

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 54fbe1e80cc41..f13688c4b9317 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1017,6 +1017,8 @@ static void blkcg_css_offline(struct cgroup_subsys_state *css)
  */
 void blkcg_destroy_blkgs(struct blkcg *blkcg)
 {
+	might_sleep();
+
 	spin_lock_irq(&blkcg->lock);
 
 	while (!hlist_empty(&blkcg->blkg_list)) {
@@ -1024,14 +1026,20 @@ void blkcg_destroy_blkgs(struct blkcg *blkcg)
 						struct blkcg_gq, blkcg_node);
 		struct request_queue *q = blkg->q;
 
-		if (spin_trylock(&q->queue_lock)) {
-			blkg_destroy(blkg);
-			spin_unlock(&q->queue_lock);
-		} else {
+		if (need_resched() || !spin_trylock(&q->queue_lock)) {
+			/*
+			 * Given that the system can accumulate a huge number
+			 * of blkgs in pathological cases, check to see if we
+			 * need to rescheduling to avoid softlockup.
+			 */
 			spin_unlock_irq(&blkcg->lock);
-			cpu_relax();
+			cond_resched();
 			spin_lock_irq(&blkcg->lock);
+			continue;
 		}
+
+		blkg_destroy(blkg);
+		spin_unlock(&q->queue_lock);
 	}
 
 	spin_unlock_irq(&blkcg->lock);
-- 
2.27.0

