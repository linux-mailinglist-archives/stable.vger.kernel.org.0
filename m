Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEAD8695D
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404453AbfHHTGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404450AbfHHTGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:06:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43BCD2184E;
        Thu,  8 Aug 2019 19:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291189;
        bh=hhpOaXceY8XZTtD7LA9VCiHAjNYrgkjZ+W051FOLOPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfLSa41KtgFwoHZJhVpMpPC05K+cZtz53bdmJv4PVzcRBV5O2uCsNehAZZIL+Gsn3
         RHvyz3MMaH0rFwKQcIWD0fbdDdtZ4YSt4aGDN2WFQC+inZMLiNZlpO+shDMYg+3jOX
         RDGG12sPhgCAKZoqD5DEE4xyxhMZVepVkkADzNMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, michael-dev <michael-dev@fami-braun.de>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 20/56] net: bridge: move default pvid init/deinit to NETDEV_REGISTER/UNREGISTER
Date:   Thu,  8 Aug 2019 21:04:46 +0200
Message-Id: <20190808190453.680894540@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit 091adf9ba6cdb432cbcc217b47e4ffb8aa0d8865 ]

Most of the bridge device's vlan init bugs come from the fact that its
default pvid is created at the wrong time, way too early in ndo_init()
before the device is even assigned an ifindex. It introduces a bug when the
bridge's dev_addr is added as fdb during the initial default pvid creation
the notification has ifindex/NDA_MASTER both equal to 0 (see example below)
which really makes no sense for user-space[0] and is wrong.
Usually user-space software would ignore such entries, but they are
actually valid and will eventually have all necessary attributes.
It makes much more sense to send a notification *after* the device has
registered and has a proper ifindex allocated rather than before when
there's a chance that the registration might still fail or to receive
it with ifindex/NDA_MASTER == 0. Note that we can remove the fdb flush
from br_vlan_flush() since that case can no longer happen. At
NETDEV_REGISTER br->default_pvid is always == 1 as it's initialized by
br_vlan_init() before that and at NETDEV_UNREGISTER it can be anything
depending why it was called (if called due to NETDEV_REGISTER error
it'll still be == 1, otherwise it could be any value changed during the
device life time).

For the demonstration below a small change to iproute2 for printing all fdb
notifications is added, because it contained a workaround not to show
entries with ifindex == 0.
Command executed while monitoring: $ ip l add br0 type bridge
Before (both ifindex and master == 0):
$ bridge monitor fdb
36:7e:8a:b3:56:ba dev * vlan 1 master * permanent

After (proper br0 ifindex):
$ bridge monitor fdb
e6:2a:ae:7a:b7:48 dev br0 vlan 1 master br0 permanent

v4: move only the default pvid init/deinit to NETDEV_REGISTER/UNREGISTER
v3: send the correct v2 patch with all changes (stub should return 0)
v2: on error in br_vlan_init set br->vlgrp to NULL and return 0 in
    the br_vlan_bridge_event stub when bridge vlans are disabled

[0] https://bugzilla.kernel.org/show_bug.cgi?id=204389

Reported-by: michael-dev <michael-dev@fami-braun.de>
Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br.c         |    5 ++++-
 net/bridge/br_private.h |    9 +++++----
 net/bridge/br_vlan.c    |   34 ++++++++++++++++------------------
 3 files changed, 25 insertions(+), 23 deletions(-)

