Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1394D5490BF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378085AbiFMNkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378657AbiFMNjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6B278929;
        Mon, 13 Jun 2022 04:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DBAE60B6E;
        Mon, 13 Jun 2022 11:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7970CC34114;
        Mon, 13 Jun 2022 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119666;
        bh=OW9TanCI/TQSFzGgkQDobyBKng33JAZMRBLKjnfSQd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFpPWvI7Rw7eU2Qe9BlgngZaAFscWn0kXR0GxXykl3R+y2Dl8sewBvVnVQ/7ft7cj
         q9sBtDxb8mqg/Wq41VteAnV/IrXnMviSyn15JCekrDk/OFJuaGsuWq1E+a/JoSzy3b
         g9TT3W/otgw5UQVzbFUhTdeShMk7gVslSunx5tmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddharth Vadapalli <s-vadapalli@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 088/339] net: ethernet: ti: am65-cpsw: Fix fwnode passed to phylink_create()
Date:   Mon, 13 Jun 2022 12:08:33 +0200
Message-Id: <20220613094929.185381069@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 0b7180072a9df5e18af5b58410fec38230848a8d ]

am65-cpsw-nuss driver incorrectly uses fwnode member of common
ethernet device's "struct device_node" instead of using fwnode
member of the port's "struct device_node" in phylink_create().
This results in all ports having the same phy data when there
are multiple ports with their phy properties populated in their
respective nodes rather than the common ethernet device node.

Fix it here by using fwnode member of the port's node.

Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20220524062558.19296-1-s-vadapalli@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index d2747e9db286..98969070ed4b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -9,6 +9,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/kmemleak.h>
 #include <linux/module.h>
@@ -1989,7 +1990,9 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
 
-	phylink = phylink_create(&port->slave.phylink_config, dev->fwnode, port->slave.phy_if,
+	phylink = phylink_create(&port->slave.phylink_config,
+				 of_node_to_fwnode(port->slave.phy_node),
+				 port->slave.phy_if,
 				 &am65_cpsw_phylink_mac_ops);
 	if (IS_ERR(phylink))
 		return PTR_ERR(phylink);
-- 
2.35.1



