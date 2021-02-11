Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D40318E26
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhBKPV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:21:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhBKPSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 329DA64F12;
        Thu, 11 Feb 2021 15:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055953;
        bh=mBU5b8VRc4MSpIsnNB2jc88+ZShmw8rX+D3GQtW1cFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G95xZDAYNuJxLeqW02FiNjtGuJtZO3x5PNTkSIk/ieIDaYFHh13kRW4VmhNtr9g5v
         ZoGlqYl1cQILklWVOB6fr3FUWYZSQ/v977RvzGAIyqaxOzmJiZf/7uKoT6Dv2AEvAF
         Pgtq2IIMp6KI3pmHYe03YFCUtMbGyRlGwFpZMeJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/24] blk-cgroup: Use cond_resched() when destroy blkgs
Date:   Thu, 11 Feb 2021 16:02:41 +0100
Message-Id: <20210211150149.315436519@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3d34ac02d76ef..cb3d44d200055 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1089,6 +1089,8 @@ static void blkcg_css_offline(struct cgroup_subsys_state *css)
  */
 void blkcg_destroy_blkgs(struct blkcg *blkcg)
 {
+	might_sleep();
+
 	spin_lock_irq(&blkcg->lock);
 
 	while (!hlist_empty(&blkcg->blkg_list)) {
@@ -1096,14 +1098,20 @@ void blkcg_destroy_blkgs(struct blkcg *blkcg)
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



