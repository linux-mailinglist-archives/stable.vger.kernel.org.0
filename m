Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDA83C4ECD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhGLHVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244199AbhGLHS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:18:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FA3261442;
        Mon, 12 Jul 2021 07:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074134;
        bh=QPJpTckAorXEJTBysmv29wSwQfq/KTpv4uOFTC6J5HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbgepoHLZJ+7VCwHdVU0rWeyrnW/lhWRFGShAYMrcjHy/rwOMnXPWOOVtA5pyV1kX
         QiwVrtZybxwyzd9x64+EWd9cE7DCYwZmqB+3a0cTMMrvXRbH/LUO6WL+Q9e39660LH
         jhEhY5rU9jrJHM8rwZNWhKUWRwCEQuE0Hj+SvXsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@quantonium.net>,
        Coco Li <lixiaoyan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 475/700] ipv6: exthdrs: do not blindly use init_net
Date:   Mon, 12 Jul 2021 08:09:18 +0200
Message-Id: <20210712061027.128129802@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bcc3f2a829b9edbe3da5fb117ee5a63686d31834 ]

I see no reason why max_dst_opts_cnt and max_hbh_opts_cnt
are fetched from the initial net namespace.

The other sysctls (max_dst_opts_len & max_hbh_opts_len)
are in fact already using the current ns.

Note: it is not clear why ipv6_destopt_rcv() use two ways to
get to the netns :

 1) dev_net(dst->dev)
    Originally used to increment IPSTATS_MIB_INHDRERRORS

 2) dev_net(skb->dev)
     Tom used this variant in his patch.

Maybe this calls to use ipv6_skb_net() instead ?

Fixes: 47d3d7ac656a ("ipv6: Implement limits on Hop-by-Hop and Destination options")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tom Herbert <tom@quantonium.net>
Cc: Coco Li <lixiaoyan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 6126f8bf94b3..a9e1d7918d14 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -306,7 +306,7 @@ fail_and_free:
 #endif
 
 	if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
-			  init_net.ipv6.sysctl.max_dst_opts_cnt)) {
+			  net->ipv6.sysctl.max_dst_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -1036,7 +1036,7 @@ fail_and_free:
 
 	opt->flags |= IP6SKB_HOPBYHOP;
 	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
-			  init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
+			  net->ipv6.sysctl.max_hbh_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
-- 
2.30.2



