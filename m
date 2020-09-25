Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E814B278857
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgIYMyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbgIYMyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B741922B2D;
        Fri, 25 Sep 2020 12:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038487;
        bh=HazS+I+g8Vg2aPaLzMtf8NRDJQ5vCt/MceZHmbR07Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3tqNkYKbqu/cJuvRNsjmVs7S3MNFAsEeWhvGncbU6ckhxMVDeR+R1jxGROPXd6OW
         BrIiPhU9JMsem2w83/khLaF7hjAJ+7Dphojhi+BarkVFPNg31OqNpVa7Ls+3rlsikN
         UugEK0O9XAkoDZvniAjrKaYgjEzzbT0+FOIxNjXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Priyaranjan Jha <priyarjha@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 35/37] tcp_bbr: refactor bbr_target_cwnd() for general inflight provisioning
Date:   Fri, 25 Sep 2020 14:49:03 +0200
Message-Id: <20200925124726.218739916@linuxfoundation.org>
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

commit 232aa8ec3ed979d4716891540c03a806ecab0c37 upstream.

Because bbr_target_cwnd() is really a general-purpose BBR helper for
computing some volume of inflight data as a function of the estimated
BDP, refactor it into following helper functions:
- bbr_bdp()
- bbr_quantization_budget()
- bbr_inflight()

Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 net/ipv4/tcp_bbr.c |   60 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 21 deletions(-)

--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -315,30 +315,19 @@ static void bbr_cwnd_event(struct sock *
 	}
 }
 
-/* Find target cwnd. Right-size the cwnd based on min RTT and the
- * estimated bottleneck bandwidth:
+/* Calculate bdp based on min RTT and the estimated bottleneck bandwidth:
  *
- * cwnd = bw * min_rtt * gain = BDP * gain
+ * bdp = bw * min_rtt * gain
  *
  * The key factor, gain, controls the amount of queue. While a small gain
  * builds a smaller queue, it becomes more vulnerable to noise in RTT
  * measurements (e.g., delayed ACKs or other ACK compression effects). This
  * noise may cause BBR to under-estimate the rate.
- *
- * To achieve full performance in high-speed paths, we budget enough cwnd to
- * fit full-sized skbs in-flight on both end hosts to fully utilize the path:
- *   - one skb in sending host Qdisc,
- *   - one skb in sending host TSO/GSO engine
- *   - one skb being received by receiver host LRO/GRO/delayed-ACK engine
- * Don't worry, at low rates (bbr_min_tso_rate) this won't bloat cwnd because
- * in such cases tso_segs_goal is 1. The minimum cwnd is 4 packets,
- * which allows 2 outstanding 2-packet sequences, to try to keep pipe
- * full even with ACK-every-other-packet delayed ACKs.
  */
