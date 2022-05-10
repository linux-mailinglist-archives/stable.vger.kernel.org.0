Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0D95218C1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243035AbiEJNj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245038AbiEJNi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CC1E732B;
        Tue, 10 May 2022 06:26:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7CD9B81DA8;
        Tue, 10 May 2022 13:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0608DC385C2;
        Tue, 10 May 2022 13:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189214;
        bh=WWcJJPaW4s0frkbSK/ZxJ/KyPtXnNk7ZjXtjDnn1RI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcszAvgINAMno2mS12MMLuKS8rdDngvKAHPXNmDzma3x3MB9X/LzXaYRaI/NzFGC5
         Qi66mLKZ4B0lUaGsNRnX3b1CpIy7flaUwAJ4WjqN4WOp7kbEqa9WtRPgpcHQSeFEtd
         XFF/biLrcDejFrYcU6wDeJ6bx4rckVqAUgz6QT/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 49/70] net: emaclite: Add error handling for of_address_to_resource()
Date:   Tue, 10 May 2022 15:08:08 +0200
Message-Id: <20220510130734.297937581@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

commit 7a6bc33ab54923d325d9a1747ec9652c4361ebd1 upstream.

check the return value of of_address_to_resource() and also add
missing of_node_put() for np and npp nodes.

Fixes: e0a3bc65448c ("net: emaclite: Support multiple phys connected to one MDIO bus")
Addresses-Coverity: Event check_return value.
Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -820,10 +820,10 @@ static int xemaclite_mdio_write(struct m
 static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 {
 	struct mii_bus *bus;
-	int rc;
 	struct resource res;
 	struct device_node *np = of_get_parent(lp->phy_node);
 	struct device_node *npp;
+	int rc, ret;
 
 	/* Don't register the MDIO bus if the phy_node or its parent node
 	 * can't be found.
@@ -833,8 +833,14 @@ static int xemaclite_mdio_setup(struct n
 		return -ENODEV;
 	}
 	npp = of_get_parent(np);
-
-	of_address_to_resource(npp, 0, &res);
+	ret = of_address_to_resource(npp, 0, &res);
+	of_node_put(npp);
+	if (ret) {
+		dev_err(dev, "%s resource error!\n",
+			dev->of_node->full_name);
+		of_node_put(np);
+		return ret;
+	}
 	if (lp->ndev->mem_start != res.start) {
 		struct phy_device *phydev;
 		phydev = of_phy_find_device(lp->phy_node);
@@ -843,6 +849,7 @@ static int xemaclite_mdio_setup(struct n
 				 "MDIO of the phy is not registered yet\n");
 		else
 			put_device(&phydev->mdio.dev);
+		of_node_put(np);
 		return 0;
 	}
 
@@ -855,6 +862,7 @@ static int xemaclite_mdio_setup(struct n
 	bus = mdiobus_alloc();
 	if (!bus) {
 		dev_err(dev, "Failed to allocate mdiobus\n");
+		of_node_put(np);
 		return -ENOMEM;
 	}
 
@@ -867,6 +875,7 @@ static int xemaclite_mdio_setup(struct n
 	bus->parent = dev;
 
 	rc = of_mdiobus_register(bus, np);
+	of_node_put(np);
 	if (rc) {
 		dev_err(dev, "Failed to register mdio bus.\n");
 		goto err_register;


