Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF79A420D12
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbhJDNLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235789AbhJDNJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:09:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09CB661AEC;
        Mon,  4 Oct 2021 13:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352607;
        bh=OSRvumG2QaN5I2Fyok2rb7aYzcqO2eo/PN0ovzWbOJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQ6rgjg8rPKtvoV4rD2duR4PU0aVmJTLXyRRe1C0KTza8AYP3E6XSC50VWY0smyX2
         ukVOv5RSCWA2tqPKYt7cWaf+el1O9YKuX6C4LVts22FfejQGIuMfKmbp5wbiKlza6G
         jftx3NF9Q18Luu5e+tMIYo+xtYoPlPfoD0m8+hH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Qiumiao Zhang <zhangqiumiao1@huawei.com>
Subject: [PATCH 4.19 50/95] tcp: address problems caused by EDT misshaps
Date:   Mon,  4 Oct 2021 14:52:20 +0200
Message-Id: <20211004125035.212480377@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 9efdda4e3abed13f0903b7b6e4d4c2102019440a upstream.

When a qdisc setup including pacing FQ is dismantled and recreated,
some TCP packets are sent earlier than instructed by TCP stack.

TCP can be fooled when ACK comes back, because the following
operation can return a negative value.

    tcp_time_stamp(tp) - tp->rx_opt.rcv_tsecr;

Some paths in TCP stack were not dealing properly with this,
this patch addresses four of them.

Fixes: ab408b6dc744 ("tcp: switch tcp and sch_fq to new earliest departure time model")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |   16 ++++++++++------
 net/ipv4/tcp_timer.c |   10 ++++++----
 2 files changed, 16 insertions(+), 10 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -581,10 +581,12 @@ static inline void tcp_rcv_rtt_measure_t
 		u32 delta = tcp_time_stamp(tp) - tp->rx_opt.rcv_tsecr;
 		u32 delta_us;
 
-		if (!delta)
-			delta = 1;
-		delta_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
-		tcp_rcv_rtt_update(tp, delta_us, 0);
+		if (likely(delta < INT_MAX / (USEC_PER_SEC / TCP_TS_HZ))) {
+			if (!delta)
+				delta = 1;
+			delta_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
+			tcp_rcv_rtt_update(tp, delta_us, 0);
+		}
 	}
 }
 
@@ -2931,9 +2933,11 @@ static bool tcp_ack_update_rtt(struct so
 	if (seq_rtt_us < 0 && tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
 	    flag & FLAG_ACKED) {
 		u32 delta = tcp_time_stamp(tp) - tp->rx_opt.rcv_tsecr;
-		u32 delta_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
 
-		seq_rtt_us = ca_rtt_us = delta_us;
+		if (likely(delta < INT_MAX / (USEC_PER_SEC / TCP_TS_HZ))) {
+			seq_rtt_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
+			ca_rtt_us = seq_rtt_us;
+		}
 	}
 	rs->rtt_us = ca_rtt_us; /* RTT of last (S)ACKed packet (or -1) */
 	if (seq_rtt_us < 0)
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -40,15 +40,17 @@ static u32 tcp_clamp_rto_to_user_timeout
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 elapsed, start_ts;
+	s32 remaining;
 
 	start_ts = tcp_retransmit_stamp(sk);
 	if (!icsk->icsk_user_timeout || !start_ts)
 		return icsk->icsk_rto;
 	elapsed = tcp_time_stamp(tcp_sk(sk)) - start_ts;
-	if (elapsed >= icsk->icsk_user_timeout)
+	remaining = icsk->icsk_user_timeout - elapsed;
+	if (remaining <= 0)
 		return 1; /* user timeout has passed; fire ASAP */
-	else
-		return min_t(u32, icsk->icsk_rto, msecs_to_jiffies(icsk->icsk_user_timeout - elapsed));
+
+	return min_t(u32, icsk->icsk_rto, msecs_to_jiffies(remaining));
 }
 
 /**
@@ -210,7 +212,7 @@ static bool retransmits_timed_out(struct
 				(boundary - linear_backoff_thresh) * TCP_RTO_MAX;
 		timeout = jiffies_to_msecs(timeout);
 	}
-	return (tcp_time_stamp(tcp_sk(sk)) - start_ts) >= timeout;
+	return (s32)(tcp_time_stamp(tcp_sk(sk)) - start_ts - timeout) >= 0;
 }
 
 /* A write timeout has occurred. Process the after effects. */


