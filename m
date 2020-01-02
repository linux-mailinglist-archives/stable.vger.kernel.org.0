Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F9912EC67
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgABWSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:32948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbgABWSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFE5722B48;
        Thu,  2 Jan 2020 22:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003483;
        bh=M6PJ3k+tZowRhOd3D2yK5DtX5doruQc/zWvHLm05xA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwQtK510mD95APAXvn6v8EmtOOq3UNoMgGAIkOQHRs8qGjSPeeD5YtNSPa2k7qHXw
         SZjyd5brufdHDcLwxUeJm8tlbpAxq6mcjztxEthternT7OY1V/4t2VxTTjy7u8AuBu
         gD4FyFIrGz73Ic6v0iBA8g2GKdSPYX6uYuW2jkF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 180/191] tcp: do not send empty skb from tcp_write_xmit()
Date:   Thu,  2 Jan 2020 23:07:42 +0100
Message-Id: <20200102215848.567294632@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
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
@@ -2441,6 +2441,14 @@ static bool tcp_write_xmit(struct sock *
 		if (tcp_small_queue_check(sk, skb, 0))
 			break;
 
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
 


