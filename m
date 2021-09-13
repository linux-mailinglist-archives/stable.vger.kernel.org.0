Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BA24094EA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345410AbhIMOgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346312AbhIMOco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9AC761BC2;
        Mon, 13 Sep 2021 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541138;
        bh=tjLNaUIqXvs8fHy+l9oxuPHt5XZV6MR5yWfzd9+byZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaTnFJrnxCdbB0YI0AYwZCvS3HpfxE1Izn0fWE31HOYmjy4FEnrYeOsTJUclwIvTb
         EQF7UqMZ3PINQmNgWiety2pK0ptl2+3DGJ457Uj9w3MCK+7baXzme2WukXhILe907Q
         EW1BmKWDUy1hU3OZXr3yaHs/z8E/VIKCh5/ZG+2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 179/334] net: dsa: dont disable multicast flooding to the CPU even without an IGMP querier
Date:   Mon, 13 Sep 2021 15:13:53 +0200
Message-Id: <20210913131119.405845373@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c73c57081b3d59aa99093fbedced32ea02620cd3 ]

Commit 08cc83cc7fd8 ("net: dsa: add support for BRIDGE_MROUTER
attribute") added an option for users to turn off multicast flooding
towards the CPU if they turn off the IGMP querier on a bridge which
already has enslaved ports (echo 0 > /sys/class/net/br0/bridge/multicast_router).

And commit a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
simply papered over that issue, because it moved the decision to flood
the CPU with multicast (or not) from the DSA core down to individual drivers,
instead of taking a more radical position then.

The truth is that disabling multicast flooding to the CPU is simply
something we are not prepared to do now, if at all. Some reasons:

- ICMP6 neighbor solicitation messages are unregistered multicast
  packets as far as the bridge is concerned. So if we stop flooding
  multicast, the outside world cannot ping the bridge device's IPv6
  link-local address.

- There might be foreign interfaces bridged with our DSA switch ports
  (sending a packet towards the host does not necessarily equal
  termination, but maybe software forwarding). So if there is no one
  interested in that multicast traffic in the local network stack, that
  doesn't mean nobody is.

- PTP over L4 (IPv4, IPv6) is multicast, but is unregistered as far as
  the bridge is concerned. This should reach the CPU port.

- The switch driver might not do FDB partitioning. And since we don't
  even bother to do more fine-grained flood disabling (such as "disable
  flooding _from_port_N_ towards the CPU port" as opposed to "disable
  flooding _from_any_port_ towards the CPU port"), this breaks standalone
  ports, or even multiple bridges where one has an IGMP querier and one
  doesn't.

Reverting the logic makes all of the above work.

Fixes: a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
Fixes: 08cc83cc7fd8 ("net: dsa: add support for BRIDGE_MROUTER attribute")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 10 ----------
 drivers/net/dsa/b53/b53_priv.h   |  2 --
 drivers/net/dsa/bcm_sf2.c        |  1 -
 drivers/net/dsa/mv88e6xxx/chip.c | 18 ------------------
 include/net/dsa.h                |  2 --
 net/dsa/dsa_priv.h               |  2 --
 net/dsa/port.c                   | 11 -----------
 net/dsa/slave.c                  |  6 ------
 8 files changed, 52 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index b23e3488695b..bd1417a66cbf 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2016,15 +2016,6 @@ int b53_br_flags(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_br_flags);
 
-int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-		    struct netlink_ext_ack *extack)
-{
-	b53_port_set_mcast_flood(ds->priv, port, mrouter);
-
-	return 0;
-}
-EXPORT_SYMBOL(b53_set_mrouter);
-
 static bool b53_possible_cpu_port(struct dsa_switch *ds, int port)
 {
 	/* Broadcom switches will accept enabling Broadcom tags on the
@@ -2268,7 +2259,6 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_bridge_leave	= b53_br_leave,
 	.port_pre_bridge_flags	= b53_br_flags_pre,
 	.port_bridge_flags	= b53_br_flags,
-	.port_set_mrouter	= b53_set_mrouter,
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
 	.port_vlan_filtering	= b53_vlan_filtering,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 82700a5714c1..9bf8319342b0 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -328,8 +328,6 @@ int b53_br_flags_pre(struct dsa_switch *ds, int port,
 int b53_br_flags(struct dsa_switch *ds, int port,
 		 struct switchdev_brport_flags flags,
 		 struct netlink_ext_ack *extack);
-int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-		    struct netlink_ext_ack *extack);
 int b53_setup_devlink_resources(struct dsa_switch *ds);
 void b53_port_event(struct dsa_switch *ds, int port);
 void b53_phylink_validate(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3b018fcf4412..6ce9ec1283e0 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1199,7 +1199,6 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.port_pre_bridge_flags	= b53_br_flags_pre,
 	.port_bridge_flags	= b53_br_flags,
 	.port_stp_state_set	= b53_br_set_stp_state,
-	.port_set_mrouter	= b53_set_mrouter,
 	.port_fast_age		= b53_br_fast_age,
 	.port_vlan_filtering	= b53_vlan_filtering,
 	.port_vlan_add		= b53_vlan_add,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 272b0535d946..111a6d5985da 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5781,23 +5781,6 @@ out:
 	return err;
 }
 
-static int mv88e6xxx_port_set_mrouter(struct dsa_switch *ds, int port,
-				      bool mrouter,
-				      struct netlink_ext_ack *extack)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	if (!chip->info->ops->port_set_mcast_flood)
-		return -EOPNOTSUPP;
-
-	mv88e6xxx_reg_lock(chip);
-	err = chip->info->ops->port_set_mcast_flood(chip, port, mrouter);
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 				      struct net_device *lag,
 				      struct netdev_lag_upper_info *info)
@@ -6099,7 +6082,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_bridge_leave	= mv88e6xxx_port_bridge_leave,
 	.port_pre_bridge_flags	= mv88e6xxx_port_pre_bridge_flags,
 	.port_bridge_flags	= mv88e6xxx_port_bridge_flags,
-	.port_set_mrouter	= mv88e6xxx_port_set_mrouter,
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
 	.port_fast_age		= mv88e6xxx_port_fast_age,
 	.port_vlan_filtering	= mv88e6xxx_port_vlan_filtering,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 33f40c1ec379..048d297623c9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -699,8 +699,6 @@ struct dsa_switch_ops {
 	int	(*port_bridge_flags)(struct dsa_switch *ds, int port,
 				     struct switchdev_brport_flags flags,
 				     struct netlink_ext_ack *extack);
-	int	(*port_set_mrouter)(struct dsa_switch *ds, int port, bool mrouter,
-				    struct netlink_ext_ack *extack);
 
 	/*
 	 * VLAN support
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f201c33980bf..cddf7cb0f398 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -234,8 +234,6 @@ int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 int dsa_port_bridge_flags(const struct dsa_port *dp,
 			  struct switchdev_brport_flags flags,
 			  struct netlink_ext_ack *extack);
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
-		     struct netlink_ext_ack *extack);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan,
 		      struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d9ef2c2fbf88..23e30198a90e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -597,17 +597,6 @@ int dsa_port_bridge_flags(const struct dsa_port *dp,
 	return ds->ops->port_bridge_flags(ds, dp->index, flags, extack);
 }
 
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
-		     struct netlink_ext_ack *extack)
-{
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->port_set_mrouter)
-		return -EOPNOTSUPP;
-
-	return ds->ops->port_set_mrouter(ds, dp->index, mrouter, extack);
-}
-
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 23be8e01026b..b34116b15d43 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -314,12 +314,6 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
-	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
-		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
-			return -EOPNOTSUPP;
-
-		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, extack);
-		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
-- 
2.30.2



