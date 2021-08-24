Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E033F639F
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbhHXQ5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234257AbhHXQ5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46C9461374;
        Tue, 24 Aug 2021 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824188;
        bh=JaQQDWTDJD/juKy/Yq5YS5zSjfP6vGiSD6Awz3BvaR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UqgNHcQmh0vIRF5od0NK/SNiTo0Oqs7AWXNNM/M1bFrN1B4abYHm4xl3HYL8esWHj
         dHXBQdEDVcVKmDrzlzSs+hBqrb3GntBu/jDavCWtKehlYjhoMdgM+RNYIZurZEXOk8
         IB/uD1ttXfnMXro4TXcYFF788YAxet/+kpI417Z2Ore8tJPNcce268FS2g1u8v9WVz
         +06lyFE30hfBy94p5NQVH4xdh9tm+WErX5EN51Z/sF8tUFAL+T7ywecSSPrhw1x8i1
         6XiYixLcdkzx4Pd4PCPRPB1R+cw4Sw0hPvGrcaJXyC2J8Rn9xRZs+iFEL1MzlARE9t
         JLSemMOXg/nqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ivan T. Ivanov" <iivanov@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 020/127] net: usb: lan78xx: don't modify phy_device state concurrently
Date:   Tue, 24 Aug 2021 12:54:20 -0400
Message-Id: <20210824165607.709387-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@suse.de>

[ Upstream commit 6b67d4d63edece1033972214704c04f36c5be89a ]

Currently phy_device state could be left in inconsistent state shown
by following alert message[1]. This is because phy_read_status could
be called concurrently from lan78xx_delayedwork, phy_state_machine and
__ethtool_get_link. Fix this by making sure that phy_device state is
updated atomically.

[1] lan78xx 1-1.1.1:1.0 eth0: No phy led trigger registered for speed(-1)

Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 02bce40a67e5..c46a66ea32eb 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1154,7 +1154,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
 	struct ethtool_link_ksettings ecmd;
-	int ladv, radv, ret;
+	int ladv, radv, ret, link;
 	u32 buf;
 
 	/* clear LAN78xx interrupt status */
@@ -1162,9 +1162,12 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 	if (unlikely(ret < 0))
 		return -EIO;
 
+	mutex_lock(&phydev->lock);
 	phy_read_status(phydev);
+	link = phydev->link;
+	mutex_unlock(&phydev->lock);
 
-	if (!phydev->link && dev->link_on) {
+	if (!link && dev->link_on) {
 		dev->link_on = false;
 
 		/* reset MAC */
@@ -1177,7 +1180,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 			return -EIO;
 
 		del_timer(&dev->stat_monitor);
-	} else if (phydev->link && !dev->link_on) {
+	} else if (link && !dev->link_on) {
 		dev->link_on = true;
 
 		phy_ethtool_ksettings_get(phydev, &ecmd);
@@ -1466,9 +1469,14 @@ static int lan78xx_set_eee(struct net_device *net, struct ethtool_eee *edata)
 
 static u32 lan78xx_get_link(struct net_device *net)
 {
+	u32 link;
+
+	mutex_lock(&net->phydev->lock);
 	phy_read_status(net->phydev);
+	link = net->phydev->link;
+	mutex_unlock(&net->phydev->lock);
 
-	return net->phydev->link;
+	return link;
 }
 
 static void lan78xx_get_drvinfo(struct net_device *net,
-- 
2.30.2

