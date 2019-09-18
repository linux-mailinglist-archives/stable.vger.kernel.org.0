Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCD0B5CEE
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfIRGac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbfIRGYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9CEA218AF;
        Wed, 18 Sep 2019 06:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787869;
        bh=wN84EXygS75F4cZ+gLTyyU/BKie991M2OnFOKEEZc+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SF5tD3JgYeGDetwVxrmtVreh9iVgpXuTwAJjOFgLeEvmeoItp5ldq7HOVJ4LjEEAm
         bFUHlIc4UojP8RD91BDgSJtEu32NcTCnCA52858vtbKSMW6mjruF285jbWduRSf3qT
         nz1I2/C3a3IaAWS9HDrpUpN/ja3vQK1dk9SyKMRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 14/85] tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
Date:   Wed, 18 Sep 2019 08:18:32 +0200
Message-Id: <20190918061234.593793994@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit af38d07ed391b21f7405fa1f936ca9686787d6d2 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -266,7 +266,7 @@ static void tcp_ecn_accept_cwr(struct so
 
 static void tcp_ecn_withdraw_cwr(struct tcp_sock *tp)
 {
-	tp->ecn_flags &= ~TCP_ECN_DEMAND_CWR;
+	tp->ecn_flags &= ~TCP_ECN_QUEUE_CWR;
 }
 
 static void __tcp_ecn_check_ce(struct sock *sk, const struct sk_buff *skb)


