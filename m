Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D71A4D82CE
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbiCNML3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241073AbiCNMIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:08:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9385130F47;
        Mon, 14 Mar 2022 05:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 05F37CE1268;
        Mon, 14 Mar 2022 12:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB70C340E9;
        Mon, 14 Mar 2022 12:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259464;
        bh=sGG4xEp0veDolkndlxoaSezooSPfZ1+e2LfA0C1bkR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AY3ltJtInTcydp217F4ccvbPcrt7KIQeaLHw7kNLHBSIeDuclQ2idCHJWN+bbJta5
         A1OcQYoZwfw5UYOtSAtrpw9Mw953Rcm3EH+MZqGjwmspcvI3XoOoaZY4SaQ8k5+9Ps
         8lHxwyl/pXB83RJmDslqTTjhksZY6PgZdryPEZgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/110] net: phy: meson-gxl: fix interrupt handling in forced mode
Date:   Mon, 14 Mar 2022 12:53:15 +0100
Message-Id: <20220314112743.403681167@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit a502a8f04097e038c3daa16c5202a9538116d563 ]

This PHY doesn't support a link-up interrupt source. If aneg is enabled
we use the "aneg complete" interrupt for this purpose, but if aneg is
disabled link-up isn't signaled currently.
According to a vendor driver there's an additional "energy detect"
interrupt source that can be used to signal link-up if aneg is disabled.
We can safely ignore this interrupt source if aneg is enabled.

This patch was tested on a TX3 Mini TV box with S905W (even though
boot message says it's a S905D).

This issue has been existing longer, but due to changes in phylib and
the driver the patch applies only from the commit marked as fixed.

Fixes: 84c8f773d2dc ("net: phy: meson-gxl: remove the use of .ack_callback()")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/04cac530-ea1b-850e-6cfa-144a55c4d75d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/meson-gxl.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 7e7904fee1d9..c49062ad72c6 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -30,8 +30,12 @@
 #define  INTSRC_LINK_DOWN	BIT(4)
 #define  INTSRC_REMOTE_FAULT	BIT(5)
 #define  INTSRC_ANEG_COMPLETE	BIT(6)
+#define  INTSRC_ENERGY_DETECT	BIT(7)
 #define INTSRC_MASK	30
 
+#define INT_SOURCES (INTSRC_LINK_DOWN | INTSRC_ANEG_COMPLETE | \
+		     INTSRC_ENERGY_DETECT)
+
 #define BANK_ANALOG_DSP		0
 #define BANK_WOL		1
 #define BANK_BIST		3
@@ -200,7 +204,6 @@ static int meson_gxl_ack_interrupt(struct phy_device *phydev)
 
 static int meson_gxl_config_intr(struct phy_device *phydev)
 {
-	u16 val;
 	int ret;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
@@ -209,16 +212,9 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
 		if (ret)
 			return ret;
 
-		val = INTSRC_ANEG_PR
-			| INTSRC_PARALLEL_FAULT
-			| INTSRC_ANEG_LP_ACK
-			| INTSRC_LINK_DOWN
-			| INTSRC_REMOTE_FAULT
-			| INTSRC_ANEG_COMPLETE;
-		ret = phy_write(phydev, INTSRC_MASK, val);
+		ret = phy_write(phydev, INTSRC_MASK, INT_SOURCES);
 	} else {
-		val = 0;
-		ret = phy_write(phydev, INTSRC_MASK, val);
+		ret = phy_write(phydev, INTSRC_MASK, 0);
 
 		/* Ack any pending IRQ */
 		ret = meson_gxl_ack_interrupt(phydev);
@@ -237,9 +233,16 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
+	irq_status &= INT_SOURCES;
+
 	if (irq_status == 0)
 		return IRQ_NONE;
 
+	/* Aneg-complete interrupt is used for link-up detection */
+	if (phydev->autoneg == AUTONEG_ENABLE &&
+	    irq_status == INTSRC_ENERGY_DETECT)
+		return IRQ_HANDLED;
+
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
-- 
2.34.1



