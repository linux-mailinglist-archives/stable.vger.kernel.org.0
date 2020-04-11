Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6FC1A50BB
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgDKMUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgDKMUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:20:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFEA9206A1;
        Sat, 11 Apr 2020 12:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607636;
        bh=XK80WFjCFM0+ej1+ead99YTMoIFBiX/cPmEjWmGYqzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpQVOlov85o6a4Jpje6fpzNZSC+NXST6W7Xh6zMwJQo2W76KqXsfMtsbBDY61w6Vi
         VBPvn2McvHb5VDYTEh8CceEVXumJQe8QtwsBnDDRcCUFZpDorLZiJnL6zdbcY8VdN2
         +AbZkORDoMx2rohk64kBGeEfimhjM6wkgI8gv8P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 15/38] net: phy: at803x: fix clock sink configuration on ATH8030 and ATH8035
Date:   Sat, 11 Apr 2020 14:09:52 +0200
Message-Id: <20200411115500.870484118@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115459.324496182@linuxfoundation.org>
References: <20200411115459.324496182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit b1f4c209d84057b6d40b939b6e4404854271d797 ]

The masks in priv->clk_25m_reg and priv->clk_25m_mask are one-bits-set
for the values that comprise the fields, not zero-bits-set.

This patch fixes the clock frequency configuration for ATH8030 and
ATH8035 Atheros PHYs by removing the erroneous "~".

To reproduce this bug, configure the PHY  with the device tree binding
"qca,clk-out-frequency" and remove the machine specific PHY fixups.

Fixes: 2f664823a47021 ("net: phy: at803x: add device tree binding")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Tested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/at803x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -425,8 +425,8 @@ static int at803x_parse_dt(struct phy_de
 		 */
 		if (at803x_match_phy_id(phydev, ATH8030_PHY_ID) ||
 		    at803x_match_phy_id(phydev, ATH8035_PHY_ID)) {
-			priv->clk_25m_reg &= ~AT8035_CLK_OUT_MASK;
-			priv->clk_25m_mask &= ~AT8035_CLK_OUT_MASK;
+			priv->clk_25m_reg &= AT8035_CLK_OUT_MASK;
+			priv->clk_25m_mask &= AT8035_CLK_OUT_MASK;
 		}
 	}
 


