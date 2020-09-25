Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B43B27886C
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbgIYMyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729612AbgIYMyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 185B02072E;
        Fri, 25 Sep 2020 12:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038489;
        bh=eHDUjn8rElp7DT0REMZzOZAKlM2xv7GUW5h3ds+vwEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJq8Z+wvIJ8KbiJlUPVGcpAqtriV97VaIOXK1tN2s6ZaCqxLz/TZ/JY7JX171jQYi
         dKj0PmBDUe22QO2ZiulpDLNr+6nbRYM+MCEQvTfslZAY6JsfbfofO6DUWmVRIFP/Zx
         wXygjbWJbloL9Rhho+Q3zJqwme6i4xTyCiYi6IjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Priyaranjan Jha <priyarjha@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 36/37] tcp_bbr: adapt cwnd based on ack aggregation estimation
Date:   Fri, 25 Sep 2020 14:49:04 +0200
Message-Id: <20200925124726.388502802@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Priyaranjan Jha <priyarjha@google.com>

commit 78dc70ebaa38aa303274e333be6c98eef87619e2 upstream.

Aggregation effects are extremely common with wifi, cellular, and cable
modem link technologies, ACK decimation in middleboxes, and LRO and GRO
in receiving hosts. The aggregation can happen in either direction,
data or ACKs, but in either case the aggregation effect is visible
to the sender in the ACK stream.

Previously BBR's sending was often limited by cwnd under severe ACK
aggregation/decimation because BBR sized the cwnd at 2*BDP. If packets
were acked in bursts after long delays (e.g. one ACK acking 5*BDP after
5*RTT), BBR's sending was halted after sending 2*BDP over 2*RTT, leaving
the bottleneck idle for potentially long periods. Note that loss-based
congestion control does not have this issue because when facing
aggregation it continues increasing cwnd after bursts of ACKs, growing
cwnd until the buffer is full.

To achieve good throughput in the presence of aggregation effects, this
algorithm allows the BBR sender to put extra data in flight to keep the
bottleneck utilized during silences in the ACK stream that it has evidence
to suggest were caused by aggregation.

A summary of the algorithm: when a burst of packets are acked by a
stretched ACK or a burst of ACKs or both, BBR first estimates the expected
amount of data that should have been acked, based on its estimated
bandwidth. Then the surplus ("extra_acked") is recorded in a windowed-max
filter to estimate the recent level of observed ACK aggregation. Then cwnd
is increased by the ACK aggregation estimate. The larger cwnd avoids BBR
being cwnd-limited in the face of ACK silences that recent history suggests
were caused by aggregation. As a sanity check, the ACK aggregation degree
is upper-bounded by the cwnd (at the time of measurement) and a global max
of BW * 100ms. The algorithm is further described by the following
presentation:
https://datatracker.ietf.org/meeting/101/materials/slides-101-iccrg-an-update-on-bbr-work-at-google-00

In our internal testing, we observed a significant increase in BBR
throughput (measured using netperf), in a basic wifi setup.
- Host1 (sender on ethernet) -> AP -> Host2 (receiver on wifi)
- 2.4 GHz -> BBR before: ~73 Mbps; BBR after: ~102 Mbps; CUBIC: ~100 Mbps
- 5.0 GHz -> BBR before: ~362 Mbps; BBR after: ~593 Mbps; CUBIC: ~601 Mbps

Also, this code is running globally on YouTube TCP connections and produced
significant bandwidth increases for YouTube traffic.

This is based on Ian Swett's max_ack_height_ algorithm from the
QUIC BBR implementation.

Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/inet_connection_sock.h |    4 -
 net/ipv4/tcp_bbr.c                 |  122 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 123 insertions(+), 3 deletions(-)

--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -139,8 +139,8 @@ struct inet_connection_sock {
 	} icsk_mtup;
 	u32			  icsk_user_timeout;
 
-	u64			  icsk_ca_priv[88 / sizeof(u64)];
-#define ICSK_CA_PRIV_SIZE      (11 * sizeof(u64))
+	u64			  icsk_ca_priv[104 / sizeof(u64)];
+#define ICSK_CA_PRIV_SIZE      (13 * sizeof(u64))
 };
 
 #define ICSK_TIME_RETRANS	1	/* Retransmit timer */
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -115,6 +115,14 @@ struct bbr {
 		unused_b:5;
 	u32	prior_cwnd;	/* prior cwnd upon entering loss recovery */
 	u32	full_bw;	/* recent bw, to estimate if pipe is full */
+
+	/* For tracking ACK aggregation: */
+	u64	ack_epoch_mstamp;	/* start of ACK sampling epoch */
+	u16	extra_acked[2];		/* max excess data ACKed in epoch */
+	u32	ack_epoch_acked:20,	/* packets (S)ACKed in sampling epoch */
+		extra_acked_win_rtts:5,	/* age of extra_acked, in round trips */
+		extra_acked_win_idx:1,	/* current index in extra_acked array */
+		unused_c:6;
 };
 
 #define CYCLE_LEN	8	/* number of phases in a pacing gain cycle */
