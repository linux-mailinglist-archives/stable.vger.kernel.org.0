Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E63EE127
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhHQAg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236360AbhHQAgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A48F560F14;
        Tue, 17 Aug 2021 00:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160564;
        bh=4gyxiK/n9KX7xbOFQ97wN+1L5/y2dlCEb5MXDADMqBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvyh/B90lvdiF9ns6yOc8O+1EirhQkowqp+D4ntCTgy6vZBFdRIGcLWDdWZQjY3Ab
         v5rdDTIUQwuN4D7BDtvuMbY83rQOuogNm2GlTNavpYvM+qP2Zz0fShsYCqFlaDCtoW
         JOJn34AZbCLsQZKEVhaJqas2jdNFXcUzep2jtXBWZUEvmyGMfVCNo/PUY8AoeMLMna
         6JgjvgedQWaaYngFYwaan5nNTFlDnbUum4Fh2mZZ/Lg6OfRrj8QIjcq3/EyVLp4Jt5
         SptcrvULbFaDdeSG/gQfTvsC1drVnP6wUNTup1parfUctuJYfX9+abWuwkj1jyVBs5
         i4VaPO1YmeHUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 7/9] blk-iocost: fix lockdep warning on blkcg->lock
Date:   Mon, 16 Aug 2021 20:35:52 -0400
Message-Id: <20210817003554.83213-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003554.83213-1-sashal@kernel.org>
References: <20210817003554.83213-1-sashal@kernel.org>
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
index b7d8a954d99c..e95b93f72bd5 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3039,19 +3039,19 @@ static ssize_t ioc_weight_write(struct kernfs_open_file *of, char *buf,
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

