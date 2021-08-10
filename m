Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCD03E7E84
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhHJRd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232140AbhHJRd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D4F460F94;
        Tue, 10 Aug 2021 17:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616786;
        bh=XQYItl7p0iEgrUN0BXM2I4nUgxhc0I0gpvMIV4v4RWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2D+Hjiiy7xT4ie8krBshqh26Ilyv7NjYUhH7pIrwIgAqTpl+bnygmfaT2FWpvpiC
         dlGaSnXTTPc0y541VKcyEfGKHzRyT+H471O00BNcMVpIx2Fk6QfxpPBp7tboY4wAsV
         zFvIpy3rHxtpWQogWHzgx2zmQC7u1pfD8KHDz3TA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/54] net: ipv6: fix returned variable type in ip6_skb_dst_mtu
Date:   Tue, 10 Aug 2021 19:30:07 +0200
Message-Id: <20210810172944.624777424@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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
index a8f5410ae0d4..f237573a2651 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -243,7 +243,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 static inline unsigned int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
-	int mtu;
+	unsigned int mtu;
 
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
-- 
2.30.2



