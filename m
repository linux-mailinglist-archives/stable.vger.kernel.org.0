Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3634540EFB1
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243360AbhIQChb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243356AbhIQCgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B76C06113E;
        Fri, 17 Sep 2021 02:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846103;
        bh=/CMX3Tqh85fOcGQGzDRAAgK2xgMJcJcFolCJRyt6qpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8MSbblVdxAtzP3Eue3Ur+qHqyHENHkUYXb5cilNfwc+OGFkJS0iWP71YgAnipCXn
         9IQuxH1gOtv08/iA6zoS22kzEEDXzsrz/c4R4Qb2TWeKkAonCNcaYwiByHvgTVbZlp
         Iv/mOpPbf3MWjv1+i5FmsUIMWJLbOYGq79VdBGo8BhsWdlf2/yoFpdW07roqXRtYEL
         7xtJDLVdevSozxj67Ie2PpfdumoMzn6vAgcff8BIfKpcXTfy7GJtK+DBOtrXXPJSRx
         ZmvPx83dRMtLLdpDMhTyyFis3rKCF9i08ZAwPrgzXHgyiJpcgcHmSBkvFyh/i3TPvX
         fDpqvOcahjQjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Jinlin <lijinlin3@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, tj@kernel.org,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/4] blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()
Date:   Thu, 16 Sep 2021 22:34:57 -0400
Message-Id: <20210917023457.816816-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023457.816816-1-sashal@kernel.org>
References: <20210917023457.816816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.30.2

