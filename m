Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C523A3C5348
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352248AbhGLHyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349296AbhGLHuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF2F5619A5;
        Mon, 12 Jul 2021 07:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075808;
        bh=mhfIjdyyEKu1F94mOcMqOS9kKuWphU9Cs+1XKnA2PeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bx9/CBU+K/BYzcT2dvSwzqyW2lP5qzAuD3eVE0hnvBZPcKsRQmxh+dMfA+CGNyH53
         i0jvEgQT9FPs3QzeqxR5s8mjPw4YZdTNidWuQYussBgvhoYvEGxbWGIHnBb7e0xXyb
         nHKdCHOFDh4e+TzSdpXlvORy2Hu8Pe6tYc8bCsW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 372/800] blk-wbt: make sure throttle is enabled properly
Date:   Mon, 12 Jul 2021 08:06:35 +0200
Message-Id: <20210712061006.642652465@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 76a8040817b4b9c69b53f9b326987fa891b4082a ]

After commit a79050434b45 ("blk-rq-qos: refactor out common elements of
blk-wbt"), if throttle was disabled by wbt_disable_default(), we could
not enable again, fix this by set enable_state back to
WBT_STATE_ON_DEFAULT.

Fixes: a79050434b45 ("blk-rq-qos: refactor out common elements of blk-wbt")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20210619093700.920393-3-yi.zhang@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-wbt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index b098ac6a84f0..f5e5ac915bf7 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -637,9 +637,13 @@ void wbt_set_write_cache(struct request_queue *q, bool write_cache_on)
 void wbt_enable_default(struct request_queue *q)
 {
 	struct rq_qos *rqos = wbt_rq_qos(q);
+
 	/* Throttling already enabled? */
-	if (rqos)
+	if (rqos) {
+		if (RQWB(rqos)->enable_state == WBT_STATE_OFF_DEFAULT)
+			RQWB(rqos)->enable_state = WBT_STATE_ON_DEFAULT;
 		return;
+	}
 
 	/* Queue not registered? Maybe shutting down... */
 	if (!blk_queue_registered(q))
-- 
2.30.2



