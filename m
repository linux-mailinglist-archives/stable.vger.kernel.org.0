Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6316A3E7EDE
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhHJRfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233137AbhHJReu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4BE76109F;
        Tue, 10 Aug 2021 17:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616868;
        bh=DSyiZh3eH9KuUQbPDRuhIrdqGMTCBIAl4rChqICO6yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lor7ljvJwaV5fEPrNvdiH7dGRCIQRPTozITm+/Ck+TypoKH5JZmfSxdUpa0LULizv
         lpOZv7VUBMmrbWG9n1864AiFlOhmzUqUMwwvbzDEuTjNLSiV0AFzjBbFzDkdacb9Tt
         CHE8j0L0Yf1Uw850e4Hjv+qUtlEbJgFN10KEVXTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/85] net: ipv6: fix returned variable type in ip6_skb_dst_mtu
Date:   Tue, 10 Aug 2021 19:30:01 +0200
Message-Id: <20210810172949.151436253@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 4039146777a91e1576da2bf38e0d8a1061a1ae47 ]

The patch fixing the returned value of ip6_skb_dst_mtu (int -> unsigned
int) was rebased between its initial review and the version applied. In
the meantime fade56410c22 was applied, which added a new variable (int)
used as the returned value. This lead to a mismatch between the function
prototype and the variable used as the return value.

Fixes: 40fc3054b458 ("net: ipv6: fix return value of ip6_skb_dst_mtu")
Cc: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_route.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index feeecbc80e72..2c739fc752e1 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -263,7 +263,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 static inline unsigned int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
-	int mtu;
+	unsigned int mtu;
 
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
-- 
2.30.2



