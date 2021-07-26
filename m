Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5106B3D5DA5
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbhGZPCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235207AbhGZPCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14F6560F22;
        Mon, 26 Jul 2021 15:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314182;
        bh=4l4PzoMxxElxrjKaAdBgkjXff7pMY1G3Llo4pFhvVkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxCUnjtHMryocrKpqIbI+QcZUnhOXfd0P+w8quvgPkXbkh5VMGQ9fprA1x6dky1LZ
         uvz2Xzs0iVLy7hD8hc1OWxUkZwSSmXLlY83sKLx0irelwMM3wEFAw7v4oYRiVTckBf
         nmMmf3+m0JI5wHCvDyiE+7Jf0Nbjeo2IxoLfdqoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 15/60] net: ipv6: fix return value of ip6_skb_dst_mtu
Date:   Mon, 26 Jul 2021 17:38:29 +0200
Message-Id: <20210726153825.348182374@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

commit 40fc3054b45820c28ea3c65e2c86d041dc244a8a upstream.

Commit 628a5c561890 ("[INET]: Add IP(V6)_PMTUDISC_RPOBE") introduced
ip6_skb_dst_mtu with return value of signed int which is inconsistent
with actually returned values. Also 2 users of this function actually
assign its value to unsigned int variable and only __xfrm6_output
assigns result of this function to signed variable but actually uses
as unsigned in further comparisons and calls. Change this function
to return unsigned int value.

Fixes: 628a5c561890 ("[INET]: Add IP(V6)_PMTUDISC_RPOBE")
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_route.h |    2 +-
 net/ipv6/xfrm6_output.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -202,7 +202,7 @@ static inline bool ipv6_anycast_destinat
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		 int (*output)(struct net *, struct sock *, struct sk_buff *));
 
-static inline int ip6_skb_dst_mtu(struct sk_buff *skb)
+static inline unsigned int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -141,7 +141,7 @@ static int __xfrm6_output(struct net *ne
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct xfrm_state *x = dst->xfrm;
-	int mtu;
+	unsigned int mtu;
 	bool toobig;
 
 #ifdef CONFIG_NETFILTER


