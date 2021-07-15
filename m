Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164CB3CA84D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbhGOTAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241827AbhGOS7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 592BE613D1;
        Thu, 15 Jul 2021 18:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375363;
        bh=aP/EM1b9qK2BBJm0OU5caXqsX2vV20/HThE6Niuaryw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKQjBy5NtdU23EEShnCm96gKf05ho6twNwkjku0qtp9KrqRjZfO/C5LoQbntvynOz
         tn/CYkOgWE0WYxS8/KZerHLDeOMke/XQQ1fQYvJaMaS5E8jXuvv1zRFsXG83nYplfa
         VJ7FfZmB/j35aHdDlYGXF+W/rtJ78O2Y0jYrruq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, mingkun bian <bianmingkun@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 054/242] net: tcp better handling of reordering then loss cases
Date:   Thu, 15 Jul 2021 20:36:56 +0200
Message-Id: <20210715182601.851501415@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit a29cb6914681a55667436a9eb7a42e28da8cf387 ]

This patch aims to improve the situation when reordering and loss are
ocurring in the same flight of packets.

Previously the reordering would first induce a spurious recovery, then
the subsequent ACK may undo the cwnd (based on the timestamps e.g.).
However the current loss recovery does not proceed to invoke
RACK to install a reordering timer. If some packets are also lost, this
may lead to a long RTO-based recovery. An example is
https://groups.google.com/g/bbr-dev/c/OFHADvJbTEI

The solution is to after reverting the recovery, always invoke RACK
to either mount the RACK timer to fast retransmit after the reordering
window, or restarts the recovery if new loss is identified. Hence
it is possible the sender may go from Recovery to Disorder/Open to
Recovery again in one ACK.

Reported-by: mingkun bian <bianmingkun@gmail.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 45 +++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 69a545db80d2..e567fff1d1a6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2816,8 +2816,17 @@ static void tcp_process_loss(struct sock *sk, int flag, int num_dupack,
 	*rexmit = REXMIT_LOST;
 }
 
+static bool tcp_force_fast_retransmit(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	return after(tcp_highest_sack_seq(tp),
+		     tp->snd_una + tp->reordering * tp->mss_cache);
+}
+
 /* Undo during fast recovery after partial ACK. */
-static bool tcp_try_undo_partial(struct sock *sk, u32 prior_snd_una)
+static bool tcp_try_undo_partial(struct sock *sk, u32 prior_snd_una,
+				 bool *do_lost)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2842,7 +2851,9 @@ static bool tcp_try_undo_partial(struct sock *sk, u32 prior_snd_una)
 		tcp_undo_cwnd_reduction(sk, true);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPPARTIALUNDO);
 		tcp_try_keep_open(sk);
-		return true;
+	} else {
+		/* Partial ACK arrived. Force fast retransmit. */
+		*do_lost = tcp_force_fast_retransmit(sk);
 	}
 	return false;
 }
@@ -2866,14 +2877,6 @@ static void tcp_identify_packet_loss(struct sock *sk, int *ack_flag)
 	}
 }
 
-static bool tcp_force_fast_retransmit(struct sock *sk)
-{
-	struct tcp_sock *tp = tcp_sk(sk);
-
-	return after(tcp_highest_sack_seq(tp),
-		     tp->snd_una + tp->reordering * tp->mss_cache);
-}
-
 /* Process an event, which can update packets-in-flight not trivially.
  * Main goal of this function is to calculate new estimate for left_out,
  * taking into account both packets sitting in receiver's buffer and
@@ -2943,17 +2946,21 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		if (!(flag & FLAG_SND_UNA_ADVANCED)) {
 			if (tcp_is_reno(tp))
 				tcp_add_reno_sack(sk, num_dupack, ece_ack);
-		} else {
-			if (tcp_try_undo_partial(sk, prior_snd_una))
-				return;
-			/* Partial ACK arrived. Force fast retransmit. */
-			do_lost = tcp_force_fast_retransmit(sk);
-		}
-		if (tcp_try_undo_dsack(sk)) {
-			tcp_try_keep_open(sk);
+		} else if (tcp_try_undo_partial(sk, prior_snd_una, &do_lost))
 			return;
-		}
+
+		if (tcp_try_undo_dsack(sk))
+			tcp_try_keep_open(sk);
+
 		tcp_identify_packet_loss(sk, ack_flag);
+		if (icsk->icsk_ca_state != TCP_CA_Recovery) {
+			if (!tcp_time_to_recover(sk, flag))
+				return;
+			/* Undo reverts the recovery state. If loss is evident,
+			 * starts a new recovery (e.g. reordering then loss);
+			 */
+			tcp_enter_recovery(sk, ece_ack);
+		}
 		break;
 	case TCP_CA_Loss:
 		tcp_process_loss(sk, flag, num_dupack, rexmit);
-- 
2.30.2



