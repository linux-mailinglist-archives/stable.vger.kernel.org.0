Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FCF583099
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbiG0Rji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242658AbiG0Ri3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:38:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36E787228;
        Wed, 27 Jul 2022 09:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8122BB821D4;
        Wed, 27 Jul 2022 16:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13E8C433C1;
        Wed, 27 Jul 2022 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940635;
        bh=1c0hP79Llw0SJOxtm92TfeWvvwn6BhuVT9xoXPPxJQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAzXpBJqEtejT+5I0Hzgj/KrmMzweuLxrvj6Guamq4vrnmwO9nU/amIFm+nuXacX8
         m8SH3idv5veT4j13glHm4Vecg4J0YuN+8Au2LZYirAUTQJJ9cCl1mU23B3d3CO08ix
         gJxgQGHbFzrXEE6ZPmlyuoq6/Gc96QBuaGyaSDL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 092/158] net: dsa: move reset of VLAN filtering to dsa_port_switchdev_unsync_attrs
Date:   Wed, 27 Jul 2022 18:12:36 +0200
Message-Id: <20220727161025.151576087@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8e9e678e4758b69b6231d3ad4d26d3381fdb5f3f ]

In dsa_port_switchdev_unsync_attrs() there is a comment that resetting
the VLAN filtering isn't done where it is expected. And since commit
108dc8741c20 ("net: dsa: Avoid cross-chip syncing of VLAN filtering"),
there is no reason to handle this in switch.c either.

Therefore, move the logic to port.c, and adapt it slightly to the data
structures and naming conventions from there.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/port.c   | 60 +++++++++++++++++++++++++++++++++++++++++++++---
 net/dsa/switch.c | 58 ----------------------------------------------
 2 files changed, 57 insertions(+), 61 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4b72513cc9e4..6aab5768ef96 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -242,6 +242,59 @@ void dsa_port_disable(struct dsa_port *dp)
 	rtnl_unlock();
 }
 
+static void dsa_port_reset_vlan_filtering(struct dsa_port *dp,
+					  struct dsa_bridge bridge)
+{
+	struct netlink_ext_ack extack = {0};
+	bool change_vlan_filtering = false;
+	struct dsa_switch *ds = dp->ds;
+	bool vlan_filtering;
+	int err;
+
+	if (ds->needs_standalone_vlan_filtering &&
+	    !br_vlan_enabled(bridge.dev)) {
+		change_vlan_filtering = true;
+		vlan_filtering = true;
+	} else if (!ds->needs_standalone_vlan_filtering &&
+		   br_vlan_enabled(bridge.dev)) {
+		change_vlan_filtering = true;
+		vlan_filtering = false;
+	}
+
+	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
+	 * event for changing vlan_filtering setting upon slave ports leaving
+	 * it. That is a good thing, because that lets us handle it and also
+	 * handle the case where the switch's vlan_filtering setting is global
+	 * (not per port). When that happens, the correct moment to trigger the
+	 * vlan_filtering callback is only when the last port leaves the last
+	 * VLAN-aware bridge.
+	 */
+	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
+		dsa_switch_for_each_port(dp, ds) {
+			struct net_device *br = dsa_port_bridge_dev_get(dp);
+
+			if (br && br_vlan_enabled(br)) {
+				change_vlan_filtering = false;
+				break;
+			}
+		}
+	}
+
+	if (!change_vlan_filtering)
+		return;
+
+	err = dsa_port_vlan_filtering(dp, vlan_filtering, &extack);
+	if (extack._msg) {
+		dev_err(ds->dev, "port %d: %s\n", dp->index,
+			extack._msg);
+	}
+	if (err && err != -EOPNOTSUPP) {
+		dev_err(ds->dev,
+			"port %d failed to reset VLAN filtering to %d: %pe\n",
+		       dp->index, vlan_filtering, ERR_PTR(err));
+	}
+}
+
 static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
@@ -313,7 +366,8 @@ static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
 	return 0;
 }
 
-static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
+static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp,
+					    struct dsa_bridge bridge)
 {
 	/* Configure the port for standalone mode (no address learning,
 	 * flood everything).
@@ -333,7 +387,7 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	 */
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING, true);
 
-	/* VLAN filtering is handled by dsa_switch_bridge_leave */
+	dsa_port_reset_vlan_filtering(dp, bridge);
 
 	/* Ageing time may be global to the switch chip, so don't change it
 	 * here because we have no good reason (or value) to change it to.
@@ -502,7 +556,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 			"port %d failed to notify DSA_NOTIFIER_BRIDGE_LEAVE: %pe\n",
 			dp->index, ERR_PTR(err));
 
-	dsa_port_switchdev_unsync_attrs(dp);
+	dsa_port_switchdev_unsync_attrs(dp, info.bridge);
 }
 
 int dsa_port_lag_change(struct dsa_port *dp,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index d25cd1da3eb3..d8a80cf9742c 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -115,62 +115,10 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	return 0;
 }
 
-static int dsa_switch_sync_vlan_filtering(struct dsa_switch *ds,
-					  struct dsa_notifier_bridge_info *info)
-{
-	struct netlink_ext_ack extack = {0};
-	bool change_vlan_filtering = false;
-	bool vlan_filtering;
-	struct dsa_port *dp;
-	int err;
-
-	if (ds->needs_standalone_vlan_filtering &&
-	    !br_vlan_enabled(info->bridge.dev)) {
-		change_vlan_filtering = true;
-		vlan_filtering = true;
-	} else if (!ds->needs_standalone_vlan_filtering &&
-		   br_vlan_enabled(info->bridge.dev)) {
-		change_vlan_filtering = true;
-		vlan_filtering = false;
-	}
-
-	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
-	 * event for changing vlan_filtering setting upon slave ports leaving
-	 * it. That is a good thing, because that lets us handle it and also
-	 * handle the case where the switch's vlan_filtering setting is global
-	 * (not per port). When that happens, the correct moment to trigger the
-	 * vlan_filtering callback is only when the last port leaves the last
-	 * VLAN-aware bridge.
-	 */
-	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
-		dsa_switch_for_each_port(dp, ds) {
-			struct net_device *br = dsa_port_bridge_dev_get(dp);
-
-			if (br && br_vlan_enabled(br)) {
-				change_vlan_filtering = false;
-				break;
-			}
-		}
-	}
-
-	if (change_vlan_filtering) {
-		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
-					      vlan_filtering, &extack);
-		if (extack._msg)
-			dev_err(ds->dev, "port %d: %s\n", info->port,
-				extack._msg);
-		if (err && err != -EOPNOTSUPP)
-			return err;
-	}
-
-	return 0;
-}
-
 static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 				   struct dsa_notifier_bridge_info *info)
 {
 	struct dsa_switch_tree *dst = ds->dst;
-	int err;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_leave)
@@ -182,12 +130,6 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 						info->sw_index, info->port,
 						info->bridge);
 
-	if (ds->dst->index == info->tree_index && ds->index == info->sw_index) {
-		err = dsa_switch_sync_vlan_filtering(ds, info);
-		if (err)
-			return err;
-	}
-
 	return 0;
 }
 
-- 
2.35.1