@@ -174,6 +182,15 @@ static const u32 bbr_lt_bw_diff = 4000 /
 /* If we estimate we're policed, use lt_bw for this many round trips: */
 static const u32 bbr_lt_bw_max_rtts = 48;
 
+/* Gain factor for adding extra_acked to target cwnd: */
+static const int bbr_extra_acked_gain = BBR_UNIT;
+/* Window length of extra_acked window. */
+static const u32 bbr_extra_acked_win_rtts = 5;
+/* Max allowed val for ack_epoch_acked, after which sampling epoch is reset */
+static const u32 bbr_ack_epoch_acked_reset_thresh = 1U << 20;
+/* Time period for clamping cwnd increment due to ack aggregation */
+static const u32 bbr_extra_acked_max_us = 100 * 1000;
+
 static void bbr_check_probe_rtt_done(struct sock *sk);
 
 /* Do we estimate that STARTUP filled the pipe? */
@@ -200,6 +217,16 @@ static u32 bbr_bw(const struct sock *sk)
 	return bbr->lt_use_bw ? bbr->lt_bw : bbr_max_bw(sk);
 }
 
+/* Return maximum extra acked in past k-2k round trips,
+ * where k = bbr_extra_acked_win_rtts.
+ */
+static u16 bbr_extra_acked(const struct sock *sk)
+{
+	struct bbr *bbr = inet_csk_ca(sk);
+
+	return max(bbr->extra_acked[0], bbr->extra_acked[1]);
+}
+
 /* Return rate in bytes per second, optionally with a gain.
  * The order here is chosen carefully to avoid overflow of u64. This should
  * work for input rates of up to 2.9Tbit/sec and gain of 2.89x.
@@ -305,6 +332,8 @@ static void bbr_cwnd_event(struct sock *
 
 	if (event == CA_EVENT_TX_START && tp->app_limited) {
 		bbr->idle_restart = 1;
+		bbr->ack_epoch_mstamp = tp->tcp_mstamp;
+		bbr->ack_epoch_acked = 0;
 		/* Avoid pointless buffer overflows: pace at est. bw if we don't
 		 * need more speed (we're restarting from idle and app-limited).
 		 */
@@ -385,6 +414,22 @@ static u32 bbr_inflight(struct sock *sk,
 	return inflight;
 }
 
+/* Find the cwnd increment based on estimate of ack aggregation */
+static u32 bbr_ack_aggregation_cwnd(struct sock *sk)
+{
+	u32 max_aggr_cwnd, aggr_cwnd = 0;
+
+	if (bbr_extra_acked_gain && bbr_full_bw_reached(sk)) {
+		max_aggr_cwnd = ((u64)bbr_bw(sk) * bbr_extra_acked_max_us)
+				/ BW_UNIT;
+		aggr_cwnd = (bbr_extra_acked_gain * bbr_extra_acked(sk))
+			     >> BBR_SCALE;
+		aggr_cwnd = min(aggr_cwnd, max_aggr_cwnd);
+	}
+
+	return aggr_cwnd;
+}
+
 /* An optimization in BBR to reduce losses: On the first round of recovery, we
  * follow the packet conservation principle: send P packets per P packets acked.
  * After that, we slow-start and send at most 2*P packets per P packets acked.
@@ -445,9 +490,15 @@ static void bbr_set_cwnd(struct sock *sk
 	if (bbr_set_cwnd_to_recover_or_restore(sk, rs, acked, &cwnd))
 		goto done;
 
-	/* If we're below target cwnd, slow start cwnd toward target cwnd. */
 	target_cwnd = bbr_bdp(sk, bw, gain);
+
+	/* Increment the cwnd to account for excess ACKed data that seems
+	 * due to aggregation (of data and/or ACKs) visible in the ACK stream.
+	 */
+	target_cwnd += bbr_ack_aggregation_cwnd(sk);
 	target_cwnd = bbr_quantization_budget(sk, target_cwnd, gain);
