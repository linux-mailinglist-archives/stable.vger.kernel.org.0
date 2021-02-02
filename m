Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F1A30CBA5
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbhBBTbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233343AbhBBN5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:57:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14FC964FDF;
        Tue,  2 Feb 2021 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273535;
        bh=ye+etvKTKQ5h668bAnqmG0SQ7nMqI4tfMOolffiWWR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7YTNNw2cvjnr2/RjGAc944m0Q8QUUioBNZH+tIwtdxqcDEBvShSWHPMIsl/bcSx9
         bjkdyWaMU1HOly+R7F3e03/fzcTu/mTAeLzNMRW9CSKztefbCFWEb9v9J63PZ6y4FA
         Uu9qqqCcRb4LqkmqG/do2pqA1uzj8TYOX6R0P5OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Enke Chen <enchen@paloaltonetworks.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 141/142] tcp: make TCP_USER_TIMEOUT accurate for zero window probes
Date:   Tue,  2 Feb 2021 14:38:24 +0100
Message-Id: <20210202133003.510204095@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enke Chen <enchen@paloaltonetworks.com>

commit 344db93ae3ee69fc137bd6ed89a8ff1bf5b0db08 upstream.

The TCP_USER_TIMEOUT is checked by the 0-window probe timer. As the
timer has backoff with a max interval of about two minutes, the
actual timeout for TCP_USER_TIMEOUT can be off by up to two minutes.

In this patch the TCP_USER_TIMEOUT is made more accurate by taking it
into account when computing the timer value for the 0-window probes.

This patch is similar to and builds on top of the one that made
TCP_USER_TIMEOUT accurate for RTOs in commit b701a99e431d ("tcp: Add
tcp_clamp_rto_to_user_timeout() helper to improve accuracy").

Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210122191306.GA99540@localhost.localdomain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/tcp.h     |    1 +
 net/ipv4/tcp_input.c  |    4 ++--
 net/ipv4/tcp_output.c |    2 ++
 net/ipv4/tcp_timer.c  |   18 ++++++++++++++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -625,6 +625,7 @@ static inline void tcp_clear_xmit_timers
 
 unsigned int tcp_sync_mss(struct sock *sk, u32 pmtu);
 unsigned int tcp_current_mss(struct sock *sk);
+u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when);
 
 /* Bound MSS / TSO packet size with the half of the window */
 static inline int tcp_bound_to_half_wnd(struct tcp_sock *tp, int pktsize)
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3378,8 +3378,8 @@ static void tcp_ack_probe(struct sock *s
 	} else {
 		unsigned long when = tcp_probe0_when(sk, TCP_RTO_MAX);
 
-		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0,
-				     when, TCP_RTO_MAX);
+		when = tcp_clamp_probe0_to_user_timeout(sk, when);
+		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, when, TCP_RTO_MAX);
 	}
 }
 
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4095,6 +4095,8 @@ void tcp_send_probe0(struct sock *sk)
 		 */
 		timeout = TCP_RESOURCE_PROBE_INTERVAL;
 	}
+
+	timeout = tcp_clamp_probe0_to_user_timeout(sk, timeout);
 	tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, timeout, TCP_RTO_MAX);
 }
 
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -40,6 +40,24 @@ static u32 tcp_clamp_rto_to_user_timeout
 	return min_t(u32, icsk->icsk_rto, msecs_to_jiffies(remaining));
 }
 
+u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	u32 remaining;
+	s32 elapsed;
+
+	if (!icsk->icsk_user_timeout || !icsk->icsk_probes_tstamp)
+		return when;
+
+	elapsed = tcp_jiffies32 - icsk->icsk_probes_tstamp;
+	if (unlikely(elapsed < 0))
+		elapsed = 0;
+	remaining = msecs_to_jiffies(icsk->icsk_user_timeout) - elapsed;
+	remaining = max_t(u32, remaining, TCP_TIMEOUT_MIN);
+
+	return min_t(u32, remaining, when);
+}
+
 /**
  *  tcp_write_err() - close socket and save error info
  *  @sk:  The socket the error has appeared on.


