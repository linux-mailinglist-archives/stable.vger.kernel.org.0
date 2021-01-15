Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200A02F7B34
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733157AbhAOMd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733154AbhAOMd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 872B02336F;
        Fri, 15 Jan 2021 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713967;
        bh=pfMeXNysOzQTPDmCEc+5nOvWKPsqEUx9T2x+yAP5mpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UG7HMaQidlSj7Ev5B0BvImnEtlDZliA6QMg8tMO0icaOn7C2KL/O+tiLVOEeRy59d
         7iamO6psMzwBLxoG4YwBiCsR66geEw7IYl5Rn1/pahP2UVau/ZbDeFAIXudzR1aoY2
         cwznf6Cd64m6K0BEwNXhRuy41JS3VRL5XAf0fQpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Perle <christian.perle@secunet.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 07/43] net: ip: always refragment ip defragmented packets
Date:   Fri, 15 Jan 2021 13:27:37 +0100
Message-Id: <20210115121957.409613220@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit bb4cc1a18856a73f0ff5137df0c2a31f4c50f6cf ]

Conntrack reassembly records the largest fragment size seen in IPCB.
However, when this gets forwarded/transmitted, fragmentation will only
be forced if one of the fragmented packets had the DF bit set.

In that case, a flag in IPCB will force fragmentation even if the
MTU is large enough.

This should work fine, but this breaks with ip tunnels.
Consider client that sends a UDP datagram of size X to another host.

The client fragments the datagram, so two packets, of size y and z, are
sent. DF bit is not set on any of these packets.

Middlebox netfilter reassembles those packets back to single size-X
packet, before routing decision.

packet-size-vs-mtu checks in ip_forward are irrelevant, because DF bit
isn't set.  At output time, ip refragmentation is skipped as well
because x is still smaller than the mtu of the output device.

If ttransmit device is an ip tunnel, the packet size increases to
x+overhead.

Also, tunnel might be configured to force DF bit on outer header.

In this case, packet will be dropped (exceeds MTU) and an ICMP error is
generated back to sender.

But sender already respects the announced MTU, all the packets that
it sent did fit the announced mtu.

Force refragmentation as per original sizes unconditionally so ip tunnel
will encapsulate the fragments instead.

The only other solution I see is to place ip refragmentation in
the ip_tunnel code to handle this case.

Fixes: d6b915e29f4ad ("ip_fragment: don't forward defragmented DF packet")
Reported-by: Christian Perle <christian.perle@secunet.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -312,7 +312,7 @@ static int ip_finish_output(struct net *
 	if (skb_is_gso(skb))
 		return ip_finish_output_gso(net, sk, skb, mtu);
 
-	if (skb->len > mtu || (IPCB(skb)->flags & IPSKB_FRAG_PMTU))
+	if (skb->len > mtu || IPCB(skb)->frag_max_size)
 		return ip_fragment(net, sk, skb, mtu, ip_finish_output2);
 
 	return ip_finish_output2(net, sk, skb);


