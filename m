Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9191C5A4901
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiH2LTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiH2LSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:18:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC73B1DF;
        Mon, 29 Aug 2022 04:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86C5F6122B;
        Mon, 29 Aug 2022 11:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91372C433C1;
        Mon, 29 Aug 2022 11:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771528;
        bh=GJXX+4tDch4DWa6Fre5H+xubtkbxl5eCNWvwFyG9/bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrRkfTXJPFNQyP8/BMeF2dWf+2Z8NLt2asr5OUQUjJip06sDRixnqFhfaoyekNbl4
         QCHQx9FsHF3ZORmltjqr3PaB2ukkmfGkuXSnFu9oV4MrSzbrBEbYc2cuYTxWxHhnDo
         8+i+7Gz8GZ/vIRbZ2p+M3HGrfpULxSRiG9SGbmbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 040/158] net: dsa: microchip: move vlan functionality to ksz_common
Date:   Mon, 29 Aug 2022 12:58:10 +0200
Message-Id: <20220829105810.457523749@linuxfoundation.org>
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

[ Upstream commit f0d997e31bb307c7aa046c4992c568547fd25195 ]

This patch moves the vlan dsa_switch_ops such as vlan_add, vlan_del and
vlan_filtering from the individual files ksz8795.c, ksz9477.c to
ksz_common.c file.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c    | 19 +++++++------
 drivers/net/dsa/microchip/ksz9477.c    | 19 +++++++------
 drivers/net/dsa/microchip/ksz_common.c | 37 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h | 14 ++++++++++
 4 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 041956e3c7b1a..16e946dbd9d42 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -958,11 +958,9 @@ static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
-static int ksz8_port_vlan_filtering(struct dsa_switch *ds, int port, bool flag,
+static int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
 				    struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
-
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
 
@@ -987,12 +985,11 @@ static void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state)
 	}
 }
 
-static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
+static int ksz8_port_vlan_add(struct ksz_device *dev, int port,
 			      const struct switchdev_obj_port_vlan *vlan,
 			      struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
-	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p = &dev->ports[port];
 	u16 data, new_pvid = 0;
 	u8 fid, member, valid;
@@ -1060,10 +1057,9 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
+static int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
-	struct ksz_device *dev = ds->priv;
 	u16 data, pvid;
 	u8 fid, member, valid;
 
@@ -1398,9 +1394,9 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= ksz8_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
-	.port_vlan_filtering	= ksz8_port_vlan_filtering,
-	.port_vlan_add		= ksz8_port_vlan_add,
-	.port_vlan_del		= ksz8_port_vlan_del,
+	.port_vlan_filtering	= ksz_port_vlan_filtering,
+	.port_vlan_add		= ksz_port_vlan_add,
+	.port_vlan_del		= ksz_port_vlan_del,
 	.port_fdb_dump		= ksz_port_fdb_dump,
 	.port_mdb_add           = ksz_port_mdb_add,
 	.port_mdb_del           = ksz_port_mdb_del,
@@ -1465,6 +1461,9 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.r_mib_pkt = ksz8_r_mib_pkt,
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
+	.vlan_filtering = ksz8_port_vlan_filtering,
+	.vlan_add = ksz8_port_vlan_add,
+	.vlan_del = ksz8_port_vlan_del,
 	.shutdown = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 31be767027feb..1bb994a9109cd 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -377,12 +377,10 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
-static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
+static int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
 				       bool flag,
 				       struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
-
 	if (flag) {
 		ksz_port_cfg(dev, port, REG_PORT_LUE_CTRL,
 			     PORT_VLAN_LOOKUP_VID_0, true);
@@ -396,11 +394,10 @@ static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
+static int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
 				 const struct switchdev_obj_port_vlan *vlan,
 				 struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
 	u32 vlan_table[3];
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	int err;
@@ -433,10 +430,9 @@ static int ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
+static int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 				 const struct switchdev_obj_port_vlan *vlan)
 {
-	struct ksz_device *dev = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	u32 vlan_table[3];
 	u16 pvid;
@@ -1331,9 +1327,9 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= ksz9477_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
-	.port_vlan_filtering	= ksz9477_port_vlan_filtering,
-	.port_vlan_add		= ksz9477_port_vlan_add,
-	.port_vlan_del		= ksz9477_port_vlan_del,
+	.port_vlan_filtering	= ksz_port_vlan_filtering,
+	.port_vlan_add		= ksz_port_vlan_add,
+	.port_vlan_del		= ksz_port_vlan_del,
 	.port_fdb_dump		= ksz9477_port_fdb_dump,
 	.port_fdb_add		= ksz9477_port_fdb_add,
 	.port_fdb_del		= ksz9477_port_fdb_del,
@@ -1413,6 +1409,9 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.r_mib_stat64 = ksz_r_mib_stats64,
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
+	.vlan_filtering = ksz9477_port_vlan_filtering,
+	.vlan_add = ksz9477_port_vlan_add,
+	.vlan_del = ksz9477_port_vlan_del,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 0713a40685fa9..5db2b55152885 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -954,6 +954,43 @@ enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 }
 EXPORT_SYMBOL_GPL(ksz_get_tag_protocol);
 
+int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
+			    bool flag, struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->vlan_filtering)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->vlan_filtering(dev, port, flag, extack);
+}
+EXPORT_SYMBOL_GPL(ksz_port_vlan_filtering);
+
+int ksz_port_vlan_add(struct dsa_switch *ds, int port,
+		      const struct switchdev_obj_port_vlan *vlan,
+		      struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->vlan_add)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->vlan_add(dev, port, vlan, extack);
+}
+EXPORT_SYMBOL_GPL(ksz_port_vlan_add);
+
+int ksz_port_vlan_del(struct dsa_switch *ds, int port,
+		      const struct switchdev_obj_port_vlan *vlan)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->vlan_del)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->vlan_del(dev, port, vlan);
+}
+EXPORT_SYMBOL_GPL(ksz_port_vlan_del);
+
 static int ksz_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 21db6f79035fa..1baa270859aa2 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -180,6 +180,13 @@ struct ksz_dev_ops {
 	void (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
 			  u64 *dropped, u64 *cnt);
 	void (*r_mib_stat64)(struct ksz_device *dev, int port);
+	int  (*vlan_filtering)(struct ksz_device *dev, int port,
+			       bool flag, struct netlink_ext_ack *extack);
+	int  (*vlan_add)(struct ksz_device *dev, int port,
+			 const struct switchdev_obj_port_vlan *vlan,
+			 struct netlink_ext_ack *extack);
+	int  (*vlan_del)(struct ksz_device *dev, int port,
+			 const struct switchdev_obj_port_vlan *vlan);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
@@ -233,6 +240,13 @@ void ksz_get_strings(struct dsa_switch *ds, int port,
 		     u32 stringset, uint8_t *buf);
 enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 					   int port, enum dsa_tag_protocol mp);
+int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
+			    bool flag, struct netlink_ext_ack *extack);
+int ksz_port_vlan_add(struct dsa_switch *ds, int port,
+		      const struct switchdev_obj_port_vlan *vlan,
+		      struct netlink_ext_ack *extack);
+int ksz_port_vlan_del(struct dsa_switch *ds, int port,
+		      const struct switchdev_obj_port_vlan *vlan);
 
 /* Common register access functions */
 
-- 
2.35.1



