Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F9F4092CB
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344906AbhIMOPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244591AbhIMOOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:14:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAA9E6140A;
        Mon, 13 Sep 2021 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540610;
        bh=o6LKyrOM87VUXOgdhYXzpg42vafYxuwFSoEPoEO8Dt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgCkwmVoXKao8VoCFOv5yR+nPlFaYYeXRfLJ8YnFl8u8wHfEhyN5Fd07Pg3eU43sj
         UQo68KBQAI8iJL60RyVVMNKFzWunNndNaijpVNjgqmlNfszPKq6PFTwG5aPHMF8gW9
         du1SG1vDx+HOtOv6eRfXvxshSrJoVD5cU9KVinGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 262/300] ipv4: fix endianness issue in inet_rtm_getroute_build_skb()
Date:   Mon, 13 Sep 2021 15:15:23 +0200
Message-Id: <20210913131118.197055792@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 92548b0ee220e000d81c27ac9a80e0ede895a881 ]

The UDP length field should be in network order.
This removes the following sparse error:

net/ipv4/route.c:3173:27: warning: incorrect type in assignment (different base types)
net/ipv4/route.c:3173:27:    expected restricted __be16 [usertype] len
net/ipv4/route.c:3173:27:    got unsigned long

Fixes: 404eb77ea766 ("ipv4: support sport, dport and ip_proto in RTM_GETROUTE")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: David Ahern <dsahern@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 70eba1c33fa4..f495fad73be9 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3061,7 +3061,7 @@ static struct sk_buff *inet_rtm_getroute_build_skb(__be32 src, __be32 dst,
 		udph = skb_put_zero(skb, sizeof(struct udphdr));
 		udph->source = sport;
 		udph->dest = dport;
-		udph->len = sizeof(struct udphdr);
+		udph->len = htons(sizeof(struct udphdr));
 		udph->check = 0;
 		break;
 	}
-- 
2.30.2



