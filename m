Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E351A64A004
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiLLNSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiLLNRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:17:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334DB30B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:17:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4CC96105A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6EEC433EF;
        Mon, 12 Dec 2022 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851056;
        bh=gZRIbtc+7rugh8bo35Se5xNBavKh/zjAi2GjYNQHYEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPCJJAXadGR/FdZL583thSsBgK5zVq3JO84ZMNVgxq7s5RntM6D0fVGI5A3M2+C1P
         /Td1HRaeRw9gSLeb4IsLu8D+NKk73ae14Z2BMWbtx8kQaAPx4xJGYl0FJWvqaxajc4
         Xd5QLmhAoXANEYuZt1nWZdnlASs2IFsL+gHcvgn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/106] tipc: call tipc_lxc_xmit without holding node_read_lock
Date:   Mon, 12 Dec 2022 14:10:42 +0100
Message-Id: <20221212130929.176091901@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 88956177db179e4eba7cd590971961857d1565b8 ]

When sending packets between nodes in netns, it calls tipc_lxc_xmit() for
peer node to receive the packets where tipc_sk_mcast_rcv()/tipc_sk_rcv()
might be called, and it's pretty much like in tipc_rcv().

Currently the local 'node rw lock' is held during calling tipc_lxc_xmit()
to protect the peer_net not being freed by another thread. However, when
receiving these packets, tipc_node_add_conn() might be called where the
peer 'node rw lock' is acquired. Then a dead lock warning is triggered by
lockdep detector, although it is not a real dead lock:

    WARNING: possible recursive locking detected
    --------------------------------------------
    conn_server/1086 is trying to acquire lock:
    ffff8880065cb020 (&n->lock#2){++--}-{2:2}, \
                     at: tipc_node_add_conn.cold.76+0xaa/0x211 [tipc]

    but task is already holding lock:
    ffff8880065cd020 (&n->lock#2){++--}-{2:2}, \
                     at: tipc_node_xmit+0x285/0xb30 [tipc]

    other info that might help us debug this:
     Possible unsafe locking scenario:

           CPU0
           ----
      lock(&n->lock#2);
      lock(&n->lock#2);

     *** DEADLOCK ***

     May be due to missing lock nesting notation

    4 locks held by conn_server/1086:
     #0: ffff8880036d1e40 (sk_lock-AF_TIPC){+.+.}-{0:0}, \
                          at: tipc_accept+0x9c0/0x10b0 [tipc]
     #1: ffff8880036d5f80 (sk_lock-AF_TIPC/1){+.+.}-{0:0}, \
                          at: tipc_accept+0x363/0x10b0 [tipc]
     #2: ffff8880065cd020 (&n->lock#2){++--}-{2:2}, \
                          at: tipc_node_xmit+0x285/0xb30 [tipc]
     #3: ffff888012e13370 (slock-AF_TIPC){+...}-{2:2}, \
                          at: tipc_sk_rcv+0x2da/0x1b40 [tipc]

    Call Trace:
     <TASK>
     dump_stack_lvl+0x44/0x5b
     __lock_acquire.cold.77+0x1f2/0x3d7
     lock_acquire+0x1d2/0x610
     _raw_write_lock_bh+0x38/0x80
     tipc_node_add_conn.cold.76+0xaa/0x211 [tipc]
     tipc_sk_finish_conn+0x21e/0x640 [tipc]
     tipc_sk_filter_rcv+0x147b/0x3030 [tipc]
     tipc_sk_rcv+0xbb4/0x1b40 [tipc]
     tipc_lxc_xmit+0x225/0x26b [tipc]
     tipc_node_xmit.cold.82+0x4a/0x102 [tipc]
     __tipc_sendstream+0x879/0xff0 [tipc]
     tipc_accept+0x966/0x10b0 [tipc]
     do_accept+0x37d/0x590

This patch avoids this warning by not holding the 'node rw lock' before
calling tipc_lxc_xmit(). As to protect the 'peer_net', rcu_read_lock()
should be enough, as in cleanup_net() when freeing the netns, it calls
synchronize_rcu() before the free is continued.

Also since tipc_lxc_xmit() is like the RX path in tipc_rcv(), it makes
sense to call it under rcu_read_lock(). Note that the right lock order
must be:

   rcu_read_lock();
   tipc_node_read_lock(n);
   tipc_node_read_unlock(n);
   tipc_lxc_xmit();
   rcu_read_unlock();

instead of:

   tipc_node_read_lock(n);
   rcu_read_lock();
   tipc_node_read_unlock(n);
   tipc_lxc_xmit();
   rcu_read_unlock();

and we have to call tipc_node_read_lock/unlock() twice in
tipc_node_xmit().

Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/5bdd1f8fee9db695cfff4528a48c9b9d0523fb00.1670110641.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/node.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 60059827563a..7589f2ac6fd0 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1660,6 +1660,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 	struct tipc_node *n;
 	struct sk_buff_head xmitq;
 	bool node_up = false;
+	struct net *peer_net;
 	int bearer_id;
 	int rc;
 
@@ -1676,18 +1677,23 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 		return -EHOSTUNREACH;
 	}
 
+	rcu_read_lock();
 	tipc_node_read_lock(n);
 	node_up = node_is_up(n);
-	if (node_up && n->peer_net && check_net(n->peer_net)) {
+	peer_net = n->peer_net;
+	tipc_node_read_unlock(n);
+	if (node_up && peer_net && check_net(peer_net)) {
 		/* xmit inner linux container */
-		tipc_lxc_xmit(n->peer_net, list);
+		tipc_lxc_xmit(peer_net, list);
 		if (likely(skb_queue_empty(list))) {
-			tipc_node_read_unlock(n);
+			rcu_read_unlock();
 			tipc_node_put(n);
 			return 0;
 		}
 	}
+	rcu_read_unlock();
 
+	tipc_node_read_lock(n);
 	bearer_id = n->active_links[selector & 1];
 	if (unlikely(bearer_id == INVALID_BEARER_ID)) {
 		tipc_node_read_unlock(n);
-- 
2.35.1



