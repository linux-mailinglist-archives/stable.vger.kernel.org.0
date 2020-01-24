Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98D3147E6C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388054AbgAXKI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733082AbgAXKI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:08:57 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26EB0214AF;
        Fri, 24 Jan 2020 10:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860537;
        bh=zI7qUngKh+tUhgdBh+cZES1MNpGRy0cIuLzw8UMt0H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4SDiojlPlf18CyWu8L94nvoRZbtndIuTK6ehcRfPg2TR+5HqHlSICNloIKSx5/Nn
         R7WgGnptTW/waVQwSff5hTEu6VhAh+ITn7K0FH8So7gzg+nP4VWtyOt5+2pd4709mn
         86w9SbgUiJV4tUm2p5nMYt7jWJsAisOOTXokSQPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jon.maloy@ericsson.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 009/639] tipc: update mons self addr when node addr generated
Date:   Fri, 24 Jan 2020 10:22:59 +0100
Message-Id: <20200124093048.234067973@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

commit 46cb01eeeb86fca6afe24dda1167b0cb95424e29 upstream.

In commit 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address
hash values"), the 32-bit node address only generated after one second
trial period expired. However the self's addr in struct tipc_monitor do
not update according to node address generated. This lead to it is
always zero as initial value. As result, sorting algorithm using this
value does not work as expected, neither neighbor monitoring framework.

In this commit, we add a fix to update self's addr when 32-bit node
address generated.

Fixes: 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address hash values")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/monitor.c |   15 +++++++++++++++
 net/tipc/monitor.h |    1 +
 net/tipc/net.c     |    2 ++
 3 files changed, 18 insertions(+)

--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -665,6 +665,21 @@ void tipc_mon_delete(struct net *net, in
 	kfree(mon);
 }
 
+void tipc_mon_reinit_self(struct net *net)
+{
+	struct tipc_monitor *mon;
+	int bearer_id;
+
+	for (bearer_id = 0; bearer_id < MAX_BEARERS; bearer_id++) {
+		mon = tipc_monitor(net, bearer_id);
+		if (!mon)
+			continue;
+		write_lock_bh(&mon->lock);
+		mon->self->addr = tipc_own_addr(net);
+		write_unlock_bh(&mon->lock);
+	}
+}
+
 int tipc_nl_monitor_set_threshold(struct net *net, u32 cluster_size)
 {
 	struct tipc_net *tn = tipc_net(net);
--- a/net/tipc/monitor.h
+++ b/net/tipc/monitor.h
@@ -77,6 +77,7 @@ int __tipc_nl_add_monitor(struct net *ne
 			  u32 bearer_id);
 int tipc_nl_add_monitor_peer(struct net *net, struct tipc_nl_msg *msg,
 			     u32 bearer_id, u32 *prev_node);
+void tipc_mon_reinit_self(struct net *net);
 
 extern const int tipc_max_domain_size;
 #endif
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -42,6 +42,7 @@
 #include "node.h"
 #include "bcast.h"
 #include "netlink.h"
+#include "monitor.h"
 
 /*
  * The TIPC locking policy is designed to ensure a very fine locking
@@ -136,6 +137,7 @@ static void tipc_net_finalize(struct net
 	tipc_set_node_addr(net, addr);
 	tipc_named_reinit(net);
 	tipc_sk_reinit(net);
+	tipc_mon_reinit_self(net);
 	tipc_nametbl_publish(net, TIPC_CFG_SRV, addr, addr,
 			     TIPC_CLUSTER_SCOPE, 0, addr);
 }


