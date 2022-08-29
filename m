Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6925A4910
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiH2LTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiH2LTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:19:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2163C74CDD;
        Mon, 29 Aug 2022 04:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3C28B80F96;
        Mon, 29 Aug 2022 11:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFCEC433D7;
        Mon, 29 Aug 2022 11:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771536;
        bh=eJX9FKnILFDrlwXT+vuAPtTESD8DHPjjPUBG0DnkAxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrwpJz9I2htj31Wv8vGaR8g+gMxacb+7Gy9Z7r71x3ElW1xYeYAt+4v755PN04B5X
         AfJwm+yqZspiHx1GSFkUqCwQ5TE1wKi18HPFN4G40V11BJzpKKCRdkn9PL6kjaXH37
         PRTrMNA6iMEZr9hOyJoIQacXjXl1fA9z8V5LgyXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 041/158] net: dsa: microchip: move the port mirror to ksz_common
Date:   Mon, 29 Aug 2022 12:58:11 +0200
Message-Id: <20220829105810.503081452@linuxfoundation.org>
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

[ Upstream commit 00a298bbc23876288b1cd04c38752d8e7ed53ae2 ]

This patch updates the common port mirror add/del dsa_switch_ops in
ksz_common.c. The individual switches implementation is executed based
on the ksz_dev_ops function pointers.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c    | 13 ++++++-------
 drivers/net/dsa/microchip/ksz9477.c    | 12 ++++++------
 drivers/net/dsa/microchip/ksz_common.c | 23 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h | 10 ++++++++++
 4 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 16e946dbd9d42..2e3d24a3260e1 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1089,12 +1089,10 @@ static int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz8_port_mirror_add(struct dsa_switch *ds, int port,
+static int ksz8_port_mirror_add(struct ksz_device *dev, int port,
 				struct dsa_mall_mirror_tc_entry *mirror,
 				bool ingress, struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
-
 	if (ingress) {
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
 		dev->mirror_rx |= BIT(port);
@@ -1113,10 +1111,9 @@ static int ksz8_port_mirror_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz8_port_mirror_del(struct dsa_switch *ds, int port,
+static void ksz8_port_mirror_del(struct ksz_device *dev, int port,
 				 struct dsa_mall_mirror_tc_entry *mirror)
 {
-	struct ksz_device *dev = ds->priv;
 	u8 data;
 
 	if (mirror->ingress) {
@@ -1400,8 +1397,8 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.port_fdb_dump		= ksz_port_fdb_dump,
 	.port_mdb_add           = ksz_port_mdb_add,
 	.port_mdb_del           = ksz_port_mdb_del,
-	.port_mirror_add	= ksz8_port_mirror_add,
-	.port_mirror_del	= ksz8_port_mirror_del,
+	.port_mirror_add	= ksz_port_mirror_add,
+	.port_mirror_del	= ksz_port_mirror_del,
 };
 
 static u32 ksz8_get_port_addr(int port, int offset)
@@ -1464,6 +1461,8 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.vlan_filtering = ksz8_port_vlan_filtering,
 	.vlan_add = ksz8_port_vlan_add,
 	.vlan_del = ksz8_port_vlan_del,
+	.mirror_add = ksz8_port_mirror_add,
+	.mirror_del = ksz8_port_mirror_del,
 	.shutdown = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 1bb994a9109cd..cd4a3088e9473 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -819,11 +819,10 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 	return ret;
 }
 
-static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
+static int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror,
 				   bool ingress, struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
 	u8 data;
 	int p;
 
@@ -859,10 +858,9 @@ static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
+static void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
 				    struct dsa_mall_mirror_tc_entry *mirror)
 {
-	struct ksz_device *dev = ds->priv;
 	bool in_use = false;
 	u8 data;
 	int p;
@@ -1335,8 +1333,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_fdb_del		= ksz9477_port_fdb_del,
 	.port_mdb_add           = ksz9477_port_mdb_add,
 	.port_mdb_del           = ksz9477_port_mdb_del,
-	.port_mirror_add	= ksz9477_port_mirror_add,
-	.port_mirror_del	= ksz9477_port_mirror_del,
+	.port_mirror_add	= ksz_port_mirror_add,
+	.port_mirror_del	= ksz_port_mirror_del,
 	.get_stats64		= ksz_get_stats64,
 	.port_change_mtu	= ksz9477_change_mtu,
 	.port_max_mtu		= ksz9477_max_mtu,
@@ -1412,6 +1410,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
+	.mirror_add = ksz9477_port_mirror_add,
+	.mirror_del = ksz9477_port_mirror_del,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5db2b55152885..676669d353ea6 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -991,6 +991,29 @@ int ksz_port_vlan_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_port_vlan_del);
 
+int ksz_port_mirror_add(struct dsa_switch *ds, int port,
+			struct dsa_mall_mirror_tc_entry *mirror,
+			bool ingress, struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->mirror_add)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->mirror_add(dev, port, mirror, ingress, extack);
+}
+EXPORT_SYMBOL_GPL(ksz_port_mirror_add);
+
+void ksz_port_mirror_del(struct dsa_switch *ds, int port,
+			 struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (dev->dev_ops->mirror_del)
+		dev->dev_ops->mirror_del(dev, port, mirror);
+}
+EXPORT_SYMBOL_GPL(ksz_port_mirror_del);
+
 static int ksz_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 1baa270859aa2..c724cbb437e29 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -187,6 +187,11 @@ struct ksz_dev_ops {
 			 struct netlink_ext_ack *extack);
 	int  (*vlan_del)(struct ksz_device *dev, int port,
 			 const struct switchdev_obj_port_vlan *vlan);
+	int (*mirror_add)(struct ksz_device *dev, int port,
+			  struct dsa_mall_mirror_tc_entry *mirror,
+			  bool ingress, struct netlink_ext_ack *extack);
+	void (*mirror_del)(struct ksz_device *dev, int port,
+			   struct dsa_mall_mirror_tc_entry *mirror);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
@@ -247,6 +252,11 @@ int ksz_port_vlan_add(struct dsa_switch *ds, int port,
 		      struct netlink_ext_ack *extack);
 int ksz_port_vlan_del(struct dsa_switch *ds, int port,
 		      const struct switchdev_obj_port_vlan *vlan);
+int ksz_port_mirror_add(struct dsa_switch *ds, int port,
+			struct dsa_mall_mirror_tc_entry *mirror,
+			bool ingress, struct netlink_ext_ack *extack);
+void ksz_port_mirror_del(struct dsa_switch *ds, int port,
+			 struct dsa_mall_mirror_tc_entry *mirror);
 
 /* Common register access functions */
 
-- 
2.35.1



