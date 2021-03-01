Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E3A328B7A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240026AbhCASfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240006AbhCAS2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:28:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F781650AD;
        Mon,  1 Mar 2021 17:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620355;
        bh=W0oZqIwJv6gjpUQrHiC3w9wbrXYkCuhkY7788ApI77I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aqi7vRB6RFWMLT5IgiXHvwoOP+pwcHcUnCGvIDPCcyF9E7yqwinmeMGPE0VDy9X/t
         PoNT51HvyCaM7ScggCCfMCPUyqZev1l3ZmPS8rN1Vv6mOgUNaxVOIPz9LbMOXxV/Qn
         7gT1VlnCpF9QZEm/bRsUWczDcAM93I41WQ218Bx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arjun Roy <arjunroy@google.com>, Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 123/775] tcp: fix SO_RCVLOWAT related hangs under mem pressure
Date:   Mon,  1 Mar 2021 17:04:51 +0100
Message-Id: <20210301161207.750462425@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f969dc5a885736842c3511ecdea240fbb02d25d9 ]

While commit 24adbc1676af ("tcp: fix SO_RCVLOWAT hangs with fat skbs")
fixed an issue vs too small sk_rcvbuf for given sk_rcvlowat constraint,
it missed to address issue caused by memory pressure.

1) If we are under memory pressure and socket receive queue is empty.
First incoming packet is allowed to be queued, after commit
76dfa6082032 ("tcp: allow one skb to be received per socket under memory pressure")

But we do not send EPOLLIN yet, in case tcp_data_ready() sees sk_rcvlowat
is bigger than skb length.

2) Then, when next packet comes, it is dropped, and we directly
call sk->sk_data_ready().

3) If application is using poll(), tcp_poll() will then use
tcp_stream_is_readable() and decide the socket receive queue is
not yet filled, so nothing will happen.

Even when sender retransmits packets, phases 2) & 3) repeat
and flow is effectively frozen, until memory pressure is off.

Fix is to consider tcp_under_memory_pressure() to take care
of global memory pressure or memcg pressure.

Fixes: 24adbc1676af ("tcp: fix SO_RCVLOWAT hangs with fat skbs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Arjun Roy <arjunroy@google.com>
Suggested-by: Wei Wang <weiwan@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 25bbada379c46..244208f6f6c2a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1431,8 +1431,13 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied);
  */
 static inline bool tcp_rmem_pressure(const struct sock *sk)
 {
-	int rcvbuf = READ_ONCE(sk->sk_rcvbuf);
-	int threshold = rcvbuf - (rcvbuf >> 3);
+	int rcvbuf, threshold;
+
+	if (tcp_under_memory_pressure(sk))
+		return true;
+
+	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
+	threshold = rcvbuf - (rcvbuf >> 3);
 
 	return atomic_read(&sk->sk_rmem_alloc) > threshold;
 }
-- 
2.27.0



