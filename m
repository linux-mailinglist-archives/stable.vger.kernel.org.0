Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1213A603D56
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJSJAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiJSI7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3061612A9D;
        Wed, 19 Oct 2022 01:55:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C826461866;
        Wed, 19 Oct 2022 08:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F4EC433D6;
        Wed, 19 Oct 2022 08:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169590;
        bh=6kvcWx+c4BB3mvwttTIv3Zj7qhfnuhSGxxgp4Ktanp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaTKdeSgjXKOejuFSKAQ+JP+SwDq/0NMktOMYoV6Ab244sCeRAc1R8nRsuYOe9cMA
         X1/xEuNJucukd6x4Uuj6t3lxJmAuHHbxuf37h9Anc7CsXpG+Os1YpNtMNJgkW3JUCF
         z79UDOuhebgsqWpPu20GgeTqHotCAmRKHm1IPyJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        "Kevin(Yudong) Yang" <yyd@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 332/862] tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited
Date:   Wed, 19 Oct 2022 10:26:59 +0200
Message-Id: <20221019083304.711344157@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a9fbe22732c3..4791fd801945 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -295,7 +295,7 @@ struct tcp_sock {
 	u32	packets_out;	/* Packets which are "in flight"	*/
 	u32	retrans_out;	/* Retransmitted packets out		*/
 	u32	max_packets_out;  /* max packets_out in last window */
-	u32	max_packets_seq;  /* right edge of max_packets_out flight */
+	u32	cwnd_usage_seq;  /* right edge of cwnd usage tracking flight */
 
 	u16	urg_data;	/* Saved octet of OOB data and control flags */
 	u8	ecn_flags;	/* ECN status bits.			*/
diff --git a/include/net/tcp.h b/include/net/tcp.h
index d10962b9f0d0..95c1d51393ac 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1295,11 +1295,14 @@ static inline bool tcp_is_cwnd_limited(const struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
+	if (tp->is_cwnd_limited)
+		return true;
+
 	/* If in slow start, ensure cwnd grows to twice what was ACKed. */
 	if (tcp_in_slow_start(tp))
 		return tcp_snd_cwnd(tp) < 2 * tp->max_packets_out;
 
-	return tp->is_cwnd_limited;
+	return false;
 }
 
 /* BBR congestion control needs pacing.
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e373dde1f46f..997a80ce1e13 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3137,6 +3137,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tcp_snd_cwnd_set(tp, TCP_INIT_CWND);
 	tp->snd_cwnd_cnt = 0;
+	tp->is_cwnd_limited = 0;
+	tp->max_packets_out = 0;
 	tp->window_clamp = 0;
 	tp->delivered = 0;
 	tp->delivered_ce = 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 290019de766d..c69f4d966024 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1875,15 +1875,20 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
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



