Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F3432C70
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfFCJL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbfFCJLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:11:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C50FF27E57;
        Mon,  3 Jun 2019 09:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553085;
        bh=AehziPUQS6ljn1V8LLSb27f6Zro9/dJ3O/PsXbIV+yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pdu1SGwq/1ekyVKtStEOzf7zoI8r/0VA2PsP52gKZcm1enMnT5Ax0KPdSsVBxPPG0
         tJI0rqUx/Yja0isA/+zhaWAoglgWWq4xX8aJp9sl3OtafgXwULSTEHO6Jb3i9rBldz
         QcNkXJTy7A7bsCRgQbD9j3YLUeh+q4eqJsbCG6EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 15/36] net: phy: marvell10g: report if the PHY fails to boot firmware
Date:   Mon,  3 Jun 2019 11:09:03 +0200
Message-Id: <20190603090521.967139526@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 3d3ced2ec5d71b99d72ae6910fbdf890bc2eccf0 ]

Some boards do not have the PHY firmware programmed in the 3310's flash,
which leads to the PHY not working as expected.  Warn the user when the
PHY fails to boot the firmware and refuse to initialise.

Fixes: 20b2af32ff3f ("net: phy: add Marvell Alaska X 88X3310 10Gigabit PHY support")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell10g.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -29,6 +29,9 @@
 #define MDIO_AN_10GBT_CTRL_ADV_NBT_MASK	0x01e0
 
 enum {
+	MV_PMA_BOOT		= 0xc050,
+	MV_PMA_BOOT_FATAL	= BIT(0),
+
 	MV_PCS_BASE_T		= 0x0000,
 	MV_PCS_BASE_R		= 0x1000,
 	MV_PCS_1000BASEX	= 0x2000,
@@ -228,6 +231,16 @@ static int mv3310_probe(struct phy_devic
 	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
 		return -ENODEV;
 
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MV_PMA_BOOT_FATAL) {
+		dev_warn(&phydev->mdio.dev,
+			 "PHY failed to boot firmware, status=%04x\n", ret);
+		return -ENODEV;
+	}
+
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;


