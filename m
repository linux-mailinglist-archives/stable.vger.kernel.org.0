Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490364172FC
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344490AbhIXMxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344603AbhIXMvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:51:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 701FB61355;
        Fri, 24 Sep 2021 12:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487749;
        bh=uemeUSOut9gPy+m0FcIHqbzGFT7EclDPEYxnY67GtZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jM7Xh/a002CYKLTeWTJnO9BCIeqMdZzHe0rqGY2sk2xm/Gj+ohtVQ0G96cThLqEc0
         UQHRKVuEmUKwo8b264ZO9nM6wHDSbJr00/j8q2egNMW5S4Bvxm7jSs/kSNHPeQLN80
         +VCx/8y22KnQ6bZ5bBDhY4VYmkE6shwTgQ4u3IeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jinlin <lijinlin3@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/34] blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()
Date:   Fri, 24 Sep 2021 14:44:27 +0200
Message-Id: <20210924124331.050066166@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jinlin <lijinlin3@huawei.com>

[ Upstream commit 884f0e84f1e3195b801319c8ec3d5774e9bf2710 ]

The pending timer has been set up in blk_throtl_init(). However, the
timer is not deleted in blk_throtl_exit(). This means that the timer
handler may still be running after freeing the timer, which would
result in a use-after-free.

Fix by calling del_timer_sync() to delete the timer in blk_throtl_exit().

Signed-off-by: Li Jinlin <lijinlin3@huawei.com>
Link: https://lore.kernel.org/r/20210907121242.2885564-1-lijinlin3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index caee658609d7..853b1770df36 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2437,6 +2437,7 @@ int blk_throtl_init(struct request_queue *q)
 void blk_throtl_exit(struct request_queue *q)
 {
 	BUG_ON(!q->td);
+	del_timer_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
 	blkcg_deactivate_policy(q, &blkcg_policy_throtl);
 	free_percpu(q->td->latency_buckets[READ]);
-- 
2.33.0



