Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD694997F2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357678AbiAXVRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37578 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448972AbiAXVOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:14:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A417614C7;
        Mon, 24 Jan 2022 21:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DC1C340E5;
        Mon, 24 Jan 2022 21:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058868;
        bh=rktmjRmnahCAgSOOgWpBvMZunEdB5saFcuYLb61QNmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrG5zHf7FCwdWPZEC+JM2IqIIlJYZ5mf/ycfON0nHnuV5xaEuoAs9q8QsXyl/eRfj
         ivr68kbfa/2tZsGGwc9pHV7I+mRqJK2CYmvQU0H8AMpQyi91CqjQz2tLK5EYapRbQI
         CclHgqLdWY0Ikc+W4rP6rY0jRJJpESWk6OuDFP0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0428/1039] net: mscc: ocelot: fix incorrect balancing with down LAG ports
Date:   Mon, 24 Jan 2022 19:36:57 +0100
Message-Id: <20220124184139.683693516@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit a14e6b69f393d651913edcbe4ec0dec27b8b4b40 ]

Assuming the test setup described here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210205130240.4072854-1-vladimir.oltean@nxp.com/
(swp1 and swp2 are in bond0, and bond0 is in a bridge with swp0)

it can be seen that when swp1 goes down (on either board A or B), then
traffic that should go through that port isn't forwarded anywhere.

A dump of the PGID table shows the following:

PGID_DST[0] = ports 0
PGID_DST[1] = ports 1
PGID_DST[2] = ports 2
PGID_DST[3] = ports 3
PGID_DST[4] = ports 4
PGID_DST[5] = ports 5
PGID_DST[6] = no ports
PGID_AGGR[0] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[1] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[2] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[3] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[4] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[5] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[6] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[7] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[8] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[9] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[10] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[11] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[12] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[13] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[14] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[15] = ports 0, 1, 2, 3, 4, 5
PGID_SRC[0] = ports 1, 2
PGID_SRC[1] = ports 0
PGID_SRC[2] = ports 0
PGID_SRC[3] = no ports
PGID_SRC[4] = no ports
PGID_SRC[5] = no ports
PGID_SRC[6] = ports 0, 1, 2, 3, 4, 5

Whereas a "good" PGID configuration for that setup should have looked
like this:

PGID_DST[0] = ports 0
PGID_DST[1] = ports 1, 2
PGID_DST[2] = ports 1, 2
PGID_DST[3] = ports 3
PGID_DST[4] = ports 4
PGID_DST[5] = ports 5
PGID_DST[6] = no ports
PGID_AGGR[0] = ports 0, 2, 3, 4, 5
PGID_AGGR[1] = ports 0, 2, 3, 4, 5
PGID_AGGR[2] = ports 0, 2, 3, 4, 5
PGID_AGGR[3] = ports 0, 2, 3, 4, 5
PGID_AGGR[4] = ports 0, 2, 3, 4, 5
PGID_AGGR[5] = ports 0, 2, 3, 4, 5
PGID_AGGR[6] = ports 0, 2, 3, 4, 5
PGID_AGGR[7] = ports 0, 2, 3, 4, 5
PGID_AGGR[8] = ports 0, 2, 3, 4, 5
PGID_AGGR[9] = ports 0, 2, 3, 4, 5
PGID_AGGR[10] = ports 0, 2, 3, 4, 5
PGID_AGGR[11] = ports 0, 2, 3, 4, 5
PGID_AGGR[12] = ports 0, 2, 3, 4, 5
PGID_AGGR[13] = ports 0, 2, 3, 4, 5
PGID_AGGR[14] = ports 0, 2, 3, 4, 5
PGID_AGGR[15] = ports 0, 2, 3, 4, 5
PGID_SRC[0] = ports 1, 2
PGID_SRC[1] = ports 0
PGID_SRC[2] = ports 0
PGID_SRC[3] = no ports
PGID_SRC[4] = no ports
PGID_SRC[5] = no ports
PGID_SRC[6] = ports 0, 1, 2, 3, 4, 5

In other words, in the "bad" configuration, the attempt is to remove the
inactive swp1 from the destination ports via PGID_DST. But when a MAC
table entry is learned, it is learned towards PGID_DST 1, because that
is the logical port id of the LAG itself (it is equal to the lowest
numbered member port). So when swp1 becomes inactive, if we set
PGID_DST[1] to contain just swp1 and not swp2, the packet will not have
any chance to reach the destination via swp2.

The "correct" way to remove swp1 as a destination is via PGID_AGGR
(remove swp1 from the aggregation port groups for all aggregation
codes). This means that PGID_DST[1] and PGID_DST[2] must still contain
both swp1 and swp2. This makes the MAC table still treat packets
destined towards the single-port LAG as "multicast", and the inactive
ports are removed via the aggregation code tables.

The change presented here is a design one: the ocelot_get_bond_mask()
function used to take an "only_active_ports" argument. We don't need
that. The only call site that specifies only_active_ports=true,
ocelot_set_aggr_pgids(), must retrieve the entire bonding mask, because
it must program that into PGID_DST. Additionally, it must also clear the
inactive ports from the bond mask here, which it can't do if bond_mask
just contains the active ports:

	ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
	ac &= ~bond_mask;  <---- here
	/* Don't do division by zero if there was no active
	 * port. Just make all aggregation codes zero.
	 */
	if (num_active_ports)
		ac |= BIT(aggr_idx[i % num_active_ports]);
	ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);

So it becomes the responsibility of ocelot_set_aggr_pgids() to take
ocelot_port->lag_tx_active into consideration when populating the
aggr_idx array.

Fixes: 23ca3b727ee6 ("net: mscc: ocelot: rebalance LAGs on link up/down events")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220107164332.402133-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 1e4ad953cffbc..d1e883666951c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1688,8 +1688,7 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
-				bool only_active_ports)
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 {
 	u32 mask = 0;
 	int port;
@@ -1700,12 +1699,8 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
 		if (!ocelot_port)
 			continue;
 
-		if (ocelot_port->bond == bond) {
-			if (only_active_ports && !ocelot_port->lag_tx_active)
-				continue;
-
+		if (ocelot_port->bond == bond)
 			mask |= BIT(port);
-		}
 	}
 
 	return mask;
@@ -1792,10 +1787,8 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			mask = ocelot_get_bridge_fwd_mask(ocelot, port, bridge);
 			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
-			if (bond) {
-				mask &= ~ocelot_get_bond_mask(ocelot, bond,
-							      false);
-			}
+			if (bond)
+				mask &= ~ocelot_get_bond_mask(ocelot, bond);
 		} else {
 			/* Standalone ports forward only to DSA tag_8021q CPU
 			 * ports (if those exist), or to the hardware CPU port
@@ -2112,13 +2105,17 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 		if (!bond || (visited & BIT(lag)))
 			continue;
 
-		bond_mask = ocelot_get_bond_mask(ocelot, bond, true);
+		bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
+			struct ocelot_port *ocelot_port = ocelot->ports[port];
+
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[num_active_ports++] = port;
+
+			if (ocelot_port->lag_tx_active)
+				aggr_idx[num_active_ports++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -2167,8 +2164,7 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond,
-							     false));
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
-- 
2.34.1



