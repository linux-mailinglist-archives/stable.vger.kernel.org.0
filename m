Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142551B0B99
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbgDTM4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbgDTMoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:44:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 699412075A;
        Mon, 20 Apr 2020 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386691;
        bh=2UBeAmBgXweJZxdbIvGSrS68EcXeYEGMD00ZYpnsJaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5NUhtMtmB5gX79QVlWq9bPYpA8p1qrdXOsXeDt8KGEdbesrTQpv2+cKr24U7WTgW
         YTWsNZGl4iOO8oaxFUkEvXjpuWuyeSXIhFNylmS9FIMX/KhQgwYm4Xc6bvtFzPIdqw
         eFWa48kJ9oEkMsyOSjNx4dZlYYLHKkaw44zhQ+V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 19/71] net: mscc: ocelot: fix untagged packet drops when enslaving to vlan aware bridge
Date:   Mon, 20 Apr 2020 14:38:33 +0200
Message-Id: <20200420121512.201117416@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 87b0f983f66f23762921129fd35966eddc3f2dae ]

To rehash a previous explanation given in commit 1c44ce560b4d ("net:
mscc: ocelot: fix vlan_filtering when enslaving to bridge before link is
up"), the switch driver operates the in a mode where a single VLAN can
be transmitted as untagged on a particular egress port. That is the
"native VLAN on trunk port" use case.

The configuration for this native VLAN is driven in 2 ways:
 - Set the egress port rewriter to strip the VLAN tag for the native
   VID (as it is egress-untagged, after all).
 - Configure the ingress port to drop untagged and priority-tagged
   traffic, if there is no native VLAN. The intention of this setting is
   that a trunk port with no native VLAN should not accept untagged
   traffic.

Since both of the above configurations for the native VLAN should only
be done if VLAN awareness is requested, they are actually done from the
ocelot_port_vlan_filtering function, after the basic procedure of
toggling the VLAN awareness flag of the port.

But there's a problem with that simplistic approach: we are trying to
juggle with 2 independent variables from a single function:
 - Native VLAN of the port - its value is held in port->vid.
 - VLAN awareness state of the port - currently there are some issues
   here, more on that later*.
The actual problem can be seen when enslaving the switch ports to a VLAN
filtering bridge:
 0. The driver configures a pvid of zero for each port, when in
    standalone mode. While the bridge configures a default_pvid of 1 for
    each port that gets added as a slave to it.
 1. The bridge calls ocelot_port_vlan_filtering with vlan_aware=true.
    The VLAN-filtering-dependent portion of the native VLAN
    configuration is done, considering that the native VLAN is 0.
 2. The bridge calls ocelot_vlan_add with vid=1, pvid=true,
    untagged=true. The native VLAN changes to 1 (change which gets
    propagated to hardware).
 3. ??? - nobody calls ocelot_port_vlan_filtering again, to reapply the
    VLAN-filtering-dependent portion of the native VLAN configuration,
    for the new native VLAN of 1. One can notice that after toggling "ip
    link set dev br0 type bridge vlan_filtering 0 && ip link set dev br0
    type bridge vlan_filtering 1", the new native VLAN finally makes it
    through and untagged traffic finally starts flowing again. But
    obviously that shouldn't be needed.

So it is clear that 2 independent variables need to both re-trigger the
native VLAN configuration. So we introduce the second variable as
ocelot_port->vlan_aware.

*Actually both the DSA Felix driver and the Ocelot driver already had
each its own variable:
 - Ocelot: ocelot_port_private->vlan_aware
 - Felix: dsa_port->vlan_filtering
but the common Ocelot library needs to work with a single, common,
variable, so there is some refactoring done to move the vlan_aware
property from the private structure into the common ocelot_port
structure.

Fixes: 97bb69e1e36e ("net: mscc: ocelot: break apart ocelot_vlan_port_apply")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix.c     |    5 --
 drivers/net/ethernet/mscc/ocelot.c |   84 ++++++++++++++++++-------------------
 drivers/net/ethernet/mscc/ocelot.h |    2 
 include/soc/mscc/ocelot.h          |    4 +
 4 files changed, 47 insertions(+), 48 deletions(-)

--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -44,11 +44,8 @@ static int felix_fdb_add(struct dsa_swit
 			 const unsigned char *addr, u16 vid)
 {
 	struct ocelot *ocelot = ds->priv;
-	bool vlan_aware;
 
-	vlan_aware = dsa_port_is_vlan_filtering(dsa_to_port(ds, port));
-
-	return ocelot_fdb_add(ocelot, port, addr, vid, vlan_aware);
+	return ocelot_fdb_add(ocelot, port, addr, vid);
 }
 
 static int felix_fdb_del(struct dsa_switch *ds, int port,
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -183,44 +183,47 @@ static void ocelot_vlan_mode(struct ocel
 	ocelot_write(ocelot, val, ANA_VLANMASK);
 }
 
-void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
-				bool vlan_aware)
+static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
+				       u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u32 val;
+	u32 val = 0;
 
-	if (vlan_aware)
-		val = ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
-		      ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
-	else
-		val = 0;
-	ocelot_rmw_gix(ocelot, val,
-		       ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
-		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
-		       ANA_PORT_VLAN_CFG, port);
+	if (ocelot_port->vid != vid) {
+		/* Always permit deleting the native VLAN (vid = 0) */
+		if (ocelot_port->vid && vid) {
+			dev_err(ocelot->dev,
+				"Port already has a native VLAN: %d\n",
+				ocelot_port->vid);
+			return -EBUSY;
+		}
+		ocelot_port->vid = vid;
+	}
+
+	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
+		       REW_PORT_VLAN_CFG_PORT_VID_M,
+		       REW_PORT_VLAN_CFG, port);
 
