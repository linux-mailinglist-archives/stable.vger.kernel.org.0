Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263D31C152C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731724AbgEANqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbgEANoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:44:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C9E205C9;
        Fri,  1 May 2020 13:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340693;
        bh=Xj0OB1AH/mPjPpR15hCJJfIMtthHJTuauzSbltQTh7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNyiFzF56Gwi9UafLj5OFazcuBpB78AY8FzM2ACzNjdwX0gti2797qrpOLViNXOzq
         cIrckMZ0hENDkCOQ+mvlRj6mWST9NfZ/rnCyiRaX+YQv25BwNUwS3QQLky3dBBsXh+
         z9Ne1et41EDwZWJVXU/WIL1h6ZD8eB2VJFZ8OcSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tuong Lien <tuong.t.lien@dektech.com.au>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 098/106] tipc: Add a missing case of TIPC_DIRECT_MSG type
Date:   Fri,  1 May 2020 15:24:11 +0200
Message-Id: <20200501131555.045930082@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
@@ -394,6 +394,11 @@ static inline u32 msg_connected(struct t
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
@@ -1586,7 +1586,8 @@ static void tipc_lxc_xmit(struct net *pe
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
@@ -1461,7 +1461,7 @@ static int __tipc_sendmsg(struct socket
 	}
 
 	__skb_queue_head_init(&pkts);
-	mtu = tipc_node_get_mtu(net, dnode, tsk->portid, false);
+	mtu = tipc_node_get_mtu(net, dnode, tsk->portid, true);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;


