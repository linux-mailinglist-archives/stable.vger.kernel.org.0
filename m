Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A799E30C7E4
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbhBBRd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:33:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234143AbhBBOMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0A7965047;
        Tue,  2 Feb 2021 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273957;
        bh=V+ry1t2waJ9OXv0A91qjdVjPt3/RK96wIRnxkznOGGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3IdS96aBg2js/7GPNh7ybScgeaZ2Ff3Igat9W5d242ts7/nHM8yQpOyxAMpRXsxp
         k+1Yjgvl2zu2ptr+GGH6S4rCFLLWAanOF6NFtY948G14eHJYXRgQFxScPaHzj+xjad
         lEMqWBPnllyy9vOjYZ2xcNPMVf4fwB9nbcEoEJgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 30/30] tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN
Date:   Tue,  2 Feb 2021 14:39:11 +0100
Message-Id: <20210202132943.369155667@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
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
@@ -1969,7 +1969,7 @@ void tcp_v4_init(void);
 void tcp_init(void);
 
 /* tcp_recovery.c */
-extern void tcp_rack_mark_lost(struct sock *sk);
+extern bool tcp_rack_mark_lost(struct sock *sk);
 extern void tcp_rack_advance(struct tcp_sock *tp, u8 sacked, u32 end_seq,
 			     u64 xmit_time);
 extern void tcp_rack_reo_timeout(struct sock *sk);
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2803,7 +2803,8 @@ static void tcp_rack_identify_loss(struc
 	if (sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION) {
 		u32 prior_retrans = tp->retrans_out;
 
-		tcp_rack_mark_lost(sk);
+		if (tcp_rack_mark_lost(sk))
+			*ack_flag &= ~FLAG_SET_XMIT_TIMER;
 		if (prior_retrans > tp->retrans_out)
 			*ack_flag |= FLAG_LOST_RETRANS;
 	}
@@ -3688,15 +3689,16 @@ static int tcp_ack(struct sock *sk, cons
 
 	if (tp->tlp_high_seq)
 		tcp_process_tlp_ack(sk, ack, flag);
-	/* If needed, reset TLP/RTO timer; RACK may later override this. */
-	if (flag & FLAG_SET_XMIT_TIMER)
-		tcp_set_xmit_timer(sk);
 
 	if (tcp_ack_is_dubious(sk, flag)) {
 		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
 		tcp_fastretrans_alert(sk, acked, is_dupack, &flag, &rexmit);
 	}
 
+	/* If needed, reset TLP/RTO timer when RACK doesn't set. */
+	if (flag & FLAG_SET_XMIT_TIMER)
+		tcp_set_xmit_timer(sk);
+
 	if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP))
 		sk_dst_confirm(sk);
 
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -102,13 +102,13 @@ static void tcp_rack_detect_loss(struct
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
@@ -118,6 +118,7 @@ void tcp_rack_mark_lost(struct sock *sk)
 		inet_csk_reset_xmit_timer(sk, ICSK_TIME_REO_TIMEOUT,
 					  timeout, inet_csk(sk)->icsk_rto);
 	}
+	return !!timeout;
 }
 
 /* Record the most recently (re)sent time among the (s)acked packets


