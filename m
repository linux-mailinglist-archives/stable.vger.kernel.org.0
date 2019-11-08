Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FAEF5677
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391727AbfKHTJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390974AbfKHTJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E9312087E;
        Fri,  8 Nov 2019 19:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240139;
        bh=sKHY9Dd94AFbprDlS8ebwtCQSa7E7TSTpXFGfINHDFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxVHc8JlgYh6akklhVwi0zSKVGvyup0Z1HbsV8p1AUWOxbseSxf+r+HTjUES8gLss
         csowlyYXJvFhq0riT75dT8S67SwyVjklcXMBExN6f44tXk0h6/3ik5M7QoSf8OTwXq
         Lf297L6Zj357ISN5ereVgi5p295p4u0IPd1Z4k24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 101/140] net: use skb_queue_empty_lockless() in busy poll contexts
Date:   Fri,  8 Nov 2019 19:50:29 +0100
Message-Id: <20191108174911.338812481@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3f926af3f4d688e2e11e7f8ed04e277a14d4d4a4 ]

Busy polling usually runs without locks.
Let's use skb_queue_empty_lockless() instead of skb_queue_empty()

Also uses READ_ONCE() in __skb_try_recv_datagram() to address
a similar potential problem.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_io.c |    2 +-
 net/core/datagram.c                     |    2 +-
 net/core/sock.c                         |    2 +-
 net/ipv4/tcp.c                          |    2 +-
 net/sctp/socket.c                       |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1701,7 +1701,7 @@ int chtls_recvmsg(struct sock *sk, struc
 		return peekmsg(sk, msg, len, nonblock, flags);
 
 	if (sk_can_busy_loop(sk) &&
-	    skb_queue_empty(&sk->sk_receive_queue) &&
+	    skb_queue_empty_lockless(&sk->sk_receive_queue) &&
 	    sk->sk_state == TCP_ESTABLISHED)
 		sk_busy_loop(sk, nonblock);
 
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -278,7 +278,7 @@ struct sk_buff *__skb_try_recv_datagram(
 			break;
 
 		sk_busy_loop(sk, flags & MSG_DONTWAIT);
-	} while (sk->sk_receive_queue.prev != *last);
+	} while (READ_ONCE(sk->sk_receive_queue.prev) != *last);
 
 	error = -EAGAIN;
 
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3593,7 +3593,7 @@ bool sk_busy_loop_end(void *p, unsigned
 {
 	struct sock *sk = p;
 
-	return !skb_queue_empty(&sk->sk_receive_queue) ||
+	return !skb_queue_empty_lockless(&sk->sk_receive_queue) ||
 	       sk_busy_loop_timeout(sk, start_time);
 }
 EXPORT_SYMBOL(sk_busy_loop_end);
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1961,7 +1961,7 @@ int tcp_recvmsg(struct sock *sk, struct
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
-	if (sk_can_busy_loop(sk) && skb_queue_empty(&sk->sk_receive_queue) &&
+	if (sk_can_busy_loop(sk) && skb_queue_empty_lockless(&sk->sk_receive_queue) &&
 	    (sk->sk_state == TCP_ESTABLISHED))
 		sk_busy_loop(sk, nonblock);
 
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8724,7 +8724,7 @@ struct sk_buff *sctp_skb_recv_datagram(s
 		if (sk_can_busy_loop(sk)) {
 			sk_busy_loop(sk, noblock);
 
-			if (!skb_queue_empty(&sk->sk_receive_queue))
+			if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 				continue;
 		}
 


