Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859401A0B78
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgDGK0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbgDGK0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:26:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2025D20644;
        Tue,  7 Apr 2020 10:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255212;
        bh=VNqCZBzrB81vN+E5aqxkm8Kxryctt/ULReZdCHmHATY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aqbp1pqF3oYtRI05ZFJGva7Jh622wcGNwC1o1b+7C0YB9Q8GpbjeVBGRc30XWMFAF
         crmAkpJXaW9nuDADNu93l3GamwGSZztp2lTFB13GND4WUvwUahHINhKaufPEtCC78M
         FQZAE79nws0am85YG1vcPnjk9EUOWIL6v8A567rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 06/29] net: macb: Fix handling of fixed-link node
Date:   Tue,  7 Apr 2020 12:22:03 +0200
Message-Id: <20200407101452.757137875@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit 79540d133ed6f65a37dacb54b7a704cc8a24c52d ]

fixed-link nodes are treated as PHY nodes by of_mdiobus_child_is_phy().
We must check if the interface is a fixed-link before looking up for PHY
nodes.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Tested-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -724,6 +724,9 @@ static int macb_mdiobus_register(struct
 {
 	struct device_node *child, *np = bp->pdev->dev.of_node;
 
+	if (of_phy_is_fixed_link(np))
+		return mdiobus_register(bp->mii_bus);
+
 	/* Only create the PHY from the device tree if at least one PHY is
 	 * described. Otherwise scan the entire MDIO bus. We do this to support
 	 * old device tree that did not follow the best practices and did not


