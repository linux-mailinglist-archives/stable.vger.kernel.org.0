Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5691B6828
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgDWXMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:12:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50016 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728498AbgDWXGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvT-0004if-Jp; Fri, 24 Apr 2020 00:06:35 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvR-00E6pB-9V; Fri, 24 Apr 2020 00:06:33 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christoph Paasch" <cpaasch@apple.com>,
        "Soheil Hassas Yeganeh" <soheil@google.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Jason Baron" <jbaron@akamai.com>
Date:   Fri, 24 Apr 2020 00:05:53 +0100
Message-ID: <lsq.1587683028.868791916@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 126/245] tcp: do not send empty skb from tcp_write_xmit()
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 1f85e6267caca44b30c54711652b0726fadbb131 upstream.

Backport of commit fdfc5c8594c2 ("tcp: remove empty skb from
write queue in error cases") in linux-4.14 stable triggered
various bugs. One of them has been fixed in commit ba2ddb43f270
("tcp: Don't dequeue SYN/FIN-segments from write-queue"), but
we still have crashes in some occasions.

Root-cause is that when tcp_sendmsg() has allocated a fresh
skb and could not append a fragment before being blocked
in sk_stream_wait_memory(), tcp_write_xmit() might be called
and decide to send this fresh and empty skb.

Sending an empty packet is not only silly, it might have caused
many issues we had in the past with tp->packets_out being
out of sync.

Fixes: c65f7f00c587 ("[TCP]: Simplify SKB data portion allocation with NETIF_F_SG.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Christoph Paasch <cpaasch@apple.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_output.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1992,6 +1992,14 @@ static bool tcp_write_xmit(struct sock *
 		    unlikely(tso_fragment(sk, skb, limit, mss_now, gfp)))
 			break;
 
+		/* Argh, we hit an empty skb(), presumably a thread
+		 * is sleeping in sendmsg()/sk_stream_wait_memory().
+		 * We do not want to send a pure-ack packet and have
+		 * a strange looking rtx queue with empty packet(s).
+		 */
+		if (TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq)
+			break;
+
 		TCP_SKB_CB(skb)->when = tcp_time_stamp;
 
 		if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))

