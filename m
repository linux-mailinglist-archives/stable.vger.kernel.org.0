Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74A0E683B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbfJ0VXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731462AbfJ0VXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:18 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92FAC205C9;
        Sun, 27 Oct 2019 21:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211397;
        bh=gSQtZAIgBdTi7gc6F0njdzOUiSs2iuVgr2fcN/YxcWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYMotQDkbVhrzKH/BNdRGzZgg5TvJp40rqWyFyOfjwKc+FJoLUgns9AgSpD8dKMoP
         zYqy99zLocVrkMJlVvt7rGw+k/Up+pDYx4MfQEK0ttge1QFHUkYnpI8gljzBSI+IuN
         rPAdbSwt+AmqRxhzj16vmgke/qe6OYY4XVt3W6Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 093/197] rxrpc: use rcu protection while reading sk->sk_user_data
Date:   Sun, 27 Oct 2019 22:00:11 +0100
Message-Id: <20191027203356.781169462@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2ca4f6ca4562594ef161e4140c2a5e0e5282967b ]

We need to extend the rcu_read_lock() section in rxrpc_error_report()
and use rcu_dereference_sk_user_data() instead of plain access
to sk->sk_user_data to make sure all rules are respected.

The compiler wont reload sk->sk_user_data at will, and RCU rules
prevent memory beeing freed too soon.

Fixes: f0308fb07080 ("rxrpc: Fix possible NULL pointer access in ICMP handling")
Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/peer_event.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 61451281d74a3..48f67a9b1037c 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -147,13 +147,16 @@ void rxrpc_error_report(struct sock *sk)
 {
 	struct sock_exterr_skb *serr;
 	struct sockaddr_rxrpc srx;
-	struct rxrpc_local *local = sk->sk_user_data;
+	struct rxrpc_local *local;
 	struct rxrpc_peer *peer;
 	struct sk_buff *skb;
 
-	if (unlikely(!local))
+	rcu_read_lock();
+	local = rcu_dereference_sk_user_data(sk);
+	if (unlikely(!local)) {
+		rcu_read_unlock();
 		return;
-
+	}
 	_enter("%p{%d}", sk, local->debug_id);
 
 	/* Clear the outstanding error value on the socket so that it doesn't
@@ -163,6 +166,7 @@ void rxrpc_error_report(struct sock *sk)
 
 	skb = sock_dequeue_err_skb(sk);
 	if (!skb) {
+		rcu_read_unlock();
 		_leave("UDP socket errqueue empty");
 		return;
 	}
@@ -170,11 +174,11 @@ void rxrpc_error_report(struct sock *sk)
 	serr = SKB_EXT_ERR(skb);
 	if (!skb->len && serr->ee.ee_origin == SO_EE_ORIGIN_TIMESTAMPING) {
 		_leave("UDP empty message");
+		rcu_read_unlock();
 		rxrpc_free_skb(skb, rxrpc_skb_freed);
 		return;
 	}
 
-	rcu_read_lock();
 	peer = rxrpc_lookup_peer_icmp_rcu(local, skb, &srx);
 	if (peer && !rxrpc_get_peer_maybe(peer))
 		peer = NULL;
-- 
2.20.1



