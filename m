Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A50BF54E5
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388350AbfKHS4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:56:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732476AbfKHS4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:56:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 422462178F;
        Fri,  8 Nov 2019 18:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239394;
        bh=qUcFqg4z4RqZDCWvaRajjLuuMCMBmoZryKmlMQxGVYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtHZqRfaKFY3y8tP6xku1VTcCQq4Nq0lk+iBZP3BDJNBbm5fPdcMcXxKBXfUVpGU5
         ktm7LmGvQq8zF1itfOz6kmy0X63rKsDS4GMC03ZIHcU8Lj8Z36uDXw04gj2LQqK5Gt
         OksjGEv3xDIlwb90Cbdosz3pW3m9WAO3avHlPz4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 25/34] net: bcmgenet: reset 40nm EPHY on energy detect
Date:   Fri,  8 Nov 2019 19:50:32 +0100
Message-Id: <20191108174645.891678120@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 25382b991d252aed961cd434176240f9de6bb15f ]

The EPHY integrated into the 40nm Set-Top Box devices can falsely
detect energy when connected to a disabled peer interface. When the
peer interface is enabled the EPHY will detect and report the link
as active, but on occasion may get into a state where it is not
able to exchange data with the connected GENET MAC. This issue has
not been observed when the link parameters are auto-negotiated;
however, it has been observed with a manually configured link.

It has been empirically determined that issuing a soft reset to the
EPHY when energy is detected prevents it from getting into this bad
state.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1914,6 +1914,8 @@ static void bcmgenet_link_intr_enable(st
 	 */
 	if (priv->internal_phy) {
 		int0_enable |= UMAC_IRQ_LINK_EVENT;
+		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
+			int0_enable |= UMAC_IRQ_PHY_DET_R;
 	} else if (priv->ext_phy) {
 		int0_enable |= UMAC_IRQ_LINK_EVENT;
 	} else if (priv->phy_interface == PHY_INTERFACE_MODE_MOCA) {
@@ -2531,6 +2533,10 @@ static void bcmgenet_irq_task(struct wor
 		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
 	}
 
+	if (status & UMAC_IRQ_PHY_DET_R &&
+	    priv->dev->phydev->autoneg != AUTONEG_ENABLE)
+		phy_init_hw(priv->dev->phydev);
+
 	/* Link UP/DOWN event */
 	if (status & UMAC_IRQ_LINK_EVENT)
 		phy_mac_interrupt(priv->phydev,
@@ -2627,8 +2633,7 @@ static irqreturn_t bcmgenet_isr0(int irq
 	}
 
 	/* all other interested interrupts handled in bottom half */
-	status &= (UMAC_IRQ_LINK_EVENT |
-		   UMAC_IRQ_MPD_R);
+	status &= (UMAC_IRQ_LINK_EVENT | UMAC_IRQ_MPD_R | UMAC_IRQ_PHY_DET_R);
 	if (status) {
 		/* Save irq status for bottom-half processing. */
 		spin_lock_irqsave(&priv->lock, flags);


