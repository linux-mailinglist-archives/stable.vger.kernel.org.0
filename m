Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD71469AEA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347394AbhLFPLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:11:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41350 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347129AbhLFPIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:08:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3515B81132;
        Mon,  6 Dec 2021 15:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24820C341C1;
        Mon,  6 Dec 2021 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803084;
        bh=LsSWTblbar9WjJ0A101qxYrGsk//7J20ewbc3ncaHmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khuz8cItdSzDm8v7ti6N6NXNUhYYATDUZoq5o4eBs+WTO2m8zlDqvBb0XMAOTIL5t
         +gDU7znQw2dqBrsSZn11vHNuYMfTwBm4LizdggeDhkD9zDwrAN1wvRFNoYMqL0X2WW
         aoWlI2AVSurRuBzB6uGabmU0Uq/fjOagQi4L+jX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tobias Brunner <tobias@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 023/106] ipv6: fix typos in __ip6_finish_output()
Date:   Mon,  6 Dec 2021 15:55:31 +0100
Message-Id: <20211206145556.166969840@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
index a903d0ce7e701..f906fe2acedd3 100644
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