+
+	/* If we're below target cwnd, slow start cwnd toward target cwnd. */
 	if (bbr_full_bw_reached(sk))  /* only cut cwnd if we filled the pipe */
 		cwnd = min(cwnd + acked, target_cwnd);
 	else if (cwnd < target_cwnd || tp->delivered < TCP_INIT_CWND)
@@ -717,6 +768,67 @@ static void bbr_update_bw(struct sock *s
 	}
 }
 
+/* Estimates the windowed max degree of ack aggregation.
+ * This is used to provision extra in-flight data to keep sending during
+ * inter-ACK silences.
+ *
+ * Degree of ack aggregation is estimated as extra data acked beyond expected.
+ *
+ * max_extra_acked = "maximum recent excess data ACKed beyond max_bw * interval"
+ * cwnd += max_extra_acked
+ *
+ * Max extra_acked is clamped by cwnd and bw * bbr_extra_acked_max_us (100 ms).
+ * Max filter is an approximate sliding window of 5-10 (packet timed) round
+ * trips.
+ */
+static void bbr_update_ack_aggregation(struct sock *sk,
+				       const struct rate_sample *rs)
+{
+	u32 epoch_us, expected_acked, extra_acked;
+	struct bbr *bbr = inet_csk_ca(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (!bbr_extra_acked_gain || rs->acked_sacked <= 0 ||
+	    rs->delivered < 0 || rs->interval_us <= 0)
+		return;
+
+	if (bbr->round_start) {
+		bbr->extra_acked_win_rtts = min(0x1F,
+						bbr->extra_acked_win_rtts + 1);
+		if (bbr->extra_acked_win_rtts >= bbr_extra_acked_win_rtts) {
+			bbr->extra_acked_win_rtts = 0;
+			bbr->extra_acked_win_idx = bbr->extra_acked_win_idx ?
+						   0 : 1;
+			bbr->extra_acked[bbr->extra_acked_win_idx] = 0;
+		}
+	}
+
+	/* Compute how many packets we expected to be delivered over epoch. */
+	epoch_us = tcp_stamp_us_delta(tp->delivered_mstamp,
+				      bbr->ack_epoch_mstamp);
+	expected_acked = ((u64)bbr_bw(sk) * epoch_us) / BW_UNIT;
+
+	/* Reset the aggregation epoch if ACK rate is below expected rate or
+	 * significantly large no. of ack received since epoch (potentially
+	 * quite old epoch).
+	 */
+	if (bbr->ack_epoch_acked <= expected_acked ||
+	    (bbr->ack_epoch_acked + rs->acked_sacked >=
+	     bbr_ack_epoch_acked_reset_thresh)) {
+		bbr->ack_epoch_acked = 0;
+		bbr->ack_epoch_mstamp = tp->delivered_mstamp;
+		expected_acked = 0;
+	}
+
+	/* Compute excess data delivered, beyond what was expected. */
+	bbr->ack_epoch_acked = min_t(u32, 0xFFFFF,
+				     bbr->ack_epoch_acked + rs->acked_sacked);
+	extra_acked = bbr->ack_epoch_acked - expected_acked;
+	extra_acked = min(extra_acked, tp->snd_cwnd);
+	if (extra_acked > bbr->extra_acked[bbr->extra_acked_win_idx])
+		bbr->extra_acked[bbr->extra_acked_win_idx] = extra_acked;
+}
+
 /* Estimate when the pipe is full, using the change in delivery rate: BBR
  * estimates that STARTUP filled the pipe if the estimated bw hasn't changed by
  * at least bbr_full_bw_thresh (25%) after bbr_full_bw_cnt (3) non-app-limited
@@ -846,6 +958,7 @@ static void bbr_update_min_rtt(struct so
 static void bbr_update_model(struct sock *sk, const struct rate_sample *rs)
 {
 	bbr_update_bw(sk, rs);
+	bbr_update_ack_aggregation(sk, rs);
 	bbr_update_cycle_phase(sk, rs);
 	bbr_check_full_bw_reached(sk, rs);
 	bbr_check_drain(sk, rs);
@@ -896,6 +1009,13 @@ static void bbr_init(struct sock *sk)
 	bbr_reset_lt_bw_sampling(sk);
 	bbr_reset_startup_mode(sk);
 
+	bbr->ack_epoch_mstamp = tp->tcp_mstamp;
+	bbr->ack_epoch_acked = 0;
+	bbr->extra_acked_win_rtts = 0;
+	bbr->extra_acked_win_idx = 0;
+	bbr->extra_acked[0] = 0;
+	bbr->extra_acked[1] = 0;
+
 	cmpxchg(&sk->sk_pacing_status, SK_PACING_NONE, SK_PACING_NEEDED);
 }
 


