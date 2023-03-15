Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAFB6BB190
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbjCOM2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjCOM2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565D99B9AA
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF2E7B81DFA
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48484C4339C;
        Wed, 15 Mar 2023 12:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883242;
        bh=wxyEEABmaI3kuX8WVh0aQlFVZCJuXh0H+h0rntSbn4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gH+OGt2/N1/mGeJMUt/6SFUt5ug7EeyVhBkJulJy7+UnZf4ZRIgIDal9mK1iu4cRJ
         k1gnXUu2neM/USsi+011ojw5ppcR2iWYHi/INwRNUGTCTaHc8Hm0nWnqaaL67ONk9s
         aNpr6mdic1pr/MCsrlTEkeoZK/YEdKFB4vXn3tdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/145] net: phy: smsc: fix link up detection in forced irq mode
Date:   Wed, 15 Mar 2023 13:12:14 +0100
Message-Id: <20230315115741.279516501@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 58aac3a2ef414fea6d7fdf823ea177744a087d13 ]

Currently link up can't be detected in forced mode if polling
isn't used. Only link up interrupt source we have is aneg
complete which isn't applicable in forced mode. Therefore we
have to use energy-on as link up indicator.

Fixes: 7365494550f6 ("net: phy: smsc: skip ENERGYON interrupt if disabled")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 63dca3bb56110..04e628788f1b5 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -44,7 +44,6 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 };
 
 struct smsc_phy_priv {
-	u16 intmask;
 	bool energy_enable;
 	struct clk *refclk;
 };
@@ -58,7 +57,6 @@ static int smsc_phy_ack_interrupt(struct phy_device *phydev)
 
 static int smsc_phy_config_intr(struct phy_device *phydev)
 {
-	struct smsc_phy_priv *priv = phydev->priv;
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
@@ -66,14 +64,9 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 		if (rc)
 			return rc;
 
-		priv->intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
-		if (priv->energy_enable)
-			priv->intmask |= MII_LAN83C185_ISF_INT7;
-
-		rc = phy_write(phydev, MII_LAN83C185_IM, priv->intmask);
+		rc = phy_write(phydev, MII_LAN83C185_IM,
+			       MII_LAN83C185_ISF_INT_PHYLIB_EVENTS);
 	} else {
-		priv->intmask = 0;
-
 		rc = phy_write(phydev, MII_LAN83C185_IM, 0);
 		if (rc)
 			return rc;
@@ -86,7 +79,6 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 
 static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 {
-	struct smsc_phy_priv *priv = phydev->priv;
 	int irq_status;
 
 	irq_status = phy_read(phydev, MII_LAN83C185_ISF);
@@ -95,7 +87,7 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
-	if (!(irq_status & priv->intmask))
+	if (!(irq_status & MII_LAN83C185_ISF_INT_PHYLIB_EVENTS))
 		return IRQ_NONE;
 
 	phy_trigger_machine(phydev);
-- 
2.39.2



