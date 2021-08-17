Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903BC3EE117
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhHQAgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235999AbhHQAgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D4C160F55;
        Tue, 17 Aug 2021 00:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160551;
        bh=qGPaQj73xkmgPoSQwd6WKS5+iUqYTWAl4B6wMKaSzwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsKtiItlJGLXPoqmvNUyauEy0c8ybg068usodItQUG0OVE3VYbHUa2Ln/81qljRL/
         Xx+NXaeZiOCZzJKZ0aDb5g44daIYmMkyA4Qbzwiuiwb14vrh00cGi+H1EhttByx5im
         mOwt8OThnl6FIYjpa5BV0X9mKlaLyEqIL7BaWq1PW+xvCYWaPJmGPWv2cqVNpyl1uY
         +HI92Gzb1sgxoe9d3smQdHDha4j71xnWBGj1dR3hakJTHTbZPvUJGpQDuIgOUegwVY
         MVfaMmroJF7CJ2BJUfAchhI7EFDgGfIgV/hmklaDllfRVcsUhhaPp0Tdlkaha8bHZs
         KyxwWy7483YaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 10/12] blk-iocost: fix lockdep warning on blkcg->lock
Date:   Mon, 16 Aug 2021 20:35:34 -0400
Message-Id: <20210817003536.83063-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003536.83063-1-sashal@kernel.org>
References: <20210817003536.83063-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 11431e26c9c43fa26f6b33ee1a90989f57b86024 ]

blkcg->lock depends on q->queue_lock which may depend on another driver
lock required in irq context, one example is dm-thin:

	Chain exists of:
	  &pool->lock#3 --> &q->queue_lock --> &blkcg->lock

	 Possible interrupt unsafe locking scenario:

	       CPU0                    CPU1
	       ----                    ----
	  lock(&blkcg->lock);
	                               local_irq_disable();
	                               lock(&pool->lock#3);
	                               lock(&q->queue_lock);
	  <Interrupt>
	    lock(&pool->lock#3);

Fix the issue by using spin_lock_irq(&blkcg->lock) in ioc_weight_write().

Cc: Tejun Heo <tj@kernel.org>
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Link: https://lore.kernel.org/linux-block/CA+QYu4rzz6079ighEanS3Qq_Dmnczcf45ZoJoHKVLVATTo1e4Q@mail.gmail.com/T/#u
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20210803070608.1766400-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 5fac3757e6e0..0e56557cacf2 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3061,19 +3061,19 @@ static ssize_t ioc_weight_write(struct kernfs_open_file *of, char *buf,
 		if (v < CGROUP_WEIGHT_MIN || v > CGROUP_WEIGHT_MAX)
 			return -EINVAL;
 
-		spin_lock(&blkcg->lock);
+		spin_lock_irq(&blkcg->lock);
 		iocc->dfl_weight = v * WEIGHT_ONE;
 		hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node) {
 			struct ioc_gq *iocg = blkg_to_iocg(blkg);
 
 			if (iocg) {
-				spin_lock_irq(&iocg->ioc->lock);
+				spin_lock(&iocg->ioc->lock);
 				ioc_now(iocg->ioc, &now);
 				weight_updated(iocg, &now);
-				spin_unlock_irq(&iocg->ioc->lock);
+				spin_unlock(&iocg->ioc->lock);
 			}
 		}
-		spin_unlock(&blkcg->lock);
+		spin_unlock_irq(&blkcg->lock);
 
 		return nbytes;
 	}
-- 
2.30.2

