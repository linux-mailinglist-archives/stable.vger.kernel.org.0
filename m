Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4C3582FF2
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbiG0Rbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241250AbiG0RaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:30:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB2981B07;
        Wed, 27 Jul 2022 09:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEB80B821D2;
        Wed, 27 Jul 2022 16:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B39AC433C1;
        Wed, 27 Jul 2022 16:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940485;
        bh=t4+PmeHplRjYmog1XkVipDtST+ACitslT3Asytvp7/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4730nk26hUk1HGU7B3IzxFhetti+hwhf48n+oHJIdu25J0UyE9CYR16sdFrKYvz7
         +3kgwdUhFwrij2zqzjEXXCa3eKbTcZo1UoiAB01Yt2RPh6WLLIiZpxEbVOKTl8tnr8
         DSxgTnFn7dSGIAK9rERa8ivYb6kI32lr9kzOTVbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 040/158] tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()
Date:   Wed, 27 Jul 2022 18:11:44 +0200
Message-Id: <20220727161023.090802081@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fdb5fd7f736ec7ae9fb36d2842ea6d9ebc4e7269 ]

inet_request_bound_dev_if() reads sk->sk_bound_dev_if twice
while listener socket is not locked.

Another cpu could change this field under us.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_sock.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index d3cf5871289b..b29108f0973a 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -117,14 +117,15 @@ static inline u32 inet_request_mark(const struct sock *sk, struct sk_buff *skb)
 static inline int inet_request_bound_dev_if(const struct sock *sk,
 					    struct sk_buff *skb)
 {
+	int bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct net *net = sock_net(sk);
 
-	if (!sk->sk_bound_dev_if && net->ipv4.sysctl_tcp_l3mdev_accept)
+	if (!bound_dev_if && net->ipv4.sysctl_tcp_l3mdev_accept)
 		return l3mdev_master_ifindex_by_index(net, skb->skb_iif);
 #endif
 
-	return sk->sk_bound_dev_if;
+	return bound_dev_if;
 }
 
 static inline int inet_sk_bound_l3mdev(const struct sock *sk)
-- 
2.35.1



