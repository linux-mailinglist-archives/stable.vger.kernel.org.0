Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDFEE683A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732282AbfJ0VXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732313AbfJ0VXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:12 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E74205C9;
        Sun, 27 Oct 2019 21:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211391;
        bh=M7uTjsI+o9WXBFHqdAS9+KC8Ahfs6NAOz4ByIO1AcQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GsgMSTO+QjtIenxns4uoq/IworbfOj6hidoT3dPU3r6pmXemjy21xq2d712l5Ksxa
         UyzTPFmZlybFYyTqu9fG1/DyJgrk5E/6hOdoQjgkze7DKebceLwOXZ91DAkVOFeU8a
         B9c8H+NZFJ0Q1CvLvMNqniUE3/cugJbmKthoS2K4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 091/197] net: phy: Fix "link partner" information disappear issue
Date:   Sun, 27 Oct 2019 22:00:09 +0100
Message-Id: <20191027203356.656590032@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 3de5ae54712c75cf3c517a288e0a704784ec6cf5 ]

Some drivers just call phy_ethtool_ksettings_set() to set the
links, for those phy drivers that use genphy_read_status(), if
autoneg is on, and the link is up, than execute "ethtool -s
ethx autoneg on" will cause "link partner" information disappear.

The call trace is phy_ethtool_ksettings_set()->phy_start_aneg()
->linkmode_zero(phydev->lp_advertising)->genphy_read_status(),
the link didn't change, so genphy_read_status() just return, and
phydev->lp_advertising is zero now.

This patch moves the clear operation of lp_advertising from
phy_start_aneg() to genphy_read_lpa()/genphy_c45_read_lpa(), and
if autoneg on and autoneg not complete, just clear what the
generic functions care about.

Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy-c45.c    |    2 ++
 drivers/net/phy/phy.c        |    3 ---
 drivers/net/phy/phy_device.c |    9 ++++++++-
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -323,6 +323,8 @@ int genphy_c45_read_pma(struct phy_devic
 {
 	int val;
 
+	linkmode_zero(phydev->lp_advertising);
+
 	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
 	if (val < 0)
 		return val;
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -566,9 +566,6 @@ int phy_start_aneg(struct phy_device *ph
 	if (AUTONEG_DISABLE == phydev->autoneg)
 		phy_sanitize_settings(phydev);
 
-	/* Invalidate LP advertising flags */
-	linkmode_zero(phydev->lp_advertising);
-
 	err = phy_config_aneg(phydev);
 	if (err < 0)
 		goto out_unlock;
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1823,7 +1823,14 @@ int genphy_read_status(struct phy_device
 
 	linkmode_zero(phydev->lp_advertising);
 
-	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
+	if (phydev->autoneg == AUTONEG_ENABLE) {
+		if (!phydev->autoneg_complete) {
+			mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising,
+							0);
+			mii_lpa_mod_linkmode_lpa_t(phydev->lp_advertising, 0);
+			return 0;
+		}
+
 		if (phydev->is_gigabit_capable) {
 			lpagb = phy_read(phydev, MII_STAT1000);
 			if (lpagb < 0)


