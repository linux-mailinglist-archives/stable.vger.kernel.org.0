Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CDD40EF6D
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbhIQCfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242847AbhIQCfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9391061164;
        Fri, 17 Sep 2021 02:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846067;
        bh=JV/I3sWrutKzK7p8ZnrvUoZG5aJchWwcew+bD5prKA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDb9xTRrg/Q1DGAxBRl0sksCDCp1oj3adqSU0yKU0ntxtE+ybbflfNxIPuqi7sbDZ
         ZG2kQA1F8jA8wX4YjRm8OZkyBrWSjRORtD1PDdBoDKViDE5uV738+RIx6P9QxYgBH8
         UbfGwHxnvN0l3NPrOOSgnKJshGK2B1ty0LTUrcENmWyWhZrBFzskMlsLWrxS0VuJaI
         im73rNs87TcgPuXkvT19xVkCsoGbIrMld/BiVNh1GQ3kfvvAzDxT/Amy7FL4af4gC/
         2D76JXi/DRjmJva7Db7UDvntNyWGYxV8fmguUFiTcIyuUEg6JwhHlFrpPJ/bKhot2z
         72Go+B/LqJvPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Jinlin <lijinlin3@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, tj@kernel.org
Subject: [PATCH AUTOSEL 5.14 16/21] blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()
Date:   Thu, 16 Sep 2021 22:33:10 -0400
Message-Id: <20210917023315.816225-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
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
index b1b22d863bdf..d0cc77c7b8bd 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2426,6 +2426,7 @@ int blk_throtl_init(struct request_queue *q)
 void blk_throtl_exit(struct request_queue *q)
 {
 	BUG_ON(!q->td);
+	del_timer_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
 	blkcg_deactivate_policy(q, &blkcg_policy_throtl);
 	free_percpu(q->td->latency_buckets[READ]);
-- 
2.30.2

