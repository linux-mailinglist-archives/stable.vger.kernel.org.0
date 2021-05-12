Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DB837CAB3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241938AbhELQbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241090AbhELQ0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC0736196A;
        Wed, 12 May 2021 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834566;
        bh=VGGLO9mUYWvHY+1NnBDA1JMsX0iKbB6XwUyukAe7P1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dY9/fkuCCApEAwLIdN7agMie/Mnad4vwomXQGeA61eve2/jFwtzOKd0LtshNmpJA0
         Lm88+SYAW/qJElcHuHEZ1/5x55Az5wsH1YeBW5kwkls0V4EFAg+E5qYQJAo9TZWw88
         JpYdX2r+JeYlsmVQILeDW2jtYXUBntW3dmqhXpIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 560/601] net: phy: marvell: fix m88e1011_set_downshift
Date:   Wed, 12 May 2021 16:50:37 +0200
Message-Id: <20210512144846.293468013@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit 990875b299b8612aeb85cb2e2751796f1add65ff ]

Changing downshift params without software reset has no effect,
so call genphy_soft_reset() after change downshift params.

As the datasheet says:
Changes to these bits are disruptive to the normal operation therefore,
any changes to these registers must be followed by software reset
to take effect.

Fixes: 911af5e149bb ("net: phy: marvell: fix downshift function naming")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 163767abceea..04e7b9a7799c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1022,22 +1022,28 @@ static int m88e1011_get_downshift(struct phy_device *phydev, u8 *data)
 
 static int m88e1011_set_downshift(struct phy_device *phydev, u8 cnt)
 {
-	int val;
+	int val, err;
 
 	if (cnt > MII_M1011_PHY_SCR_DOWNSHIFT_MAX)
 		return -E2BIG;
 
-	if (!cnt)
-		return phy_clear_bits(phydev, MII_M1011_PHY_SCR,
-				      MII_M1011_PHY_SCR_DOWNSHIFT_EN);
+	if (!cnt) {
+		err = phy_clear_bits(phydev, MII_M1011_PHY_SCR,
+				     MII_M1011_PHY_SCR_DOWNSHIFT_EN);
+	} else {
+		val = MII_M1011_PHY_SCR_DOWNSHIFT_EN;
+		val |= FIELD_PREP(MII_M1011_PHY_SCR_DOWNSHIFT_MASK, cnt - 1);
 
-	val = MII_M1011_PHY_SCR_DOWNSHIFT_EN;
-	val |= FIELD_PREP(MII_M1011_PHY_SCR_DOWNSHIFT_MASK, cnt - 1);
+		err = phy_modify(phydev, MII_M1011_PHY_SCR,
+				 MII_M1011_PHY_SCR_DOWNSHIFT_EN |
+				 MII_M1011_PHY_SCR_DOWNSHIFT_MASK,
+				 val);
+	}
 
-	return phy_modify(phydev, MII_M1011_PHY_SCR,
-			  MII_M1011_PHY_SCR_DOWNSHIFT_EN |
-			  MII_M1011_PHY_SCR_DOWNSHIFT_MASK,
-			  val);
+	if (err < 0)
+		return err;
+
+	return genphy_soft_reset(phydev);
 }
 
 static int m88e1011_get_tunable(struct phy_device *phydev,
-- 
2.30.2



