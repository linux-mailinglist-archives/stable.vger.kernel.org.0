Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C67A5B72ED
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiIMOzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiIMOyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E5472ED1;
        Tue, 13 Sep 2022 07:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07907614B7;
        Tue, 13 Sep 2022 14:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A509C433D7;
        Tue, 13 Sep 2022 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078572;
        bh=Liea1cG2e92kbVfPF0I2YMi9V8aWwZ45tAoLKg6z6Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpVVo9O6c1GuS4JMns5CWHDTln2sS8ar3mcerh/D5H54Cs3rAp3R9ef8h0SVf4SWd
         bGPppaEv2BOwtzy8VpZ5yKgOOvxsnhTe81cIfED5nJigPgKgqbD/sfTiQNtq3ptKTm
         heVoI7tPzUFq5rpjVGfoaLJeYxD0JyPC720mUwJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 166/192] net: bonding: replace dev_trans_start() with the jiffies of the last ARP/NS
Date:   Tue, 13 Sep 2022 16:04:32 +0200
Message-Id: <20220913140418.300333823@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 06799a9085e12a778fe2851db550ab5911ad28fe ]

The bonding driver piggybacks on time stamps kept by the network stack
for the purpose of the netdev TX watchdog, and this is problematic
because it does not work with NETIF_F_LLTX devices.

It is hard to say why the driver looks at dev_trans_start() of the
slave->dev, considering that this is updated even by non-ARP/NS probes
sent by us, and even by traffic not sent by us at all (for example PTP
on physical slave devices). ARP monitoring in active-backup mode appears
to still work even if we track only the last TX time of actual ARP
probes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 592335a4164c ("bonding: accept unsolicited NA message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 35 +++++++++++++++++++--------------
 include/net/bonding.h           | 13 +++++++++++-
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0cf8c3a125d2e..01b58b7e7f165 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1974,6 +1974,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++)
 		new_slave->target_last_arp_rx[i] = new_slave->last_rx;
 
+	new_slave->last_tx = new_slave->last_rx;
+
 	if (bond->params.miimon && !bond->params.use_carrier) {
 		link_reporting = bond_check_dev_link(bond, slave_dev, 1);
 
@@ -2857,8 +2859,11 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 		return;
 	}
 
-	if (bond_handle_vlan(slave, tags, skb))
+	if (bond_handle_vlan(slave, tags, skb)) {
+		slave_update_last_tx(slave);
 		arp_xmit(skb);
+	}
+
 	return;
 }
 
@@ -3047,8 +3052,7 @@ static int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
 			    curr_active_slave->last_link_up))
 		bond_validate_arp(bond, slave, tip, sip);
 	else if (curr_arp_slave && (arp->ar_op == htons(ARPOP_REPLY)) &&
-		 bond_time_in_interval(bond,
-				       dev_trans_start(curr_arp_slave->dev), 1))
+		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
 		bond_validate_arp(bond, slave, sip, tip);
 
 out_unlock:
@@ -3076,8 +3080,10 @@ static void bond_ns_send(struct slave *slave, const struct in6_addr *daddr,
 	}
 
 	addrconf_addr_solict_mult(daddr, &mcaddr);
-	if (bond_handle_vlan(slave, tags, skb))
+	if (bond_handle_vlan(slave, tags, skb)) {
+		slave_update_last_tx(slave);
 		ndisc_send_skb(skb, &mcaddr, saddr);
+	}
 }
 
 static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
@@ -3222,8 +3228,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 			    curr_active_slave->last_link_up))
 		bond_validate_ns(bond, slave, saddr, daddr);
 	else if (curr_arp_slave &&
-		 bond_time_in_interval(bond,
-				       dev_trans_start(curr_arp_slave->dev), 1))
+		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
 		bond_validate_ns(bond, slave, saddr, daddr);
 
 out:
@@ -3311,12 +3316,12 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 	 *       so it can wait
 	 */
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		unsigned long trans_start = dev_trans_start(slave->dev);
+		unsigned long last_tx = slave_last_tx(slave);
 
 		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 		if (slave->link != BOND_LINK_UP) {
-			if (bond_time_in_interval(bond, trans_start, 1) &&
+			if (bond_time_in_interval(bond, last_tx, 1) &&
 			    bond_time_in_interval(bond, slave->last_rx, 1)) {
 
 				bond_propose_link_state(slave, BOND_LINK_UP);
@@ -3341,7 +3346,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			 * when the source ip is 0, so don't take the link down
 			 * if we don't know our ip yet
 			 */
-			if (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
+			if (!bond_time_in_interval(bond, last_tx, bond->params.missed_max) ||
 			    !bond_time_in_interval(bond, slave->last_rx, bond->params.missed_max)) {
 
 				bond_propose_link_state(slave, BOND_LINK_DOWN);
@@ -3407,7 +3412,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
  */
 static int bond_ab_arp_inspect(struct bonding *bond)
 {
-	unsigned long trans_start, last_rx;
+	unsigned long last_tx, last_rx;
 	struct list_head *iter;
 	struct slave *slave;
 	int commit = 0;
@@ -3458,9 +3463,9 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		 * - (more than missed_max*delta since receive AND
 		 *    the bond has an IP address)
 		 */
-		trans_start = dev_trans_start(slave->dev);
+		last_tx = slave_last_tx(slave);
 		if (bond_is_active_slave(slave) &&
-		    (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
+		    (!bond_time_in_interval(bond, last_tx, bond->params.missed_max) ||
 		     !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) {
 			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
@@ -3477,8 +3482,8 @@ static int bond_ab_arp_inspect(struct bonding *bond)
  */
 static void bond_ab_arp_commit(struct bonding *bond)
 {
-	unsigned long trans_start;
 	struct list_head *iter;
+	unsigned long last_tx;
 	struct slave *slave;
 
 	bond_for_each_slave(bond, slave, iter) {
@@ -3487,10 +3492,10 @@ static void bond_ab_arp_commit(struct bonding *bond)
 			continue;
 
 		case BOND_LINK_UP:
-			trans_start = dev_trans_start(slave->dev);
+			last_tx = slave_last_tx(slave);
 			if (rtnl_dereference(bond->curr_active_slave) != slave ||
 			    (!rtnl_dereference(bond->curr_active_slave) &&
-			     bond_time_in_interval(bond, trans_start, 1))) {
+			     bond_time_in_interval(bond, last_tx, 1))) {
 				struct slave *current_arp_slave;
 
 				current_arp_slave = rtnl_dereference(bond->current_arp_slave);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index cb904d356e31e..3b816ae8b1f3b 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -161,8 +161,9 @@ struct slave {
 	struct net_device *dev; /* first - useful for panic debug */
 	struct bonding *bond; /* our master */
 	int    delay;
-	/* all three in jiffies */
+	/* all 4 in jiffies */
 	unsigned long last_link_up;
+	unsigned long last_tx;
 	unsigned long last_rx;
 	unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
 	s8     link;		/* one of BOND_LINK_XXXX */
@@ -539,6 +540,16 @@ static inline unsigned long slave_last_rx(struct bonding *bond,
 	return slave->last_rx;
 }
 
+static inline void slave_update_last_tx(struct slave *slave)
+{
+	WRITE_ONCE(slave->last_tx, jiffies);
+}
+
+static inline unsigned long slave_last_tx(struct slave *slave)
+{
+	return READ_ONCE(slave->last_tx);
+}
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static inline netdev_tx_t bond_netpoll_send_skb(const struct slave *slave,
 					 struct sk_buff *skb)
-- 
2.35.1



