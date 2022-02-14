Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFFF4B46B2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbiBNJuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:50:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245509AbiBNJuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:50:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FD5A1B2;
        Mon, 14 Feb 2022 01:41:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF2B611B8;
        Mon, 14 Feb 2022 09:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEF7C340E9;
        Mon, 14 Feb 2022 09:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831667;
        bh=iPR46toKRaybBG1ZVK3CBILUGx+GNDjIARheSgboNc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpDezGbSitP+dJTpmXYZjxp+j/hknZBCIv7/GsIHXVO0BmbNNq3KkqHAOxI4WJ0e1
         y+urcOKq16gEDTD+oL5jAXM4DFLhdGsEAcTr8exdXhDdrypHqBeCJzE2M/iSIpWlqU
         LgHfuxTpq1v9kOzVi5RR+2i67n05RpRfZ2r8PNCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/116] phy: xilinx: zynqmp: Fix bus width setting for SGMII
Date:   Mon, 14 Feb 2022 10:25:55 +0100
Message-Id: <20220214092500.669503172@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 37291f60d0822f191748c2a54ce63b0bc669020f ]

TX_PROT_BUS_WIDTH and RX_PROT_BUS_WIDTH are single registers with
separate bit fields for each lane. The code in xpsgtr_phy_init_sgmii was
not preserving the existing register value for other lanes, so enabling
the PHY in SGMII mode on one lane zeroed out the settings for all other
lanes, causing other PS-GTR peripherals such as USB3 to malfunction.

Use xpsgtr_clr_set to only manipulate the desired bits in the register.

Fixes: 4a33bea00314 ("phy: zynqmp: Add PHY driver for the Xilinx ZynqMP Gigabit Transceiver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20220126001600.1592218-1-robert.hancock@calian.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index 2b0f921b6ee3d..b8ccac6f31467 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -134,7 +134,8 @@
 #define PROT_BUS_WIDTH_10		0x0
 #define PROT_BUS_WIDTH_20		0x1
 #define PROT_BUS_WIDTH_40		0x2
-#define PROT_BUS_WIDTH_SHIFT		2
+#define PROT_BUS_WIDTH_SHIFT(n)		((n) * 2)
+#define PROT_BUS_WIDTH_MASK(n)		GENMASK((n) * 2 + 1, (n) * 2)
 
 /* Number of GT lanes */
 #define NUM_LANES			4
@@ -443,12 +444,12 @@ static void xpsgtr_phy_init_sata(struct xpsgtr_phy *gtr_phy)
 static void xpsgtr_phy_init_sgmii(struct xpsgtr_phy *gtr_phy)
 {
 	struct xpsgtr_dev *gtr_dev = gtr_phy->dev;
+	u32 mask = PROT_BUS_WIDTH_MASK(gtr_phy->lane);
+	u32 val = PROT_BUS_WIDTH_10 << PROT_BUS_WIDTH_SHIFT(gtr_phy->lane);
 
 	/* Set SGMII protocol TX and RX bus width to 10 bits. */
-	xpsgtr_write(gtr_dev, TX_PROT_BUS_WIDTH,
-		     PROT_BUS_WIDTH_10 << (gtr_phy->lane * PROT_BUS_WIDTH_SHIFT));
-	xpsgtr_write(gtr_dev, RX_PROT_BUS_WIDTH,
-		     PROT_BUS_WIDTH_10 << (gtr_phy->lane * PROT_BUS_WIDTH_SHIFT));
+	xpsgtr_clr_set(gtr_dev, TX_PROT_BUS_WIDTH, mask, val);
+	xpsgtr_clr_set(gtr_dev, RX_PROT_BUS_WIDTH, mask, val);
 
 	xpsgtr_bypass_scrambler_8b10b(gtr_phy);
 }
-- 
2.34.1



