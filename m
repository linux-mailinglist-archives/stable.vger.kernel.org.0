Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC3B6DEF2D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjDLIsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjDLIsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:48:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34587ABF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88E4462B5B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977C0C433D2;
        Wed, 12 Apr 2023 08:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289259;
        bh=27lklvznINahqMlcvhIU/MmVPvw/ZCB2CcKur4Hj7gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCZtEV5qXpKhUoAGSonoX3+imwVJjyYXPjFAsYXcVb1favXOaPrGWs3goRNPaGwoX
         yhdmrOxfQmw0U6TRpYRYa9Xsm7DpX+0/W2e3P0D6jGoOwiyLcG+B7JMz7NGZ3k5GO1
         McXHb2Bdca232C9NqWSGg3zoq4M8EqdP1CqhChZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Frank Wunderlich <frank-w@public-files.de>,
        Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 031/173] net: ethernet: mtk_eth_soc: fix remaining throughput regression
Date:   Wed, 12 Apr 2023 10:32:37 +0200
Message-Id: <20230412082839.347863903@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit e669ce46740a9815953bb4452a6bc5a7fdc21a50 ]

Based on further tests, it seems that the QDMA shaper is not able to
perform shaping close to the MAC link rate without throughput loss.
This cannot be compensated by increasing the shaping rate, so it seems
to be an internal limit.

Fix the remaining throughput regression by detecting that condition and
limiting shaping to ports with lower link speed.

This patch intentionally ignores link speed gain from TRGMII, because
even on such links, shaping to 1000 Mbit/s incurs some throughput
degradation.

Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
Tested-By: Frank Wunderlich <frank-w@public-files.de>
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bd7c18c839d42..f56d4e7d4ae5d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -703,6 +703,7 @@ static void mtk_mac_link_up(struct phylink_config *config,
 		 MAC_MCR_FORCE_RX_FC);
 
 	/* Configure speed */
+	mac->speed = speed;
 	switch (speed) {
 	case SPEED_2500:
 	case SPEED_1000:
@@ -3169,6 +3170,9 @@ static int mtk_device_event(struct notifier_block *n, unsigned long event, void
 	if (dp->index >= MTK_QDMA_NUM_QUEUES)
 		return NOTIFY_DONE;
 
+	if (mac->speed > 0 && mac->speed <= s.base.speed)
+		s.base.speed = 0;
+
 	mtk_set_queue_speed(eth, dp->index + 3, s.base.speed);
 
 	return NOTIFY_DONE;
-- 
2.39.2



