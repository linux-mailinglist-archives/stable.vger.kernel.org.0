Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E224B4930
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243551AbiBNKEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:04:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344372AbiBNKDb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:03:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFA141996;
        Mon, 14 Feb 2022 01:48:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E654B80D83;
        Mon, 14 Feb 2022 09:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB86C340E9;
        Mon, 14 Feb 2022 09:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832127;
        bh=Ps3oBb9b+xFWRMsLAGzbqJCxUR2gJJ6YgKqya6yTpKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFxl+p8qPMVGmonc3sjBvcWyXxM6O2Tpf+ojIz9tEX4+oygjo2w+rVcXuNQQADtRc
         jHX5LDIxkOg01p1B+pTKigJ8tnMFYHTMi4WTqPUgAbAMK0fBI3d/VP1kDVwmCdgpzr
         y2/58efOXfWXkl3bEYwkgN3p9AuFF6Tv9H6Po5g4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/172] phy: xilinx: zynqmp: Fix bus width setting for SGMII
Date:   Mon, 14 Feb 2022 10:25:45 +0100
Message-Id: <20220214092509.420516886@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index f478d8a17115b..9be9535ad7ab7 100644
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
@@ -445,12 +446,12 @@ static void xpsgtr_phy_init_sata(struct xpsgtr_phy *gtr_phy)
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



