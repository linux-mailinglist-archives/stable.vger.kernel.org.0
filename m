Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE4B10BDEE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbfK0UxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:53:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbfK0UxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:53:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC2A21903;
        Wed, 27 Nov 2019 20:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887988;
        bh=tHrJ+YCWwkR88WUqXar21vkFGy5QEqlLZ0Xs5JXIW3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP2Wetcs+STHrKk+LxubeKyBBjyRRbqtekNQ2tCgo6TW8B56P3v6OwZupwnAJHZon
         AYdvqlzuTSDb9e48gHimvWet36YAHkyeRhFqcxzGtwcoJ9xYa9eLPCWrYkoUTKDFo1
         II8w/AORG1589Rph9WTiFtopr/TRdi02Wfro7P8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Uvarov <muvarov@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 4.14 171/211] net: phy: dp83867: increase SGMII autoneg timer duration
Date:   Wed, 27 Nov 2019 21:31:44 +0100
Message-Id: <20191127203110.034421649@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Uvarov <muvarov@gmail.com>

commit 1a97a477e666cbdededab93bd3754e508f0c09d7 upstream.

After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
That is not enough to finalize autonegatiation on some devices.
Increase this timer duration to maximum supported 16ms.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ adapted for kernels without phy_modify_mmd ]
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/dp83867.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -33,6 +33,12 @@
 
 /* Extended Registers */
 #define DP83867_CFG4            0x0031
+#define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
+#define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_16MS   (0 << 5)
+
 #define DP83867_RGMIICTL	0x0032
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
@@ -300,6 +306,18 @@ static int dp83867_config_init(struct ph
 
 		if (ret)
 			return ret;
+
+		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
+		 * are 01). That is not enough to finalize autoneg on some
+		 * devices. Increase this timer duration to maximum 16ms.
+		 */
+		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4);
+		val &= ~DP83867_CFG4_SGMII_ANEG_MASK;
+		val |= DP83867_CFG4_SGMII_ANEG_TIMER_16MS;
+		ret = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4, val);
+
+		if (ret)
+			return ret;
 	}
 
 	/* Enable Interrupt output INT_OE in CFG3 register */


