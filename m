Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826BF5B703F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiIMOY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbiIMOXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:23:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D856611C;
        Tue, 13 Sep 2022 07:15:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E06614AE;
        Tue, 13 Sep 2022 14:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87642C433D7;
        Tue, 13 Sep 2022 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078467;
        bh=900PzX5Acpk2QwjDYmAp0NBaHR6gsyXB1qRe6hcKIko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjYWEr31TSTu/zPUeALnrDL+7bw5+LOX2Er0JtKNy3pVUchTsRc+n/3o1oUlOPN2K
         Xf6S4TYMTZPUWDKQTzYOa7kM6mO2oOiuD9TxUwIyDzSIatXrHUfxgt8Jib8PmHdJ7q
         9FNojrCxKDdWvD+MKAWViMrqED9Vsp8Ukz7nrpeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 150/192] net: phy: lan87xx: change interrupt src of link_up to comm_ready
Date:   Tue, 13 Sep 2022 16:04:16 +0200
Message-Id: <20220913140417.497196854@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Ramadoss <arun.ramadoss@microchip.com>

[ Upstream commit 5382033a35227c57a349d74752ad2527780159a9 ]

Currently phy link up/down interrupt is enabled using the
LAN87xx_INTERRUPT_MASK register. In the lan87xx_read_status function,
phy link is determined using the T1_MODE_STAT_REG register comm_ready bit.
comm_ready bit is set using the loc_rcvr_status & rem_rcvr_status.
Whenever the phy link is up, LAN87xx_INTERRUPT_SOURCE link_up bit is set
first but comm_ready bit takes some time to set based on local and
remote receiver status.
As per the current implementation, interrupt is triggered using link_up
but the comm_ready bit is still cleared in the read_status function. So,
link is always down.  Initially tested with the shared interrupt
mechanism with switch and internal phy which is working, but after
implementing interrupt controller it is not working.
It can fixed either by updating the read_status function to read from
LAN87XX_INTERRUPT_SOURCE register or enable the interrupt mask for
comm_ready bit. But the validation team recommends the use of comm_ready
for link detection.
This patch fixes by enabling the comm_ready bit for link_up in the
LAN87XX_INTERRUPT_MASK_2 register (MISC Bank) and link_down in
LAN87xx_INTERRUPT_MASK register.

Fixes: 8a1b415d70b7 ("net: phy: added ethtool master-slave configuration support")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220905152750.5079-1-arun.ramadoss@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/microchip_t1.c | 58 +++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index d4c93d59bc539..8569a545e0a3f 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -28,12 +28,16 @@
 
 /* Interrupt Source Register */
 #define LAN87XX_INTERRUPT_SOURCE                (0x18)
+#define LAN87XX_INTERRUPT_SOURCE_2              (0x08)
 
 /* Interrupt Mask Register */
 #define LAN87XX_INTERRUPT_MASK                  (0x19)
 #define LAN87XX_MASK_LINK_UP                    (0x0004)
 #define LAN87XX_MASK_LINK_DOWN                  (0x0002)
 
+#define LAN87XX_INTERRUPT_MASK_2                (0x09)
+#define LAN87XX_MASK_COMM_RDY			BIT(10)
+
 /* MISC Control 1 Register */
 #define LAN87XX_CTRL_1                          (0x11)
 #define LAN87XX_MASK_RGMII_TXC_DLY_EN           (0x4000)
@@ -424,17 +428,55 @@ static int lan87xx_phy_config_intr(struct phy_device *phydev)
 	int rc, val = 0;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
-		/* unmask all source and clear them before enable */
-		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, 0x7FFF);
+		/* clear all interrupt */
+		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
+		if (rc < 0)
+			return rc;
+
 		rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
-		val = LAN87XX_MASK_LINK_UP | LAN87XX_MASK_LINK_DOWN;
+		if (rc < 0)
+			return rc;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_MASK_2, val);
+		if (rc < 0)
+			return rc;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_SOURCE_2, 0);
+		if (rc < 0)
+			return rc;
+
+		/* enable link down and comm ready interrupt */
+		val = LAN87XX_MASK_LINK_DOWN;
 		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
+		if (rc < 0)
+			return rc;
+
+		val = LAN87XX_MASK_COMM_RDY;
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_MASK_2, val);
 	} else {
 		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
-		if (rc)
+		if (rc < 0)
 			return rc;
 
 		rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
+		if (rc < 0)
+			return rc;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_MASK_2, val);
+		if (rc < 0)
+			return rc;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_SOURCE_2, 0);
 	}
 
 	return rc < 0 ? rc : 0;
@@ -444,6 +486,14 @@ static irqreturn_t lan87xx_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status;
 
+	irq_status  = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				  PHYACC_ATTR_BANK_MISC,
+				  LAN87XX_INTERRUPT_SOURCE_2, 0);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
 	irq_status = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
 	if (irq_status < 0) {
 		phy_error(phydev);
-- 
2.35.1



