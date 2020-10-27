Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EFD29ABBD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 13:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750992AbgJ0MSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 08:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750981AbgJ0MSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 08:18:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 063A622202;
        Tue, 27 Oct 2020 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603801091;
        bh=q8yStVDEuOGuGDO3Hgspo0XZ98se1YDC0xJIfeGRWLs=;
        h=Subject:To:From:Date:From;
        b=Gy4mJo8SdUoIijLuo0f/ZN4fDRfaRq9TOCgzXQdEhWni5g9AmgSMu+Wnj5WOk9mSN
         VygrCPQo8LOemrhgE2BcEjQu0B0dSt+/oNAMQQvqlZktrzVfiYo7i2Rz1MyyCAf0n5
         Cd1H1/FH8VrgvchiapfQM3zILZzCLgMeH5Z1JUTg=
Subject: patch "staging: octeon: repair "fixed-link" support" added to staging-linus
To:     alexander.sverdlin@nokia.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Oct 2020 13:19:05 +0100
Message-ID: <16038011451865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: octeon: repair "fixed-link" support

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 179f5dc36b0a1aa31538d7d8823deb65c39847b3 Mon Sep 17 00:00:00 2001
From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Date: Fri, 16 Oct 2020 12:18:57 +0200
Subject: staging: octeon: repair "fixed-link" support

The PHYs must be registered once in device probe function, not in device
open callback because it's only possible to register them once.

Fixes: a25e278020bf ("staging: octeon: support fixed-link phys")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201016101858.11374-1-alexander.sverdlin@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/octeon/ethernet-mdio.c | 6 ------
 drivers/staging/octeon/ethernet.c      | 9 +++++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-mdio.c b/drivers/staging/octeon/ethernet-mdio.c
index cfb673a52b25..0bf545849b11 100644
--- a/drivers/staging/octeon/ethernet-mdio.c
+++ b/drivers/staging/octeon/ethernet-mdio.c
@@ -147,12 +147,6 @@ int cvm_oct_phy_setup_device(struct net_device *dev)
 
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
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 204f0b1e2739..5dea6e96ec90 100644
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
@@ -892,6 +893,14 @@ static int cvm_oct_probe(struct platform_device *pdev)
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
-- 
2.29.1


