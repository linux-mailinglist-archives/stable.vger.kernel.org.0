Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ABD232D92
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbgG3IMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729624AbgG3IMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:12:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E5072075F;
        Thu, 30 Jul 2020 08:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096742;
        bh=OP1aGH95r4pPCaQO3EtPt5K3eQHVlqcfnaOhtPoR9Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOSvxKOspF0Kl1uUvrblVWUdXrF4vUA+p2iTTNnHSvtTBOLmENGcQeZ9Zf15ICeJ8
         XAG4j7aYeQ8V9nZwU+hpSNsretPnQDQ2zTzTGVNIJ/bzL95CcADncRHvU7ptjnzSgd
         htBe7G97htXfd4ryUnwc0YrbCU3AevU3rRaF0iW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 43/54] tcp: allow at most one TLP probe per flight
Date:   Thu, 30 Jul 2020 10:05:22 +0200
Message-Id: <20200730074423.268072804@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 76be93fc0702322179bb0ea87295d820ee46ad14 ]

Previously TLP may send multiple probes of new data in one
flight. This happens when the sender is cwnd limited. After the
initial TLP containing new data is sent, the sender receives another
ACK that acks partial inflight.  It may re-arm another TLP timer
to send more, if no further ACK returns before the next TLP timeout
(PTO) expires. The sender may send in theory a large amount of TLP
until send queue is depleted. This only happens if the sender sees
such irregular uncommon ACK pattern. But it is generally undesirable
behavior during congestion especially.

The original TLP design restrict only one TLP probe per inflight as
published in "Reducing Web Latency: the Virtue of Gentle Aggression",
SIGCOMM 2013. This patch changes TLP to send at most one probe
per inflight.

Note that if the sender is app-limited, TLP retransmits old data
and did not have this issue.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tcp.h   |    5 +++--
 net/ipv4/tcp_input.c  |   11 ++++++-----
 net/ipv4/tcp_output.c |   13 ++++++++-----
 3 files changed, 17 insertions(+), 12 deletions(-)

--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -211,7 +211,8 @@ struct tcp_sock {
 		u8 reord;    /* reordering detected */
 	} rack;
 	u16	advmss;		/* Advertised MSS			*/
-	u8	unused;
+	u8	tlp_retrans:1,	/* TLP is a retransmission */
+		unused_1:7;
 	u8	nonagle     : 4,/* Disable Nagle algorithm?             */
 		thin_lto    : 1,/* Use linear timeouts for thin streams */
 		thin_dupack : 1,/* Fast retransmit on first dupack      */
@@ -225,7 +226,7 @@ struct tcp_sock {
 		syn_data_acked:1,/* data in SYN is acked by SYN-ACK */
 		save_syn:1,	/* Save headers of SYN packet */
 		is_cwnd_limited:1;/* forward progress limited by snd_cwnd? */
-	u32	tlp_high_seq;	/* snd_nxt at the time of TLP retransmit. */
+	u32	tlp_high_seq;	/* snd_nxt at the time of TLP */
 
 /* RTT measurement */
 	u32	srtt_us;	/* smoothed round trip time << 3 in usecs */
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3517,10 +3517,8 @@ static void tcp_replace_ts_recent(struct
 	}
 }
 
-/* This routine deals with acks during a TLP episode.
- * We mark the end of a TLP episode on receiving TLP dupack or when
- * ack is after tlp_high_seq.
- * Ref: loss detection algorithm in draft-dukkipati-tcpm-tcp-loss-probe.
+/* This routine deals with acks during a TLP episode and ends an episode by
+ * resetting tlp_high_seq. Ref: TLP algorithm in draft-ietf-tcpm-rack
  */
 static void tcp_process_tlp_ack(struct sock *sk, u32 ack, int flag)
 {
@@ -3529,7 +3527,10 @@ static void tcp_process_tlp_ack(struct s
 	if (before(ack, tp->tlp_high_seq))
 		return;
 
-	if (flag & FLAG_DSACKING_ACK) {
+	if (!tp->tlp_retrans) {
+		/* TLP of new data has been acknowledged */
+		tp->tlp_high_seq = 0;
+	} else if (flag & FLAG_DSACKING_ACK) {
 		/* This DSACK means original and TLP probe arrived; no loss */
 		tp->tlp_high_seq = 0;
 	} else if (after(ack, tp->tlp_high_seq)) {
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2271,6 +2271,11 @@ void tcp_send_loss_probe(struct sock *sk
 	int pcount;
 	int mss = tcp_current_mss(sk);
 
+	/* At most one outstanding TLP */
+	if (tp->tlp_high_seq)
+		goto rearm_timer;
+
+	tp->tlp_retrans = 0;
 	skb = tcp_send_head(sk);
 	if (skb) {
 		if (tcp_snd_wnd_test(tp, skb, mss)) {
@@ -2293,10 +2298,6 @@ void tcp_send_loss_probe(struct sock *sk
 		return;
 	}
 
-	/* At most one outstanding TLP retransmission. */
-	if (tp->tlp_high_seq)
-		goto rearm_timer;
-
 	if (skb_still_in_host_queue(sk, skb))
 		goto rearm_timer;
 
@@ -2317,10 +2318,12 @@ void tcp_send_loss_probe(struct sock *sk
 	if (__tcp_retransmit_skb(sk, skb))
 		goto rearm_timer;
 
+	tp->tlp_retrans = 1;
+
+probe_sent:
 	/* Record snd_nxt for loss detection. */
 	tp->tlp_high_seq = tp->snd_nxt;
 
-probe_sent:
 	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPLOSSPROBES);
 	/* Reset s.t. tcp_rearm_rto will restart timer from now */
 	inet_csk(sk)->icsk_pending = 0;


