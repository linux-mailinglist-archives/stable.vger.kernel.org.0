Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC983599FF6
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351652AbiHSQLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350101AbiHSQJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:09:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7034810F6B4;
        Fri, 19 Aug 2022 08:56:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38656614DA;
        Fri, 19 Aug 2022 15:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2614BC433B5;
        Fri, 19 Aug 2022 15:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924607;
        bh=WYk6ZRDt2o5Y4YtVfwybZ7oy3VYzYw6NrQaEtCi5dqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nABm9tfVXtq0ux0NEddeQJlBaqcmnRb/9dzOm95h75VfF14YvIppBUiE3n4wefUOy
         1b4PGkizT8YdyQpxo5YUsFtBCLXS/BzdMrN7Y8cV19HD7NHs8185+Ke/i8rCkR8vHU
         cmXgbcODDhKo2IofU2LtNhHwf4YQdyC6RD34izuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Li <liyonglong@chinatelecom.cn>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/545] tcp: make retransmitted SKB fit into the send window
Date:   Fri, 19 Aug 2022 17:39:55 +0200
Message-Id: <20220819153839.442837458@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

[ Upstream commit 536a6c8e05f95e3d1118c40ae8b3022ee2d05d52 ]

current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
in send window, and TCP_SKB_CB(skb)->seq_end maybe out of send window.
If receiver has shrunk his window, and skb is out of new window,  it
should retransmit a smaller portion of the payload.

test packetdrill script:
    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 fcntl(3, F_GETFL) = 0x2 (flags O_RDWR)
   +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0

   +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
   +0 > S 0:0(0)  win 65535 <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8>
 +.05 < S. 0:0(0) ack 1 win 6000 <mss 1000,nop,nop,sackOK>
   +0 > . 1:1(0) ack 1

   +0 write(3, ..., 10000) = 10000

   +0 > . 1:2001(2000) ack 1 win 65535
   +0 > . 2001:4001(2000) ack 1 win 65535
   +0 > . 4001:6001(2000) ack 1 win 65535

 +.05 < . 1:1(0) ack 4001 win 1001

and tcpdump show:
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 1:2001, ack 1, win 65535, length 2000
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 2001:4001, ack 1, win 65535, length 2000
192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
192.0.2.1.8080 > 192.168.226.67.55: Flags [.], ack 4001, win 1001, length 0
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000

when cient retract window to 1001, send window is [4001,5002],
but TLP send 5001-6001 packet which is out of send window.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/1657532838-20200-1-git-send-email-liyonglong@chinatelecom.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 657b0a4d9359..5662faf81fa5 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3137,7 +3137,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int cur_mss;
 	int diff, len, err;
-
+	int avail_wnd;
 
 	/* Inconclusive MTU probe */
 	if (icsk->icsk_mtup.probe_size)
@@ -3167,17 +3167,25 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		return -EHOSTUNREACH; /* Routing failure or similar. */
 
 	cur_mss = tcp_current_mss(sk);
+	avail_wnd = tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
 
 	/* If receiver has shrunk his window, and skb is out of
 	 * new window, do not retransmit it. The exception is the
 	 * case, when window is shrunk to zero. In this case
-	 * our retransmit serves as a zero window probe.
+	 * our retransmit of one segment serves as a zero window probe.
 	 */
-	if (!before(TCP_SKB_CB(skb)->seq, tcp_wnd_end(tp)) &&
-	    TCP_SKB_CB(skb)->seq != tp->snd_una)
-		return -EAGAIN;
+	if (avail_wnd <= 0) {
+		if (TCP_SKB_CB(skb)->seq != tp->snd_una)
+			return -EAGAIN;
+		avail_wnd = cur_mss;
+	}
 
 	len = cur_mss * segs;
+	if (len > avail_wnd) {
+		len = rounddown(avail_wnd, cur_mss);
+		if (!len)
+			len = avail_wnd;
+	}
 	if (skb->len > len) {
 		if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
 				 cur_mss, GFP_ATOMIC))
@@ -3191,8 +3199,9 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		diff -= tcp_skb_pcount(skb);
 		if (diff)
 			tcp_adjust_pcount(sk, skb, diff);
-		if (skb->len < cur_mss)
-			tcp_retrans_try_collapse(sk, skb, cur_mss);
+		avail_wnd = min_t(int, avail_wnd, cur_mss);
+		if (skb->len < avail_wnd)
+			tcp_retrans_try_collapse(sk, skb, avail_wnd);
 	}
 
 	/* RFC3168, section 6.1.1.1. ECN fallback */
-- 
2.35.1



