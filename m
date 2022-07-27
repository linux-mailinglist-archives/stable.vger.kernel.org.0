Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8F1582E0B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241364AbiG0RGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241367AbiG0RFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:05:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FF36FA03;
        Wed, 27 Jul 2022 09:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF76CCE2311;
        Wed, 27 Jul 2022 16:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC56FC433C1;
        Wed, 27 Jul 2022 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939976;
        bh=674Qol5JQCIYt6EHb/3ISoH7vwQdVNwHkzMbSSZKRHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUBFxeUTbz92cA0wDI8OjL4VGBByhw6QdI95L81Zs5ezVeFdmmipgpWXLjiu1Nnk7
         gB5tx9K5C7aLQHpaHU/4QTE7rpTaPHto04Er8PnaT1N5oDdAO+mae+8gzsd+vz20qU
         oT640nqALKrFTyXe0Mh2n5Hn8tKbGkdKmMZTsbFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/201] tcp: Fix data-races around sysctl_tcp_l3mdev_accept.
Date:   Wed, 27 Jul 2022 18:09:26 +0200
Message-Id: <20220727161029.487106444@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 08a75f10679470552a3a443f9aefd1399604d31d ]

While reading sysctl_tcp_l3mdev_accept, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 6dd9a14e92e5 ("net: Allow accepted sockets to be bound to l3mdev domain")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_hashtables.h | 2 +-
 include/net/inet_sock.h       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 98e1ec1a14f0..749bb1e46087 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -207,7 +207,7 @@ static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 					int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_tcp_l3mdev_accept,
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index e71827aa2dfb..c307a547d2cb 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -121,7 +121,7 @@ static inline int inet_request_bound_dev_if(const struct sock *sk,
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct net *net = sock_net(sk);
 
-	if (!bound_dev_if && net->ipv4.sysctl_tcp_l3mdev_accept)
+	if (!bound_dev_if && READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept))
 		return l3mdev_master_ifindex_by_index(net, skb->skb_iif);
 #endif
 
@@ -133,7 +133,7 @@ static inline int inet_sk_bound_l3mdev(const struct sock *sk)
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct net *net = sock_net(sk);
 
-	if (!net->ipv4.sysctl_tcp_l3mdev_accept)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept))
 		return l3mdev_master_ifindex_by_index(net,
 						      sk->sk_bound_dev_if);
 #endif
-- 
2.35.1



