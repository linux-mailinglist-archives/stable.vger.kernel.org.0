Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E18D1E2E0A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391506AbgEZTFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391504AbgEZTF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4262A208A7;
        Tue, 26 May 2020 19:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519928;
        bh=zL1ncFwqIrkyxwUfDGOmJpigKvrIf1byzCxY4Qi79oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlCrTlPP2F+cgpfEsHf75sRRccO36H5uYu8R4ZCgFogmJ7PvCrryf9tdw7fwPiweB
         TgKlppTaR95HhFfgTf3B0CvzjXnP4BCoGeQIIuOfVyiFHgj4tYrxoxKZQiefxgjapH
         kxad7qqVPUttyj2OLBUBG9jp7xOrxSPKUtq5fahE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/81] thunderbolt: Drop duplicated get_switch_at_route()
Date:   Tue, 26 May 2020 20:53:30 +0200
Message-Id: <20200526183933.179031466@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8f965efd215a09c20b0b5e5bb4e20009a954472e ]

tb_switch_find_by_route() does the same already so use it instead and
remove duplicated get_switch_at_route().

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/icm.c    | 12 ++++++++----
 drivers/thunderbolt/switch.c | 18 ------------------
 drivers/thunderbolt/tb.c     |  9 ++++++---
 drivers/thunderbolt/tb.h     |  1 -
 4 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index 8490a1b6b615..2b83d8b02f81 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -801,9 +801,11 @@ icm_fr_xdomain_connected(struct tb *tb, const struct icm_pkg_header *hdr)
 	 * connected another host to the same port, remove the switch
 	 * first.
 	 */
-	sw = get_switch_at_route(tb->root_switch, route);
-	if (sw)
+	sw = tb_switch_find_by_route(tb, route);
+	if (sw) {
 		remove_switch(sw);
+		tb_switch_put(sw);
+	}
 
 	sw = tb_switch_find_by_link_depth(tb, link, depth);
 	if (!sw) {
@@ -1146,9 +1148,11 @@ icm_tr_xdomain_connected(struct tb *tb, const struct icm_pkg_header *hdr)
 	 * connected another host to the same port, remove the switch
 	 * first.
 	 */
-	sw = get_switch_at_route(tb->root_switch, route);
-	if (sw)
+	sw = tb_switch_find_by_route(tb, route);
+	if (sw) {
 		remove_switch(sw);
+		tb_switch_put(sw);
+	}
 
 	sw = tb_switch_find_by_route(tb, get_parent_route(route));
 	if (!sw) {
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 42d90ceec279..010a50ac4881 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -664,24 +664,6 @@ int tb_switch_reset(struct tb *tb, u64 route)
 	return res.err;
 }
 
-struct tb_switch *get_switch_at_route(struct tb_switch *sw, u64 route)
-{
-	u8 next_port = route; /*
-			       * Routes use a stride of 8 bits,
-			       * eventhough a port index has 6 bits at most.
-			       * */
-	if (route == 0)
-		return sw;
-	if (next_port > sw->config.max_port_number)
-		return NULL;
-	if (tb_is_upstream_port(&sw->ports[next_port]))
-		return NULL;
-	if (!sw->ports[next_port].remote)
-		return NULL;
-	return get_switch_at_route(sw->ports[next_port].remote->sw,
-				   route >> TB_ROUTE_SHIFT);
-}
-
 /**
  * tb_plug_events_active() - enable/disable plug events on a switch
  *
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 1424581fd9af..146f261bf2c3 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -258,7 +258,7 @@ static void tb_handle_hotplug(struct work_struct *work)
 	if (!tcm->hotplug_active)
 		goto out; /* during init, suspend or shutdown */
 
-	sw = get_switch_at_route(tb->root_switch, ev->route);
+	sw = tb_switch_find_by_route(tb, ev->route);
 	if (!sw) {
 		tb_warn(tb,
 			"hotplug event from non existent switch %llx:%x (unplug: %d)\n",
@@ -269,14 +269,14 @@ static void tb_handle_hotplug(struct work_struct *work)
 		tb_warn(tb,
 			"hotplug event from non existent port %llx:%x (unplug: %d)\n",
 			ev->route, ev->port, ev->unplug);
-		goto out;
+		goto put_sw;
 	}
 	port = &sw->ports[ev->port];
 	if (tb_is_upstream_port(port)) {
 		tb_warn(tb,
 			"hotplug event for upstream port %llx:%x (unplug: %d)\n",
 			ev->route, ev->port, ev->unplug);
-		goto out;
+		goto put_sw;
 	}
 	if (ev->unplug) {
 		if (port->remote) {
@@ -306,6 +306,9 @@ static void tb_handle_hotplug(struct work_struct *work)
 			tb_activate_pcie_devices(tb);
 		}
 	}
+
+put_sw:
+	tb_switch_put(sw);
 out:
 	mutex_unlock(&tb->lock);
 	kfree(ev);
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 7a0ee9836a8a..d927cf7b14d2 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -397,7 +397,6 @@ void tb_switch_suspend(struct tb_switch *sw);
 int tb_switch_resume(struct tb_switch *sw);
 int tb_switch_reset(struct tb *tb, u64 route);
 void tb_sw_set_unplugged(struct tb_switch *sw);
-struct tb_switch *get_switch_at_route(struct tb_switch *sw, u64 route);
 struct tb_switch *tb_switch_find_by_link_depth(struct tb *tb, u8 link,
 					       u8 depth);
 struct tb_switch *tb_switch_find_by_uuid(struct tb *tb, const uuid_t *uuid);
-- 
2.25.1



