Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822D4103F5D
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbfKTPnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:43:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52836 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730064AbfKTPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004b5-BU; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004M9-3V; Wed, 20 Nov 2019 15:40:13 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "Soheil Hassas Yeganeh" <soheil@google.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 20 Nov 2019 15:38:19 +0000
Message-ID: <lsq.1574264230.162320205@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 69/83] tcp: fix tcp_ecn_withdraw_cwr() to clear
 TCP_ECN_QUEUE_CWR
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

commit af38d07ed391b21f7405fa1f936ca9686787d6d2 upstream.

Fix tcp_ecn_withdraw_cwr() to clear the correct bit:
TCP_ECN_QUEUE_CWR.

Rationale: basically, TCP_ECN_DEMAND_CWR is a bit that is purely about
the behavior of data receivers, and deciding whether to reflect
incoming IP ECN CE marks as outgoing TCP th->ece marks. The
TCP_ECN_QUEUE_CWR bit is purely about the behavior of data senders,
and deciding whether to send CWR. The tcp_ecn_withdraw_cwr() function
is only called from tcp_undo_cwnd_reduction() by data senders during
an undo, so it should zero the sender-side state,
TCP_ECN_QUEUE_CWR. It does not make sense to stop the reflection of
incoming CE bits on incoming data packets just because outgoing
packets were spuriously retransmitted.

The bug has been reproduced with packetdrill to manifest in a scenario
with RFC3168 ECN, with an incoming data packet with CE bit set and
carrying a TCP timestamp value that causes cwnd undo. Before this fix,
the IP CE bit was ignored and not reflected in the TCP ECE header bit,
and sender sent a TCP CWR ('W') bit on the next outgoing data packet,
even though the cwnd reduction had been undone.  After this fix, the
sender properly reflects the CE bit and does not set the W bit.

Note: the bug actually predates 2005 git history; this Fixes footer is
chosen to be the oldest SHA1 I have tested (from Sep 2007) for which
the patch applies cleanly (since before this commit the code was in a
.h file).

Fixes: bdf1ee5d3bd3 ("[TCP]: Move code from tcp_ecn.h to tcp*.c and tcp.h & remove it")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -214,7 +214,7 @@ static inline void TCP_ECN_accept_cwr(st
 
 static inline void TCP_ECN_withdraw_cwr(struct tcp_sock *tp)
 {
-	tp->ecn_flags &= ~TCP_ECN_DEMAND_CWR;
+	tp->ecn_flags &= ~TCP_ECN_QUEUE_CWR;
 }
 
 static inline void TCP_ECN_check_ce(struct tcp_sock *tp, const struct sk_buff *skb)

