Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB3D201310
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392692AbgFSPU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392482AbgFSPU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:20:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56B2B2158C;
        Fri, 19 Jun 2020 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580026;
        bh=LGucAxx+x52tVKnfbNkMjULMnphu0SKvwqOkseuLR7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVr0NsFTFo8UQW6jm6c1IiKRNq/wcksxOKknt829u3EiSfinim98uQTUCMYVBUn6Q
         aGQhn4WekAdIbQW6wy8q8ks5vUMetkUC6IYehUBdcj5yuPjbgVS5J1vmX7sLuY0SE9
         PImfItKo/XzyMJgv41GCD5+vLr1toYVrbACSTSXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 095/376] net: mscc: ocelot: deal with problematic MAC_ETYPE VCAP IS2 rules
Date:   Fri, 19 Jun 2020 16:30:13 +0200
Message-Id: <20200619141714.841234975@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 89f9ffd3eb670bad1260bc579f5e13b8f2d5b3e0 ]

By default, the VCAP IS2 will produce a single match for each frame, on
the most specific classification.

Example: a ping packet (ICMP over IPv4 over Ethernet) sent from an IP
address of 10.0.0.1 and a MAC address of 96:18:82:00:04:01 will match
this rule:

tc filter add dev swp0 ingress protocol ipv4 \
	flower skip_sw src_ip 10.0.0.1 action drop

but not this one:

tc filter add dev swp0 ingress \
	flower skip_sw src_mac 96:18:82:00:04:01 action drop

Currently the driver does not really warn the user in any way about
this, and the behavior is rather strange anyway.

The current patch is a workaround to force matches on MAC_ETYPE keys
(DMAC and SMAC) for all packets irrespective of higher layer protocol.
The setting is made at the port level.

Of course this breaks all other non-src_mac and non-dst_mac matches, so
rule exclusivity checks have been added to the driver, in order to never
have rules of both types on any ingress port.

The bits that discard higher-level protocol information are set only
once a MAC_ETYPE rule is added to a filter block, and only for the ports
that are bound to that filter block. Then all further non-MAC_ETYPE
rules added to that filter block should be denied by the ports bound to
it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_ace.c    | 103 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_ace.h    |   5 +-
 drivers/net/ethernet/mscc/ocelot_flower.c |   2 +-
 3 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 3bd286044480..8a2f7d13ef6d 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -706,13 +706,114 @@ ocelot_ace_rule_get_rule_index(struct ocelot_acl_block *block, int index)
 	return NULL;
 }
 
