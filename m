Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A537CEB1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345108AbhELRGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237911AbhELQtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA78561E87;
        Wed, 12 May 2021 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836160;
        bh=+bIrOzM6rEAVjb0tOzunP4RJ+HVoSaTH1ulTvDHrSFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOuJqvoQ+9lMgWONC9yWCWk4jutnU/p0Wg01g65sf4iovFdOV6RKSF+a3ZdrOODjY
         BmoHpIs4DQUQctUR3qGPzOBAjcsg2ok4P61iAZbZzwL4sQdbS1OuAKU3lmQ23GroZE
         pq8XX1JcIHeA/3ICoUI1brKEKpXup8Z20TVdQat4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 633/677] net: phy: marvell: fix m88e1111_set_downshift
Date:   Wed, 12 May 2021 16:51:19 +0200
Message-Id: <20210512144858.395300928@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit e7679c55a7249f1315256cfc672d53e84072e223 ]

Changing downshift params without software reset has no effect,
so call genphy_soft_reset() after change downshift params.

As the datasheet says:
Changes to these bits are disruptive to the normal operation therefore,
any changes to these registers must be followed by software reset
to take effect.

Fixes: 5c6bc5199b5d ("net: phy: marvell: add downshift support for M88E1111")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 723f25f6138d..f86c9ddc609e 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -967,22 +967,28 @@ static int m88e1111_get_downshift(struct phy_device *phydev, u8 *data)
 
 static int m88e1111_set_downshift(struct phy_device *phydev, u8 cnt)
 {
-	int val;
+	int val, err;
 
 	if (cnt > MII_M1111_PHY_EXT_CR_DOWNSHIFT_MAX)
 		return -E2BIG;
 
-	if (!cnt)
-		return phy_clear_bits(phydev, MII_M1111_PHY_EXT_CR,
-				      MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN);
+	if (!cnt) {
+		err = phy_clear_bits(phydev, MII_M1111_PHY_EXT_CR,
+				     MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN);
+	} else {
+		val = MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN;
+		val |= FIELD_PREP(MII_M1111_PHY_EXT_CR_DOWNSHIFT_MASK, cnt - 1);
 
-	val = MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN;
-	val |= FIELD_PREP(MII_M1111_PHY_EXT_CR_DOWNSHIFT_MASK, cnt - 1);
+		err = phy_modify(phydev, MII_M1111_PHY_EXT_CR,
+				 MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN |
+				 MII_M1111_PHY_EXT_CR_DOWNSHIFT_MASK,
+				 val);
+	}
 
-	return phy_modify(phydev, MII_M1111_PHY_EXT_CR,
-			  MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN |
-			  MII_M1111_PHY_EXT_CR_DOWNSHIFT_MASK,
-			  val);
+	if (err < 0)
+		return err;
+
+	return genphy_soft_reset(phydev);
 }
 
 static int m88e1111_get_tunable(struct phy_device *phydev,
-- 
2.30.2