-static u32 bbr_target_cwnd(struct sock *sk, u32 bw, int gain)
+static u32 bbr_bdp(struct sock *sk, u32 bw, int gain)
 {
 	struct bbr *bbr = inet_csk_ca(sk);
-	u32 cwnd;
+	u32 bdp;
 	u64 w;
 
 	/* If we've never had a valid RTT sample, cap cwnd at the initial
@@ -353,7 +342,24 @@ static u32 bbr_target_cwnd(struct sock *
 	w = (u64)bw * bbr->min_rtt_us;
 
 	/* Apply a gain to the given value, then remove the BW_SCALE shift. */
-	cwnd = (((w * gain) >> BBR_SCALE) + BW_UNIT - 1) / BW_UNIT;
+	bdp = (((w * gain) >> BBR_SCALE) + BW_UNIT - 1) / BW_UNIT;
+
+	return bdp;
+}
+
+/* To achieve full performance in high-speed paths, we budget enough cwnd to
+ * fit full-sized skbs in-flight on both end hosts to fully utilize the path:
+ *   - one skb in sending host Qdisc,
+ *   - one skb in sending host TSO/GSO engine
+ *   - one skb being received by receiver host LRO/GRO/delayed-ACK engine
+ * Don't worry, at low rates (bbr_min_tso_rate) this won't bloat cwnd because
+ * in such cases tso_segs_goal is 1. The minimum cwnd is 4 packets,
+ * which allows 2 outstanding 2-packet sequences, to try to keep pipe
+ * full even with ACK-every-other-packet delayed ACKs.
+ */
+static u32 bbr_quantization_budget(struct sock *sk, u32 cwnd, int gain)
+{
+	struct bbr *bbr = inet_csk_ca(sk);
 
 	/* Allow enough full-sized skbs in flight to utilize end systems. */
 	cwnd += 3 * bbr_tso_segs_goal(sk);
@@ -368,6 +374,17 @@ static u32 bbr_target_cwnd(struct sock *
 	return cwnd;
 }
 
+/* Find inflight based on min RTT and the estimated bottleneck bandwidth. */
+static u32 bbr_inflight(struct sock *sk, u32 bw, int gain)
+{
+	u32 inflight;
+
+	inflight = bbr_bdp(sk, bw, gain);
+	inflight = bbr_quantization_budget(sk, inflight, gain);
+
+	return inflight;
+}
+
 /* An optimization in BBR to reduce losses: On the first round of recovery, we
  * follow the packet conservation principle: send P packets per P packets acked.
  * After that, we slow-start and send at most 2*P packets per P packets acked.
@@ -429,7 +446,8 @@ static void bbr_set_cwnd(struct sock *sk
 		goto done;
 
 	/* If we're below target cwnd, slow start cwnd toward target cwnd. */
-	target_cwnd = bbr_target_cwnd(sk, bw, gain);
+	target_cwnd = bbr_bdp(sk, bw, gain);
+	target_cwnd = bbr_quantization_budget(sk, target_cwnd, gain);
 	if (bbr_full_bw_reached(sk))  /* only cut cwnd if we filled the pipe */
 		cwnd = min(cwnd + acked, target_cwnd);
 	else if (cwnd < target_cwnd || tp->delivered < TCP_INIT_CWND)
@@ -470,14 +488,14 @@ static bool bbr_is_next_cycle_phase(stru
 	if (bbr->pacing_gain > BBR_UNIT)
 		return is_full_length &&
 			(rs->losses ||  /* perhaps pacing_gain*BDP won't fit */
-			 inflight >= bbr_target_cwnd(sk, bw, bbr->pacing_gain));
+			 inflight >= bbr_inflight(sk, bw, bbr->pacing_gain));
 
 	/* A pacing_gain < 1.0 tries to drain extra queue we added if bw
 	 * probing didn't find more bw. If inflight falls to match BDP then we
 	 * estimate queue is drained; persisting would underutilize the pipe.
 	 */
 	return is_full_length ||
-		inflight <= bbr_target_cwnd(sk, bw, BBR_UNIT);
+		inflight <= bbr_inflight(sk, bw, BBR_UNIT);
 }
 
 static void bbr_advance_cycle_phase(struct sock *sk)
@@ -736,11 +754,11 @@ static void bbr_check_drain(struct sock
 		bbr->pacing_gain = bbr_drain_gain;	/* pace slow to drain */
 		bbr->cwnd_gain = bbr_high_gain;	/* maintain cwnd */
 		tcp_sk(sk)->snd_ssthresh =
-				bbr_target_cwnd(sk, bbr_max_bw(sk), BBR_UNIT);
+				bbr_inflight(sk, bbr_max_bw(sk), BBR_UNIT);
 	}	/* fall through to check if in-flight is already small: */
 	if (bbr->mode == BBR_DRAIN &&
 	    tcp_packets_in_flight(tcp_sk(sk)) <=
-	    bbr_target_cwnd(sk, bbr_max_bw(sk), BBR_UNIT))
+	    bbr_inflight(sk, bbr_max_bw(sk), BBR_UNIT))
 		bbr_reset_probe_bw_mode(sk);  /* we estimate queue is drained */
 }
 


