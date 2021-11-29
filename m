Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD9F46243D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhK2WRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbhK2WQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B1AC12711E;
        Mon, 29 Nov 2021 10:21:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F2CACE13DE;
        Mon, 29 Nov 2021 18:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB42C53FAD;
        Mon, 29 Nov 2021 18:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210116;
        bh=vhhQTfrCy1Jff1g9L/tEoS8r5KRE+i7ueXb7ad4/avw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ds5C6s1iVResgmvQfZld4Vq4/BLGuW4lwlUpYNuT2fF1sgcCgcN4u9p1ZA072/dz3
         P4ZKeQtum49geTBIPw9Nq2rmbY1oiSg5YuTbBhtpps5+Sb1DtFMBq+Clftfxl0eMgQ
         /N/860WQfvCUZh4z5IFUvZQQ8V+SkXacUjWXwO6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tobias Brunner <tobias@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/69] ipv6: fix typos in __ip6_finish_output()
Date:   Mon, 29 Nov 2021 19:18:30 +0100
Message-Id: <20211129181705.225925797@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 19d36c5f294879949c9d6f57cb61d39cc4c48553 ]

We deal with IPv6 packets, so we need to use IP6CB(skb)->flags and
IP6SKB_REROUTED, instead of IPCB(skb)->flags and IPSKB_REROUTED

Found by code inspection, please double check that fixing this bug
does not surface other bugs.

Fixes: 09ee9dba9611 ("ipv6: Reinject IPv6 packets if IPsec policy matches after SNAT")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tobias Brunner <tobias@strongswan.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: David Ahern <dsahern@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Tested-by: Tobias Brunner <tobias@strongswan.org>
Acked-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index fc36f3b0dceb3..251ec12517e93 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -175,7 +175,7 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
 	/* Policy lookup after SNAT yielded a new policy */
 	if (skb_dst(skb)->xfrm) {
-		IPCB(skb)->flags |= IPSKB_REROUTED;
+		IP6CB(skb)->flags |= IP6SKB_REROUTED;
 		return dst_output(net, sk, skb);
 	}
 #endif
-- 
2.33.0



