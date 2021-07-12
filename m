Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBEE3C455F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbhGLGZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235122AbhGLGYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D789611AB;
        Mon, 12 Jul 2021 06:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070873;
        bh=6bb55UEYQJtDb0ZZ6Y27q92PGWzl7dEbNfqZHxdj6WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJZHi1uerx3TJLtyWfZJWGgcQOlx9DNSeipB9Z+L6IZj7e/tDDWCrVanm3YCVHh6L
         6V5LBWKS+CpeCiNEMSj7MYVuI5cvSLf2lHwrb2iGaQ0FSUK0nH8XBzl3XeVFt8f16E
         naCI6k7FL3gat2cWw2dHPtUWUEIY3RaBxlBavPrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/348] blk-wbt: make sure throttle is enabled properly
Date:   Mon, 12 Jul 2021 08:09:22 +0200
Message-Id: <20210712060724.513089133@linuxfoundation.org>
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
index 7c7dd5c14391..ee708c1bc352 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -645,9 +645,13 @@ void wbt_set_write_cache(struct request_queue *q, bool write_cache_on)
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



