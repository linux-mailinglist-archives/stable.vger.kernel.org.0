Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6B42DEF67
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgLSNDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbgLSNDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:03:02 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 11/34] tcp: select sane initial rcvq_space.space for big MSS
Date:   Sat, 19 Dec 2020 14:03:08 +0100
Message-Id: <20201219125341.934325259@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 72d05c00d7ecda85df29abd046da7e41cc071c17 ]

Before commit a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
small tcp_rmem[1] values were overridden by tcp_fixup_rcvbuf() to accommodate various MSS.

This is no longer the case, and Hazem Mohamed Abuelfotoh reported
that DRS would not work for MTU 9000 endpoints receiving regular (1500 bytes) frames.

Root cause is that tcp_init_buffer_space() uses tp->rcv_wnd for upper limit
of rcvq_space.space computation, while it can select later a smaller
value for tp->rcv_ssthresh and tp->window_clamp.

ss -temoi on receiver would show :

skmem:(r0,rb131072,t0,tb46080,f0,w0,o0,bl0,d0) rcv_space:62496 rcv_ssthresh:56596

This means that TCP can not increase its window in tcp_grow_window(),
and that DRS can never kick.

Fix this by making sure that rcvq_space.space is not bigger than number of bytes
that can be held in TCP receive queue.

People unable/unwilling to change their kernel can work around this issue by
selecting a bigger tcp_rmem[1] value as in :

echo "4096 196608 6291456" >/proc/sys/net/ipv4/tcp_rmem

Based on an initial report and patch from Hazem Mohamed Abuelfotoh
 https://lore.kernel.org/netdev/20201204180622.14285-1-abuehaze@amazon.com/

Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
Reported-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -446,7 +446,6 @@ void tcp_init_buffer_space(struct sock *
 	if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
 		tcp_sndbuf_expand(sk);
 
-	tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);
 	tcp_mstamp_refresh(tp);
 	tp->rcvq_space.time = tp->tcp_mstamp;
 	tp->rcvq_space.seq = tp->copied_seq;
@@ -470,6 +469,8 @@ void tcp_init_buffer_space(struct sock *
 
 	tp->rcv_ssthresh = min(tp->rcv_ssthresh, tp->window_clamp);
 	tp->snd_cwnd_stamp = tcp_jiffies32;
+	tp->rcvq_space.space = min3(tp->rcv_ssthresh, tp->rcv_wnd,
+				    (u32)TCP_INIT_CWND * tp->advmss);
 }
 
 /* 4. Recalculate window clamp after socket hit its memory bounds. */


