Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E5D408DCA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242821AbhIMNaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242189AbhIMN1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80C4161264;
        Mon, 13 Sep 2021 13:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539393;
        bh=dg2QN3AWCIWmVz2nrFCFnJUi6tR7PcdlkYoww0kPG3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJfwZNaOroKU+LfPUWD4gaaq74tcQZrcS9iDdZa7Y/91Yw01VITCbPNPAmxNlBIQU
         X+IMhzLooyAbh0XdN4u4VLpj+FAwgmytH6hiG470K2DZ4S6Go9k+Rq/yeYgaTu7O7u
         Rc3SLllx/1k4U7faWFMOxWF/zppUFeluBwZsEc14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/144] ipv4: fix endianness issue in inet_rtm_getroute_build_skb()
Date:   Mon, 13 Sep 2021 15:15:07 +0200
Message-Id: <20210913131052.141914548@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index 03f35764a40e..539492998864 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3004,7 +3004,7 @@ static struct sk_buff *inet_rtm_getroute_build_skb(__be32 src, __be32 dst,
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



