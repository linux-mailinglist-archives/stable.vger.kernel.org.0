Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC563E810F
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbhHJRzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233743AbhHJRwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:52:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 299EE61359;
        Tue, 10 Aug 2021 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617410;
        bh=ez7aY6q2dkidHDP8HWdo6L12rlwjnNAzTAse5SdjP6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mebW9ip9fHhASPoAzhkTDkm7ON0Z63RdqILforCorVuyJ4MJeICzkaiFQstux9DhV
         mRVZVMFVSrzaL3fb5D879ue7MxPdWxqi4O1kGb3Dll6wgb7tEZIjJnKAFAgm1KG9lj
         YSzHFY2mJFnRzONqa/8kg9WML73F7PMvTIdJgI6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Bennett <steveb@workware.net.au>,
        Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 046/175] net: phy: micrel: Fix detection of ksz87xx switch
Date:   Tue, 10 Aug 2021 19:29:14 +0200
Message-Id: <20210810173002.463391735@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
index a14a00328fa3..7afd9edaf249 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -382,11 +382,11 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
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
@@ -399,7 +399,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
 	 * the switch does not.
 	 */
 	ret &= BMSR_ERCAP;
-	if (ksz_phy_id == PHY_ID_KSZ8051)
+	if (ksz_8051)
 		return ret;
 	else
 		return !ret;
@@ -407,7 +407,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
 
 static int ksz8051_match_phy_device(struct phy_device *phydev)
 {
-	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8051);
+	return ksz8051_ksz8795_match_phy_device(phydev, true);
 }
 
 static int ksz8081_config_init(struct phy_device *phydev)
@@ -435,7 +435,7 @@ static int ksz8061_config_init(struct phy_device *phydev)
 
 static int ksz8795_match_phy_device(struct phy_device *phydev)
 {
-	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ87XX);
+	return ksz8051_ksz8795_match_phy_device(phydev, false);
 }
 
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
-- 
2.30.2



