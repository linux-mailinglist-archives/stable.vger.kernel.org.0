Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788334B42BC
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 08:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbiBNHXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 02:23:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241227AbiBNHXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 02:23:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C39859A4C
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 23:23:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43A46B80D61
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 07:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E89C340EB;
        Mon, 14 Feb 2022 07:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644823414;
        bh=p44dn/HkyLRWzTmDZygj6itIRca3Iy1d+Wa+qn1zOgc=;
        h=Subject:To:Cc:From:Date:From;
        b=iq/GA1fwhEUhE8BNK7Ps8fczSeYzXntOvTD3Er6HcNbI9Y7kdUo46HcP8H0n3RplV
         Ds+PACbU5AWdApMIsQbf9/bpzSox5DdXzv2K1eoqA5tDu4mRGBf2cxkwbVHNFrI3qf
         Q1+ZvWBNil47L3CTXvyiqoJy0ysnpL5iJZSZ09pU=
Subject: FAILED: patch "[PATCH] phy: cadence: Sierra: fix error handling bugs in probe()" failed to apply to 5.10-stable tree
To:     dan.carpenter@oracle.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 08:23:23 +0100
Message-ID: <16448234039392@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 29afbd769ca338fa14cbfbbc824f7dc457ed7f2e Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Sat, 15 Jan 2022 14:51:46 +0300
Subject: [PATCH] phy: cadence: Sierra: fix error handling bugs in probe()

There are two bugs in the error handling:
1: If devm_of_phy_provider_register() fails then there was no cleanup.
2: The error handling called of_node_put(child) improperly leading to
   a use after free.  We are only holding the reference inside the loop
   so the last two gotos after the loop lead to a use after free bug.
   Fix this by cleaning up the partial allocations (or partial iterations)
   in the loop before doing the goto.

Fixes: a43f72ae136a ("phy: cadence: Sierra: Change MAX_LANES of Sierra to 16")
Fixes: 44d30d622821 ("phy: cadence: Add driver for Sierra PHY")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220115115146.GC7552@kili
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/phy/cadence/phy-cadence-sierra.c b/drivers/phy/cadence/phy-cadence-sierra.c
index da24acd26666..e265647e29a2 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -1338,7 +1338,7 @@ static int cdns_sierra_phy_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	const struct cdns_sierra_data *data;
 	unsigned int id_value;
-	int i, ret, node = 0;
+	int ret, node = 0;
 	void __iomem *base;
 	struct device_node *dn = dev->of_node, *child;
 
@@ -1416,7 +1416,8 @@ static int cdns_sierra_phy_probe(struct platform_device *pdev)
 			dev_err(dev, "failed to get reset %s\n",
 				child->full_name);
 			ret = PTR_ERR(sp->phys[node].lnk_rst);
-			goto put_child2;
+			of_node_put(child);
+			goto put_control;
 		}
 
 		if (!sp->autoconf) {
@@ -1424,7 +1425,9 @@ static int cdns_sierra_phy_probe(struct platform_device *pdev)
 			if (ret) {
 				dev_err(dev, "missing property in node %s\n",
 					child->name);
-				goto put_child;
+				of_node_put(child);
+				reset_control_put(sp->phys[node].lnk_rst);
+				goto put_control;
 			}
 		}
 
@@ -1434,7 +1437,9 @@ static int cdns_sierra_phy_probe(struct platform_device *pdev)
 
 		if (IS_ERR(gphy)) {
 			ret = PTR_ERR(gphy);
-			goto put_child;
+			of_node_put(child);
+			reset_control_put(sp->phys[node].lnk_rst);
+			goto put_control;
 		}
 		sp->phys[node].phy = gphy;
 		phy_set_drvdata(gphy, &sp->phys[node]);
@@ -1446,26 +1451,28 @@ static int cdns_sierra_phy_probe(struct platform_device *pdev)
 	if (sp->num_lanes > SIERRA_MAX_LANES) {
 		ret = -EINVAL;
 		dev_err(dev, "Invalid lane configuration\n");
-		goto put_child2;
+		goto put_control;
 	}
 
 	/* If more than one subnode, configure the PHY as multilink */
 	if (!sp->autoconf && sp->nsubnodes > 1) {
 		ret = cdns_sierra_phy_configure_multilink(sp);
 		if (ret)
-			goto put_child2;
+			goto put_control;
 	}
 
 	pm_runtime_enable(dev);
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	return PTR_ERR_OR_ZERO(phy_provider);
-
-put_child:
-	node++;
-put_child2:
-	for (i = 0; i < node; i++)
-		reset_control_put(sp->phys[i].lnk_rst);
-	of_node_put(child);
+	if (IS_ERR(phy_provider)) {
+		ret = PTR_ERR(phy_provider);
+		goto put_control;
+	}
+
+	return 0;
+
+put_control:
+	while (--node >= 0)
+		reset_control_put(sp->phys[node].lnk_rst);
 clk_disable:
 	cdns_sierra_phy_disable_clocks(sp);
 	reset_control_assert(sp->apb_rst);

