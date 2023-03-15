Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE026BB104
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjCOMYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjCOMX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:23:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE1690085
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:22:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24356B81E01
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782AFC433A1;
        Wed, 15 Mar 2023 12:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882911;
        bh=90QlV4b7PGLUMreR+1r340ANnX7nlY4hp0ter0rsICE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdFfobEysnYfFYibu3Q3+uOnFx0xCX1VXaZL40cKHuIjdmIluRTwmoM3z+rqPCov6
         TByCqu2yO/n9ZiCZroRz8z0UVSeVsnga7Tz5xE/YugMKAIMSy8dht76IrWxpRxEINA
         V6rsWi4vAHJQ7NVKlws4FS1EffWYrGkF6iQhhihM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Daniel Golle <daniel@makrotopia.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/104] net: ethernet: mtk_eth_soc: fix RX data corruption issue
Date:   Wed, 15 Mar 2023 13:12:20 +0100
Message-Id: <20230315115734.049355066@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 193250ace270fecd586dd2d0dfbd9cbd2ade977f ]

Fix data corruption issue with SerDes connected PHYs operating at 1.25
Gbps speed where we could previously observe about 30% packet loss while
the bad packet counter was increasing.

As almost all boards with MediaTek MT7622 or MT7986 use either the MT7531
switch IC operating at 3.125Gbps SerDes rate or single-port PHYs using
rate-adaptation to 2500Base-X mode, this issue only got exposed now when
we started trying to use SFP modules operating with 1.25 Gbps with the
BananaPi R3 board.

The fix is to set bit 12 which disables the RX FIFO clear function when
setting up MAC MCR, MediaTek SDK did the same change stating:
"If without this patch, kernel might receive invalid packets that are
corrupted by GMAC."[1]

[1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/d8a2975939a12686c4a95c40db21efdc3f821f63

Fixes: 42c03844e93d ("net-next: mediatek: add support for MediaTek MT7622 SoC")
Tested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/138da2735f92c8b6f8578ec2e5a794ee515b665f.1677937317.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 217dc67c48fa2..a8319295f1ab2 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -354,7 +354,8 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 	mcr_new = mcr_cur;
 	mcr_new |= MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
-		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
+		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK |
+		   MAC_MCR_RX_FIFO_CLR_DIS;
 
 	/* Only update control register when needed! */
 	if (mcr_new != mcr_cur)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 54a7cd93cc0fe..0ca3223ad5457 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -339,6 +339,7 @@
 #define MAC_MCR_FORCE_MODE	BIT(15)
 #define MAC_MCR_TX_EN		BIT(14)
 #define MAC_MCR_RX_EN		BIT(13)
+#define MAC_MCR_RX_FIFO_CLR_DIS	BIT(12)
 #define MAC_MCR_BACKOFF_EN	BIT(9)
 #define MAC_MCR_BACKPR_EN	BIT(8)
 #define MAC_MCR_FORCE_RX_FC	BIT(5)
-- 
2.39.2



