Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4871B2B63D9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733305AbgKQNmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733297AbgKQNmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:42:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19B172463D;
        Tue, 17 Nov 2020 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620530;
        bh=eSsr7wYzNlAIPuGAZ2XxEOxpythixFw451ns2aFGXNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QB8Yb/bSnRtpACIPdYPJYTzi7ZV5xZf7FG8lc6lNvhFaMbYusxJa06Yuw8yv3he6T
         EOowhVW3CdKy4dhChx4Dhl9mBhB4jUM+9dCZ7qG3lPwjg3u9sIbkBfX2Zkxw7fDbKq
         xesShTo5qVltNrjxj3ogzGfaaFtYxKAGLoHplQBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 249/255] tunnels: Fix off-by-one in lower MTU bounds for ICMP/ICMPv6 replies
Date:   Tue, 17 Nov 2020 14:06:29 +0100
Message-Id: <20201117122151.049260651@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 77a2d673d5c9d1d359b5652ff75043273c5dea28 ]

Jianlin reports that a bridged IPv6 VXLAN endpoint, carrying IPv6
packets over a link with a PMTU estimation of exactly 1350 bytes,
won't trigger ICMPv6 Packet Too Big replies when the encapsulated
datagrams exceed said PMTU value. VXLAN over IPv6 adds 70 bytes of
overhead, so an ICMPv6 reply indicating 1280 bytes as inner MTU
would be legitimate and expected.

This comes from an off-by-one error I introduced in checks added
as part of commit 4cb47a8644cc ("tunnels: PMTU discovery support
for directly bridged IP packets"), whose purpose was to prevent
sending ICMPv6 Packet Too Big messages with an MTU lower than the
smallest permissible IPv6 link MTU, i.e. 1280 bytes.

In iptunnel_pmtud_check_icmpv6(), avoid triggering a reply only if
the advertised MTU would be less than, and not equal to, 1280 bytes.

Also fix the analogous comparison for IPv4, that is, skip the ICMP
reply only if the resulting MTU is strictly less than 576 bytes.

This becomes apparent while running the net/pmtu.sh bridged VXLAN
or GENEVE selftests with adjusted lower-link MTU values. Using
e.g. GENEVE, setting ll_mtu to the values reported below, in the
test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception() test
function, we can see failures on the following tests:

             test                | ll_mtu
  -------------------------------|--------
  pmtu_ipv4_br_geneve4_exception |   626
  pmtu_ipv6_br_geneve4_exception |  1330
  pmtu_ipv6_br_geneve6_exception |  1350

owing to the different tunneling overheads implied by the
corresponding configurations.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Link: https://lore.kernel.org/r/4f5fc2f33bfdf8409549fafd4f952b008bf04d63.1604681709.git.sbrivio@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -263,7 +263,7 @@ static int iptunnel_pmtud_check_icmp(str
 	const struct icmphdr *icmph = icmp_hdr(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 
-	if (mtu <= 576 || iph->frag_off != htons(IP_DF))
+	if (mtu < 576 || iph->frag_off != htons(IP_DF))
 		return 0;
 
 	if (ipv4_is_lbcast(iph->daddr)  || ipv4_is_multicast(iph->daddr) ||
@@ -359,7 +359,7 @@ static int iptunnel_pmtud_check_icmpv6(s
 	__be16 frag_off;
 	int offset;
 
-	if (mtu <= IPV6_MIN_MTU)
+	if (mtu < IPV6_MIN_MTU)
 		return 0;
 
 	if (stype == IPV6_ADDR_ANY || stype == IPV6_ADDR_MULTICAST ||


