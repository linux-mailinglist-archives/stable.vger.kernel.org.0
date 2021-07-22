Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DBD3D28E7
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhGVP77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233380AbhGVP6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E1726136D;
        Thu, 22 Jul 2021 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971961;
        bh=sponig7x7Ln5ffgY5GWc8EuHMcbuPqadfCcrwxr+gJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jClw3vIGRU6JtKx7P2oooC0iEDo2hj7Z60jS08TRqM63WmIWpDeB+hZtj0vS42FdQ
         RDrMbmyOLrBV6oS4Hj7HvXXptOiuGTwMwPASDUQYbPDWcPexEGL2TR9VCHxbGodQ2U
         ElUPQSwS0ltug6tzXpWwv8Hmo5V9dGpR7oaAY3AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 094/125] net: ipv6: fix return value of ip6_skb_dst_mtu
Date:   Thu, 22 Jul 2021 18:31:25 +0200
Message-Id: <20210722155627.813308798@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
@@ -262,7 +262,7 @@ static inline bool ipv6_anycast_destinat
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		 int (*output)(struct net *, struct sock *, struct sk_buff *));
 
-static inline int ip6_skb_dst_mtu(struct sk_buff *skb)
+static inline unsigned int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
 	int mtu;
 
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -56,7 +56,7 @@ static int __xfrm6_output(struct net *ne
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct xfrm_state *x = dst->xfrm;
-	int mtu;
+	unsigned int mtu;
 	bool toobig;
 
 #ifdef CONFIG_NETFILTER


