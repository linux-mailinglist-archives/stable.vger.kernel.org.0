Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11FD966C980
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbjAPQuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbjAPQtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:49:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DFC2413A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:36:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3853261086
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF9BC433D2;
        Mon, 16 Jan 2023 16:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886984;
        bh=8d8K77kOe0ssH5V1VRtMbprS/PSfv+dkOe6JpvdWqF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsnGJHf5lDEReKtDQna5qU1KjHIEIINKGUtdnWKQpFECxDE9cSuHn/HiloSxjQZ9p
         GY64fvnOUnwkJQr758yIOBpoHckuVJsjIz5JEIkJvlMZFLeunqUrHeYarZNXJmbSIN
         D56mE7khNhK7Nm07JerJro2awbU7yO7wJ0y4kBXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jon Maloy <jmaloy@redhat.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 636/658] tipc: fix unexpected link reset due to discovery messages
Date:   Mon, 16 Jan 2023 16:52:04 +0100
Message-Id: <20230116154938.589315723@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 81fe8d051ba4..a6ac67c38770 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1035,8 +1035,9 @@ void tipc_node_check_dest(struct net *net, u32 addr,
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
@@ -1056,14 +1057,14 @@ void tipc_node_check_dest(struct net *net, u32 addr,
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
@@ -1088,6 +1089,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		 */
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	} else if (!sign_match && addr_match && link_up) {
 		/* Peer node rebooted. Two possibilities:
 		 *  - Delayed re-discovery; this link endpoint has already
@@ -1119,6 +1121,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		n->signature = signature;
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	}
 
 	if (!accept_addr)
@@ -1147,6 +1150,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		tipc_link_fsm_evt(l, LINK_RESET_EVT);
 		if (n->state == NODE_FAILINGOVER)
 			tipc_link_fsm_evt(l, LINK_FAILOVER_BEGIN_EVT);
+		link_is_reset = tipc_link_is_reset(l);
 		le->link = l;
 		n->link_cnt++;
 		tipc_node_calculate_timer(n, l);
@@ -1159,7 +1163,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
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



