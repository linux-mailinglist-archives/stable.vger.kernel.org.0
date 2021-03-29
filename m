Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA46C34C652
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhC2IGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231580AbhC2IFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:05:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A0C61938;
        Mon, 29 Mar 2021 08:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005142;
        bh=PzrJR67FvEnJOBrgFZg6b5pr2t3VI0la/+3L64PDOL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rF6UvN998eAmIniacdv+AcRTi9Jk02bCl/PEZsqTcnywffjb9GCba86n7vYtrynzX
         gpbXRb1L3EJSKxw0vF8hxRCIxAOYxd1pmCkX1dTM+GM8QroeDiaA/2Rp20YI5rI/Dy
         TthT0G+3+8roZFe9Sa4vkRG4YVS24XZ2pTON08tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/59] net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port
Date:   Mon, 29 Mar 2021 09:58:12 +0200
Message-Id: <20210329075609.949091231@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 47142ed6c34d544ae9f0463e58d482289cbe0d46 ]

Similar to commit 92696286f3bb37ba50e4bd8d1beb24afb759a799 ("net:
bcmgenet: Set phydev->dev_flags only for internal PHYs") we need to
qualify the phydev->dev_flags based on whether the port is connected to
an internal or external PHY otherwise we risk having a flags collision
with a completely different interpretation depending on the driver.

Fixes: aa9aef77c761 ("net: dsa: bcm_sf2: communicate integrated PHY revision to PHY driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 7fc84ae562a2..11a72c4cbb92 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -613,8 +613,10 @@ static u32 bcm_sf2_sw_get_phy_flags(struct dsa_switch *ds, int port)
 	 * in bits 15:8 and the patch level in bits 7:0 which is exactly what
 	 * the REG_PHY_REVISION register layout is.
 	 */
-
-	return priv->hw_params.gphy_rev;
+	if (priv->int_phy_mask & BIT(port))
+		return priv->hw_params.gphy_rev;
+	else
+		return 0;
 }
 
 static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
-- 
2.30.1



