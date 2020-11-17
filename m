Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14C02B6294
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgKQN3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:29:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731255AbgKQN3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:29:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 212F92078D;
        Tue, 17 Nov 2020 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619789;
        bh=8vychjACC1LFnCXrvS8QNF1aC9mbaARz/UIJ33YZ81c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zj4tGcD6wAQbgH4DJBxR76aeSdVWZev0+iqjxJl2n+qah9xS1BTFmwSfRXiAJ+xRk
         Ezq837+xUbElD9bYPbkmNmjsQI4io3TWAUT4JmPTMMpPZPx/OV+Erd+nErdsVlQXRG
         VD37PjwYH72SgqnP3AyqNn5vgByEhG9PCz0kFkj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mao Wenan <wenan.mao@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 141/151] net: Update window_clamp if SOCK_RCVBUF is set
Date:   Tue, 17 Nov 2020 14:06:11 +0100
Message-Id: <20201117122128.293232755@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Wenan <wenan.mao@linux.alibaba.com>

[ Upstream commit 909172a149749242990a6e64cb55d55460d4e417 ]

When net.ipv4.tcp_syncookies=1 and syn flood is happened,
cookie_v4_check or cookie_v6_check tries to redo what
tcp_v4_send_synack or tcp_v6_send_synack did,
rsk_window_clamp will be changed if SOCK_RCVBUF is set,
which will make rcv_wscale is different, the client
still operates with initial window scale and can overshot
granted window, the client use the initial scale but local
server use new scale to advertise window value, and session
work abnormally.

Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's rcv-buffer via setsockopt")
Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/1604967391-123737-1-git-send-email-wenan.mao@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/syncookies.c |    9 +++++++--
 net/ipv6/syncookies.c |   10 ++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -291,7 +291,7 @@ struct sock *cookie_v4_check(struct sock
 	__u32 cookie = ntohl(th->ack_seq) - 1;
 	struct sock *ret = sk;
 	struct request_sock *req;
-	int mss;
+	int full_space, mss;
 	struct rtable *rt;
 	__u8 rcv_wscale;
 	struct flowi4 fl4;
@@ -386,8 +386,13 @@ struct sock *cookie_v4_check(struct sock
 
 	/* Try to redo what tcp_v4_send_synack did. */
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(&rt->dst, RTAX_WINDOW);
+	/* limit the window selection if the user enforce a smaller rx buffer */
+	full_space = tcp_full_space(sk);
+	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
+	    (req->rsk_window_clamp > full_space || req->rsk_window_clamp == 0))
+		req->rsk_window_clamp = full_space;
 
-	tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
+	tcp_select_initial_window(sk, full_space, req->mss,
 				  &req->rsk_rcv_wnd, &req->rsk_window_clamp,
 				  ireq->wscale_ok, &rcv_wscale,
 				  dst_metric(&rt->dst, RTAX_INITRWND));
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -136,7 +136,7 @@ struct sock *cookie_v6_check(struct sock
 	__u32 cookie = ntohl(th->ack_seq) - 1;
 	struct sock *ret = sk;
 	struct request_sock *req;
-	int mss;
+	int full_space, mss;
 	struct dst_entry *dst;
 	__u8 rcv_wscale;
 	u32 tsoff = 0;
@@ -241,7 +241,13 @@ struct sock *cookie_v6_check(struct sock
 	}
 
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(dst, RTAX_WINDOW);
-	tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
+	/* limit the window selection if the user enforce a smaller rx buffer */
+	full_space = tcp_full_space(sk);
+	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
+	    (req->rsk_window_clamp > full_space || req->rsk_window_clamp == 0))
+		req->rsk_window_clamp = full_space;
+
+	tcp_select_initial_window(sk, full_space, req->mss,
 				  &req->rsk_rcv_wnd, &req->rsk_window_clamp,
 				  ireq->wscale_ok, &rcv_wscale,
 				  dst_metric(dst, RTAX_INITRWND));


