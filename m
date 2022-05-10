Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811D65217E9
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243349AbiEJNah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242973AbiEJN3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:29:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB46F56416;
        Tue, 10 May 2022 06:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C4BE61761;
        Tue, 10 May 2022 13:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACEDC385C6;
        Tue, 10 May 2022 13:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188873;
        bh=/8F670taQclENz0qzSApJEtsYRmSdHV0+LAvMGqYgiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSDtevDz0Q8BmIMzWzg8S3tr3H8Uo6dH00fentw560sPVtods3V73t7XIOXzxnZGD
         EsRQI2Bs6SL0mS1nO857CeLVw4AaoADqD2SS7o3UVqV1TTMYYsGFa/plRsujCa+A/Y
         Oil0U2/h2DLgVbFM9Yrl200EZIBOeRjWLejE0gMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 4.19 76/88] net: emaclite: Add error handling for of_address_to_resource()
Date:   Tue, 10 May 2022 15:08:01 +0200
Message-Id: <20220510130735.937653041@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
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
@@ -827,10 +827,10 @@ static int xemaclite_mdio_write(struct m
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
@@ -840,8 +840,14 @@ static int xemaclite_mdio_setup(struct n
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
@@ -850,6 +856,7 @@ static int xemaclite_mdio_setup(struct n
 				 "MDIO of the phy is not registered yet\n");
 		else
 			put_device(&phydev->mdio.dev);
+		of_node_put(np);
 		return 0;
 	}
 
@@ -862,6 +869,7 @@ static int xemaclite_mdio_setup(struct n
 	bus = mdiobus_alloc();
 	if (!bus) {
 		dev_err(dev, "Failed to allocate mdiobus\n");
+		of_node_put(np);
 		return -ENOMEM;
 	}
 
@@ -874,6 +882,7 @@ static int xemaclite_mdio_setup(struct n
 	bus->parent = dev;
 
 	rc = of_mdiobus_register(bus, np);
+	of_node_put(np);
 	if (rc) {
 		dev_err(dev, "Failed to register mdio bus.\n");
 		goto err_register;