+/* If @on=false, then SNAP, ARP, IP and OAM frames will not match on keys based
+ * on destination and source MAC addresses, but only on higher-level protocol
+ * information. The only frame types to match on keys containing MAC addresses
+ * in this case are non-SNAP, non-ARP, non-IP and non-OAM frames.
+ *
+ * If @on=true, then the above frame types (SNAP, ARP, IP and OAM) will match
+ * on MAC_ETYPE keys such as destination and source MAC on this ingress port.
+ * However the setting has the side effect of making these frames not matching
+ * on any _other_ keys than MAC_ETYPE ones.
+ */
+static void ocelot_match_all_as_mac_etype(struct ocelot *ocelot, int port,
+					  bool on)
+{
+	u32 val = 0;
+
+	if (on)
+		val = ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS(3) |
+		      ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS(3) |
+		      ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS(3) |
+		      ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS(3) |
+		      ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS(3);
+
+	ocelot_rmw_gix(ocelot, val,
+		       ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS_M |
+		       ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS_M |
+		       ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS_M |
+		       ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS_M |
+		       ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS_M,
+		       ANA_PORT_VCAP_S2_CFG, port);
+}
+
+static bool ocelot_ace_is_problematic_mac_etype(struct ocelot_ace_rule *ace)
+{
+	if (ace->type != OCELOT_ACE_TYPE_ETYPE)
+		return false;
+	if (ether_addr_to_u64(ace->frame.etype.dmac.value) &
+	    ether_addr_to_u64(ace->frame.etype.dmac.mask))
+		return true;
+	if (ether_addr_to_u64(ace->frame.etype.smac.value) &
+	    ether_addr_to_u64(ace->frame.etype.smac.mask))
+		return true;
+	return false;
+}
+
+static bool ocelot_ace_is_problematic_non_mac_etype(struct ocelot_ace_rule *ace)
+{
+	if (ace->type == OCELOT_ACE_TYPE_SNAP)
+		return true;
+	if (ace->type == OCELOT_ACE_TYPE_ARP)
+		return true;
+	if (ace->type == OCELOT_ACE_TYPE_IPV4)
+		return true;
+	if (ace->type == OCELOT_ACE_TYPE_IPV6)
+		return true;
+	return false;
+}
+
+static bool ocelot_exclusive_mac_etype_ace_rules(struct ocelot *ocelot,
+						 struct ocelot_ace_rule *ace)
+{
+	struct ocelot_acl_block *block = &ocelot->acl_block;
+	struct ocelot_ace_rule *tmp;
+	unsigned long port;
+	int i;
+
+	if (ocelot_ace_is_problematic_mac_etype(ace)) {
+		/* Search for any non-MAC_ETYPE rules on the port */
+		for (i = 0; i < block->count; i++) {
+			tmp = ocelot_ace_rule_get_rule_index(block, i);
+			if (tmp->ingress_port_mask & ace->ingress_port_mask &&
+			    ocelot_ace_is_problematic_non_mac_etype(tmp))
+				return false;
+		}
+
+		for_each_set_bit(port, &ace->ingress_port_mask,
+				 ocelot->num_phys_ports)
+			ocelot_match_all_as_mac_etype(ocelot, port, true);
+	} else if (ocelot_ace_is_problematic_non_mac_etype(ace)) {
+		/* Search for any MAC_ETYPE rules on the port */
+		for (i = 0; i < block->count; i++) {
+			tmp = ocelot_ace_rule_get_rule_index(block, i);
+			if (tmp->ingress_port_mask & ace->ingress_port_mask &&
+			    ocelot_ace_is_problematic_mac_etype(tmp))
+				return false;
+		}
+
+		for_each_set_bit(port, &ace->ingress_port_mask,
+				 ocelot->num_phys_ports)
+			ocelot_match_all_as_mac_etype(ocelot, port, false);
+	}
+
+	return true;
+}
+
 int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
-				struct ocelot_ace_rule *rule)
+				struct ocelot_ace_rule *rule,
+				struct netlink_ext_ack *extack)
 {
 	struct ocelot_acl_block *block = &ocelot->acl_block;
 	struct ocelot_ace_rule *ace;
 	int i, index;
 
+	if (!ocelot_exclusive_mac_etype_ace_rules(ocelot, rule)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules");
+		return -EBUSY;
+	}
+
 	/* Add rule to the linked list */
 	ocelot_ace_rule_add(ocelot, block, rule);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index 29d22c566786..099e177f2617 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -194,7 +194,7 @@ struct ocelot_ace_rule {
 
 	enum ocelot_ace_action action;
 	struct ocelot_ace_stats stats;
-	u16 ingress_port_mask;
+	unsigned long ingress_port_mask;
 
 	enum ocelot_vcap_bit dmac_mc;
 	enum ocelot_vcap_bit dmac_bc;
@@ -215,7 +215,8 @@ struct ocelot_ace_rule {
 };
 
 int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
-				struct ocelot_ace_rule *rule);
+				struct ocelot_ace_rule *rule,
+				struct netlink_ext_ack *extack);
 int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
 				struct ocelot_ace_rule *rule);
 int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 341923311fec..954cb67eeaa2 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -205,7 +205,7 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 		return ret;
 	}
 
-	return ocelot_ace_rule_offload_add(ocelot, ace);
+	return ocelot_ace_rule_offload_add(ocelot, ace, f->common.extack);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 
-- 
2.25.1



