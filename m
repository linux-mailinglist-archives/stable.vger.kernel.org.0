Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FE84A4168
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358529AbiAaLDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358796AbiAaLCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:02:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1A5C06136C;
        Mon, 31 Jan 2022 03:00:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44601B82A69;
        Mon, 31 Jan 2022 11:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC15BC340EE;
        Mon, 31 Jan 2022 11:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626852;
        bh=krk3JK/6W2Uck8W8Qsdm4XLEPCdioCNoGKl/TvaDwy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eh5gvIoVVs6T2Ifa+buAzEnu1dN2qI+ql6u7wxKim7nBsXvOmXef9XvIF2UcjmbfW
         BWoKXu78dUe+OL3cd2f/UHop/5aoMb58ciuIEhRF+mosfVjeon67XULhByjQa8CVad
         1I55LrYfF0b85fGAKtyILnjDU3qI4zZdhv796cYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Ray Che <xijiache@gmail.com>, David Ahern <dsahern@kernel.org>,
        Geoff Alexander <alexandg@cs.unm.edu>,
        Willy Tarreau <w@1wt.eu>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/64] ipv4: tcp: send zero IPID in SYNACK messages
Date:   Mon, 31 Jan 2022 11:56:45 +0100
Message-Id: <20220131105217.695729664@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 970a5a3ea86da637471d3cd04d513a0755aba4bf ]

In commit 431280eebed9 ("ipv4: tcp: send zero IPID for RST and
ACK sent in SYN-RECV and TIME-WAIT state") we took care of some
ctl packets sent by TCP.

It turns out we need to use a similar strategy for SYNACK packets.

By default, they carry IP_DF and IPID==0, but there are ways
to ask them to use the hashed IP ident generator and thus
be used to build off-path attacks.
(Ref: Off-Path TCP Exploits of the Mixed IPID Assignment)

One of this way is to force (before listener is started)
echo 1 >/proc/sys/net/ipv4/ip_no_pmtu_disc

Another way is using forged ICMP ICMP_FRAG_NEEDED
with a very small MTU (like 68) to force a false return from
ip_dont_fragment()

In this patch, ip_build_and_send_pkt() uses the following
heuristics.

1) Most SYNACK packets are smaller than IPV4_MIN_MTU and therefore
can use IP_DF regardless of the listener or route pmtu setting.

2) In case the SYNACK packet is bigger than IPV4_MIN_MTU,
we use prandom_u32() generator instead of the IPv4 hashed ident one.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Ray Che <xijiache@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Cc: Geoff Alexander <alexandg@cs.unm.edu>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 0ec529d77a56e..418e939878004 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -161,12 +161,19 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	if (ip_dont_fragment(sk, &rt->dst)) {
+	/* Do not bother generating IPID for small packets (eg SYNACK) */
+	if (skb->len <= IPV4_MIN_MTU || ip_dont_fragment(sk, &rt->dst)) {
 		iph->frag_off = htons(IP_DF);
 		iph->id = 0;
 	} else {
 		iph->frag_off = 0;
-		__ip_select_ident(net, iph, 1);
+		/* TCP packets here are SYNACK with fat IPv4/TCP options.
+		 * Avoid using the hashed IP ident generator.
+		 */
+		if (sk->sk_protocol == IPPROTO_TCP)
+			iph->id = (__force __be16)prandom_u32();
+		else
+			__ip_select_ident(net, iph, 1);
 	}
 
 	if (opt && opt->opt.optlen) {
-- 
2.34.1



