Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547AB395E88
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhEaN77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232881AbhEaN5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 963C06192F;
        Mon, 31 May 2021 13:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468116;
        bh=dTvWK3ibe+ieHXr70pNnGweVN+C5JA6qf9FhUXG5dqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6ZKH0Pb63YhZ4aaOt6qGgpOxO3qk4ZSflyrqa7bXsniMI56820bA0wzFe7ctXiab
         gf7DAt+udTgRyJen5vQ5CAfPRB8b2TKXXsV58zrXbzWk3OtnLaJwYbMsP//fuKSNFt
         z/OitCxNmaD2YokdHWiKcPOJL4farxlHsyFvUDqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 115/252] net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic
Date:   Mon, 31 May 2021 15:13:00 +0200
Message-Id: <20210531130701.886242103@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit ed040abca4c1db72dfd3b8483b6ed6bfb7c2571e upstream.

One thing became visible when writing the blamed commit, and that was
that STP and PTP frames injected by net/dsa/tag_sja1105.c using the
deferred xmit mechanism are always classified to the pvid of the CPU
port, regardless of whatever VLAN there might be in these packets.

So a decision needed to be taken regarding the mechanism through which
we should ensure that delivery of STP and PTP traffic is possible when
we are in a VLAN awareness mode that involves tag_8021q. This is because
tag_8021q is not concerned with managing the pvid of the CPU port, since
as far as tag_8021q is concerned, no traffic should be sent as untagged
from the CPU port. So we end up not actually having a pvid on the CPU
port if we only listen to tag_8021q, and unless we do something about it.

The decision taken at the time was to keep VLAN 1 in the list of
priv->dsa_8021q_vlans, and make it a pvid of the CPU port. This ensures
that STP and PTP frames can always be sent to the outside world.

However there is a problem. If we do the following while we are in
the best_effort_vlan_filtering=true mode:

ip link add br0 type bridge vlan_filtering 1
ip link set swp2 master br0
bridge vlan del dev swp2 vid 1

Then untagged and pvid-tagged frames should be dropped. But we observe
that they aren't, and this is because of the precaution we took that VID
1 is always installed on all ports.

So clearly VLAN 1 is not good for this purpose. What about VLAN 0?
Well, VLAN 0 is managed by the 8021q module, and that module wants to
ensure that 802.1p tagged frames are always received by a port, and are
always transmitted as VLAN-tagged (with VLAN ID 0). Whereas we want our
STP and PTP frames to be untagged if the stack sent them as untagged -
we don't want the driver to just decide out of the blue that it adds
VID 0 to some packets.

So what to do?

Well, there is one other VLAN that is reserved, and that is 4095:
$ ip link add link swp2 name swp2.4095 type vlan id 4095
Error: 8021q: Invalid VLAN id.
$ bridge vlan add dev swp2 vid 4095
Error: bridge: Vlan id is invalid.

After we made this change, VLAN 1 is indeed forwarded and/or dropped
according to the bridge VLAN table, there are no further alterations
done by the sja1105 driver.

Fixes: ec5ae61076d0 ("net: dsa: sja1105: save/restore VLANs using a delta commit method")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -25,6 +25,8 @@
 #include "sja1105_sgmii.h"
 #include "sja1105_tas.h"
 
+#define SJA1105_DEFAULT_VLAN		(VLAN_N_VID - 1)
+
 static const struct dsa_switch_ops sja1105_switch_ops;
 
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
@@ -292,6 +294,13 @@ static int sja1105_init_l2_lookup_params
 	return 0;
 }
 
+/* Set up a default VLAN for untagged traffic injected from the CPU
+ * using management routes (e.g. STP, PTP) as opposed to tag_8021q.
+ * All DT-defined ports are members of this VLAN, and there are no
+ * restrictions on forwarding (since the CPU selects the destination).
+ * Frames from this VLAN will always be transmitted as untagged, and
+ * neither the bridge nor the 8021q module cannot create this VLAN ID.
+ */
 static int sja1105_init_static_vlan(struct sja1105_private *priv)
 {
 	struct sja1105_table *table;
@@ -301,17 +310,13 @@ static int sja1105_init_static_vlan(stru
 		.vmemb_port = 0,
 		.vlan_bc = 0,
 		.tag_port = 0,
-		.vlanid = 1,
+		.vlanid = SJA1105_DEFAULT_VLAN,
 	};
 	struct dsa_switch *ds = priv->ds;
 	int port;
 
 	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
 
-	/* The static VLAN table will only contain the initial pvid of 1.
-	 * All other VLANs are to be configured through dynamic entries,
-	 * and kept in the static configuration table as backing memory.
-	 */
 	if (table->entry_count) {
 		kfree(table->entries);
 		table->entry_count = 0;
@@ -324,9 +329,6 @@ static int sja1105_init_static_vlan(stru
 
 	table->entry_count = 1;
 
-	/* VLAN 1: all DT-defined ports are members; no restrictions on
-	 * forwarding; always transmit as untagged.
-	 */
 	for (port = 0; port < ds->num_ports; port++) {
 		struct sja1105_bridge_vlan *v;
 
@@ -337,15 +339,12 @@ static int sja1105_init_static_vlan(stru
 		pvid.vlan_bc |= BIT(port);
 		pvid.tag_port &= ~BIT(port);
 
-		/* Let traffic that don't need dsa_8021q (e.g. STP, PTP) be
-		 * transmitted as untagged.
-		 */
 		v = kzalloc(sizeof(*v), GFP_KERNEL);
 		if (!v)
 			return -ENOMEM;
 
 		v->port = port;
-		v->vid = 1;
+		v->vid = SJA1105_DEFAULT_VLAN;
 		v->untagged = true;
 		if (dsa_is_cpu_port(ds, port))
 			v->pvid = true;


