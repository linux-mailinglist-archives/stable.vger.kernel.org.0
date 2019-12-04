Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1AF11347D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfLDSBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:01:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfLDSBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:01:51 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 375B52073B;
        Wed,  4 Dec 2019 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482510;
        bh=w4zyZXbk8MVRi/+ixB+f5FMdWGiF75exDMl/cdzkZHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYYJl+n85446/G6SlaMtpJcrGLmvYNujbSAIYrFY4ODhB9gCZ+T9y5Jex0ZgZm5Z1
         DO0zHUety2Zl5G0PZQLeiUK0UhppG+nd8P9ztk+VBC6zp1ZsWizR1yrR6ZjlLMCV+r
         wb7NuBCIKS5GCZDCGL/u2Al+drlyUBEdligztaO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 025/209] net: bcmgenet: reapply manual settings to the PHY
Date:   Wed,  4 Dec 2019 18:53:57 +0100
Message-Id: <20191204175323.224732683@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 0686bd9d5e6863f60e4bb1e78e6fe7bb217a0890 ]

The phy_init_hw() function may reset the PHY to a configuration
that does not match manual network settings stored in the phydev
structure. If the phy state machine is polled rather than event
driven this can create a timing hazard where the phy state machine
might alter the settings stored in the phydev structure from the
value read from the BMCR.

This commit follows invocations of phy_init_hw() by the bcmgenet
driver with invocations of the genphy_config_aneg() function to
ensure that the BMCR is written to match the settings held in the
phydev structure. This prevents the risk of manual settings being
accidentally altered.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index b6af286fa5c7e..3e3044fe32066 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2611,8 +2611,10 @@ static void bcmgenet_irq_task(struct work_struct *work)
 	}
 
 	if (status & UMAC_IRQ_PHY_DET_R &&
-	    priv->dev->phydev->autoneg != AUTONEG_ENABLE)
+	    priv->dev->phydev->autoneg != AUTONEG_ENABLE) {
 		phy_init_hw(priv->dev->phydev);
+		genphy_config_aneg(priv->dev->phydev);
+	}
 
 	/* Link UP/DOWN event */
 	if (status & UMAC_IRQ_LINK_EVENT)
@@ -3688,6 +3690,7 @@ static int bcmgenet_resume(struct device *d)
 
 	phy_init_hw(priv->phydev);
 	/* Speed settings must be restored */
+	genphy_config_aneg(dev->phydev);
 	bcmgenet_mii_config(priv->dev, false);
 
 	/* disable ethernet MAC while updating its registers */
-- 
2.20.1



