Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED664FD75B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353134AbiDLIAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357712AbiDLHkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CE4387AA;
        Tue, 12 Apr 2022 00:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2815B81B4F;
        Tue, 12 Apr 2022 07:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FFFC385A5;
        Tue, 12 Apr 2022 07:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747805;
        bh=b6+Qsoq0oHDFLGd4vDHTBx5eQpFygbzQY1mLHRzieZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LonVzBb2Qyfq314csBFHoUpxWxEqq0fjPYardfsLF5KKnU63Yq71X4IpHMNGgqcwO
         RtxIZYMsukJniMii/Wpr7LoMBJ6GEQj4rqdvZTUy3NdktkZRiNhjWnV+DdxPeqbVEF
         wFDz/FR/93dGpFkS0tVhr3dhUl7pz5AXlPOEOcSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rinaldi <mjrinal@g.clemson.edu>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 212/343] mctp: Use output netdev to allocate skb headroom
Date:   Tue, 12 Apr 2022 08:30:30 +0200
Message-Id: <20220412062957.465760024@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 4a9dda1c1da65beee994f0977a56a9a21c5db2a7 ]

Previously the skb was allocated with headroom MCTP_HEADER_MAXLEN,
but that isn't sufficient if we are using devs that are not MCTP
specific.

This also adds a check that the smctp_halen provided to sendmsg for
extended addressing is the correct size for the netdev.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Reported-by: Matthew Rinaldi <mjrinal@g.clemson.edu>
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mctp.h |  2 --
 net/mctp/af_mctp.c | 46 +++++++++++++++++++++++++++++++++-------------
 net/mctp/route.c   | 14 +++++++++++---
 3 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index 7e35ec79b909..204ae3aebc0d 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -36,8 +36,6 @@ struct mctp_hdr {
 #define MCTP_HDR_TAG_SHIFT	0
 #define MCTP_HDR_TAG_MASK	GENMASK(2, 0)
 
-#define MCTP_HEADER_MAXLEN	4
-
 #define MCTP_INITIAL_DEFAULT_NET	1
 
 static inline bool mctp_address_ok(mctp_eid_t eid)
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index c921de63b494..fc05351d3a82 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -90,13 +90,13 @@ static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	DECLARE_SOCKADDR(struct sockaddr_mctp *, addr, msg->msg_name);
-	const int hlen = MCTP_HEADER_MAXLEN + sizeof(struct mctp_hdr);
 	int rc, addrlen = msg->msg_namelen;
 	struct sock *sk = sock->sk;
 	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct mctp_skb_cb *cb;
 	struct mctp_route *rt;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
+	int hlen;
 
 	if (addr) {
 		if (addrlen < sizeof(struct sockaddr_mctp))
@@ -119,6 +119,34 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (addr->smctp_network == MCTP_NET_ANY)
 		addr->smctp_network = mctp_default_net(sock_net(sk));
 
+	/* direct addressing */
+	if (msk->addr_ext && addrlen >= sizeof(struct sockaddr_mctp_ext)) {
+		DECLARE_SOCKADDR(struct sockaddr_mctp_ext *,
+				 extaddr, msg->msg_name);
+		struct net_device *dev;
+
+		rc = -EINVAL;
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), extaddr->smctp_ifindex);
+		/* check for correct halen */
+		if (dev && extaddr->smctp_halen == dev->addr_len) {
+			hlen = LL_RESERVED_SPACE(dev) + sizeof(struct mctp_hdr);
+			rc = 0;
+		}
+		rcu_read_unlock();
+		if (rc)
+			goto err_free;
+		rt = NULL;
+	} else {
+		rt = mctp_route_lookup(sock_net(sk), addr->smctp_network,
+				       addr->smctp_addr.s_addr);
+		if (!rt) {
+			rc = -EHOSTUNREACH;
+			goto err_free;
+		}
+		hlen = LL_RESERVED_SPACE(rt->dev->dev) + sizeof(struct mctp_hdr);
+	}
+
 	skb = sock_alloc_send_skb(sk, hlen + 1 + len,
 				  msg->msg_flags & MSG_DONTWAIT, &rc);
 	if (!skb)
@@ -137,8 +165,8 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	cb = __mctp_cb(skb);
 	cb->net = addr->smctp_network;
 
-	/* direct addressing */
-	if (msk->addr_ext && addrlen >= sizeof(struct sockaddr_mctp_ext)) {
+	if (!rt) {
+		/* fill extended address in cb */
 		DECLARE_SOCKADDR(struct sockaddr_mctp_ext *,
 				 extaddr, msg->msg_name);
 
@@ -149,17 +177,9 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		}
 
 		cb->ifindex = extaddr->smctp_ifindex;
+		/* smctp_halen is checked above */
 		cb->halen = extaddr->smctp_halen;
 		memcpy(cb->haddr, extaddr->smctp_haddr, cb->halen);
-
-		rt = NULL;
-	} else {
-		rt = mctp_route_lookup(sock_net(sk), addr->smctp_network,
-				       addr->smctp_addr.s_addr);
-		if (!rt) {
-			rc = -EHOSTUNREACH;
-			goto err_free;
-		}
 	}
 
 	rc = mctp_local_output(sk, rt, skb, addr->smctp_addr.s_addr,
diff --git a/net/mctp/route.c b/net/mctp/route.c
index d47438f5233d..1a296e211a50 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -498,6 +498,11 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 
 	if (cb->ifindex) {
 		/* direct route; use the hwaddr we stashed in sendmsg */
+		if (cb->halen != skb->dev->addr_len) {
+			/* sanity check, sendmsg should have already caught this */
+			kfree_skb(skb);
+			return -EMSGSIZE;
+		}
 		daddr = cb->haddr;
 	} else {
 		/* If lookup fails let the device handle daddr==NULL */
@@ -707,7 +712,7 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 {
 	const unsigned int hlen = sizeof(struct mctp_hdr);
 	struct mctp_hdr *hdr, *hdr2;
-	unsigned int pos, size;
+	unsigned int pos, size, headroom;
 	struct sk_buff *skb2;
 	int rc;
 	u8 seq;
@@ -721,6 +726,9 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 		return -EMSGSIZE;
 	}
 
+	/* keep same headroom as the original skb */
+	headroom = skb_headroom(skb);
+
 	/* we've got the header */
 	skb_pull(skb, hlen);
 
@@ -728,7 +736,7 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 		/* size of message payload */
 		size = min(mtu - hlen, skb->len - pos);
 
-		skb2 = alloc_skb(MCTP_HEADER_MAXLEN + hlen + size, GFP_KERNEL);
+		skb2 = alloc_skb(headroom + hlen + size, GFP_KERNEL);
 		if (!skb2) {
 			rc = -ENOMEM;
 			break;
@@ -744,7 +752,7 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 			skb_set_owner_w(skb2, skb->sk);
 
 		/* establish packet */
-		skb_reserve(skb2, MCTP_HEADER_MAXLEN);
+		skb_reserve(skb2, headroom);
 		skb_reset_network_header(skb2);
 		skb_put(skb2, hlen + size);
 		skb2->transport_header = skb2->network_header + hlen;
-- 
2.35.1



