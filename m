Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576153CDD07
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241982AbhGSOzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244782AbhGSOxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:53:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2362461263;
        Mon, 19 Jul 2021 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708753;
        bh=c/5BV9Bj/jtYa4g9blAqzUKz7ddRS9cS6X+QQQYD06M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJTxpph0uV3B60tKL3ex2ER0kuKl6bdupeGSAbXP8qz5Ke5Uev/8sd21UgSSoA++C
         41eHQX5wJ3muuT040zkyJRD6deq4DMvsAHbDZQB29Yq6eZRTM5BceeFs1R8SYcY5A7
         TxFRja8npcZ8JMxZy0olwp/Naw/Qs8JBjGKweVpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/421] blk-wbt: make sure throttle is enabled properly
Date:   Mon, 19 Jul 2021 16:48:49 +0200
Message-Id: <20210719144950.643291305@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 08623f37617f..880a41adde8f 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -704,9 +704,13 @@ void wbt_set_write_cache(struct request_queue *q, bool write_cache_on)
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



