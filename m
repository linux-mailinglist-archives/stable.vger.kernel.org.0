Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819F33E7FE5
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbhHJRny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235073AbhHJRlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5A3961103;
        Tue, 10 Aug 2021 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617117;
        bh=kKkK3wXtQo9mLqPEZ38S4Y1FLgCwRzc12w1kAC3agD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vofndGzrwgFG1Twoeg2Ht4OWHB0UcNIHtm7zquCHNifgxpVZ1gYadfrrFqD96mcoh
         u4wSW9+3d48LvDAfpfzSK1m1N+a/euoEAPcUlkThgzggq1+/3IssWpUVMNuRmkuy9H
         VRQOSkXqTK1O5lmZ/hBCjxKZZanO0b4PwnoOgBC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Bennett <steveb@workware.net.au>,
        Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/135] net: phy: micrel: Fix detection of ksz87xx switch
Date:   Tue, 10 Aug 2021 19:29:29 +0200
Message-Id: <20210810172956.870080277@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Bennett <steveb@workware.net.au>

[ Upstream commit a5e63c7d38d548b8dab6c6205e0b6af76899dbf5 ]

The logic for discerning between KSZ8051 and KSZ87XX PHYs is incorrect
such that the that KSZ87XX switch is not identified correctly.

ksz8051_ksz8795_match_phy_device() uses the parameter ksz_phy_id
to discriminate whether it was called from ksz8051_match_phy_device()
or from ksz8795_match_phy_device() but since PHY_ID_KSZ87XX is the
same value as PHY_ID_KSZ8051, this doesn't work.

Instead use a bool to discriminate the caller.

Without this patch, the KSZ8795 switch port identifies as:

ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver [Generic PHY]

With the patch, it identifies correctly:

ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver [Micrel KSZ87XX Switch]

Fixes: 8b95599c55ed24b36cf4 ("net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs")
Signed-off-by: Steve Bennett <steveb@workware.net.au>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 9b0bc8b74bc0..9a566c5b36a6 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -349,11 +349,11 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
 }
 
 static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
-					    const u32 ksz_phy_id)
+					    const bool ksz_8051)
 {
 	int ret;
 
-	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != ksz_phy_id)
+	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8051)
 		return 0;
 
 	ret = phy_read(phydev, MII_BMSR);
@@ -366,7 +366,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
 	 * the switch does not.
 	 */
 	ret &= BMSR_ERCAP;
-	if (ksz_phy_id == PHY_ID_KSZ8051)
+	if (ksz_8051)
 		return ret;
 	else
 		return !ret;
@@ -374,7 +374,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
 
 static int ksz8051_match_phy_device(struct phy_device *phydev)
 {
-	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8051);
+	return ksz8051_ksz8795_match_phy_device(phydev, true);
 }
 
 static int ksz8081_config_init(struct phy_device *phydev)
@@ -402,7 +402,7 @@ static int ksz8061_config_init(struct phy_device *phydev)
 
 static int ksz8795_match_phy_device(struct phy_device *phydev)
 {
-	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ87XX);
+	return ksz8051_ksz8795_match_phy_device(phydev, false);
 }
 
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
-- 
2.30.2



