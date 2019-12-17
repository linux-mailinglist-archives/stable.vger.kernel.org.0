Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B16C122125
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfLQBAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:00:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34558 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbfLQAvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:31 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15F-0003JI-OX; Tue, 17 Dec 2019 00:51:29 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15E-0005SN-O0; Tue, 17 Dec 2019 00:51:28 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "syzbot" <syzkaller@googlegroups.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Florian Westphal" <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 17 Dec 2019 00:45:48 +0000
Message-ID: <lsq.1576543535.239294093@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 014/136] ipv6: drop incoming packets having a
 v4mapped source address
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 6af1799aaf3f1bc8defedddfa00df3192445bbf3 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ip6_input.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -151,6 +151,16 @@ int ipv6_rcv(struct sk_buff *skb, struct
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
 

