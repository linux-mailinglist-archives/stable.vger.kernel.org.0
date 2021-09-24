Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11C4172B2
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344585AbhIXMut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343965AbhIXMtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:49:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02DCF61164;
        Fri, 24 Sep 2021 12:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487662;
        bh=aJQe5lCArK09m0hsV83U8kMbXwdCnposyjYAP3kZq/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=weBHuNVdFHClkU84CNKd9rZ5eT5IOcx+UTjt6Kkyxsn+9NYnkgR9oBH/gfE1JtfRl
         hFYZr/fOnZ0hlw5+F8m5WMV3OvBykM7hnP9xjJLqrrqsBfIBIAAjP2GNbVhPKn4koH
         CY3wWJt6iRnxg2Uw+oJXI7G3suw4THG+C0d0lj3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jinlin <lijinlin3@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/27] blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()
Date:   Fri, 24 Sep 2021 14:44:20 +0200
Message-Id: <20210924124330.053225617@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
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
index a8cd7b3d9647..fcbbe2e45a2b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2414,6 +2414,7 @@ int blk_throtl_init(struct request_queue *q)
 void blk_throtl_exit(struct request_queue *q)
 {
 	BUG_ON(!q->td);
+	del_timer_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
 	blkcg_deactivate_policy(q, &blkcg_policy_throtl);
 	free_percpu(q->td->latency_buckets);
-- 
2.33.0



