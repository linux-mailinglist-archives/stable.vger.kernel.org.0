Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E27302ADD
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731360AbhAYSzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731361AbhAYSzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EE33229C5;
        Mon, 25 Jan 2021 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600864;
        bh=SE9Xo74Mmsjaq4i7ndiW5CfX4wHHOux+QA9ro9SRtkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pX68ignkBtEfxIS5rqI3sOCqeebM0Hrgli14VLsTNkZ0t1SmQoqtijmRgUXwgyiq2
         gOMrWgPAHBcfjf/d8AmmwYT5fY+gTwdW/Vm/XoC1NGgn/YNritdXlsdogw52pTe2Hx
         L1Q/6EkTcyjDOD/Ts2E0YaCaGDjWzh62yGOVbZXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William McCall <william.mccall@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Enke Chen <enchen@paloaltonetworks.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 180/199] tcp: fix TCP_USER_TIMEOUT with zero window
Date:   Mon, 25 Jan 2021 19:40:02 +0100
Message-Id: <20210125183223.786356182@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enke Chen <enchen@paloaltonetworks.com>

commit 9d9b1ee0b2d1c9e02b2338c4a4b0a062d2d3edac upstream.

The TCP session does not terminate with TCP_USER_TIMEOUT when data
remain untransmitted due to zero window.

The number of unanswered zero-window probes (tcp_probes_out) is
reset to zero with incoming acks irrespective of the window size,
as described in tcp_probe_timer():

    RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
    as long as the receiver continues to respond probes. We support
    this by default and reset icsk_probes_out with incoming ACKs.

This counter, however, is the wrong one to be used in calculating the
duration that the window remains closed and data remain untransmitted.
Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
actual issue.

In this patch a new timestamp is introduced for the socket in order to
track the elapsed time for the zero-window probes that have not been
answered with any non-zero window ack.

Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
Reported-by: William McCall <william.mccall@gmail.com>
Co-developed-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
Reviewed-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210115223058.GA39267@localhost.localdomain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/inet_connection_sock.h |    3 +++
 net/ipv4/inet_connection_sock.c    |    1 +
 net/ipv4/tcp.c                     |    1 +
 net/ipv4/tcp_input.c               |    1 +
 net/ipv4/tcp_output.c              |    1 +
 net/ipv4/tcp_timer.c               |   14 +++++++-------
 6 files changed, 14 insertions(+), 7 deletions(-)

--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -76,6 +76,8 @@ struct inet_connection_sock_af_ops {
  * @icsk_ext_hdr_len:	   Network protocol overhead (IP/IPv6 options)
  * @icsk_ack:		   Delayed ACK control data
  * @icsk_mtup;		   MTU probing control data
+ * @icsk_probes_tstamp:    Probe timestamp (cleared by non-zero window ack)
+ * @icsk_user_timeout:	   TCP_USER_TIMEOUT value
  */
 struct inet_connection_sock {
 	/* inet_sock has to be the first member! */
@@ -129,6 +131,7 @@ struct inet_connection_sock {
 
 		u32		  probe_timestamp;
 	} icsk_mtup;
+	u32			  icsk_probes_tstamp;
 	u32			  icsk_user_timeout;
 
 	u64			  icsk_ca_priv[104 / sizeof(u64)];
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -851,6 +851,7 @@ struct sock *inet_csk_clone_lock(const s
 		newicsk->icsk_retransmits = 0;
 		newicsk->icsk_backoff	  = 0;
 		newicsk->icsk_probes_out  = 0;
+		newicsk->icsk_probes_tstamp = 0;
 
 		/* Deinitialize accept_queue to trap illegal accesses. */
 		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2685,6 +2685,7 @@ int tcp_disconnect(struct sock *sk, int
 
 	icsk->icsk_backoff = 0;
 	icsk->icsk_probes_out = 0;
+	icsk->icsk_probes_tstamp = 0;
 	icsk->icsk_rto = TCP_TIMEOUT_INIT;
 	icsk->icsk_rto_min = TCP_RTO_MIN;
 	icsk->icsk_delack_max = TCP_DELACK_MAX;
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3370,6 +3370,7 @@ static void tcp_ack_probe(struct sock *s
 		return;
 	if (!after(TCP_SKB_CB(head)->end_seq, tcp_wnd_end(tp))) {
 		icsk->icsk_backoff = 0;
+		icsk->icsk_probes_tstamp = 0;
 		inet_csk_clear_xmit_timer(sk, ICSK_TIME_PROBE0);
 		/* Socket must be waked up by subsequent tcp_data_snd_check().
 		 * This function is not for random using!
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4080,6 +4080,7 @@ void tcp_send_probe0(struct sock *sk)
 		/* Cancel probe timer, if it is not required. */
 		icsk->icsk_probes_out = 0;
 		icsk->icsk_backoff = 0;
+		icsk->icsk_probes_tstamp = 0;
 		return;
 	}
 
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -343,6 +343,7 @@ static void tcp_probe_timer(struct sock
 
 	if (tp->packets_out || !skb) {
 		icsk->icsk_probes_out = 0;
+		icsk->icsk_probes_tstamp = 0;
 		return;
 	}
 
@@ -354,13 +355,12 @@ static void tcp_probe_timer(struct sock
 	 * corresponding system limit. We also implement similar policy when
 	 * we use RTO to probe window in tcp_retransmit_timer().
 	 */
-	if (icsk->icsk_user_timeout) {
-		u32 elapsed = tcp_model_timeout(sk, icsk->icsk_probes_out,
-						tcp_probe0_base(sk));
-
-		if (elapsed >= icsk->icsk_user_timeout)
-			goto abort;
-	}
+	if (!icsk->icsk_probes_tstamp)
+		icsk->icsk_probes_tstamp = tcp_jiffies32;
+	else if (icsk->icsk_user_timeout &&
+		 (s32)(tcp_jiffies32 - icsk->icsk_probes_tstamp) >=
+		 msecs_to_jiffies(icsk->icsk_user_timeout))
+		goto abort;
 
 	max_probes = sock_net(sk)->ipv4.sysctl_tcp_retries2;
 	if (sock_flag(sk, SOCK_DEAD)) {


