Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015B16B4871
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbjCJPC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbjCJPCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:02:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EA112D400
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:55:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AB32B822E8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D7FC433EF;
        Fri, 10 Mar 2023 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459754;
        bh=fIPZsHEA4KhhOps6TeSrbtx9o7altuJh8t8QdY9TKpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESjolZFryRjysNa6lLYv/d3qkKWe7vi0ZK7SVPHfzgjQHPcsn9/Rd6+FotZFb3xcI
         iWBmIOcPpOjmbIN7AQCtJgSIP3wd+YbMxfD0a3LiSS80lFWIODac4BZpUOsBfwPEKv
         AFnJomMMXzZLYiZVIudigiNf2oYglVGgKN0oJggA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/529] net: ethernet: ti: am65-cpsw: fix tx csum offload for multi mac mode
Date:   Fri, 10 Mar 2023 14:34:11 +0100
Message-Id: <20230310133809.986448466@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 97067aaf127487788a297267dede0008cd75bb7b ]

The current implementation uses .ndo_set_features() callback to track
NETIF_F_HW_CSUM feature changes and update generic
CPSW_P0_CONTROL_REG.RX_CHECKSUM_EN option accordingly. It's not going to
work in case of multi-port devices as TX csum offload can be changed per
netdev.

On K3 CPSWxG devices TX csum offload enabled in the following way:

 - the CPSW_P0_CONTROL_REG.RX_CHECKSUM_EN option enables TX csum offload in
generic and affects all TX DMA channels and packets;

 - corresponding fields in TX DMA descriptor have to be filed properly when
upper layer wants to offload TX csum (skb->ip_summed == CHECKSUM_PARTIAL)
and it's per-packet option.

The Linux Network core is expected to never request TX csum offload if
netdev NETIF_F_HW_CSUM feature is disabled, and, as result, TX DMA
descriptors should not be modified, and per-packet TX csum offload will be
disabled (or enabled) on per-netdev basis. Which, in turn, makes it safe to
enable the CPSW_P0_CONTROL_REG.RX_CHECKSUM_EN option unconditionally.

Hence, fix TX csum offload for multi-port devices by:
 - enabling the CPSW_P0_CONTROL_REG.RX_CHECKSUM_EN option in
am65_cpsw_nuss_common_open() unconditionally
 - and removing .ndo_set_features() callback implementation, which was used
only NETIF_F_HW_CSUM feature update purposes

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 30 +-----------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 059d68d48f1e9..487c1570dd420 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -426,9 +426,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 	writel(common->rx_flow_id_base,
 	       host_p->port_base + AM65_CPSW_PORT0_REG_FLOW_ID_OFFSET);
 	/* en tx crc offload */
-	if (features & NETIF_F_HW_CSUM)
-		writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN,
-		       host_p->port_base + AM65_CPSW_P0_REG_CTL);
+	writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN, host_p->port_base + AM65_CPSW_P0_REG_CTL);
 
 	am65_cpsw_nuss_set_p0_ptype(common);
 
@@ -1369,31 +1367,6 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
-static int am65_cpsw_nuss_ndo_slave_set_features(struct net_device *ndev,
-						 netdev_features_t features)
-{
-	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
-	netdev_features_t changes = features ^ ndev->features;
-	struct am65_cpsw_host *host_p;
-
-	host_p = am65_common_get_host(common);
-
-	if (changes & NETIF_F_HW_CSUM) {
-		bool enable = !!(features & NETIF_F_HW_CSUM);
-
-		dev_info(common->dev, "Turn %s tx-checksum-ip-generic\n",
-			 enable ? "ON" : "OFF");
-		if (enable)
-			writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN,
-			       host_p->port_base + AM65_CPSW_P0_REG_CTL);
-		else
-			writel(0,
-			       host_p->port_base + AM65_CPSW_P0_REG_CTL);
-	}
-
-	return 0;
-}
-
 static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
 	.ndo_open		= am65_cpsw_nuss_ndo_slave_open,
 	.ndo_stop		= am65_cpsw_nuss_ndo_slave_stop,
@@ -1406,7 +1379,6 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
 	.ndo_vlan_rx_add_vid	= am65_cpsw_nuss_ndo_slave_add_vid,
 	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
 	.ndo_do_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
-	.ndo_set_features	= am65_cpsw_nuss_ndo_slave_set_features,
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
 };
 
-- 
2.39.2