--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -37,12 +37,15 @@ static int br_device_event(struct notifi
 	int err;
 
 	if (dev->priv_flags & IFF_EBRIDGE) {
+		err = br_vlan_bridge_event(dev, event, ptr);
+		if (err)
+			return notifier_from_errno(err);
+
 		if (event == NETDEV_REGISTER) {
 			/* register of bridge completed, add sysfs entries */
 			br_sysfs_addbr(dev);
 			return NOTIFY_DONE;
 		}
-		br_vlan_bridge_event(dev, event, ptr);
 	}
 
 	/* not a port of a bridge */
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -893,8 +893,8 @@ int nbp_get_num_vlan_infos(struct net_br
 void br_vlan_get_stats(const struct net_bridge_vlan *v,
 		       struct br_vlan_stats *stats);
 void br_vlan_port_event(struct net_bridge_port *p, unsigned long event);
-void br_vlan_bridge_event(struct net_device *dev, unsigned long event,
-			  void *ptr);
+int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
+			 void *ptr);
 
 static inline struct net_bridge_vlan_group *br_vlan_group(
 					const struct net_bridge *br)
@@ -1084,9 +1084,10 @@ static inline void br_vlan_port_event(st
 {
 }
 
-static inline void br_vlan_bridge_event(struct net_device *dev,
-					unsigned long event, void *ptr)
+static inline int br_vlan_bridge_event(struct net_device *dev,
+				       unsigned long event, void *ptr)
 {
+	return 0;
 }
 #endif
 
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -715,11 +715,6 @@ void br_vlan_flush(struct net_bridge *br
 
 	ASSERT_RTNL();
 
-	/* delete auto-added default pvid local fdb before flushing vlans
-	 * otherwise it will be leaked on bridge device init failure
-	 */
-	br_fdb_delete_by_port(br, NULL, 0, 1);
-
 	vg = br_vlan_group(br);
 	__vlan_flush(vg);
 	RCU_INIT_POINTER(br->vlgrp, NULL);
@@ -1048,7 +1043,6 @@ int br_vlan_init(struct net_bridge *br)
 {
 	struct net_bridge_vlan_group *vg;
 	int ret = -ENOMEM;
-	bool changed;
 
 	vg = kzalloc(sizeof(*vg), GFP_KERNEL);
 	if (!vg)
@@ -1063,17 +1057,10 @@ int br_vlan_init(struct net_bridge *br)
 	br->vlan_proto = htons(ETH_P_8021Q);
 	br->default_pvid = 1;
 	rcu_assign_pointer(br->vlgrp, vg);
-	ret = br_vlan_add(br, 1,
-			  BRIDGE_VLAN_INFO_PVID | BRIDGE_VLAN_INFO_UNTAGGED |
-			  BRIDGE_VLAN_INFO_BRENTRY, &changed, NULL);
-	if (ret)
-		goto err_vlan_add;
 
 out:
 	return ret;
 
-err_vlan_add:
-	vlan_tunnel_deinit(vg);
 err_tunnel_init:
 	rhashtable_destroy(&vg->vlan_hash);
 err_rhtbl:
@@ -1448,13 +1435,23 @@ static void nbp_vlan_set_vlan_dev_state(
 }
 
 /* Must be protected by RTNL. */
-void br_vlan_bridge_event(struct net_device *dev, unsigned long event,
-			  void *ptr)
+int br_vlan_bridge_event(struct net_device *dev, unsigned long event, void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info;
-	struct net_bridge *br;
+	struct net_bridge *br = netdev_priv(dev);
+	bool changed;
+	int ret = 0;
 
 	switch (event) {
+	case NETDEV_REGISTER:
+		ret = br_vlan_add(br, br->default_pvid,
+				  BRIDGE_VLAN_INFO_PVID |
+				  BRIDGE_VLAN_INFO_UNTAGGED |
+				  BRIDGE_VLAN_INFO_BRENTRY, &changed, NULL);
+		break;
+	case NETDEV_UNREGISTER:
+		br_vlan_delete(br, br->default_pvid);
+		break;
 	case NETDEV_CHANGEUPPER:
 		info = ptr;
 		br_vlan_upper_change(dev, info->upper_dev, info->linking);
@@ -1462,12 +1459,13 @@ void br_vlan_bridge_event(struct net_dev
 
 	case NETDEV_CHANGE:
 	case NETDEV_UP:
-		br = netdev_priv(dev);
 		if (!br_opt_get(br, BROPT_VLAN_BRIDGE_BINDING))
-			return;
+			break;
 		br_vlan_link_state_change(dev, br);
 		break;
 	}
+
+	return ret;
 }
 
 /* Must be protected by RTNL. */


