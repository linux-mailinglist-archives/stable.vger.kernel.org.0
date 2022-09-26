Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E5B5EA4DA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238500AbiIZL4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238981AbiIZLyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E564DB00;
        Mon, 26 Sep 2022 03:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC92B60B2F;
        Mon, 26 Sep 2022 10:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11C5C433C1;
        Mon, 26 Sep 2022 10:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189338;
        bh=rSpcze+w5f8A6yGVWV9axhSYli8sV5dEXvHyPyy8LP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMI1eKMW/+uz6oNgT84xg24fbpM9RFPw60WU1chWol4E9j6HlfejmJmtP9bAT8Wkn
         HyoA8okA15hS1iiSJ/RnfLSx9Izs7x97hNHxy5f5Ob6tXLDciN+l2Gau29aCW/T5Oj
         Whc/cFFM5CLp8xjsdf5RWHVz2fryEHjHxrCabges=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Andrew Lunn <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 153/207] net: phy: micrel: fix shared interrupt on LAN8814
Date:   Mon, 26 Sep 2022 12:12:22 +0200
Message-Id: <20220926100813.496924103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 2002fbac743b6e2391b4ed50ad9eb626768dd78a ]

Since commit ece19502834d ("net: phy: micrel: 1588 support for LAN8814
phy") the handler always returns IRQ_HANDLED, except in an error case.
Before that commit, the interrupt status register was checked and if
it was empty, IRQ_NONE was returned. Restore that behavior to play nice
with the interrupt line being shared with others.

Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Divya Koppera <Divya.Koppera@microchip.com>
Link: https://lore.kernel.org/r/20220920141619.808117-1-michael@walle.cc
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 34483a4bd688..e8e1101911b2 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2662,16 +2662,19 @@ static int lan8804_config_init(struct phy_device *phydev)
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status, tsu_irq_status;
+	int ret = IRQ_NONE;
 
 	irq_status = phy_read(phydev, LAN8814_INTS);
-	if (irq_status > 0 && (irq_status & LAN8814_INT_LINK))
-		phy_trigger_machine(phydev);
-
 	if (irq_status < 0) {
 		phy_error(phydev);
 		return IRQ_NONE;
 	}
 
+	if (irq_status & LAN8814_INT_LINK) {
+		phy_trigger_machine(phydev);
+		ret = IRQ_HANDLED;
+	}
+
 	while (1) {
 		tsu_irq_status = lanphy_read_page_reg(phydev, 4,
 						      LAN8814_INTR_STS_REG);
@@ -2680,12 +2683,15 @@ static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 		    (tsu_irq_status & (LAN8814_INTR_STS_REG_1588_TSU0_ |
 				       LAN8814_INTR_STS_REG_1588_TSU1_ |
 				       LAN8814_INTR_STS_REG_1588_TSU2_ |
-				       LAN8814_INTR_STS_REG_1588_TSU3_)))
+				       LAN8814_INTR_STS_REG_1588_TSU3_))) {
 			lan8814_handle_ptp_interrupt(phydev);
-		else
+			ret = IRQ_HANDLED;
+		} else {
 			break;
+		}
 	}
-	return IRQ_HANDLED;
+
+	return ret;
 }
 
 static int lan8814_ack_interrupt(struct phy_device *phydev)
-- 
2.35.1



