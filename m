Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025B8420D18
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhJDNLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235804AbhJDNJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F165961B63;
        Mon,  4 Oct 2021 13:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352615;
        bh=DWgu6fWazTOOWNuA8jIFByCrDuBfCx4HNg5MdMyrf5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/4fUdt0zd0t9CzY59rdM5LdtL6LfNtG4cGVuYKlR/4lgd9k7yFrkdYn3m0bK6k28
         Q3t0GG86OWYoym9OzWYZ2LC46XPZyO0+YWlOZ9FnS+ZkuYr6QiXAMUhh2Mqfqvcyw4
         buqDThZFnrKxLUT/Zkgo1tuGOHJ8yIbknIobQXYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Marek Majkowski <marek@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Qiumiao Zhang <zhangqiumiao1@huawei.com>
Subject: [PATCH 4.19 53/95] tcp: adjust rto_base in retransmits_timed_out()
Date:   Mon,  4 Oct 2021 14:52:23 +0200
Message-Id: <20211004125035.306364570@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 3256a2d6ab1f71f9a1bd2d7f6f18eb8108c48d17 upstream.

The cited commit exposed an old retransmits_timed_out() bug
which assumed it could call tcp_model_timeout() with
TCP_RTO_MIN as rto_base for all states.

But flows in SYN_SENT or SYN_RECV state uses a different
RTO base (1 sec instead of 200 ms, unless BPF choses
another value)

This caused a reduction of SYN retransmits from 6 to 4 with
the default /proc/sys/net/ipv4/tcp_syn_retries value.

Fixes: a41e8a88b06e ("tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -197,8 +197,13 @@ static bool retransmits_timed_out(struct
 		return false;
 
 	start_ts = tcp_sk(sk)->retrans_stamp;
-	if (likely(timeout == 0))
-		timeout = tcp_model_timeout(sk, boundary, TCP_RTO_MIN);
+	if (likely(timeout == 0)) {
+		unsigned int rto_base = TCP_RTO_MIN;
+
+		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
+			rto_base = tcp_timeout_init(sk);
+		timeout = tcp_model_timeout(sk, boundary, rto_base);
+	}
 
 	return (s32)(tcp_time_stamp(tcp_sk(sk)) - start_ts - timeout) >= 0;
 }


