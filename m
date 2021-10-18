Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74100431783
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhJRLi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231336AbhJRLi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:38:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C86C60E76;
        Mon, 18 Oct 2021 11:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634556975;
        bh=GvpyPEm/7Nwvo8n4PS905sF6Gmn7R6uqMubgQ2vBCt0=;
        h=Subject:To:Cc:From:Date:From;
        b=yuWkxDTZYOnswIwP60qv81sh006PNtSNHKETENc6ZByGxgVvruEzrrzjJ6aeNc4N3
         vMcQnADX8gLd5ihWpVle+sqRNu9+3MxJOo+/rcgefXkwe6zUk1S2MUisehUf4K1p7D
         uo/Qghgi9et441MCVnNaS1hM8zOpbXTtTT5bNQIY=
Subject: FAILED: patch "[PATCH] net: dsa: tag_ocelot_8021q: break circular dependency with" failed to apply to 5.14-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org, michael@walle.cc
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:36:13 +0200
Message-ID: <1634556973135139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 49f885b2d97093451410e7279aa29d81e094e108 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 12 Oct 2021 14:40:41 +0300
Subject: [PATCH] net: dsa: tag_ocelot_8021q: break circular dependency with
 ocelot switch lib

Michael reported that when using the "ocelot-8021q" tagging protocol,
the switch driver module must be manually loaded before the tagging
protocol can be loaded/is available.

This appears to be the same problem described here:
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
where due to the fact that DSA tagging protocols make use of symbols
exported by the switch drivers, circular dependencies appear and this
breaks module autoloading.

The ocelot_8021q driver needs the ocelot_can_inject() and
ocelot_port_inject_frame() functions from the switch library. Previously
the wrong approach was taken to solve that dependency: shims were
provided for the case where the ocelot switch library was compiled out,
but that turns out to be insufficient, because the dependency when the
switch lib _is_ compiled is problematic too.

We cannot declare ocelot_can_inject() and ocelot_port_inject_frame() as
static inline functions, because these access I/O functions like
__ocelot_write_ix() which is called by ocelot_write_rix(). Making those
static inline basically means exposing the whole guts of the ocelot
switch library, not ideal...

We already have one tagging protocol driver which calls into the switch
driver during xmit but not using any exported symbol: sja1105_defer_xmit.
We can do the same thing here: create a kthread worker and one work item
per skb, and let the switch driver itself do the register accesses to
send the skb, and then consume it.

Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 50ef20724958..f8603e068e7c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1074,6 +1074,73 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	return 0;
 }
 
+#define work_to_xmit_work(w) \
+		container_of((w), struct felix_deferred_xmit_work, work)
+
+static void felix_port_deferred_xmit(struct kthread_work *work)
+{
+	struct felix_deferred_xmit_work *xmit_work = work_to_xmit_work(work);
+	struct dsa_switch *ds = xmit_work->dp->ds;
+	struct sk_buff *skb = xmit_work->skb;
+	u32 rew_op = ocelot_ptp_rew_op(skb);
+	struct ocelot *ocelot = ds->priv;
+	int port = xmit_work->dp->index;
+	int retries = 10;
+
+	do {
+		if (ocelot_can_inject(ocelot, 0))
+			break;
+
+		cpu_relax();
+	} while (--retries);
+
+	if (!retries) {
+		dev_err(ocelot->dev, "port %d failed to inject skb\n",
+			port);
+		kfree_skb(skb);
+		return;
+	}
+
+	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
+
+	consume_skb(skb);
+	kfree(xmit_work);
+}
+
+static int felix_port_setup_tagger_data(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct felix_port *felix_port;
+
+	if (!dsa_port_is_user(dp))
+		return 0;
+
+	felix_port = kzalloc(sizeof(*felix_port), GFP_KERNEL);
+	if (!felix_port)
+		return -ENOMEM;
+
+	felix_port->xmit_worker = felix->xmit_worker;
+	felix_port->xmit_work_fn = felix_port_deferred_xmit;
+
+	dp->priv = felix_port;
+
+	return 0;
+}
+
+static void felix_port_teardown_tagger_data(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct felix_port *felix_port = dp->priv;
+
+	if (!felix_port)
+		return;
+
+	dp->priv = NULL;
+	kfree(felix_port);
+}
+
 /* Hardware initialization done here so that we can allocate structures with
  * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
  * us to allocate structures twice (leak memory) and map PCI memory twice
@@ -1102,6 +1169,12 @@ static int felix_setup(struct dsa_switch *ds)
 		}
 	}
 
+	felix->xmit_worker = kthread_create_worker(0, "felix_xmit");
+	if (IS_ERR(felix->xmit_worker)) {
+		err = PTR_ERR(felix->xmit_worker);
+		goto out_deinit_timestamp;
+	}
+
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
 			continue;
@@ -1112,6 +1185,14 @@ static int felix_setup(struct dsa_switch *ds)
 		 * bits of vlan tag.
 		 */
 		felix_port_qos_map_init(ocelot, port);
+
+		err = felix_port_setup_tagger_data(ds, port);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to set up tagger data: %pe\n",
+				port, ERR_PTR(err));
+			goto out_deinit_ports;
+		}
 	}
 
 	err = ocelot_devlink_sb_register(ocelot);
