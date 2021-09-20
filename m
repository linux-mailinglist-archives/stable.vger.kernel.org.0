Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60351411FAB
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353134AbhITRnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352759AbhITRlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:41:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9E1261B63;
        Mon, 20 Sep 2021 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157722;
        bh=ZRg9tBO70UphgkvhuQCuYQVfzIBZWJPP6hkwL1qnChA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LL20G5BN5fDZZOYFh7m42RhwWUF7TccQJjKkEA5k/6AHztiI3o7+aG2u3FypBDUo7
         zBkRRHv1WColaecxl2G4EFwg/6LAiQRx3iPlT6I+SAzoSKeZ2ytiRHiRlqq+eKNL6l
         PcdPDJLgZjDqqHzF/cqKgjtmihkyMvlpD8SnSIY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/293] ipv4: fix endianness issue in inet_rtm_getroute_build_skb()
Date:   Mon, 20 Sep 2021 18:41:06 +0200
Message-Id: <20210920163936.818194608@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index d72bffab6ffc..730a15fc497c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2815,7 +2815,7 @@ static struct sk_buff *inet_rtm_getroute_build_skb(__be32 src, __be32 dst,
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



