Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FD34A44D2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377097AbiAaLcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57166 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359363AbiAaLYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:24:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57E9860B28;
        Mon, 31 Jan 2022 11:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C00C340F0;
        Mon, 31 Jan 2022 11:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628284;
        bh=0/4qqa1wTaF3Qode9fXp/Z88QTW8pXk94tsFhuIOyyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDMGXDMu78plCAjB9pCK3q6XqXrTsBupUQAzVKtJubsFHHLnm0TeKZ8R9kGxn6gvE
         og3mo3Ziw1r0uWLCuZqVbTCAKvHauGdOQ5i7QaOD5c4GPQHYLzGe7Hupfrg08SiU3f
         adAtdwBu8yI3GhZdhTZwGso8g0EQ3T410Druhgj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Ray Che <xijiache@gmail.com>, David Ahern <dsahern@kernel.org>,
        Geoff Alexander <alexandg@cs.unm.edu>,
        Willy Tarreau <w@1wt.eu>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 184/200] ipv4: tcp: send zero IPID in SYNACK messages
Date:   Mon, 31 Jan 2022 11:57:27 +0100
Message-Id: <20220131105239.738283675@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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
index ff38b46bd4b0f..a4d2eb691cbc1 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -162,12 +162,19 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
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



