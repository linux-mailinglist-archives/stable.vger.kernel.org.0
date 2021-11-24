Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC6745C5BD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353490AbhKXOAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355541AbhKXN6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E97D96339C;
        Wed, 24 Nov 2021 13:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759276;
        bh=/fprBi0tYgrQ0S313FUJCtkVjXQfhBa6qb+hqU3QPM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwO/HpprURsP2l3nZCsF8Id4fFrISeA8gBWMooUxyl/iFID0jqRz6tTmreXhAtBHI
         E5XeEWU3RWDcuUySilXZmGUrkYZBoaxhF6TL0YPX0qjTvAlccujXyQKNzEF8UNEMx3
         cwXLUduJVF9FQCFFDF2aE8CDGPSrmeDwpIFLKQxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/279] blk-cgroup: fix missing put device in error path from blkg_conf_pref()
Date:   Wed, 24 Nov 2021 12:57:53 +0100
Message-Id: <20211124115725.149385331@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 15c30104965101b8e76b24d27035569d6613a7d6 ]

If blk_queue_enter() failed due to queue is dying, the
blkdev_put_no_open() is needed because blkcg_conf_open_bdev() succeeded.

Fixes: 0c9d338c8443 ("blk-cgroup: synchronize blkg creation against policy deactivation")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20211102020705.2321858-1-yukuai3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ebff1af402e5b..0eec59e4df65c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -639,7 +639,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	 */
 	ret = blk_queue_enter(q, 0);
 	if (ret)
-		return ret;
+		goto fail;
 
 	rcu_read_lock();
 	spin_lock_irq(&q->queue_lock);
@@ -675,13 +675,13 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		new_blkg = blkg_alloc(pos, q, GFP_KERNEL);
 		if (unlikely(!new_blkg)) {
 			ret = -ENOMEM;
-			goto fail;
+			goto fail_exit_queue;
 		}
 
 		if (radix_tree_preload(GFP_KERNEL)) {
 			blkg_free(new_blkg);
 			ret = -ENOMEM;
-			goto fail;
+			goto fail_exit_queue;
 		}
 
 		rcu_read_lock();
@@ -721,9 +721,10 @@ fail_preloaded:
 fail_unlock:
 	spin_unlock_irq(&q->queue_lock);
 	rcu_read_unlock();
+fail_exit_queue:
+	blk_queue_exit(q);
 fail:
 	blkdev_put_no_open(bdev);
-	blk_queue_exit(q);
 	/*
 	 * If queue was bypassing, we should retry.  Do so after a
 	 * short msleep().  It isn't strictly necessary but queue
-- 
2.33.0



