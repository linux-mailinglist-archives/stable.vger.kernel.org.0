Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5822A52C4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbgKCUxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732199AbgKCUxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:53:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3274C2053B;
        Tue,  3 Nov 2020 20:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436779;
        bh=NxZczzKcqeCU+BNFCiNF670ECwuFYum6RRy+3uVwvDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avEuYDG/39VopmOsac6/LUpMFyh8F6C/8VI5LvS+4kmMzkhCxBfK+/0Qn0UQ7PVWL
         IYOEuOOfS0QWlkJtR42GOwIBitfRY73gQYPaI6rKfTIWcd83CC9NO3Dhz5Vq3/ELgC
         h7xZslUU0ktRkjal87d+t4FvgSeW9+cfudmy8WWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCH 5.9 383/391] staging: octeon: repair "fixed-link" support
Date:   Tue,  3 Nov 2020 21:37:14 +0100
Message-Id: <20201103203413.007475866@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

commit 179f5dc36b0a1aa31538d7d8823deb65c39847b3 upstream.

The PHYs must be registered once in device probe function, not in device
open callback because it's only possible to register them once.

Fixes: a25e278020bf ("staging: octeon: support fixed-link phys")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201016101858.11374-1-alexander.sverdlin@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/octeon/ethernet-mdio.c |    6 ------
 drivers/staging/octeon/ethernet.c      |    9 +++++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/staging/octeon/ethernet-mdio.c
+++ b/drivers/staging/octeon/ethernet-mdio.c
@@ -147,12 +147,6 @@ int cvm_oct_phy_setup_device(struct net_
 
 	phy_node = of_parse_phandle(priv->of_node, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(priv->of_node)) {
-		int rc;
-
-		rc = of_phy_register_fixed_link(priv->of_node);
-		if (rc)
-			return rc;
-
 		phy_node = of_node_get(priv->of_node);
 	}
 	if (!phy_node)
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -13,6 +13,7 @@
 #include <linux/phy.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
@@ -892,6 +893,14 @@ static int cvm_oct_probe(struct platform
 				break;
 			}
 
+			if (priv->of_node && of_phy_is_fixed_link(priv->of_node)) {
+				if (of_phy_register_fixed_link(priv->of_node)) {
+					netdev_err(dev, "Failed to register fixed link for interface %d, port %d\n",
+						   interface, priv->port);
+					dev->netdev_ops = NULL;
+				}
+			}
+
 			if (!dev->netdev_ops) {
 				free_netdev(dev);
 			} else if (register_netdev(dev) < 0) {


