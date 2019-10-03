Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F20CA635
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391206AbfJCQlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405003AbfJCQlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:41:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC18720830;
        Thu,  3 Oct 2019 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120865;
        bh=L+xO4ZeH3EGqd3+aM/8Rncwq+bXfmP+b1hrydvIjwyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPPTxji9a7YcY/lEazi/aGp3r/yANgNeYvtdVUpt3szRtIdCatZaQNKSKyFoarNqW
         GSjcM0sP9l6PhpgfWkIOhOXYSwb4m14Aq4nUAPXNtFN8WMaaLqE/SC/bgGZIr6eqnh
         zznvM6KHIlqsmHAVYmE157FHM1f+z43xv0gmjwy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Jon Maxwell <jmaxwell37@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 031/344] tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
Date:   Thu,  3 Oct 2019 17:49:56 +0200
Message-Id: <20191003154543.153025392@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a66b10c05ee2d744189e9a2130394b070883d289 ]

Yuchung Cheng and Marek Majkowski independently reported a weird
behavior of TCP_USER_TIMEOUT option when used at connect() time.

When the TCP_USER_TIMEOUT is reached, tcp_write_timeout()
believes the flow should live, and the following condition
in tcp_clamp_rto_to_user_timeout() programs one jiffie timers :

    remaining = icsk->icsk_user_timeout - elapsed;
    if (remaining <= 0)
        return 1; /* user timeout has passed; fire ASAP */

This silly situation ends when the max syn rtx count is reached.

This patch makes sure we honor both TCP_SYNCNT and TCP_USER_TIMEOUT,
avoiding these spurious SYN packets.

Fixes: b701a99e431d ("tcp: Add tcp_clamp_rto_to_user_timeout() helper to improve accuracy")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Yuchung Cheng <ycheng@google.com>
Reported-by: Marek Majkowski <marek@cloudflare.com>
Cc: Jon Maxwell <jmaxwell37@gmail.com>
Link: https://marc.info/?l=linux-netdev&m=156940118307949&w=2
Acked-by: Jon Maxwell <jmaxwell37@gmail.com>
Tested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Marek Majkowski <marek@cloudflare.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -210,7 +210,7 @@ static int tcp_write_timeout(struct sock
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
-	bool expired, do_reset;
+	bool expired = false, do_reset;
 	int retry_until;
 
 	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
@@ -242,9 +242,10 @@ static int tcp_write_timeout(struct sock
 			if (tcp_out_of_resources(sk, do_reset))
 				return 1;
 		}
+	}
+	if (!expired)
 		expired = retransmits_timed_out(sk, retry_until,
 						icsk->icsk_user_timeout);
-	}
 	tcp_fastopen_active_detect_blackhole(sk, expired);
 
 	if (BPF_SOCK_OPS_TEST_FLAG(tp, BPF_SOCK_OPS_RTO_CB_FLAG))