-	if (vlan_aware && !ocelot_port->vid)
+	if (ocelot_port->vlan_aware && !ocelot_port->vid)
 		/* If port is vlan-aware and tagged, drop untagged and priority
 		 * tagged frames.
 		 */
 		val = ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
 		      ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
 		      ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
-	else
-		val = 0;
 	ocelot_rmw_gix(ocelot, val,
 		       ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
 		       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
 		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA,
 		       ANA_PORT_DROP_CFG, port);
 
-	if (vlan_aware) {
+	if (ocelot_port->vlan_aware) {
 		if (ocelot_port->vid)
 			/* Tag all frames except when VID == DEFAULT_VLAN */
-			val |= REW_TAG_CFG_TAG_CFG(1);
+			val = REW_TAG_CFG_TAG_CFG(1);
 		else
 			/* Tag all frames */
-			val |= REW_TAG_CFG_TAG_CFG(3);
+			val = REW_TAG_CFG_TAG_CFG(3);
 	} else {
 		/* Port tagging disabled. */
 		val = REW_TAG_CFG_TAG_CFG(0);
@@ -228,31 +231,31 @@ void ocelot_port_vlan_filtering(struct o
 	ocelot_rmw_gix(ocelot, val,
 		       REW_TAG_CFG_TAG_CFG_M,
 		       REW_TAG_CFG, port);
+
+	return 0;
 }
-EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
-static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
-				       u16 vid)
+void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
+				bool vlan_aware)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 val;
 
-	if (ocelot_port->vid != vid) {
-		/* Always permit deleting the native VLAN (vid = 0) */
-		if (ocelot_port->vid && vid) {
-			dev_err(ocelot->dev,
-				"Port already has a native VLAN: %d\n",
-				ocelot_port->vid);
-			return -EBUSY;
-		}
-		ocelot_port->vid = vid;
-	}
+	ocelot_port->vlan_aware = vlan_aware;
 
-	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
-		       REW_PORT_VLAN_CFG_PORT_VID_M,
-		       REW_PORT_VLAN_CFG, port);
+	if (vlan_aware)
+		val = ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
+		      ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
+	else
+		val = 0;
+	ocelot_rmw_gix(ocelot, val,
+		       ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
+		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
+		       ANA_PORT_VLAN_CFG, port);
 
-	return 0;
+	ocelot_port_set_native_vlan(ocelot, port, ocelot_port->vid);
 }
+EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
 /* Default vlan to clasify for untagged frames (may be zero) */
 static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
@@ -858,12 +861,12 @@ static void ocelot_get_stats64(struct ne
 }
 
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid, bool vlan_aware)
+		   const unsigned char *addr, u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	if (!vid) {
-		if (!vlan_aware)
+		if (!ocelot_port->vlan_aware)
 			/* If the bridge is not VLAN aware and no VID was
 			 * provided, set it to pvid to ensure the MAC entry
 			 * matches incoming untagged packets
@@ -890,7 +893,7 @@ static int ocelot_port_fdb_add(struct nd
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_fdb_add(ocelot, port, addr, vid, priv->vlan_aware);
+	return ocelot_fdb_add(ocelot, port, addr, vid);
 }
 
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
@@ -1489,8 +1492,8 @@ static int ocelot_port_attr_set(struct n
 		ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		priv->vlan_aware = attr->u.vlan_filtering;
-		ocelot_port_vlan_filtering(ocelot, port, priv->vlan_aware);
+		ocelot_port_vlan_filtering(ocelot, port,
+					   attr->u.vlan_filtering);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
@@ -1861,7 +1864,6 @@ static int ocelot_netdevice_port_event(s
 			} else {
 				err = ocelot_port_bridge_leave(ocelot, port,
 							       info->upper_dev);
-				priv->vlan_aware = false;
 			}
 		}
 		if (netif_is_lag_master(info->upper_dev)) {
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -66,8 +66,6 @@ struct ocelot_port_private {
 	struct phy_device *phy;
 	u8 chip_port;
 
-	u8 vlan_aware;
-
 	struct phy *serdes;
 
 	struct ocelot_port_tc tc;
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -411,6 +411,8 @@ struct ocelot_port {
 
 	void __iomem			*regs;
 
+	bool				vlan_aware;
+
 	/* Ingress default VLAN (pvid) */
 	u16				pvid;
 
@@ -529,7 +531,7 @@ int ocelot_port_bridge_leave(struct ocel
 int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 		    dsa_fdb_dump_cb_t *cb, void *data);
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid, bool vlan_aware);
+		   const unsigned char *addr, u16 vid);
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,


