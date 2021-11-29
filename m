Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38E1461F2B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351317AbhK2So2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:44:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47334 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379838AbhK2SmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:42:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF771B81600;
        Mon, 29 Nov 2021 18:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30111C53FAD;
        Mon, 29 Nov 2021 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211139;
        bh=N+uQcXOy95LIVJmKQFeYr/wenz2cVVHQdpmuG3GN6NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/r6UHJCRTvj3O9lbC0BUC06QN+oNHg/6ycFviDggMsf6cPR48BU58bjF+RhKV2qq
         ntIfc2aawDIC7dKPMyLLfFYwthJcjG2JD+VWectZN0ErbqrsOwugSxSwZK6dX0KWHg
         ca1n608Da5TR5e+sgVRM7hXk7lab3i+9Kpz0IP90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tobias Brunner <tobias@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/179] ipv6: fix typos in __ip6_finish_output()
Date:   Mon, 29 Nov 2021 19:18:22 +0100
Message-Id: <20211129181722.498254423@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index 2f044a49afa8c..ff4e83e2a5068 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -174,7 +174,7 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
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



