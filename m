Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2423566C571
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbjAPQGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjAPQFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:05:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EAF274AD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DA6061049
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C67AC433D2;
        Mon, 16 Jan 2023 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885042;
        bh=wDgTdSDYDoEr4cSxVZpF4BI8puZycLQrplwYdLz8DeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTD0fbyyIanNDE0RMoSDITXtYe63NKVY9g0gq0XMnHC0llpiF+VX0fDIH16iCLSzk
         cGisng5YkYYT4u8PSr8I/V0spOIDF59CydsfA4zB2CW8v69HfwakXMqqs2SUnsKUHt
         7O5Fhryryh1V3H2Rq3TXPEdNAUrwX3GXEH230wg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jon Maloy <jmaloy@redhat.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 52/86] tipc: fix unexpected link reset due to discovery messages
Date:   Mon, 16 Jan 2023 16:51:26 +0100
Message-Id: <20230116154749.224093584@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

[ Upstream commit c244c092f1ed2acfb5af3d3da81e22367d3dd733 ]

This unexpected behavior is observed:

node 1                    | node 2
------                    | ------
link is established       | link is established
reboot                    | link is reset
up                        | send discovery message
receive discovery message |
link is established       | link is established
send discovery message    |
                          | receive discovery message
                          | link is reset (unexpected)
                          | send reset message
link is reset             |

It is due to delayed re-discovery as described in function
tipc_node_check_dest(): "this link endpoint has already reset
and re-established contact with the peer, before receiving a
discovery message from that node."

However, commit 598411d70f85 has changed the condition for calling
tipc_node_link_down() which was the acceptance of new media address.

This commit fixes this by restoring the old and correct behavior.

Fixes: 598411d70f85 ("tipc: make resetting of links non-atomic")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/node.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 49ddc484c4fe..5e000fde8067 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1179,8 +1179,9 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	bool addr_match = false;
 	bool sign_match = false;
 	bool link_up = false;
+	bool link_is_reset = false;
 	bool accept_addr = false;
-	bool reset = true;
+	bool reset = false;
 	char *if_name;
 	unsigned long intv;
 	u16 session;
@@ -1200,14 +1201,14 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	/* Prepare to validate requesting node's signature and media address */
 	l = le->link;
 	link_up = l && tipc_link_is_up(l);
+	link_is_reset = l && tipc_link_is_reset(l);
 	addr_match = l && !memcmp(&le->maddr, maddr, sizeof(*maddr));
 	sign_match = (signature == n->signature);
 
 	/* These three flags give us eight permutations: */
 
 	if (sign_match && addr_match && link_up) {
-		/* All is fine. Do nothing. */
-		reset = false;
+		/* All is fine. Ignore requests. */
 		/* Peer node is not a container/local namespace */
 		if (!n->peer_hash_mix)
 			n->peer_hash_mix = hash_mixes;
@@ -1232,6 +1233,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		 */
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	} else if (!sign_match && addr_match && link_up) {
 		/* Peer node rebooted. Two possibilities:
 		 *  - Delayed re-discovery; this link endpoint has already
@@ -1263,6 +1265,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		n->signature = signature;
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	}
 
 	if (!accept_addr)
@@ -1291,6 +1294,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		tipc_link_fsm_evt(l, LINK_RESET_EVT);
 		if (n->state == NODE_FAILINGOVER)
 			tipc_link_fsm_evt(l, LINK_FAILOVER_BEGIN_EVT);
+		link_is_reset = tipc_link_is_reset(l);
 		le->link = l;
 		n->link_cnt++;
 		tipc_node_calculate_timer(n, l);
@@ -1303,7 +1307,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	memcpy(&le->maddr, maddr, sizeof(*maddr));
 exit:
 	tipc_node_write_unlock(n);
-	if (reset && l && !tipc_link_is_reset(l))
+	if (reset && !link_is_reset)
 		tipc_node_link_down(n, b->identity, false);
 	tipc_node_put(n);
 }
-- 
2.35.1



