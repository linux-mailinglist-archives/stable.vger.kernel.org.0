Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760A666C99A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbjAPQwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjAPQvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:51:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B26A4C0DB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:37:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59816B81092
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB3AC433F2;
        Mon, 16 Jan 2023 16:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887032;
        bh=3hgBKHOHGO/SddED0eXVkvDcKqLRV2TmTT7N34rbzG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7/iEnsuHkRFnqJ9V3kWLAZS2T8z7lv3IgtmqJPVAjjfuiFeRHKJOrfAkFaPWWFvs
         7hS+W7BYovSb54hPIPh0rjeJYXi9BzjhjR14YtAwVqZwDhIyMHhfSdSaRvnlI7uxce
         wm8d98gccS1ir74Gtpab62TCeEIq8roT2RT+Ib20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tuong Lien <tuong.t.lien@dektech.com.au>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 655/658] tipc: Add a missing case of TIPC_DIRECT_MSG type
Date:   Mon, 16 Jan 2023 16:52:23 +0100
Message-Id: <20230116154939.416588790@linuxfoundation.org>
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

From: Hoang Le <hoang.h.le@dektech.com.au>

commit 8b1e5b0a99f04bda2d6c85ecfe5e68a356c10914 upstream.

In the commit f73b12812a3d
("tipc: improve throughput between nodes in netns"), we're missing a check
to handle TIPC_DIRECT_MSG type, it's still using old sending mechanism for
this message type. So, throughput improvement is not significant as
expected.

Besides that, when sending a large message with that type, we're also
handle wrong receiving queue, it should be enqueued in socket receiving
instead of multicast messages.

Fix this by adding the missing case for TIPC_DIRECT_MSG.

Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
Reported-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/msg.h    |    5 +++++
 net/tipc/node.c   |    3 ++-
 net/tipc/socket.c |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -358,6 +358,11 @@ static inline u32 msg_connected(struct t
 	return msg_type(m) == TIPC_CONN_MSG;
 }
 
+static inline u32 msg_direct(struct tipc_msg *m)
+{
+	return msg_type(m) == TIPC_DIRECT_MSG;
+}
+
 static inline u32 msg_errcode(struct tipc_msg *m)
 {
 	return msg_bits(m, 1, 25, 0xf);
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1489,7 +1489,8 @@ static void tipc_lxc_xmit(struct net *pe
 	case TIPC_MEDIUM_IMPORTANCE:
 	case TIPC_HIGH_IMPORTANCE:
 	case TIPC_CRITICAL_IMPORTANCE:
-		if (msg_connected(hdr) || msg_named(hdr)) {
+		if (msg_connected(hdr) || msg_named(hdr) ||
+		    msg_direct(hdr)) {
 			tipc_loopback_trace(peer_net, list);
 			spin_lock_init(&list->lock);
 			tipc_sk_rcv(peer_net, list);
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1407,7 +1407,7 @@ static int __tipc_sendmsg(struct socket
 	}
 
 	__skb_queue_head_init(&pkts);
-	mtu = tipc_node_get_mtu(net, dnode, tsk->portid, false);
+	mtu = tipc_node_get_mtu(net, dnode, tsk->portid, true);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;


