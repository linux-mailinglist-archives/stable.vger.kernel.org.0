Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A50101446
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbfKSFcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbfKSFcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB8D21783;
        Tue, 19 Nov 2019 05:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141530;
        bh=0tFSaKQyGEqGezkRj4bPM4JS9i+QDuEA8486jI4EfWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYHNcImKNk7nwuQZN8otfAT8UpqDp32VMWzGhYAET/W4LmqJI2Hj/7G6d+P19JoDB
         Y9+OD3xqgwSfmzCopV4oSGA+rEjTECt4DifMNP258Ap1IOrnhmlopknPrpFCkrCjcD
         vwN0LFFhcA3/jr50OBn5mWZjI2WMWmyEBFva5YOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/422] net: bcmgenet: Fix speed selection for reverse MII
Date:   Tue, 19 Nov 2019 06:16:30 +0100
Message-Id: <20191119051411.055198820@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 00eb2243b933a496958f4ce1bcf59840fea8be16 ]

The phy supported speed is being used to determine if the MAC should
be configured to 100 or 1G. The masking logic is broken. Instead, look
at 1G supported speeds to enable 1G MAC support.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 0d527fa5de610..b0592fd4135b3 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -226,11 +226,10 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 		 * capabilities, use that knowledge to also configure the
 		 * Reverse MII interface correctly.
 		 */
-		if ((dev->phydev->supported & PHY_BASIC_FEATURES) ==
-				PHY_BASIC_FEATURES)
-			port_ctrl = PORT_MODE_EXT_RVMII_25;
-		else
+		if (dev->phydev->supported & PHY_1000BT_FEATURES)
 			port_ctrl = PORT_MODE_EXT_RVMII_50;
+		else
+			port_ctrl = PORT_MODE_EXT_RVMII_25;
 		bcmgenet_sys_writel(priv, port_ctrl, SYS_PORT_CTRL);
 		break;
 
-- 
2.20.1



