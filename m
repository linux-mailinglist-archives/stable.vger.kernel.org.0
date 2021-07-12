Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C62B3C494D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbhGLGnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237686AbhGLGlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A697B610FA;
        Mon, 12 Jul 2021 06:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071937;
        bh=s3DRTfCNjYTdY8CkL/eLUhR1xdmA8QiN27nLEWTp1Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSNbw6Z6hUGF+hYDf9KGoQYwmkAHLqNr+SzSGZwucKaf/S3H+Q63I+vPdbITuw1gf
         mHKe0pKwhqAvBvrixePhxiV9BEqe/yWuK4VNjaICzzi3gxxTWPkRxEUUxOB5pgXmNX
         awYG3xCc661CpGe2k+c+V3b1jujxHa4ksagCHrP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/593] blk-wbt: introduce a new disable state to prevent false positive by rwb_enabled()
Date:   Mon, 12 Jul 2021 08:07:23 +0200
Message-Id: <20210712060915.343426687@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index fd410086fe1d..d90082c6b41f 100644
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
@@ -702,7 +703,7 @@ void wbt_disable_default(struct request_queue *q)
 	rwb = RQWB(rqos);
 	if (rwb->enable_state == WBT_STATE_ON_DEFAULT) {
 		blk_stat_deactivate(rwb->cb);
-		rwb->wb_normal = 0;
+		rwb->enable_state = WBT_STATE_OFF_DEFAULT;
 	}
 }
 EXPORT_SYMBOL_GPL(wbt_disable_default);
diff --git a/block/blk-wbt.h b/block/blk-wbt.h
index 16bdc85b8df9..2eb01becde8c 100644
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



