Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF166304B04
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbhAZEvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:51:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730526AbhAYSrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9BCC23110;
        Mon, 25 Jan 2021 18:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600396;
        bh=zXxPj2mz3TeHYYeBPFRY2ftmWGj036Lw6BjuNgQZ2lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1j9I2sTSnKuuS4KMNqr3BhEmlh51GGc0DZthWNKzOQmKa6n8n3Z96k3n2AGCT48zz
         mp0YhQgUjPAdhk0Gg0k4SdB92IHU9EzClXtYhfHcrIgftFz2Gk+/0c0DXazGk4P7fw
         2x3ZfJ2Ki2BhLEAHiEwnDxd2WRA7izqp0XCsKzLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William McCall <william.mccall@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Enke Chen <enchen@paloaltonetworks.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 86/86] tcp: fix TCP_USER_TIMEOUT with zero window
Date:   Mon, 25 Jan 2021 19:40:08 +0100
Message-Id: <20210125183204.684104321@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
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
@@ -83,6 +83,8 @@ struct inet_connection_sock_af_ops {
  * @icsk_ext_hdr_len:	   Network protocol overhead (IP/IPv6 options)
  * @icsk_ack:		   Delayed ACK control data
  * @icsk_mtup;		   MTU probing control data
+ * @icsk_probes_tstamp:    Probe timestamp (cleared by non-zero window ack)
+ * @icsk_user_timeout:	   TCP_USER_TIMEOUT value
  */
 struct inet_connection_sock {
 	/* inet_sock has to be the first member! */
@@ -133,6 +135,7 @@ struct inet_connection_sock {
 
 		u32		  probe_timestamp;
 	} icsk_mtup;
+	u32			  icsk_probes_tstamp;
 	u32			  icsk_user_timeout;
 
 	u64			  icsk_ca_priv[104 / sizeof(u64)];
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -840,6 +840,7 @@ struct sock *inet_csk_clone_lock(const s
 		newicsk->icsk_retransmits = 0;
 		newicsk->icsk_backoff	  = 0;
 		newicsk->icsk_probes_out  = 0;
+		newicsk->icsk_probes_tstamp = 0;
 
 		/* Deinitialize accept_queue to trap illegal accesses. */
 		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2627,6 +2627,7 @@ int tcp_disconnect(struct sock *sk, int
 	icsk->icsk_backoff = 0;
 	tp->snd_cwnd = 2;
 	icsk->icsk_probes_out = 0;
+	icsk->icsk_probes_tstamp = 0;
 	icsk->icsk_rto = TCP_TIMEOUT_INIT;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd = TCP_INIT_CWND;
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3286,6 +3286,7 @@ static void tcp_ack_probe(struct sock *s
 		return;
 	if (!after(TCP_SKB_CB(head)->end_seq, tcp_wnd_end(tp))) {
 		icsk->icsk_backoff = 0;
+		icsk->icsk_probes_tstamp = 0;
 		inet_csk_clear_xmit_timer(sk, ICSK_TIME_PROBE0);
 		/* Socket must be waked up by subsequent tcp_data_snd_check().
 		 * This function is not for random using!
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3835,6 +3835,7 @@ void tcp_send_probe0(struct sock *sk)
 		/* Cancel probe timer, if it is not required. */
 		icsk->icsk_probes_out = 0;
 		icsk->icsk_backoff = 0;
+		icsk->icsk_probes_tstamp = 0;
 		return;
 	}
 
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -344,6 +344,7 @@ static void tcp_probe_timer(struct sock
 
 	if (tp->packets_out || !skb) {
 		icsk->icsk_probes_out = 0;
+		icsk->icsk_probes_tstamp = 0;
 		return;
 	}
 
@@ -355,13 +356,12 @@ static void tcp_probe_timer(struct sock
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


