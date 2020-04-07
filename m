Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131481A0BBA
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgDGKZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbgDGKZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2FB20644;
        Tue,  7 Apr 2020 10:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255102;
        bh=MunPn4yar4LQvXOnM4u+z9RULnq2Lbrbew8pDtjZ0zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNWYErKb21ktqtnKNi8jWVpgxLNgcH/Wmg/D4J7xfTfmvAiLDBNA2mq9EcKNO/XOu
         JvClL5T3N/msImmI0NeWwsmZHbf8ZuCw2LLwcL5XlSVQ+W4gizJzWXpPdmJGEYIbq8
         X5uG/LAK96Iyll9dbDy6hBuMI/H66mKtBg5WuQ0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 06/46] net: macb: Fix handling of fixed-link node
Date:   Tue,  7 Apr 2020 12:21:37 +0200
Message-Id: <20200407101500.171147979@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
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
@@ -685,6 +685,9 @@ static int macb_mdiobus_register(struct
 {
 	struct device_node *child, *np = bp->pdev->dev.of_node;
 
+	if (of_phy_is_fixed_link(np))
+		return mdiobus_register(bp->mii_bus);
+
 	/* Only create the PHY from the device tree if at least one PHY is
 	 * described. Otherwise scan the entire MDIO bus. We do this to support
 	 * old device tree that did not follow the best practices and did not


