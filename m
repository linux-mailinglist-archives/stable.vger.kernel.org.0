Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765192A1590
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgJaLfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgJaLfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:35:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5395A20739;
        Sat, 31 Oct 2020 11:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144149;
        bh=24Z/K7X6dVToT0UoNvTTvqd2i60MODxc6HAE700638E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtXYl1r/yydOPFjVXw0bosvb3uwbEdREnKVbSLAuM9tBwaANx0U5vEKaG/e/YC3Qa
         dXV50UFNL3FnOAfCJLnSsHm50q4qn7FqXvhQzatfXSCTivoJTADn0doYxTznse0rho
         rG145eY2X79kCx4wihr/HzwkUZZ8udo9BCVmO+so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 23/49] tcp: Prevent low rmem stalls with SO_RCVLOWAT.
Date:   Sat, 31 Oct 2020 12:35:19 +0100
Message-Id: <20201031113456.564495411@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

[ Upstream commit 435ccfa894e35e3d4a1799e6ac030e48a7b69ef5 ]

With SO_RCVLOWAT, under memory pressure,
it is possible to enter a state where:

1. We have not received enough bytes to satisfy SO_RCVLOWAT.
2. We have not entered buffer pressure (see tcp_rmem_pressure()).
3. But, we do not have enough buffer space to accept more packets.

In this case, we advertise 0 rwnd (due to #3) but the application does
not drain the receive queue (no wakeup because of #1 and #2) so the
flow stalls.

Modify the heuristic for SO_RCVLOWAT so that, if we are advertising
rwnd<=rcv_mss, force a wakeup to prevent a stall.

Without this patch, setting tcp_rmem to 6143 and disabling TCP
autotune causes a stalled flow. With this patch, no stall occurs. This
is with RPC-style traffic with large messages.

Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20201023184709.217614-1-arjunroy.kdev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c       |    2 ++
 net/ipv4/tcp_input.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -484,6 +484,8 @@ static inline bool tcp_stream_is_readabl
 			return true;
 		if (tcp_rmem_pressure(sk))
 			return true;
+		if (tcp_receive_window(tp) <= inet_csk(sk)->icsk_ack.rcv_mss)
+			return true;
 	}
 	if (sk->sk_prot->stream_memory_read)
 		return sk->sk_prot->stream_memory_read(sk);
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4774,7 +4774,8 @@ void tcp_data_ready(struct sock *sk)
 	int avail = tp->rcv_nxt - tp->copied_seq;
 
 	if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
-	    !sock_flag(sk, SOCK_DONE))
+	    !sock_flag(sk, SOCK_DONE) &&
+	    tcp_receive_window(tp) > inet_csk(sk)->icsk_ack.rcv_mss)
 		return;
 
 	sk->sk_data_ready(sk);


