Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9741412575
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353836AbhITSpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382850AbhITSmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AFFD61AF0;
        Mon, 20 Sep 2021 17:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159126;
        bh=G1E7ac7GdflTp/GdhZCOeFUB2YLp8l10fKzj1WtTc1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enFc+Fl2xL9y/6q1TxiCtJLfvLAvQh4qVADf756h+cTzLgVddwm3S6Uxlwnu1nh8f
         gq4ePgSSG0uo5i9r4J3vz2Y4W0n0FgKF3qcv8Lcjwun+UDIa7ibnVllqjI82OBPi1K
         Z/Ns6O0oTxRmhzDgW9CCU7hbjui+5vrIiS6SX7xY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 088/168] net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports
Date:   Mon, 20 Sep 2021 18:43:46 +0200
Message-Id: <20210920163924.527871711@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit a57d8c217aadac75530b8e7ffb3a3e1b7bfd0330 ]

Sometimes when unbinding the mv88e6xxx driver on Turris MOX, these error
messages appear:

mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete be:79:b4:9e:9e:96 vid 1 from fdb: -2
mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete be:79:b4:9e:9e:96 vid 0 from fdb: -2
mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 100 from fdb: -2
mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 1 from fdb: -2
mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 0 from fdb: -2

(and similarly for other ports)

What happens is that DSA has a policy "even if there are bugs, let's at
least not leak memory" and dsa_port_teardown() clears the dp->fdbs and
dp->mdbs lists, which are supposed to be empty.

But deleting that cleanup code, the warnings go away.

=> the FDB and MDB lists (used for refcounting on shared ports, aka CPU
and DSA ports) will eventually be empty, but are not empty by the time
we tear down those ports. Aka we are deleting them too soon.

The addresses that DSA complains about are host-trapped addresses: the
local addresses of the ports, and the MAC address of the bridge device.

The problem is that offloading those entries happens from a deferred
work item scheduled by the SWITCHDEV_FDB_DEL_TO_DEVICE handler, and this
races with the teardown of the CPU and DSA ports where the refcounting
is kept.

In fact, not only it races, but fundamentally speaking, if we iterate
through the port list linearly, we might end up tearing down the shared
ports even before we delete a DSA user port which has a bridge upper.

So as it turns out, we need to first tear down the user ports (and the
unused ones, for no better place of doing that), then the shared ports
(the CPU and DSA ports). In between, we need to ensure that all work
items scheduled by our switchdev handlers (which only run for user
ports, hence the reason why we tear them down first) have finished.

Fixes: 161ca59d39e9 ("net: dsa: reference count the MDB entries at the cross-chip notifier level")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210914134726.2305133-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dsa.h  |  5 +++++
 net/dsa/dsa.c      |  5 +++++
 net/dsa/dsa2.c     | 46 +++++++++++++++++++++++++++++++---------------
 net/dsa/dsa_priv.h |  1 +
 4 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 048d297623c9..d833f717e802 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -437,6 +437,11 @@ static inline bool dsa_port_is_user(struct dsa_port *dp)
 	return dp->type == DSA_PORT_TYPE_USER;
 }
 
+static inline bool dsa_port_is_unused(struct dsa_port *dp)
+{
+	return dp->type == DSA_PORT_TYPE_UNUSED;
+}
+
 static inline bool dsa_is_unused_port(struct dsa_switch *ds, int p)
 {
 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_UNUSED;
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 84cad1be9ce4..e058a2e320e3 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -345,6 +345,11 @@ bool dsa_schedule_work(struct work_struct *work)
 	return queue_work(dsa_owq, work);
 }
 
+void dsa_flush_workqueue(void)
+{
+	flush_workqueue(dsa_owq);
+}
+
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 185629f27f80..79267b00af68 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -809,6 +809,33 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	ds->setup = false;
 }
 
+/* First tear down the non-shared, then the shared ports. This ensures that
+ * all work items scheduled by our switchdev handlers for user ports have
+ * completed before we destroy the refcounting kept on the shared ports.
+ */
+static void dsa_tree_teardown_ports(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp))
+			dsa_port_teardown(dp);
+
+	dsa_flush_workqueue();
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
+			dsa_port_teardown(dp);
+}
+
+static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		dsa_switch_teardown(dp->ds);
+}
+
 static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
@@ -835,26 +862,13 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 	return 0;
 
 teardown:
-	list_for_each_entry(dp, &dst->ports, list)
-		dsa_port_teardown(dp);
+	dsa_tree_teardown_ports(dst);
 
-	list_for_each_entry(dp, &dst->ports, list)
-		dsa_switch_teardown(dp->ds);
+	dsa_tree_teardown_switches(dst);
 
 	return err;
 }
 
-static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
-{
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list)
-		dsa_port_teardown(dp);
-
-	list_for_each_entry(dp, &dst->ports, list)
-		dsa_switch_teardown(dp->ds);
-}
-
 static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
@@ -964,6 +978,8 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_master(dst);
 
+	dsa_tree_teardown_ports(dst);
+
 	dsa_tree_teardown_switches(dst);
 
 	dsa_tree_teardown_default_cpu(dst);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index cddf7cb0f398..6c00557ca9bf 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -158,6 +158,7 @@ void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
+void dsa_flush_workqueue(void);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
-- 
2.30.2



