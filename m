Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B216E3917D
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbfFGQAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730062AbfFGPkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:40:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C769A214D8;
        Fri,  7 Jun 2019 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922042;
        bh=gKNAFyK22tYRKB11/vHXTkanklIh/BMUv2eXKW5ZH8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1GjCgY+MAJQUEUNsrBDNxPXn4I+3FhoKksahGjpKa2Ua4AIMbJQuXTapf/gzMxom
         IyEjysBhI7jriehWdznOvonsVy5SEM1BxvyCB8K+64S3WJehWcIQgL3OKjLAy8S5Ca
         lItpATvDz5IfKMdIN8Y2C7Qd37dv5usPIx1CbHec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 16/69] net: phy: marvell10g: report if the PHY fails to boot firmware
Date:   Fri,  7 Jun 2019 17:38:57 +0200
Message-Id: <20190607153850.300582175@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
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
 drivers/net/phy/marvell10g.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -19,6 +19,9 @@
 #include <linux/marvell_phy.h>
 
 enum {
+	MV_PMA_BOOT		= 0xc050,
+	MV_PMA_BOOT_FATAL	= BIT(0),
+
 	MV_PCS_BASE_T		= 0x0000,
 	MV_PCS_BASE_R		= 0x1000,
 	MV_PCS_1000BASEX	= 0x2000,
@@ -59,11 +62,22 @@ static int mv3310_modify(struct phy_devi
 static int mv3310_probe(struct phy_device *phydev)
 {
 	u32 mmd_mask = MDIO_DEVS_PMAPMD | MDIO_DEVS_AN;
+	int ret;
 
 	if (!phydev->is_c45 ||
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
 	return 0;
 }
 


