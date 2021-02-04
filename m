Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C2930C263
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhBBOtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234299AbhBBORg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:17:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 863D565060;
        Tue,  2 Feb 2021 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612274065;
        bh=JGDgF9MMKput11Atgdt1RtpXOn7atWLXnl5KUD7ATkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w96z3lAzMB2oyPZlkgH90WYaZVlXLCgXhwQrAcHPzuq6qfnR26taqr25Q9MkM3YjJ
         G/KMT0k2iJZyayyvOrBOgiinD9K0AvSNiNw2OJb7W/2w2UDh0A3WoXK8schAwgXw3m
         UafmEhKTLs2SX0ZABnwOhyCcFrye+iXF/6vn07Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 37/37] tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN
Date:   Tue,  2 Feb 2021 14:39:20 +0100
Message-Id: <20210202132944.477906025@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>

commit 62d9f1a6945ba69c125e548e72a36d203b30596e upstream.

Upon receiving a cumulative ACK that changes the congestion state from
Disorder to Open, the TLP timer is not set. If the sender is app-limited,
it can only wait for the RTO timer to expire and retransmit.

The reason for this is that the TLP timer is set before the congestion
state changes in tcp_ack(), so we delay the time point of calling
tcp_set_xmit_timer() until after tcp_fastretrans_alert() returns and
remove the FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer
is set.

This commit has two additional benefits:
1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
avoid spurious RTO caused by RTO timer early expires.
2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
timer is set.

Fixes: df92c8394e6e ("tcp: fix xmit timer to only be reset if data ACKed/SACKed")
Link: https://lore.kernel.org/netdev/1611311242-6675-1-git-send-email-yangpc@wangsu.com
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/1611464834-23030-1-git-send-email-yangpc@wangsu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/tcp.h       |    2 +-
 net/ipv4/tcp_input.c    |   10 ++++++----
 net/ipv4/tcp_recovery.c |    5 +++--
 3 files changed, 10 insertions(+), 7 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1961,7 +1961,7 @@ void tcp_mark_skb_lost(struct sock *sk,
 void tcp_newreno_mark_lost(struct sock *sk, bool snd_una_advanced);
 extern s32 tcp_rack_skb_timeout(struct tcp_sock *tp, struct sk_buff *skb,
 				u32 reo_wnd);
-extern void tcp_rack_mark_lost(struct sock *sk);
+extern bool tcp_rack_mark_lost(struct sock *sk);
 extern void tcp_rack_advance(struct tcp_sock *tp, u8 sacked, u32 end_seq,
 			     u64 xmit_time);
 extern void tcp_rack_reo_timeout(struct sock *sk);
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2750,7 +2750,8 @@ static void tcp_identify_packet_loss(str
 	} else if (tcp_is_rack(sk)) {
 		u32 prior_retrans = tp->retrans_out;
 
-		tcp_rack_mark_lost(sk);
+		if (tcp_rack_mark_lost(sk))
+			*ack_flag &= ~FLAG_SET_XMIT_TIMER;
 		if (prior_retrans > tp->retrans_out)
 			*ack_flag |= FLAG_LOST_RETRANS;
 	}
@@ -3693,9 +3694,6 @@ static int tcp_ack(struct sock *sk, cons
 
 	if (tp->tlp_high_seq)
 		tcp_process_tlp_ack(sk, ack, flag);
-	/* If needed, reset TLP/RTO timer; RACK may later override this. */
-	if (flag & FLAG_SET_XMIT_TIMER)
-		tcp_set_xmit_timer(sk);
 
 	if (tcp_ack_is_dubious(sk, flag)) {
 		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
@@ -3703,6 +3701,10 @@ static int tcp_ack(struct sock *sk, cons
 				      &rexmit);
 	}
 
+	/* If needed, reset TLP/RTO timer when RACK doesn't set. */
+	if (flag & FLAG_SET_XMIT_TIMER)
+		tcp_set_xmit_timer(sk);
+
 	if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP))
 		sk_dst_confirm(sk);
 
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -109,13 +109,13 @@ static void tcp_rack_detect_loss(struct
 	}
 }
 
-void tcp_rack_mark_lost(struct sock *sk)
+bool tcp_rack_mark_lost(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 timeout;
 
 	if (!tp->rack.advanced)
-		return;
+		return false;
 
 	/* Reset the advanced flag to avoid unnecessary queue scanning */
 	tp->rack.advanced = 0;
@@ -125,6 +125,7 @@ void tcp_rack_mark_lost(struct sock *sk)
 		inet_csk_reset_xmit_timer(sk, ICSK_TIME_REO_TIMEOUT,
 					  timeout, inet_csk(sk)->icsk_rto);
 	}
+	return !!timeout;
 }
 
 /* Record the most recently (re)sent time among the (s)acked packets


