Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84094566D00
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiGEMUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiGEMRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0AC1C125;
        Tue,  5 Jul 2022 05:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91973B8170A;
        Tue,  5 Jul 2022 12:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09705C341CF;
        Tue,  5 Jul 2022 12:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023133;
        bh=qtR+L+imlhsuaNM4K5Mt9oLNyF1AorjqhC75DA53sHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riHuFNSf89/OOL5h9zvL789nfQc5NFYbEOqWDWGZyX5UXUUdN1mKJDL9zRdYyGMMr
         5lP48hyWTy4CnIckGL2sTweQnw1rs2XuPoKYrt93eQ8pfaHCAMgEzD8VXSWT3+P+HM
         DkNj+cX0xkGaeUoW4WTnHbEUAZ77FcHR4bLlCGgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 50/98] tipc: move bc link creation back to tipc_node_create
Date:   Tue,  5 Jul 2022 13:58:08 +0200
Message-Id: <20220705115619.005195067@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit cb8092d70a6f5f01ec1490fce4d35efed3ed996c upstream.

Shuang Li reported a NULL pointer dereference crash:

  [] BUG: kernel NULL pointer dereference, address: 0000000000000068
  [] RIP: 0010:tipc_link_is_up+0x5/0x10 [tipc]
  [] Call Trace:
  []  <IRQ>
  []  tipc_bcast_rcv+0xa2/0x190 [tipc]
  []  tipc_node_bc_rcv+0x8b/0x200 [tipc]
  []  tipc_rcv+0x3af/0x5b0 [tipc]
  []  tipc_udp_recv+0xc7/0x1e0 [tipc]

It was caused by the 'l' passed into tipc_bcast_rcv() is NULL. When it
creates a node in tipc_node_check_dest(), after inserting the new node
into hashtable in tipc_node_create(), it creates the bc link. However,
there is a gap between this insert and bc link creation, a bc packet
may come in and get the node from the hashtable then try to dereference
its bc link, which is NULL.

This patch is to fix it by moving the bc link creation before inserting
into the hashtable.

Note that for a preliminary node becoming "real", the bc link creation
should also be called before it's rehashed, as we don't create it for
preliminary nodes.

Fixes: 4cbf8ac2fe5a ("tipc: enable creating a "preliminary" node")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |   41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -472,8 +472,8 @@ struct tipc_node *tipc_node_create(struc
 				   bool preliminary)
 {
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
+	struct tipc_link *l, *snd_l = tipc_bc_sndlink(net);
 	struct tipc_node *n, *temp_node;
-	struct tipc_link *l;
 	unsigned long intv;
 	int bearer_id;
 	int i;
@@ -488,6 +488,16 @@ struct tipc_node *tipc_node_create(struc
 			goto exit;
 		/* A preliminary node becomes "real" now, refresh its data */
 		tipc_node_write_lock(n);
+		if (!tipc_link_bc_create(net, tipc_own_addr(net), addr, peer_id, U16_MAX,
+					 tipc_link_min_win(snd_l), tipc_link_max_win(snd_l),
+					 n->capabilities, &n->bc_entry.inputq1,
+					 &n->bc_entry.namedq, snd_l, &n->bc_entry.link)) {
+			pr_warn("Broadcast rcv link refresh failed, no memory\n");
+			tipc_node_write_unlock_fast(n);
+			tipc_node_put(n);
+			n = NULL;
+			goto exit;
+		}
 		n->preliminary = false;
 		n->addr = addr;
 		hlist_del_rcu(&n->hash);
@@ -567,7 +577,16 @@ update:
 	n->signature = INVALID_NODE_SIG;
 	n->active_links[0] = INVALID_BEARER_ID;
 	n->active_links[1] = INVALID_BEARER_ID;
-	n->bc_entry.link = NULL;
+	if (!preliminary &&
+	    !tipc_link_bc_create(net, tipc_own_addr(net), addr, peer_id, U16_MAX,
+				 tipc_link_min_win(snd_l), tipc_link_max_win(snd_l),
+				 n->capabilities, &n->bc_entry.inputq1,
+				 &n->bc_entry.namedq, snd_l, &n->bc_entry.link)) {
+		pr_warn("Broadcast rcv link creation failed, no memory\n");
+		kfree(n);
+		n = NULL;
+		goto exit;
+	}
 	tipc_node_get(n);
 	timer_setup(&n->timer, tipc_node_timeout, 0);
 	/* Start a slow timer anyway, crypto needs it */
@@ -1155,7 +1174,7 @@ void tipc_node_check_dest(struct net *ne
 			  bool *respond, bool *dupl_addr)
 {
 	struct tipc_node *n;
-	struct tipc_link *l, *snd_l;
+	struct tipc_link *l;
 	struct tipc_link_entry *le;
 	bool addr_match = false;
 	bool sign_match = false;
@@ -1175,22 +1194,6 @@ void tipc_node_check_dest(struct net *ne
 		return;
 
 	tipc_node_write_lock(n);
-	if (unlikely(!n->bc_entry.link)) {
-		snd_l = tipc_bc_sndlink(net);
-		if (!tipc_link_bc_create(net, tipc_own_addr(net),
-					 addr, peer_id, U16_MAX,
-					 tipc_link_min_win(snd_l),
-					 tipc_link_max_win(snd_l),
-					 n->capabilities,
-					 &n->bc_entry.inputq1,
-					 &n->bc_entry.namedq, snd_l,
-					 &n->bc_entry.link)) {
-			pr_warn("Broadcast rcv link creation failed, no mem\n");
-			tipc_node_write_unlock_fast(n);
-			tipc_node_put(n);
-			return;
-		}
-	}
 
 	le = &n->links[b->identity];
 


