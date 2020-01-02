Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B4012EE84
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731410AbgABWjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731408AbgABWjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:39:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33D1E21835;
        Thu,  2 Jan 2020 22:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004750;
        bh=DIyWtAQ7QSGL6ztK8yUbiunjL1bhrGVP3ckBM3rg+PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UayEiFilIm2Zrh/FLvvF6oqsgqfRpkSr4g6ERvMMpR8x4l7DNSxwYGF8fwkau+iib
         U5deCQl8DFPyTA55MH6Kb7e3yAOXmGN51UcjxqFecvDkm8gZwQtf2df572wrpoy6xH
         uA/qCyMJLD5Hx4HLyBYy9iyyj0CGLyNWllqFocn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.4 137/137] tcp: do not send empty skb from tcp_write_xmit()
Date:   Thu,  2 Jan 2020 23:08:30 +0100
Message-Id: <20200102220605.660213239@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1f85e6267caca44b30c54711652b0726fadbb131 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2148,6 +2148,14 @@ static bool tcp_write_xmit(struct sock *
 				break;
 		}
 
+		/* Argh, we hit an empty skb(), presumably a thread
+		 * is sleeping in sendmsg()/sk_stream_wait_memory().
+		 * We do not want to send a pure-ack packet and have
+		 * a strange looking rtx queue with empty packet(s).
+		 */
+		if (TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq)
+			break;
+
 		if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
 			break;
 


