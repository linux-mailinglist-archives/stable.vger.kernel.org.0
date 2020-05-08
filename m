Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8CD1CAB50
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgEHMm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbgEHMm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D065221835;
        Fri,  8 May 2020 12:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941746;
        bh=ZQKEIAGLe2s9mWOHVz6Ecs4t1Uznlxw/Mut7HicAnzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SnFHuOfikMkyBtoLZ8/NsUztu07fxF1iSl80cxeJsWF+sn3Ohfy47ursDsRcmD4S
         T8FE3OUqubvf2tg4uxULBTvidXdHsFsFlRGp65ydWRcjvbFTfpBTbiWiJ45/Ig2b3T
         J5Uq1vs5oLL4lHmL/E6r611zNPs4Tp46KE2c4Rf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Henri Roosen <henri.roosen@ginzinger.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 156/312] phy: micrel: Fix finding PHY properties in MAC node for KSZ9031.
Date:   Fri,  8 May 2020 14:32:27 +0200
Message-Id: <20200508123135.430852212@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roosen Henri <Henri.Roosen@ginzinger.com>

commit b4c19f71252e3b6b8c6478fd712c592f00b11438 upstream.

Commit 651df2183543 ("phy: micrel: Fix finding PHY properties in MAC
 node.") only fixes finding PHY properties in MAC node for KSZ9021. This
commit applies the same fix for KSZ9031.

Fixes: 8b63ec1837fa ("phylib: Make PHYs children of their MDIO bus, not the bus' parent.")
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Henri Roosen <henri.roosen@ginzinger.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/micrel.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -482,9 +482,17 @@ static int ksz9031_config_init(struct ph
 		"txd2-skew-ps", "txd3-skew-ps"
 	};
 	static const char *control_skews[2] = {"txen-skew-ps", "rxdv-skew-ps"};
+	const struct device *dev_walker;
 
-	if (!of_node && dev->parent->of_node)
-		of_node = dev->parent->of_node;
+	/* The Micrel driver has a deprecated option to place phy OF
+	 * properties in the MAC node. Walk up the tree of devices to
+	 * find a device with an OF node.
+	 */
+	dev_walker = &phydev->dev;
+	do {
+		of_node = dev_walker->of_node;
+		dev_walker = dev_walker->parent;
+	} while (!of_node && dev_walker);
 
 	if (of_node) {
 		ksz9031_of_load_skew_values(phydev, of_node,


