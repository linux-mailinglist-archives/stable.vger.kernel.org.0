Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F62B353CCC
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhDEI4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232513AbhDEI4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:56:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42BA4613A0;
        Mon,  5 Apr 2021 08:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613003;
        bh=/P+Vo1W0T6FOcxZ+Dr2e4zbpyOCW0AsFJRXvfd/YCww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIP+QD+UCk4B7useZNnBDvSal7qViPKNMOYcckfPFKfROoImYZOAE3PgbLVQN9dm/
         4SdHYFX6RvS1IAqEyIvvhVSkMnDbew6mKjbNGCrS5rocG+0XW/L5A76e7/WmAplphx
         +IR6ohD6/uSMvZj4EpMqP42MpTbFzAKUp9IhP/tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Brown <doug@schmorgal.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 16/35] appletalk: Fix skb allocation size in loopback case
Date:   Mon,  5 Apr 2021 10:53:51 +0200
Message-Id: <20210405085019.390095420@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Brown <doug@schmorgal.com>

[ Upstream commit 39935dccb21c60f9bbf1bb72d22ab6fd14ae7705 ]

If a DDP broadcast packet is sent out to a non-gateway target, it is
also looped back. There is a potential for the loopback device to have a
longer hardware header length than the original target route's device,
which can result in the skb not being created with enough room for the
loopback device's hardware header. This patch fixes the issue by
determining that a loopback will be necessary prior to allocating the
skb, and if so, ensuring the skb has enough room.

This was discovered while testing a new driver that creates a LocalTalk
network interface (LTALK_HLEN = 1). It caused an skb_under_panic.

Signed-off-by: Doug Brown <doug@schmorgal.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/appletalk/ddp.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 93209c009df5..a66de21671ac 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1575,8 +1575,8 @@ static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct ddpehdr *ddp;
-	int size;
-	struct atalk_route *rt;
+	int size, hard_header_len;
+	struct atalk_route *rt, *rt_lo = NULL;
 	int err;
 
 	if (flags & ~(MSG_DONTWAIT|MSG_CMSG_COMPAT))
@@ -1639,7 +1639,22 @@ static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	SOCK_DEBUG(sk, "SK %p: Size needed %d, device %s\n",
 			sk, size, dev->name);
 
-	size += dev->hard_header_len;
+	hard_header_len = dev->hard_header_len;
+	/* Leave room for loopback hardware header if necessary */
+	if (usat->sat_addr.s_node == ATADDR_BCAST &&
+	    (dev->flags & IFF_LOOPBACK || !(rt->flags & RTF_GATEWAY))) {
+		struct atalk_addr at_lo;
+
+		at_lo.s_node = 0;
+		at_lo.s_net  = 0;
+
+		rt_lo = atrtr_find(&at_lo);
+
+		if (rt_lo && rt_lo->dev->hard_header_len > hard_header_len)
+			hard_header_len = rt_lo->dev->hard_header_len;
+	}
+
+	size += hard_header_len;
 	release_sock(sk);
 	skb = sock_alloc_send_skb(sk, size, (flags & MSG_DONTWAIT), &err);
 	lock_sock(sk);
@@ -1647,7 +1662,7 @@ static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out;
 
 	skb_reserve(skb, ddp_dl->header_length);
-	skb_reserve(skb, dev->hard_header_len);
+	skb_reserve(skb, hard_header_len);
 	skb->dev = dev;
 
 	SOCK_DEBUG(sk, "SK %p: Begin build.\n", sk);
@@ -1698,18 +1713,12 @@ static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		/* loop back */
 		skb_orphan(skb);
 		if (ddp->deh_dnode == ATADDR_BCAST) {
-			struct atalk_addr at_lo;
-
-			at_lo.s_node = 0;
-			at_lo.s_net  = 0;
-
-			rt = atrtr_find(&at_lo);
-			if (!rt) {
+			if (!rt_lo) {
 				kfree_skb(skb);
 				err = -ENETUNREACH;
 				goto out;
 			}
-			dev = rt->dev;
+			dev = rt_lo->dev;
 			skb->dev = dev;
 		}
 		ddp_dl->request(ddp_dl, skb, dev->dev_addr);
-- 
2.30.1



