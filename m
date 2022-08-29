Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EB55A4922
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiH2LUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiH2LTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:19:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB3D696C7;
        Mon, 29 Aug 2022 04:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE65661231;
        Mon, 29 Aug 2022 11:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCE5C43147;
        Mon, 29 Aug 2022 11:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771545;
        bh=PAkLakiva+eRxlLa8CPm6Kw0uAf6QR0uZ0BvuAUJ6OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uU4FvhL34IxuvRFepmfeSa7SbP/c7/6flzY889UxPcQFb7VWXq4NTQsYu091RVHeL
         xXCciyhNaUgrpaS84n2Cg0yzIKd+IENDXPVjoXlWuAAARQxWU9Icxg3YCbqv2+R9HL
         lVqBsehRhilXEMLHTHBZ/bdOaWC8U2o/0AAsEvXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 042/158] net: dsa: microchip: update the ksz_phylink_get_caps
Date:   Mon, 29 Aug 2022 12:58:12 +0200
Message-Id: <20220829105810.542750343@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Ramadoss <arun.ramadoss@microchip.com>

[ Upstream commit 7012033ce10e0968e6cb82709aa0ed7f2080b61e ]

This patch assigns the phylink_get_caps in ksz8795 and ksz9477 to
ksz_phylink_get_caps. And update their mac_capabilities in the
respective ksz_dev_ops.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c    | 9 +++------
 drivers/net/dsa/microchip/ksz9477.c    | 7 +++----
 drivers/net/dsa/microchip/ksz_common.c | 3 +++
 drivers/net/dsa/microchip/ksz_common.h | 2 ++
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 2e3d24a3260e1..c771797fd902f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1353,13 +1353,9 @@ static int ksz8_setup(struct dsa_switch *ds)
 	return ksz8_handle_global_errata(ds);
 }
 
-static void ksz8_get_caps(struct dsa_switch *ds, int port,
+static void ksz8_get_caps(struct ksz_device *dev, int port,
 			  struct phylink_config *config)
 {
-	struct ksz_device *dev = ds->priv;
-
-	ksz_phylink_get_caps(ds, port, config);
-
 	config->mac_capabilities = MAC_10 | MAC_100;
 
 	/* Silicon Errata Sheet (DS80000830A):
@@ -1381,7 +1377,7 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
-	.phylink_get_caps	= ksz8_get_caps,
+	.phylink_get_caps	= ksz_phylink_get_caps,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz_get_strings,
@@ -1463,6 +1459,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.vlan_del = ksz8_port_vlan_del,
 	.mirror_add = ksz8_port_mirror_add,
 	.mirror_del = ksz8_port_mirror_del,
+	.get_caps = ksz8_get_caps,
 	.shutdown = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index cd4a3088e9473..125124fdefbf4 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1082,11 +1082,9 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
 }
 
-static void ksz9477_get_caps(struct dsa_switch *ds, int port,
+static void ksz9477_get_caps(struct ksz_device *dev, int port,
 			     struct phylink_config *config)
 {
-	ksz_phylink_get_caps(ds, port, config);
-
 	config->mac_capabilities = MAC_10 | MAC_100 | MAC_1000FD |
 				   MAC_ASYM_PAUSE | MAC_SYM_PAUSE;
 }
@@ -1316,7 +1314,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.phy_read		= ksz9477_phy_read16,
 	.phy_write		= ksz9477_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
-	.phylink_get_caps	= ksz9477_get_caps,
+	.phylink_get_caps	= ksz_phylink_get_caps,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
@@ -1412,6 +1410,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.vlan_del = ksz9477_port_vlan_del,
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
+	.get_caps = ksz9477_get_caps,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 676669d353ea6..0f02c62b02685 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -456,6 +456,9 @@ void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
 	if (dev->info->internal_phy[port])
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
+
+	if (dev->dev_ops->get_caps)
+		dev->dev_ops->get_caps(dev, port, config);
 }
 EXPORT_SYMBOL_GPL(ksz_phylink_get_caps);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c724cbb437e29..10f9ef2dbf1ca 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -192,6 +192,8 @@ struct ksz_dev_ops {
 			  bool ingress, struct netlink_ext_ack *extack);
 	void (*mirror_del)(struct ksz_device *dev, int port,
 			   struct dsa_mall_mirror_tc_entry *mirror);
+	void (*get_caps)(struct ksz_device *dev, int port,
+			 struct phylink_config *config);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
-- 
2.35.1



