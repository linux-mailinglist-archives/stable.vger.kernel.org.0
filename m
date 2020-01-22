Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6D5145641
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgAVNXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:23:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730547AbgAVNXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:23:54 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 251FA24688;
        Wed, 22 Jan 2020 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699433;
        bh=QKDa25hlURHn5kDz4X4uEheo2MeMZoYUHemUpyuIs7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idqSZ/PAKrGsv1BCw5a/Es1Xjf3njgb26BnG+ROPO+RL4q+pA/J9lqKgcAggJnCf1
         gq9sDdKwh/C6zonS+rKF0virzwmZoxRGkEwtPSm2Q2Kc2IzDzzSa58V21gu1ZarSVH
         yU/4QJxwGXdzsI9xlt63g2lfP8vs8di+Nj892OWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 142/222] net: phy: dp83867: Set FORCE_LINK_GOOD to default after reset
Date:   Wed, 22 Jan 2020 10:28:48 +0100
Message-Id: <20200122092843.900371168@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 86ffe920e669ec73035e84553e18edf17d16317c ]

According to the Datasheet this bit should be 0 (Normal operation) in
default. With the FORCE_LINK_GOOD bit set, it is not possible to get a
link. This patch sets FORCE_LINK_GOOD to the default value after
resetting the phy.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83867.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -80,6 +80,7 @@
 #define DP83867_PHYCR_FIFO_DEPTH_MAX		0x03
 #define DP83867_PHYCR_FIFO_DEPTH_MASK		GENMASK(15, 14)
 #define DP83867_PHYCR_RESERVED_MASK		BIT(11)
+#define DP83867_PHYCR_FORCE_LINK_GOOD		BIT(10)
 
 /* RGMIIDCTL bits */
 #define DP83867_RGMII_TX_CLK_DELAY_MAX		0xf
@@ -454,7 +455,12 @@ static int dp83867_phy_reset(struct phy_
 
 	usleep_range(10, 20);
 
-	return 0;
+	/* After reset FORCE_LINK_GOOD bit is set. Although the
+	 * default value should be unset. Disable FORCE_LINK_GOOD
+	 * for the phy to work properly.
+	 */
+	return phy_modify(phydev, MII_DP83867_PHYCTRL,
+			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
 }
 
 static struct phy_driver dp83867_driver[] = {


