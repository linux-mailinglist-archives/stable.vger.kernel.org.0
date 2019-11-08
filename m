Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0161F5595
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732842AbfKHTDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388338AbfKHTDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:03:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A77DE2067B;
        Fri,  8 Nov 2019 19:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239802;
        bh=OLx9Vi9JjlRltzTIwfiJ5OeN9fc4fgj5NJrc/CXMSwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRowG7UhteBS+eaZ7NgHZdcS8vNYWR/+MSCPKv3zv9XYBTDRLGeTLLZ60bKfTrzzF
         cG8Ook/I8rwqgOAabvdewPK94Zjs+9wLWgNmOWsTi6CdsGAwrjb1t/+SGFqe/Nl6X6
         InrBTxhQcltrG8zEARHHStREsOB95JvBMsqF4dq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 65/79] net: bcmgenet: dont set phydev->link from MAC
Date:   Fri,  8 Nov 2019 19:50:45 +0100
Message-Id: <20191108174822.160399490@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 7de48402faa32298c3551ea32c76ccb4f9d3025d ]

When commit 28b2e0d2cd13 ("net: phy: remove parameter new_link from
phy_mac_interrupt()") removed the new_link parameter it set the
phydev->link state from the MAC before invoking phy_mac_interrupt().

However, once commit 88d6272acaaa ("net: phy: avoid unneeded MDIO
reads in genphy_read_status") was added this initialization prevents
the proper determination of the connection parameters by the function
genphy_read_status().

This commit removes that initialization to restore the proper
functionality.

Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2619,10 +2619,8 @@ static void bcmgenet_irq_task(struct wor
 	spin_unlock_irq(&priv->lock);
 
 	/* Link UP/DOWN event */
-	if (status & UMAC_IRQ_LINK_EVENT) {
-		priv->dev->phydev->link = !!(status & UMAC_IRQ_LINK_UP);
+	if (status & UMAC_IRQ_LINK_EVENT)
 		phy_mac_interrupt(priv->dev->phydev);
-	}
 }
 
 /* bcmgenet_isr1: handle Rx and Tx priority queues */


