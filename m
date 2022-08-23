Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D871559DD4D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243871AbiHWLT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244023AbiHWLRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:17:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2665689820;
        Tue, 23 Aug 2022 02:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB6C1B81C65;
        Tue, 23 Aug 2022 09:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE683C433C1;
        Tue, 23 Aug 2022 09:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246476;
        bh=NeHKc98R14zR8ENVc6BjZmsKaav6RKSz1RkV7bt+kvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7xeaFzpwMmWzbZ3xVDtZ/wvZ8VnadjaRCMVidxCDQmq102/90AlKoek+uvhbTS3+
         Fhmzdakof7QdPMRORflGHwGH3r3uTFUrXe/p07Bp6eDPFDHNZKQ68JEVvnEy2DcgUz
         SVKUmyKEkvJqc0Se6bWluQz/FkDxlsrJcUXEB3so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Li <liyonglong@chinatelecom.cn>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/389] tcp: make retransmitted SKB fit into the send window
Date:   Tue, 23 Aug 2022 10:23:20 +0200
Message-Id: <20220823080120.701174987@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index ef749a47768a..fa7fb30e4b59 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2911,7 +2911,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int cur_mss;
 	int diff, len, err;
-
+	int avail_wnd;
 
 	/* Inconclusive MTU probe */
 	if (icsk->icsk_mtup.probe_size)
@@ -2941,17 +2941,25 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
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
@@ -2965,8 +2973,9 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
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



