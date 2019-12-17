Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1873B12207B
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfLQAzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:55:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35276 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbfLQAvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003MU-9E; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0005Z2-Gc; Tue, 17 Dec 2019 00:51:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Doug Berger" <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Florian Fainelli" <f.fainelli@gmail.com>
Date:   Tue, 17 Dec 2019 00:46:52 +0000
Message-ID: <lsq.1576543535.926693273@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 078/136] net: bcmgenet: reset 40nm EPHY on energy detect
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit 25382b991d252aed961cd434176240f9de6bb15f upstream.

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1558,11 +1558,13 @@ static void init_umac(struct bcmgenet_pr
 	dev_dbg(kdev, "%s:Enabling RXDMA_BDONE interrupt\n", __func__);
 
 	/* Monitor cable plug/unpluged event for internal PHY */
-	if (phy_is_internal(priv->phydev))
+	if (phy_is_internal(priv->phydev)) {
 		cpu_mask_clear |= (UMAC_IRQ_LINK_DOWN | UMAC_IRQ_LINK_UP);
-	else if (priv->ext_phy)
+		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
+			cpu_mask_clear |= UMAC_IRQ_PHY_DET_R;
+	} else if (priv->ext_phy) {
 		cpu_mask_clear |= (UMAC_IRQ_LINK_DOWN | UMAC_IRQ_LINK_UP);
-	else if (priv->phy_interface == PHY_INTERFACE_MODE_MOCA) {
+	} else if (priv->phy_interface == PHY_INTERFACE_MODE_MOCA) {
 		reg = bcmgenet_bp_mc_get(priv);
 		reg |= BIT(priv->hw_params->bp_in_en_shift);
 
@@ -1861,11 +1863,16 @@ static void bcmgenet_irq_task(struct wor
 	priv->irq0_stat = 0;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	if (status & UMAC_IRQ_PHY_DET_R &&
+	    priv->dev->phydev->autoneg != AUTONEG_ENABLE)
+		phy_init_hw(priv->dev->phydev);
+
 	/* Link UP/DOWN event */
 	if ((priv->hw_params->flags & GENET_HAS_MDIO_INTR) &&
 		(status & (UMAC_IRQ_LINK_UP|UMAC_IRQ_LINK_DOWN)))
 		phy_mac_interrupt(priv->phydev,
 			status & UMAC_IRQ_LINK_UP);
+
 }
 
 /* bcmgenet_isr1: interrupt handler for ring buffer. */
@@ -1934,7 +1941,7 @@ static irqreturn_t bcmgenet_isr0(int irq
 	}
 
 	/* all other interested interrupts handled in bottom half */
-	status &= UMAC_IRQ_LINK_UP | UMAC_IRQ_LINK_DOWN;
+	status &= (UMAC_IRQ_LINK_UP | UMAC_IRQ_LINK_DOWN | UMAC_IRQ_PHY_DET_R);
 	if (status) {
 		/* Save irq status for bottom-half processing. */
 		spin_lock_irqsave(&priv->lock, flags);

