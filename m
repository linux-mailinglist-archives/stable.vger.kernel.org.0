Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BA231BD43
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhBOPnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231315AbhBOPiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5194464EF9;
        Mon, 15 Feb 2021 15:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403283;
        bh=ckmmS+ZBAbk7p3iE3rlNHhDdSswh4hh+y6vPWUB7zS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjTHYLc7enms9Pp036UrriRNwWSMWwn12aQfbNzM8WmxGIdSQLauoru26if7/DCxw
         TwRB5gp2xR5AXsj/NVJ5NAlFvIKiSld2LV7qvpLoU7WtMWscnDNK7dYlut0x7xT7AK
         HL80Su0pwoWkMe29Nh+EWJq+4DuEKBvS8JCmbqac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 097/104] bridge: mrp: Fix the usage of br_mrp_port_switchdev_set_state
Date:   Mon, 15 Feb 2021 16:27:50 +0100
Message-Id: <20210215152722.596833486@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

commit b2bdba1cbc84cadb14393d0101a5bfd38d342e0a upstream.

The function br_mrp_port_switchdev_set_state was called both with MRP
port state and STP port state, which is an issue because they don't
match exactly.

Therefore, update the function to be used only with STP port state and
use the id SWITCHDEV_ATTR_ID_PORT_STP_STATE.

The choice of using STP over MRP is that the drivers already implement
SWITCHDEV_ATTR_ID_PORT_STP_STATE and already in SW we update the port
STP state.

Fixes: 9a9f26e8f7ea30 ("bridge: mrp: Connect MRP API with the switchdev API")
Fixes: fadd409136f0f2 ("bridge: switchdev: mrp: Implement MRP API for switchdev")
Fixes: 2f1a11ae11d222 ("bridge: mrp: Add MRP interface.")
Reported-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_mrp.c           |    9 ++++++---
 net/bridge/br_mrp_switchdev.c |    7 +++----
 net/bridge/br_private_mrp.h   |    3 +--
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -544,19 +544,22 @@ int br_mrp_del(struct net_bridge *br, st
 int br_mrp_set_port_state(struct net_bridge_port *p,
 			  enum br_mrp_port_state_type state)
 {
+	u32 port_state;
+
 	if (!p || !(p->flags & BR_MRP_AWARE))
 		return -EINVAL;
 
 	spin_lock_bh(&p->br->lock);
 
 	if (state == BR_MRP_PORT_STATE_FORWARDING)
-		p->state = BR_STATE_FORWARDING;
+		port_state = BR_STATE_FORWARDING;
 	else
-		p->state = BR_STATE_BLOCKING;
+		port_state = BR_STATE_BLOCKING;
 
+	p->state = port_state;
 	spin_unlock_bh(&p->br->lock);
 
-	br_mrp_port_switchdev_set_state(p, state);
+	br_mrp_port_switchdev_set_state(p, port_state);
 
 	return 0;
 }
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -169,13 +169,12 @@ int br_mrp_switchdev_send_in_test(struct
 	return err;
 }
 
-int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
-				    enum br_mrp_port_state_type state)
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p, u32 state)
 {
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
-		.id = SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
-		.u.mrp_port_state = state,
+		.id = SWITCHDEV_ATTR_ID_PORT_STP_STATE,
+		.u.stp_state = state,
 	};
 	int err;
 
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -72,8 +72,7 @@ int br_mrp_switchdev_set_ring_state(stru
 int br_mrp_switchdev_send_ring_test(struct net_bridge *br, struct br_mrp *mrp,
 				    u32 interval, u8 max_miss, u32 period,
 				    bool monitor);
-int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
-				    enum br_mrp_port_state_type state);
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p, u32 state);
 int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 				   enum br_mrp_port_role_type role);
 int br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,


