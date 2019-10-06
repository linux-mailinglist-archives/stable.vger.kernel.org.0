Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4C8CD874
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfJFRYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbfJFRYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:24:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C6EC2133F;
        Sun,  6 Oct 2019 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382646;
        bh=2R5UQKQCKUH14RTpSXnTUZ8jMC8VnrRarE+x3n4Ojzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfuBkaPx6cryVU2fy2Rra5JsvV8FVxxOnZ5JBxg3Ylf9teBAusfXRGFbgdTGefz14
         VrUkqRpLqagChSTThNSj1Wq1TXSagw7Ms3LWi+igwZFrqbev0Uga/HiBIJzxMfwqvg
         iXtc7i1yfMmffE58BoH11NpCb9qd1KsMXHs99Z/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 34/47] ipv6: drop incoming packets having a v4mapped source address
Date:   Sun,  6 Oct 2019 19:21:21 +0200
Message-Id: <20191006172018.691078571@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
References: <20191006172016.873463083@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6af1799aaf3f1bc8defedddfa00df3192445bbf3 ]

This began with a syzbot report. syzkaller was injecting
IPv6 TCP SYN packets having a v4mapped source address.

After an unsuccessful 4-tuple lookup, TCP creates a request
socket (SYN_RECV) and calls reqsk_queue_hash_req()

reqsk_queue_hash_req() calls sk_ehashfn(sk)

At this point we have AF_INET6 sockets, and the heuristic
used by sk_ehashfn() to either hash the IPv4 or IPv6 addresses
is to use ipv6_addr_v4mapped(&sk->sk_v6_daddr)

For the particular spoofed packet, we end up hashing V4 addresses
which were not initialized by the TCP IPv6 stack, so KMSAN fired
a warning.

I first fixed sk_ehashfn() to test both source and destination addresses,
but then faced various problems, including user-space programs
like packetdrill that had similar assumptions.

Instead of trying to fix the whole ecosystem, it is better
to admit that we have a dual stack behavior, and that we
can not build linux kernels without V4 stack anyway.

The dual stack API automatically forces the traffic to be IPv4
if v4mapped addresses are used at bind() or connect(), so it makes
no sense to allow IPv6 traffic to use the same v4mapped class.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_input.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -168,6 +168,16 @@ int ipv6_rcv(struct sk_buff *skb, struct
 	if (ipv6_addr_is_multicast(&hdr->saddr))
 		goto err;
 
+	/* While RFC4291 is not explicit about v4mapped addresses
+	 * in IPv6 headers, it seems clear linux dual-stack
+	 * model can not deal properly with these.
+	 * Security models could be fooled by ::ffff:127.0.0.1 for example.
+	 *
+	 * https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02
+	 */
+	if (ipv6_addr_v4mapped(&hdr->saddr))
+		goto err;
+
 	skb->transport_header = skb->network_header + sizeof(*hdr);
 	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
 


