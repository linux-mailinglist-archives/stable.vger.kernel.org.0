Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445041212B1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfLPRzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727390AbfLPRzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:55:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E79205ED;
        Mon, 16 Dec 2019 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518913;
        bh=DYeh9forBhYUxyxk7ChjjS288K8KaqAK00EUlOonP8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1CkM2IEdd3q5B/tmdPrvHpmlAb9QKhBNjG1I1NJkHEnFW8XkcBW3ox48eDxvDv5D
         3gwsvF2rd3fCfrZ0iqhx3cnQcCs6/K7mJOPZeG40cn36a260jaVsPlhOQUXqseGlOF
         sBy4JV/1oQ6/zdncysMLECacqoV7NhimD3IupEq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 119/267] tcp: exit if nothing to retransmit on RTO timeout
Date:   Mon, 16 Dec 2019 18:47:25 +0100
Message-Id: <20191216174903.234158752@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Two upstream commits squashed together for v4.14 stable :

 commit 88f8598d0a302a08380eadefd09b9f5cb1c4c428 upstream.

  Previously TCP only warns if its RTO timer fires and the
  retransmission queue is empty, but it'll cause null pointer
  reference later on. It's better to avoid such catastrophic failure
  and simply exit with a warning.

Squashed with "tcp: refactor tcp_retransmit_timer()" :

 commit 0d580fbd2db084a5c96ee9c00492236a279d5e0f upstream.

  It appears linux-4.14 stable needs a backport of commit
  88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")

  Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
  let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -413,6 +413,7 @@ void tcp_retransmit_timer(struct sock *s
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct sk_buff *skb;
 
 	if (tp->fastopen_rsk) {
 		WARN_ON_ONCE(sk->sk_state != TCP_SYN_RECV &&
@@ -423,10 +424,13 @@ void tcp_retransmit_timer(struct sock *s
 		 */
 		return;
 	}
+
 	if (!tp->packets_out)
-		goto out;
+		return;
 
-	WARN_ON(tcp_write_queue_empty(sk));
+	skb = tcp_rtx_queue_head(sk);
+	if (WARN_ON_ONCE(!skb))
+		return;
 
 	tp->tlp_high_seq = 0;
 
@@ -459,7 +463,7 @@ void tcp_retransmit_timer(struct sock *s
 			goto out;
 		}
 		tcp_enter_loss(sk);
-		tcp_retransmit_skb(sk, tcp_write_queue_head(sk), 1);
+		tcp_retransmit_skb(sk, skb, 1);
 		__sk_dst_reset(sk);
 		goto out_reset_timer;
 	}


