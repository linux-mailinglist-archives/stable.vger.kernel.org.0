Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FFD37C645
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbhELPt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234432AbhELPoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBBB861C8E;
        Wed, 12 May 2021 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832959;
        bh=DZ/XnnmeEQAiNYxiBQXimh04RwnUmfSV/6gyphyJMgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3mDqjoveNLXC9rQixYa78k/jBUINL5wRdkMfmbTDb9R7Yt0BbcygPgQ5Lxcp/v/K
         W4u/seZi/okD3KFm738qeFA49X84oXzUaEDXc/d7M//8CivTim2b0Eq9uybwoRjrCC
         4svDcycsd4gxRy+WlBx9oyCZ0dx1ON3JZWnSfKpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 493/530] net: phy: marvell: fix m88e1111_set_downshift
Date:   Wed, 12 May 2021 16:50:03 +0200
Message-Id: <20210512144835.958855987@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 8e2ef7d67bff..91616182c311 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -861,22 +861,28 @@ static int m88e1111_get_downshift(struct phy_device *phydev, u8 *data)
 
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



