Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93547420D1A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhJDNLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234436AbhJDNJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC67E61B5D;
        Mon,  4 Oct 2021 13:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352610;
        bh=ON3V8TIuQGWM/QPhMquel8vyqbtYbIMGqAD3eE9/G1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0q12c0c4PlqA2kwX5aNUFJ57jl2ixq12fvSRdNupKZHWJfSQieTMtAZfcCfl4FVq
         6z+4eZrwjsoBGY+caI7W2lti/SArOt7ufNbU6HcudovTI4w8iio6grqaCLOcI+sebc
         jQC3N7Ul5AdCws8wJM/2nVLNxDJOFDVomzBHSux8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Qiumiao Zhang <zhangqiumiao1@huawei.com>
Subject: [PATCH 4.19 51/95] tcp: always set retrans_stamp on recovery
Date:   Mon,  4 Oct 2021 14:52:21 +0200
Message-Id: <20211004125035.244830487@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

commit 7ae189759cc48cf8b54beebff566e9fd2d4e7d7c upstream.

Previously TCP socket's retrans_stamp is not set if the
retransmission has failed to send. As a result if a socket is
experiencing local issues to retransmit packets, determining when
to abort a socket is complicated w/o knowning the starting time of
the recovery since retrans_stamp may remain zero.

This complication causes sub-optimal behavior that TCP may use the
latest, instead of the first, retransmission time to compute the
elapsed time of a stalling connection due to local issues. Then TCP
may disrecard TCP retries settings and keep retrying until it finally
succeed: not a good idea when the local host is already strained.

The simple fix is to always timestamp the start of a recovery.
It's worth noting that retrans_stamp is also used to compare echo
timestamp values to detect spurious recovery. This patch does
not break that because retrans_stamp is still later than when the
original packet was sent.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    9 ++++-----
 net/ipv4/tcp_timer.c  |   23 +++--------------------
 2 files changed, 7 insertions(+), 25 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2958,13 +2958,12 @@ int tcp_retransmit_skb(struct sock *sk,
 #endif
 		TCP_SKB_CB(skb)->sacked |= TCPCB_RETRANS;
 		tp->retrans_out += tcp_skb_pcount(skb);
-
-		/* Save stamp of the first retransmit. */
-		if (!tp->retrans_stamp)
-			tp->retrans_stamp = tcp_skb_timestamp(skb);
-
 	}
 
+	/* Save stamp of the first (attempted) retransmit. */
+	if (!tp->retrans_stamp)
+		tp->retrans_stamp = tcp_skb_timestamp(skb);
+
 	if (tp->undo_retrans < 0)
 		tp->undo_retrans = 0;
 	tp->undo_retrans += tcp_skb_pcount(skb);
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -22,28 +22,14 @@
 #include <linux/gfp.h>
 #include <net/tcp.h>
 
-static u32 tcp_retransmit_stamp(const struct sock *sk)
-{
-	u32 start_ts = tcp_sk(sk)->retrans_stamp;
-
-	if (unlikely(!start_ts)) {
-		struct sk_buff *head = tcp_rtx_queue_head(sk);
-
-		if (!head)
-			return 0;
-		start_ts = tcp_skb_timestamp(head);
-	}
-	return start_ts;
-}
-
 static u32 tcp_clamp_rto_to_user_timeout(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 elapsed, start_ts;
 	s32 remaining;
 
-	start_ts = tcp_retransmit_stamp(sk);
-	if (!icsk->icsk_user_timeout || !start_ts)
+	start_ts = tcp_sk(sk)->retrans_stamp;
+	if (!icsk->icsk_user_timeout)
 		return icsk->icsk_rto;
 	elapsed = tcp_time_stamp(tcp_sk(sk)) - start_ts;
 	remaining = icsk->icsk_user_timeout - elapsed;
@@ -198,10 +184,7 @@ static bool retransmits_timed_out(struct
 	if (!inet_csk(sk)->icsk_retransmits)
 		return false;
 
-	start_ts = tcp_retransmit_stamp(sk);
-	if (!start_ts)
-		return false;
-
+	start_ts = tcp_sk(sk)->retrans_stamp;
 	if (likely(timeout == 0)) {
 		linear_backoff_thresh = ilog2(TCP_RTO_MAX/rto_base);
 


