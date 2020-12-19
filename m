Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C828A2DEF62
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgLSNDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgLSNDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:03:05 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ingemar Johansson <ingemar.s.johansson@ericsson.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 12/34] tcp: fix cwnd-limited bug for TSO deferral where we send nothing
Date:   Sat, 19 Dec 2020 14:03:09 +0100
Message-Id: <20201219125341.984693145@linuxfoundation.org>
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

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 299bcb55ecd1412f6df606e9dc0912d55610029e ]

When cwnd is not a multiple of the TSO skb size of N*MSS, we can get
into persistent scenarios where we have the following sequence:

(1) ACK for full-sized skb of N*MSS arrives
  -> tcp_write_xmit() transmit full-sized skb with N*MSS
  -> move pacing release time forward
  -> exit tcp_write_xmit() because pacing time is in the future

(2) TSQ callback or TCP internal pacing timer fires
  -> try to transmit next skb, but TSO deferral finds remainder of
     available cwnd is not big enough to trigger an immediate send
     now, so we defer sending until the next ACK.

(3) repeat...

So we can get into a case where we never mark ourselves as
cwnd-limited for many seconds at a time, even with
bulk/infinite-backlog senders, because:

o In case (1) above, every time in tcp_write_xmit() we have enough
cwnd to send a full-sized skb, we are not fully using the cwnd
(because cwnd is not a multiple of the TSO skb size). So every time we
send data, we are not cwnd limited, and so in the cwnd-limited
tracking code in tcp_cwnd_validate() we mark ourselves as not
cwnd-limited.

o In case (2) above, every time in tcp_write_xmit() that we try to
transmit the "remainder" of the cwnd but defer, we set the local
variable is_cwnd_limited to true, but we do not send any packets, so
sent_pkts is zero, so we don't call the cwnd-limited logic to update
tp->is_cwnd_limited.

Fixes: ca8a22634381 ("tcp: make cwnd-limited checks measurement-based, and gentler")
Reported-by: Ingemar Johansson <ingemar.s.johansson@ericsson.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20201209035759.1225145-1-ncardwell.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1654,7 +1654,8 @@ static void tcp_cwnd_validate(struct soc
 	 * window, and remember whether we were cwnd-limited then.
 	 */
 	if (!before(tp->snd_una, tp->max_packets_seq) ||
-	    tp->packets_out > tp->max_packets_out) {
+	    tp->packets_out > tp->max_packets_out ||
+	    is_cwnd_limited) {
 		tp->max_packets_out = tp->packets_out;
 		tp->max_packets_seq = tp->snd_nxt;
 		tp->is_cwnd_limited = is_cwnd_limited;
@@ -2476,6 +2477,10 @@ repair:
 	else
 		tcp_chrono_stop(sk, TCP_CHRONO_RWND_LIMITED);
 
+	is_cwnd_limited |= (tcp_packets_in_flight(tp) >= tp->snd_cwnd);
+	if (likely(sent_pkts || is_cwnd_limited))
+		tcp_cwnd_validate(sk, is_cwnd_limited);
+
 	if (likely(sent_pkts)) {
 		if (tcp_in_cwnd_reduction(sk))
 			tp->prr_out += sent_pkts;
@@ -2483,8 +2488,6 @@ repair:
 		/* Send one loss probe per tail loss episode. */
 		if (push_one != 2)
 			tcp_schedule_loss_probe(sk, false);
-		is_cwnd_limited |= (tcp_packets_in_flight(tp) >= tp->snd_cwnd);
-		tcp_cwnd_validate(sk, is_cwnd_limited);
 		return false;
 	}
 	return !tp->packets_out && !tcp_write_queue_empty(sk);


