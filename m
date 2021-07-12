Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD8F3C4561
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbhGLGZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235121AbhGLGYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7B49611AF;
        Mon, 12 Jul 2021 06:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070871;
        bh=Yi5NytIE9J3gmo0GWWAKPRo90xCSBXEVAHL4emG5zCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7Gw5LXRH+hgEQrlJOtd4JPlCqVFfJ0JRWAjwiwuYho+xhO9rxGjPtZLtlbhUHXT3
         BPHrul5pez5s4Cu4K99coQVtoVJCDR4O15Cq0hFliH9WR+cqyvwf66QSnghWZn/nHw
         YGSJxLgcSXok9vQEjTkU/eAjm3Qmq9ysDYKV7Of0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 177/348] blk-wbt: introduce a new disable state to prevent false positive by rwb_enabled()
Date:   Mon, 12 Jul 2021 08:09:21 +0200
Message-Id: <20210712060724.385474539@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 1d0903d61e9645c6330b94247b96dd873dfc11c8 ]

Now that we disable wbt by simply zero out rwb->wb_normal in
wbt_disable_default() when switch elevator to bfq, but it's not safe
because it will become false positive if we change queue depth. If it
become false positive between wbt_wait() and wbt_track() when submit
write request, it will lead to drop rqw->inflight to -1 in wbt_done(),
which will end up trigger IO hung. Fix this issue by introduce a new
state which mean the wbt was disabled.

Fixes: a79050434b45 ("blk-rq-qos: refactor out common elements of blk-wbt")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20210619093700.920393-2-yi.zhang@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-wbt.c | 5 +++--
 block/blk-wbt.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 8641ba9793c5..7c7dd5c14391 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -77,7 +77,8 @@ enum {
 
 static inline bool rwb_enabled(struct rq_wb *rwb)
 {
-	return rwb && rwb->wb_normal != 0;
+	return rwb && rwb->enable_state != WBT_STATE_OFF_DEFAULT &&
+		      rwb->wb_normal != 0;
 }
 
 static void wb_timestamp(struct rq_wb *rwb, unsigned long *var)
@@ -710,7 +711,7 @@ void wbt_disable_default(struct request_queue *q)
 	rwb = RQWB(rqos);
 	if (rwb->enable_state == WBT_STATE_ON_DEFAULT) {
 		blk_stat_deactivate(rwb->cb);
-		rwb->wb_normal = 0;
+		rwb->enable_state = WBT_STATE_OFF_DEFAULT;
 	}
 }
 EXPORT_SYMBOL_GPL(wbt_disable_default);
diff --git a/block/blk-wbt.h b/block/blk-wbt.h
index 8e4e37660971..d8d9f41b42f9 100644
--- a/block/blk-wbt.h
+++ b/block/blk-wbt.h
@@ -34,6 +34,7 @@ enum {
 enum {
 	WBT_STATE_ON_DEFAULT	= 1,
 	WBT_STATE_ON_MANUAL	= 2,
+	WBT_STATE_OFF_DEFAULT
 };
 
 struct rq_wb {
-- 
2.30.2