@@ -1138,9 +1219,13 @@ static int felix_setup(struct dsa_switch *ds)
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
+		felix_port_teardown_tagger_data(ds, port);
 		ocelot_deinit_port(ocelot, port);
 	}
 
+	kthread_destroy_worker(felix->xmit_worker);
+
+out_deinit_timestamp:
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
 
@@ -1164,17 +1249,20 @@ static void felix_teardown(struct dsa_switch *ds)
 		felix_del_tag_protocol(ds, port, felix->tag_proto);
 	}
 
-	ocelot_devlink_sb_unregister(ocelot);
-	ocelot_deinit_timestamp(ocelot);
-	ocelot_deinit(ocelot);
-
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
+		felix_port_teardown_tagger_data(ds, port);
 		ocelot_deinit_port(ocelot, port);
 	}
 
+	kthread_destroy_worker(felix->xmit_worker);
+
+	ocelot_devlink_sb_unregister(ocelot);
+	ocelot_deinit_timestamp(ocelot);
+	ocelot_deinit(ocelot);
+
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
 }
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 54024b6f9498..be3e42e135c0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -62,6 +62,7 @@ struct felix {
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
 	enum dsa_tag_protocol		tag_proto;
+	struct kthread_worker		*xmit_worker;
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 50641a7529ad..8ae999f587c4 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -5,6 +5,7 @@
 #ifndef _NET_DSA_TAG_OCELOT_H
 #define _NET_DSA_TAG_OCELOT_H
 
+#include <linux/kthread.h>
 #include <linux/packing.h>
 #include <linux/skbuff.h>
 
@@ -160,6 +161,17 @@ struct ocelot_skb_cb {
  *         +------+------+------+------+------+------+------+------+
  */
 
+struct felix_deferred_xmit_work {
+	struct dsa_port *dp;
+	struct sk_buff *skb;
+	struct kthread_work work;
+};
+
+struct felix_port {
+	void (*xmit_work_fn)(struct kthread_work *work);
+	struct kthread_worker *xmit_worker;
+};
+
 static inline void ocelot_xfh_get_rew_val(void *extraction, u64 *rew_val)
 {
 	packing(extraction, rew_val, 116, 85, OCELOT_TAG_LEN, UNPACK, 0);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 66b2e65c1179..d7055b41982d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -737,8 +737,6 @@ u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 			      u32 val, u32 reg, u32 offset);
 
-#if IS_ENABLED(CONFIG_MSCC_OCELOT_SWITCH_LIB)
-
 /* Packet I/O */
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
@@ -746,31 +744,6 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
-#else
-
-static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
-{
-	return false;
-}
-
-static inline void ocelot_port_inject_frame(struct ocelot *ocelot, int port,
-					    int grp, u32 rew_op,
-					    struct sk_buff *skb)
-{
-}
-
-static inline int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
-					struct sk_buff **skb)
-{
-	return -EIO;
-}
-
-static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
-{
-}
-
-#endif
-
 /* Hardware initialization */
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index d166377d7085..d8ee15f1c7a9 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -112,8 +112,6 @@ config NET_DSA_TAG_OCELOT
 
 config NET_DSA_TAG_OCELOT_8021Q
 	tristate "Tag driver for Ocelot family of switches, using VLAN"
-	depends on MSCC_OCELOT_SWITCH_LIB || \
-	          (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
 	help
 	  Say Y or M if you want to enable support for tagging frames with a
 	  custom VLAN-based header. Frames that require timestamping, such as
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 1e4e66ea6796..d05c352f96e5 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -10,10 +10,31 @@
  */
 #include <linux/dsa/8021q.h>
 #include <linux/dsa/ocelot.h>
-#include <soc/mscc/ocelot.h>
-#include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
 
+static struct sk_buff *ocelot_defer_xmit(struct dsa_port *dp,
+					 struct sk_buff *skb)
+{
+	struct felix_deferred_xmit_work *xmit_work;
+	struct felix_port *felix_port = dp->priv;
+
+	xmit_work = kzalloc(sizeof(*xmit_work), GFP_ATOMIC);
+	if (!xmit_work)
+		return NULL;
+
+	/* Calls felix_port_deferred_xmit in felix.c */
+	kthread_init_work(&xmit_work->work, felix_port->xmit_work_fn);
+	/* Increase refcount so the kfree_skb in dsa_slave_xmit
+	 * won't really free the packet.
+	 */
+	xmit_work->dp = dp;
+	xmit_work->skb = skb_get(skb);
+
+	kthread_queue_work(felix_port->xmit_worker, &xmit_work->work);
+
+	return NULL;
+}
+
 static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
@@ -21,18 +42,9 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
-	struct ocelot *ocelot = dp->ds->priv;
-	int port = dp->index;
-	u32 rew_op = 0;
 
-	rew_op = ocelot_ptp_rew_op(skb);
-	if (rew_op) {
-		if (!ocelot_can_inject(ocelot, 0))
-			return NULL;
-
-		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
-		return NULL;
-	}
+	if (ocelot_ptp_rew_op(skb))
+		return ocelot_defer_xmit(dp, skb);
 
 	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
 			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));

