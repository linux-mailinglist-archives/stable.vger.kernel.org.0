Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45086A5E
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404504AbfHHTPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404515AbfHHTGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:06:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5917421882;
        Thu,  8 Aug 2019 19:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291207;
        bh=P/54bSpCJpUwxgQUnW/OJbhwuoF+50j/V8zB5zTi/SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgUbf2AGeSLivJt9yK/omvmAFz1S7xsDHWhatun/nR247jCIBaNL0mrvB4OZf3WA1
         YbOxXulR9EIuMXzZrQFdWV0L2dq16h/xxsnJjI+ru4GpBvSJaHRBMjprSxQWEYv0ZO
         HvjzCKwLhKNB9DjUwEYK8C1U0dLoc3Uq8V+QY0hY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@suse.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 27/56] net: phy: mscc: initialize stats array
Date:   Thu,  8 Aug 2019 21:04:53 +0200
Message-Id: <20190808190454.020579894@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Schwab <schwab@suse.de>

[ Upstream commit f972037e71246c5e0916eef835174d58ffc517e4 ]

The memory allocated for the stats array may contain arbitrary data.

Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
Fixes: 00d70d8e0e78 ("net: phy: mscc: add support for VSC8574 PHY")
Fixes: a5afc1678044 ("net: phy: mscc: add support for VSC8584 PHY")
Fixes: f76178dc5218 ("net: phy: mscc: add ethtool statistics counters")
Signed-off-by: Andreas Schwab <schwab@suse.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mscc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -2226,8 +2226,8 @@ static int vsc8514_probe(struct phy_devi
 	vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc85xx_hw_stats;
 	vsc8531->nstats = ARRAY_SIZE(vsc85xx_hw_stats);
-	vsc8531->stats = devm_kmalloc_array(&phydev->mdio.dev, vsc8531->nstats,
-					    sizeof(u64), GFP_KERNEL);
+	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
+				      sizeof(u64), GFP_KERNEL);
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
@@ -2251,8 +2251,8 @@ static int vsc8574_probe(struct phy_devi
 	vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc8584_hw_stats;
 	vsc8531->nstats = ARRAY_SIZE(vsc8584_hw_stats);
-	vsc8531->stats = devm_kmalloc_array(&phydev->mdio.dev, vsc8531->nstats,
-					    sizeof(u64), GFP_KERNEL);
+	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
+				      sizeof(u64), GFP_KERNEL);
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
@@ -2281,8 +2281,8 @@ static int vsc8584_probe(struct phy_devi
 	vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc8584_hw_stats;
 	vsc8531->nstats = ARRAY_SIZE(vsc8584_hw_stats);
-	vsc8531->stats = devm_kmalloc_array(&phydev->mdio.dev, vsc8531->nstats,
-					    sizeof(u64), GFP_KERNEL);
+	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
+				      sizeof(u64), GFP_KERNEL);
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
@@ -2311,8 +2311,8 @@ static int vsc85xx_probe(struct phy_devi
 	vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc85xx_hw_stats;
 	vsc8531->nstats = ARRAY_SIZE(vsc85xx_hw_stats);
-	vsc8531->stats = devm_kmalloc_array(&phydev->mdio.dev, vsc8531->nstats,
-					    sizeof(u64), GFP_KERNEL);
+	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
+				      sizeof(u64), GFP_KERNEL);
 	if (!vsc8531->stats)
 		return -ENOMEM;
 


