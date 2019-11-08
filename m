Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FCAF5584
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390660AbfKHTC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387457AbfKHTC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35AB5215EA;
        Fri,  8 Nov 2019 19:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239775;
        bh=WmOcJMhOy+iSbGh+HRZw31aZbXaM0RzcRwAY467U6fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlvQd4sCeV90xYKexsz5L8TwpBRUhJNdY4PhIWT7lDDBMjq+ik97bU707uiDilBhF
         NeobbkUqLSKzgboFNhrxMJrQEfcrNPVirDThzBT3b3tf5viLvItNuPDbbufj/HsSVB
         FgDxxbbbagYLpdEyXqVuytuIHc3uQ9vZoBw17yeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 57/79] net: use skb_queue_empty_lockless() in busy poll contexts
Date:   Fri,  8 Nov 2019 19:50:37 +0100
Message-Id: <20191108174819.403194786@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
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
@@ -1716,7 +1716,7 @@ int chtls_recvmsg(struct sock *sk, struc
 		return peekmsg(sk, msg, len, nonblock, flags);
 
 	if (sk_can_busy_loop(sk) &&
-	    skb_queue_empty(&sk->sk_receive_queue) &&
+	    skb_queue_empty_lockless(&sk->sk_receive_queue) &&
 	    sk->sk_state == TCP_ESTABLISHED)
 		sk_busy_loop(sk, nonblock);
 
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -279,7 +279,7 @@ struct sk_buff *__skb_try_recv_datagram(
 			break;
 
 		sk_busy_loop(sk, flags & MSG_DONTWAIT);
-	} while (sk->sk_receive_queue.prev != *last);
+	} while (READ_ONCE(sk->sk_receive_queue.prev) != *last);
 
 	error = -EAGAIN;
 
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3483,7 +3483,7 @@ bool sk_busy_loop_end(void *p, unsigned
 {
 	struct sock *sk = p;
 
-	return !skb_queue_empty(&sk->sk_receive_queue) ||
+	return !skb_queue_empty_lockless(&sk->sk_receive_queue) ||
 	       sk_busy_loop_timeout(sk, start_time);
 }
 EXPORT_SYMBOL(sk_busy_loop_end);
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1948,7 +1948,7 @@ int tcp_recvmsg(struct sock *sk, struct
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
-	if (sk_can_busy_loop(sk) && skb_queue_empty(&sk->sk_receive_queue) &&
+	if (sk_can_busy_loop(sk) && skb_queue_empty_lockless(&sk->sk_receive_queue) &&
 	    (sk->sk_state == TCP_ESTABLISHED))
 		sk_busy_loop(sk, nonblock);
 
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8334,7 +8334,7 @@ struct sk_buff *sctp_skb_recv_datagram(s
 		if (sk_can_busy_loop(sk)) {
 			sk_busy_loop(sk, noblock);
 
-			if (!skb_queue_empty(&sk->sk_receive_queue))
+			if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 				continue;
 		}
 


