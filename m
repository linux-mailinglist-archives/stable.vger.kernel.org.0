Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5F4579E01
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242282AbiGSM5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242353AbiGSM41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772925B079;
        Tue, 19 Jul 2022 05:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09E636177D;
        Tue, 19 Jul 2022 12:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00D2C341C6;
        Tue, 19 Jul 2022 12:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233353;
        bh=XOu0oGKI6SMaLuAB12ayFkZ+0xnv/ip8udQlsI+WW+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlAkYs1QpnqoqkDp55apg61H1+tqS9Fq8HqO9Vvw5mZmOFySWcqVi8T/waiKcWFf6
         kmv/JzGCMqd8uBTm86czKVHxNnWxFXQVT8vN6tSWkyBrnaoS+4dPYwbVMbJLpdcIfc
         PdJcAzXbD0+A9QgJIEq5uuAw6XdX8jNT8YrcCucc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddharth Vadapalli <s-vadapalli@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 067/231] net: ethernet: ti: am65-cpsw: Fix devlink port register sequence
Date:   Tue, 19 Jul 2022 13:52:32 +0200
Message-Id: <20220719114719.868009251@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 0680e20af5fbf41df8a11b11bd9a7c25b2ca0746 ]

Renaming interfaces using udevd depends on the interface being registered
before its netdev is registered. Otherwise, udevd reads an empty
phys_port_name value, resulting in the interface not being renamed.

Fix this by registering the interface before registering its netdev
by invoking am65_cpsw_nuss_register_devlink() before invoking
register_netdev() for the interface.

Move the function call to devlink_port_type_eth_set(), invoking it after
register_netdev() is invoked, to ensure that netlink notification for the
port state change is generated after the netdev is completely initialized.

Fixes: 58356eb31d60 ("net: ti: am65-cpsw-nuss: Add devlink support")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20220706070208.12207-1-s-vadapalli@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6d978dbf708f..298953053407 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2475,7 +2475,6 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 				port->port_id, ret);
 			goto dl_port_unreg;
 		}
-		devlink_port_type_eth_set(dl_port, port->ndev);
 	}
 	devlink_register(common->devlink);
 	return ret;
@@ -2519,6 +2518,7 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
+	struct devlink_port *dl_port;
 	struct am65_cpsw_port *port;
 	int ret = 0, i;
 
@@ -2535,6 +2535,10 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 		return ret;
 	}
 
+	ret = am65_cpsw_nuss_register_devlink(common);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
 
@@ -2547,25 +2551,24 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 				i, ret);
 			goto err_cleanup_ndev;
 		}
+
+		dl_port = &port->devlink_port;
+		devlink_port_type_eth_set(dl_port, port->ndev);
 	}
 
 	ret = am65_cpsw_register_notifiers(common);
 	if (ret)
 		goto err_cleanup_ndev;
 
-	ret = am65_cpsw_nuss_register_devlink(common);
-	if (ret)
-		goto clean_unregister_notifiers;
-
 	/* can't auto unregister ndev using devm_add_action() due to
 	 * devres release sequence in DD core for DMA
 	 */
 
 	return 0;
-clean_unregister_notifiers:
-	am65_cpsw_unregister_notifiers(common);
+
 err_cleanup_ndev:
 	am65_cpsw_nuss_cleanup_ndev(common);
+	am65_cpsw_unregister_devlink(common);
 
 	return ret;
 }
-- 
2.35.1



