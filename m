Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3975C198F52
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgCaJCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730696AbgCaJCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:02:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41D7720787;
        Tue, 31 Mar 2020 09:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645342;
        bh=Irv4dI89uT/HZw/zpNiTUqKbVXvlI606scLyEu0Vg8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8EB72m0BZ7qzZEfQNz7oHjf0dDr5VSl7s7je/zwMLaqR8+MkgbT4QaWbNt6XMv3l
         Sh8Ok5PHQ91DBOe60H4Yv/kDaziy7YjCmfYAgvLIn/Ly3aUdaBKL6RKo0BAg972I5T
         ySPsPwckKnLOH1Py7/GTvcByyMRssyrxNfsmWW6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 024/170] net: phy: dp83867: w/a for fld detect threshold bootstrapping issue
Date:   Tue, 31 Mar 2020 10:57:18 +0200
Message-Id: <20200331085426.629750627@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 749f6f6843115b424680f1aada3c0dd613ad807c ]

When the DP83867 PHY is strapped to enable Fast Link Drop (FLD) feature
STRAP_STS2.STRAP_ FLD (reg 0x006F bit 10), the Energy Lost Threshold for
FLD Energy Lost Mode FLD_THR_CFG.ENERGY_LOST_FLD_THR (reg 0x002e bits 2:0)
will be defaulted to 0x2. This may cause the phy link to be unstable. The
new DP83867 DM recommends to always restore ENERGY_LOST_FLD_THR to 0x1.

Hence, restore default value of FLD_THR_CFG.ENERGY_LOST_FLD_THR to 0x1 when
FLD is enabled by bootstrapping as recommended by DM.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83867.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -28,7 +28,8 @@
 #define DP83867_CTRL		0x1f
 
 /* Extended Registers */
-#define DP83867_CFG4            0x0031
+#define DP83867_FLD_THR_CFG	0x002e
+#define DP83867_CFG4		0x0031
 #define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
 #define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
 #define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
@@ -91,6 +92,7 @@
 #define DP83867_STRAP_STS2_CLK_SKEW_RX_MASK	GENMASK(2, 0)
 #define DP83867_STRAP_STS2_CLK_SKEW_RX_SHIFT	0
 #define DP83867_STRAP_STS2_CLK_SKEW_NONE	BIT(2)
+#define DP83867_STRAP_STS2_STRAP_FLD		BIT(10)
 
 /* PHY CTRL bits */
 #define DP83867_PHYCR_FIFO_DEPTH_SHIFT		14
@@ -123,6 +125,9 @@
 /* CFG4 bits */
 #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
 
+/* FLD_THR_CFG */
+#define DP83867_FLD_THR_CFG_ENERGY_LOST_THR_MASK	0x7
+
 enum {
 	DP83867_PORT_MIRROING_KEEP,
 	DP83867_PORT_MIRROING_EN,
@@ -459,6 +464,20 @@ static int dp83867_config_init(struct ph
 		phy_clear_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
 				   BIT(7));
 
+	bs = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_STRAP_STS2);
+	if (bs & DP83867_STRAP_STS2_STRAP_FLD) {
+		/* When using strap to enable FLD, the ENERGY_LOST_FLD_THR will
+		 * be set to 0x2. This may causes the PHY link to be unstable -
+		 * the default value 0x1 need to be restored.
+		 */
+		ret = phy_modify_mmd(phydev, DP83867_DEVADDR,
+				     DP83867_FLD_THR_CFG,
+				     DP83867_FLD_THR_CFG_ENERGY_LOST_THR_MASK,
+				     0x1);
+		if (ret)
+			return ret;
+	}
+
 	if (phy_interface_is_rgmii(phydev)) {
 		val = phy_read(phydev, MII_DP83867_PHYCTRL);
 		if (val < 0)


