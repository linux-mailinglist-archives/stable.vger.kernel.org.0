Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E570F3CAA59
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243997AbhGOTM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243962AbhGOTK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0C4E61285;
        Thu, 15 Jul 2021 19:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376045;
        bh=8Uvy0ZR2VNDF31lYFpuwH6pxmHiXXDSje6pg83UwUio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9jU7pAU3sU/C8tx5H4ld0JHgOKQnMCVf0Bhi8UTwOzkBinDmQcK2rXkCPSZHYZCg
         3wOqDmvlh1thD8qx4a0rd9bmZ8JPIKCtuX5NyliZTjDrzRlr+vzd3FAIcPTKSO0lTT
         cry5YuuKtx23qbpDWpl7YPMflV6nB/x2Fr0PSN7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 102/266] net: phy: nxp-c45-tja11xx: enable MDIO write access to the master/slave registers
Date:   Thu, 15 Jul 2021 20:37:37 +0200
Message-Id: <20210715182632.006335242@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0b5f0f29b118910c89fe249cdfbc11b400a86a18 ]

The SJA1110 switch integrates TJA1103 PHYs, but in SJA1110 switch rev B
silicon, there is a bug in that the registers for selecting the 100base-T1
autoneg master/slave roles are not writable.

To enable write access to the master/slave registers, these additional
PHY writes are necessary during initialization.

The issue has been corrected in later SJA1110 silicon versions and is
not present in the standalone PHY variants, but applying the workaround
unconditionally in the driver should not do any harm.

Suggested-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 26b9c0d7cb9d..b7ce0e737333 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -546,6 +546,12 @@ static int nxp_c45_config_init(struct phy_device *phydev)
 		return ret;
 	}
 
+	/* Bug workaround for SJA1110 rev B: enable write access
+	 * to MDIO_MMD_PMAPMD
+	 */
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 1);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 2);
+
 	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_CONFIG,
 			 PHY_CONFIG_AUTO);
 
-- 
2.30.2



