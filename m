Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E131160A3FD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiJXMDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiJXMB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:01:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BDD13F11;
        Mon, 24 Oct 2022 04:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A02B161286;
        Mon, 24 Oct 2022 11:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F60C433C1;
        Mon, 24 Oct 2022 11:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612171;
        bh=HA9MCoEoC8QqmrO+2/VbuNC0X/ywxoU5lg6FjR2ETcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+r25CL2ZORvV/2FylmmFEde6pNdTjchJBH0sXyFMH8eswrtw1lt1anMSTq8zDgPo
         AhkK2zVfzCliyBD9PA6Ng1/fQCmEo2BY4L+/joT2VLSOrWylIseaZq8lNcE0aUziWV
         X3Zw2IdHZLZIXLmK3jIHePj94ixjQ/FMA3cEj120=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        "Kevin(Yudong) Yang" <yyd@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 095/210] tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited
Date:   Mon, 24 Oct 2022 13:30:12 +0200
Message-Id: <20221024113000.110431859@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit f4ce91ce12a7c6ead19b128ffa8cff6e3ded2a14 ]

This commit fixes a bug in the tracking of max_packets_out and
is_cwnd_limited. This bug can cause the connection to fail to remember
that is_cwnd_limited is true, causing the connection to fail to grow
cwnd when it should, causing throughput to be lower than it should be.

The following event sequence is an example that triggers the bug:

 (a) The connection is cwnd_limited, but packets_out is not at its
     peak due to TSO deferral deciding not to send another skb yet.
     In such cases the connection can advance max_packets_seq and set
     tp->is_cwnd_limited to true and max_packets_out to a small
     number.

(b) Then later in the round trip the connection is pacing-limited (not
     cwnd-limited), and packets_out is larger. In such cases the
     connection would raise max_packets_out to a bigger number but
     (unexpectedly) flip tp->is_cwnd_limited from true to false.

This commit fixes that bug.

One straightforward fix would be to separately track (a) the next
window after max_packets_out reaches a maximum, and (b) the next
window after tp->is_cwnd_limited is set to true. But this would
require consuming an extra u32 sequence number.

Instead, to save space we track only the most important
information. Specifically, we track the strongest available signal of
the degree to which the cwnd is fully utilized:

(1) If the connection is cwnd-limited then we remember that fact for
the current window.

(2) If the connection not cwnd-limited then we track the maximum
number of outstanding packets in the current window.

In particular, note that the new logic cannot trigger the buggy
(a)/(b) sequence above because with the new logic a condition where
tp->packets_out > tp->max_packets_out can only trigger an update of
tp->is_cwnd_limited if tp->is_cwnd_limited is false.

This first showed up in a testing of a BBRv2 dev branch, but this
buggy behavior highlighted a general issue with the
tcp_cwnd_validate() logic that can cause cwnd to fail to increase at
the proper rate for any TCP congestion control, including Reno or
CUBIC.

Fixes: ca8a22634381 ("tcp: make cwnd-limited checks measurement-based, and gentler")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tcp.h   |  2 +-
 include/net/tcp.h     |  5 ++++-
 net/ipv4/tcp.c        |  2 ++
 net/ipv4/tcp_output.c | 19 ++++++++++++-------
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 61eb40fef759..b9bc6e3e4ef9 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -245,7 +245,7 @@ struct tcp_sock {
 	u32	packets_out;	/* Packets which are "in flight"	*/
 	u32	retrans_out;	/* Retransmitted packets out		*/
 	u32	max_packets_out;  /* max packets_out in last window */
-	u32	max_packets_seq;  /* right edge of max_packets_out flight */
+	u32	cwnd_usage_seq;  /* right edge of cwnd usage tracking flight */
 
 	u16	urg_data;	/* Saved octet of OOB data and control flags */
 	u8	ecn_flags;	/* ECN status bits.			*/
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5e719f9d60fd..003638f73ffa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1228,11 +1228,14 @@ static inline bool tcp_is_cwnd_limited(const struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
+	if (tp->is_cwnd_limited)
+		return true;
+
 	/* If in slow start, ensure cwnd grows to twice what was ACKed. */
 	if (tcp_in_slow_start(tp))
 		return tp->snd_cwnd < 2 * tp->max_packets_out;
 
-	return tp->is_cwnd_limited;
+	return false;
 }
 
 /* Something is really bad, we could not queue an additional packet,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a0fd9ef2d2c6..783d0cd4fcbd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2366,6 +2366,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_probes_out = 0;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd_cnt = 0;
+	tp->is_cwnd_limited = 0;
+	tp->max_packets_out = 0;
 	tp->window_clamp = 0;
 	tp->delivered = 0;
 	if (icsk->icsk_ca_ops->release)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6b6dfb08dde4..2a9e55411ac4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1618,15 +1618,20 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 	const struct tcp_congestion_ops *ca_ops = inet_csk(sk)->icsk_ca_ops;
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	/* Track the maximum number of outstanding packets in each
-	 * window, and remember whether we were cwnd-limited then.
+	/* Track the strongest available signal of the degree to which the cwnd
+	 * is fully utilized. If cwnd-limited then remember that fact for the
+	 * current window. If not cwnd-limited then track the maximum number of
+	 * outstanding packets in the current window. (If cwnd-limited then we
+	 * chose to not update tp->max_packets_out to avoid an extra else
+	 * clause with no functional impact.)
 	 */
-	if (!before(tp->snd_una, tp->max_packets_seq) ||
-	    tp->packets_out > tp->max_packets_out ||
-	    is_cwnd_limited) {
-		tp->max_packets_out = tp->packets_out;
-		tp->max_packets_seq = tp->snd_nxt;
+	if (!before(tp->snd_una, tp->cwnd_usage_seq) ||
+	    is_cwnd_limited ||
+	    (!tp->is_cwnd_limited &&
+	     tp->packets_out > tp->max_packets_out)) {
 		tp->is_cwnd_limited = is_cwnd_limited;
+		tp->max_packets_out = tp->packets_out;
+		tp->cwnd_usage_seq = tp->snd_nxt;
 	}
 
 	if (tcp_is_cwnd_limited(sk)) {
-- 
2.35.1



