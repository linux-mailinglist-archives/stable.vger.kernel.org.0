Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8A06C18A8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbjCTP0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjCTP0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:26:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA0A2A14F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:19:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4544B615B3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510CFC433D2;
        Mon, 20 Mar 2023 15:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325564;
        bh=Eb5jnuG1Ekz+HQ+52zkkQu/88M0jhTAM6jLx6dtOlQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTjRPTjNT4Dyb7ik4nC/X1grU5N3Upi/XH4/s4DYOnu+rvnuZepFvfHJ6qDyqzLJb
         ndgd2JhFPL94zJUZezb08Ntiq4Ia9J3zl5KLlSwAkLB9JwOpqkmYTmZ0QJXcDpq0cv
         FCBsmRlAp2XWaJxi2cuxq42Mq3/yo7oVBhMqX7jY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Daniel Golle <daniel@makrotopia.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 062/211] net: ethernet: mtk_eth_soc: reset PCS state
Date:   Mon, 20 Mar 2023 15:53:17 +0100
Message-Id: <20230320145515.828203504@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 611e2dabb4b3243d176739fd6a5a34d007fa3f86 ]

Reset the internal PCS state machine when changing interface mode.
This prevents confusing the state machine when changing interface
modes, e.g. from SGMII to 2500Base-X or vice-versa.

Fixes: 7e538372694b ("net: ethernet: mediatek: Re-add support SGMII")
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Tested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 4 ++++
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index b481d0d46bb16..d4b4f9eaa4419 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -528,6 +528,10 @@
 #define SGMII_SEND_AN_ERROR_EN		BIT(11)
 #define SGMII_IF_MODE_MASK		GENMASK(5, 1)
 
+/* Register to reset SGMII design */
+#define SGMII_RESERVED_0	0x34
+#define SGMII_SW_RESET		BIT(0)
+
 /* Register to set SGMII speed, ANA RG_ Control Signals III*/
 #define SGMSYS_ANA_RG_CS3	0x2028
 #define RG_PHY_SPEED_MASK	(BIT(2) | BIT(3))
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index bb00de1003ac4..612f65bb03454 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -88,6 +88,10 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
 				   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
 
+		/* Reset SGMII PCS state */
+		regmap_update_bits(mpcs->regmap, SGMII_RESERVED_0,
+				   SGMII_SW_RESET, SGMII_SW_RESET);
+
 		if (interface == PHY_INTERFACE_MODE_2500BASEX)
 			rgc3 = RG_PHY_SPEED_3_125G;
 		else
-- 
2.39.2



