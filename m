Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410F437C583
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhELPlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235554AbhELPf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B845961C43;
        Wed, 12 May 2021 15:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832678;
        bh=V7B4Wi4Gqt+hVdPTZ8oV/auGEclNsH/Hpn+n/5MwV/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mf5Xscm1l9CNW46iXdLsWsXUCqfOiywbRNsM34AqFA1iXnyhKJei1CFgKx+Bc4EFu
         +2n12nHyN2XKPTZe+g0A5CoDJsTAM4bS3fjGPNI7t7N1LQ+vAm36LvdXTC+6uovDYQ
         5fiAEKFH/q7UTNInJ5SbPHSo8rIhATvXUorZvdFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>,
        Andre Edich <andre.edich@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/530] net: phy: lan87xx: fix access to wrong register of LAN87xx
Date:   Wed, 12 May 2021 16:48:09 +0200
Message-Id: <20210512144832.233547667@linuxfoundation.org>
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

From: Andre Edich <andre.edich@microchip.com>

[ Upstream commit fdb5cc6ab3b6a1c0122d3644a63ef9dc7a610d35 ]

The function lan87xx_config_aneg_ext was introduced to configure
LAN95xxA but as well writes to undocumented register of LAN87xx.
This fix prevents that access.

The function lan87xx_config_aneg_ext gets more suitable for the new
behavior name.

Reported-by: Måns Rullgård <mans@mansr.com>
Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Andre Edich <andre.edich@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 10722fed666d..caf7291ffaf8 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -152,10 +152,13 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
-static int lan87xx_config_aneg_ext(struct phy_device *phydev)
+static int lan95xx_config_aneg_ext(struct phy_device *phydev)
 {
 	int rc;
 
+	if (phydev->phy_id != 0x0007c0f0) /* not (LAN9500A or LAN9505A) */
+		return lan87xx_config_aneg(phydev);
+
 	/* Extend Manual AutoMDIX timer */
 	rc = phy_read(phydev, PHY_EDPD_CONFIG);
 	if (rc < 0)
@@ -408,7 +411,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	.read_status	= lan87xx_read_status,
 	.config_init	= smsc_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
-	.config_aneg	= lan87xx_config_aneg_ext,
+	.config_aneg	= lan95xx_config_aneg_ext,
 
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
-- 
2.30.2



