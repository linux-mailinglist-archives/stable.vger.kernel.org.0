Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4EC10BABE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfK0VGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbfK0VGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:06:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F58621770;
        Wed, 27 Nov 2019 21:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888769;
        bh=UdTQy0sebNhzvQQBQPvL4tB24mTeh/mRDWo6wJ5MdCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHeyFRKOVc545hTi6kBE4HS/XHa3yS++XSU8PxHin683BQvI2PrGj3x4lpRc6rNcY
         MjMRdx7Ud5XAqTtT2IMoxoQfNt3MNkIg+8dW6Tb9ylySa4xk9LC0Dh0EK++JHd7LRG
         c0LeBMzOlsrKVSiOS5VmUhv9laAyj9qw5bQKIZsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Uvarov <muvarov@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 4.19 262/306] net: phy: dp83867: fix speed 10 in sgmii mode
Date:   Wed, 27 Nov 2019 21:31:52 +0100
Message-Id: <20191127203133.982768147@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Uvarov <muvarov@gmail.com>

commit 333061b924539c0de081339643f45514f5f1c1e6 upstream.

For supporting 10Mps speed in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
of DP83867_10M_SGMII_CFG register has to be cleared by software.
That does not affect speeds 100 and 1000 so can be done on init.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ adapted for kernels without phy_modify_mmd ]
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/dp83867.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -37,6 +37,8 @@
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
 #define DP83867_IO_MUX_CFG	0x0170
+#define DP83867_10M_SGMII_CFG   0x016F
+#define DP83867_10M_SGMII_RATE_ADAPT_MASK BIT(7)
 
 #define DP83867_SW_RESET	BIT(15)
 #define DP83867_SW_RESTART	BIT(14)
@@ -294,6 +296,23 @@ static int dp83867_config_init(struct ph
 		}
 	}
 
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		/* For support SPEED_10 in SGMII mode
+		 * DP83867_10M_SGMII_RATE_ADAPT bit
+		 * has to be cleared by software. That
+		 * does not affect SPEED_100 and
+		 * SPEED_1000.
+		 */
+		val = phy_read_mmd(phydev, DP83867_DEVADDR,
+				   DP83867_10M_SGMII_CFG);
+		val &= ~DP83867_10M_SGMII_RATE_ADAPT_MASK;
+		ret = phy_write_mmd(phydev, DP83867_DEVADDR,
+				    DP83867_10M_SGMII_CFG, val);
+
+		if (ret)
+			return ret;
+	}
+
 	/* Enable Interrupt output INT_OE in CFG3 register */
 	if (phy_interrupt_is_valid(phydev)) {
 		val = phy_read(phydev, DP83867_CFG3);


