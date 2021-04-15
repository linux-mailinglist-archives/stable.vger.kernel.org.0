Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B75360D74
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhDOPCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234993AbhDOPAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49E8C6140D;
        Thu, 15 Apr 2021 14:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498568;
        bh=l2QtIfWfPxcp5/ACxCh3296t4OV1Zjaa2ba4KpJE9Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yq4wi7mU0mZd45rAGIF7dTJc0ZQ2H60OhVl7MWXISNe0LHMFt2F2oSkp2Nl6AU2gP
         n8/4f+Kfeh552X97+/fCa86U0aWqn8rBQpgef8j4Y+sYRQwUiCiuT00rsDBWJ4xZ3z
         1wscBDS9gR565l9v5tohYfXA4NjITwB3Wiqmlx4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/13] net: phy: broadcom: Only advertise EEE for supported modes
Date:   Thu, 15 Apr 2021 16:47:57 +0200
Message-Id: <20210415144411.873197197@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
References: <20210415144411.596695196@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit c056d480b40a68f2520ccc156c7fae672d69d57d upstream

We should not be advertising EEE for modes that we do not support,
correct that oversight by looking at the PHY device supported linkmodes.

Fixes: 99cec8a4dda2 ("net: phy: broadcom: Allow enabling or disabling of EEE")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm-phy-lib.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -198,7 +198,7 @@ EXPORT_SYMBOL_GPL(bcm_phy_enable_apd);
 
 int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 {
-	int val;
+	int val, mask = 0;
 
 	/* Enable EEE at PHY level */
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, BRCM_CL45VEN_EEE_CONTROL);
@@ -217,10 +217,15 @@ int bcm_phy_set_eee(struct phy_device *p
 	if (val < 0)
 		return val;
 
+	if (phydev->supported & SUPPORTED_1000baseT_Full)
+		mask |= MDIO_EEE_1000T;
+	if (phydev->supported & SUPPORTED_100baseT_Full)
+		mask |= MDIO_EEE_100TX;
+
 	if (enable)
-		val |= (MDIO_EEE_100TX | MDIO_EEE_1000T);
+		val |= mask;
 	else
-		val &= ~(MDIO_EEE_100TX | MDIO_EEE_1000T);
+		val &= ~mask;
 
 	phy_write_mmd(phydev, MDIO_MMD_AN, BCM_CL45VEN_EEE_ADV, (u32)val);
 


