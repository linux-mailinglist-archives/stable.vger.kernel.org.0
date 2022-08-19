Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DAA59A015
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352048AbiHSQTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352076AbiHSQPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:15:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD46D7CE7;
        Fri, 19 Aug 2022 08:58:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8516261796;
        Fri, 19 Aug 2022 15:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93126C433D6;
        Fri, 19 Aug 2022 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924716;
        bh=/KPKV50PXtsAmT4RQycRokI9s+7rxw7lKWZb1hEqWcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1dPHqCWPvReils9hnMey7ArQZhIfgJH8EnYM7FZjFd6wj3PgrrvDoelT9HQiTlfs
         07WzaAptytsEA+b8CPUYNlaultdL97VbuMMldaYmCIEOkN84JEjAO5/UWVUKTH+Jb2
         iBzYcUoaN7zZzlOit8KmFE04Aeyj06d7DPn3VQpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/545] tcp: Fix data-races around sysctl_tcp_l3mdev_accept.
Date:   Fri, 19 Aug 2022 17:40:30 +0200
Message-Id: <20220819153840.977801700@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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
index 816851807fa8..1a3bf9726b75 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -201,7 +201,7 @@ static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 					int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_tcp_l3mdev_accept,
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 886ed0950b7f..4908513c6dfb 100644
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



