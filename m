Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C188155D059
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiF0LYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbiF0LYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:24:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F40A6578;
        Mon, 27 Jun 2022 04:24:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 063A061454;
        Mon, 27 Jun 2022 11:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03812C3411D;
        Mon, 27 Jun 2022 11:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329046;
        bh=TJxd5l/FQ144uRvUJQpPK3pSbYgbwSLYcxsPK3FiQnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUuk/NxHBZoLDwrooiviE6qrHs0JIsYsdoMv+ao0mLo+iUc9x8VKuFZrV2HplJ5Fx
         mePWrdo4EyJFac4WtxlsoH8Rn4OPxPOq8UTG+Q6S60UXadOY50deaIOdiE8WUWKsp9
         nkdmTbZNo+YwGlRUpOATG6D56fkrDkpyujGhhi9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/102] tipc: simplify the finalize work queue
Date:   Mon, 27 Jun 2022 13:20:42 +0200
Message-Id: <20220627111934.389114522@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit be07f056396d6bb40963c45a02951c566ddeef8e ]

This patch is to use "struct work_struct" for the finalize work queue
instead of "struct tipc_net_work", as it can get the "net" and "addr"
from tipc_net's other members and there is no need to add extra net
and addr in tipc_net by defining "struct tipc_net_work".

Note that it's safe to get net from tn->bcl as bcl is always released
after the finalize work queue is done.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/core.c     |  4 ++--
 net/tipc/core.h     |  8 +-------
 net/tipc/discover.c |  4 ++--
 net/tipc/link.c     |  5 +++++
 net/tipc/link.h     |  1 +
 net/tipc/net.c      | 15 +++------------
 6 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 40c03085c0ea..96bfcb2986f5 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -60,7 +60,7 @@ static int __net_init tipc_init_net(struct net *net)
 	tn->trial_addr = 0;
 	tn->addr_trial_end = 0;
 	tn->capabilities = TIPC_NODE_CAPABILITIES;
-	INIT_WORK(&tn->final_work.work, tipc_net_finalize_work);
+	INIT_WORK(&tn->work, tipc_net_finalize_work);
 	memset(tn->node_id, 0, sizeof(tn->node_id));
 	memset(tn->node_id_string, 0, sizeof(tn->node_id_string));
 	tn->mon_threshold = TIPC_DEF_MON_THRESHOLD;
@@ -112,7 +112,7 @@ static void __net_exit tipc_exit_net(struct net *net)
 
 	tipc_detach_loopback(net);
 	/* Make sure the tipc_net_finalize_work() finished */
-	cancel_work_sync(&tn->final_work.work);
+	cancel_work_sync(&tn->work);
 	tipc_net_stop(net);
 
 	tipc_bcast_stop(net);
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 992924a849be..73a26b0b9ca1 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -90,12 +90,6 @@ extern unsigned int tipc_net_id __read_mostly;
 extern int sysctl_tipc_rmem[3] __read_mostly;
 extern int sysctl_tipc_named_timeout __read_mostly;
 
-struct tipc_net_work {
-	struct work_struct work;
-	struct net *net;
-	u32 addr;
-};
-
 struct tipc_net {
 	u8  node_id[NODE_ID_LEN];
 	u32 node_addr;
@@ -150,7 +144,7 @@ struct tipc_net {
 	struct tipc_crypto *crypto_tx;
 #endif
 	/* Work item for net finalize */
-	struct tipc_net_work final_work;
+	struct work_struct work;
 	/* The numbers of work queues in schedule */
 	atomic_t wq_count;
 };
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index d4ecacddb40c..14bc20604051 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -167,7 +167,7 @@ static bool tipc_disc_addr_trial_msg(struct tipc_discoverer *d,
 
 	/* Apply trial address if we just left trial period */
 	if (!trial && !self) {
-		tipc_sched_net_finalize(net, tn->trial_addr);
+		schedule_work(&tn->work);
 		msg_set_prevnode(buf_msg(d->skb), tn->trial_addr);
 		msg_set_type(buf_msg(d->skb), DSC_REQ_MSG);
 	}
@@ -307,7 +307,7 @@ static void tipc_disc_timeout(struct timer_list *t)
 	if (!time_before(jiffies, tn->addr_trial_end) && !tipc_own_addr(net)) {
 		mod_timer(&d->timer, jiffies + TIPC_DISC_INIT);
 		spin_unlock_bh(&d->lock);
-		tipc_sched_net_finalize(net, tn->trial_addr);
+		schedule_work(&tn->work);
 		return;
 	}
 
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 7a353ff62844..064fdb8e50e1 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -344,6 +344,11 @@ char tipc_link_plane(struct tipc_link *l)
 	return l->net_plane;
 }
 
+struct net *tipc_link_net(struct tipc_link *l)
+{
+	return l->net;
+}
+
 void tipc_link_update_caps(struct tipc_link *l, u16 capabilities)
 {
 	l->peer_caps = capabilities;
diff --git a/net/tipc/link.h b/net/tipc/link.h
index fc07232c9a12..a16f401fdabd 100644
--- a/net/tipc/link.h
+++ b/net/tipc/link.h
@@ -156,4 +156,5 @@ int tipc_link_bc_sync_rcv(struct tipc_link *l,   struct tipc_msg *hdr,
 int tipc_link_bc_nack_rcv(struct tipc_link *l, struct sk_buff *skb,
 			  struct sk_buff_head *xmitq);
 bool tipc_link_too_silent(struct tipc_link *l);
+struct net *tipc_link_net(struct tipc_link *l);
 #endif
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 0bb2323201da..671cb4f9d563 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -41,6 +41,7 @@
 #include "socket.h"
 #include "node.h"
 #include "bcast.h"
+#include "link.h"
 #include "netlink.h"
 #include "monitor.h"
 
@@ -138,19 +139,9 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 
 void tipc_net_finalize_work(struct work_struct *work)
 {
-	struct tipc_net_work *fwork;
+	struct tipc_net *tn = container_of(work, struct tipc_net, work);
 
-	fwork = container_of(work, struct tipc_net_work, work);
-	tipc_net_finalize(fwork->net, fwork->addr);
-}
-
-void tipc_sched_net_finalize(struct net *net, u32 addr)
-{
-	struct tipc_net *tn = tipc_net(net);
-
-	tn->final_work.net = net;
-	tn->final_work.addr = addr;
-	schedule_work(&tn->final_work.work);
+	tipc_net_finalize(tipc_link_net(tn->bcl), tn->trial_addr);
 }
 
 void tipc_net_stop(struct net *net)
-- 
2.35.1



