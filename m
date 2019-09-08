Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D4BACD2B
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfIHMqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730361AbfIHMqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:46:22 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8584D218AC;
        Sun,  8 Sep 2019 12:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946781;
        bh=8cxZQoccA38riXltPcjcux5V2PVhcAp6o3vBVpqBvV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4zSU3CKkxo452lctryN9nZB3nAUvimCLefJSEl7qLdqE+jFGi+hhR3FTAaY7xNvE
         OztdnVBBhWAsKD33ORFd6ASzGdjj4aoRbBS7YeyTt+dvJkP+O3L0xL8XHQ4zeenpRt
         TTivcMUwfnDVn+273TvPrtGZCKP4+7/cvH75gArs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 37/40] tcp: remove empty skb from write queue in error cases
Date:   Sun,  8 Sep 2019 13:42:10 +0100
Message-Id: <20190908121132.072577101@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
References: <20190908121114.260662089@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fdfc5c8594c24c5df883583ebd286321a80e0a67 ]

Vladimir Rutsky reported stuck TCP sessions after memory pressure
events. Edge Trigger epoll() user would never receive an EPOLLOUT
notification allowing them to retry a sendmsg().

Jason tested the case of sk_stream_alloc_skb() returning NULL,
but there are other paths that could lead both sendmsg() and sendpage()
to return -1 (EAGAIN), with an empty skb queued on the write queue.

This patch makes sure we remove this empty skb so that
Jason code can detect that the queue is empty, and
call sk->sk_write_space(sk) accordingly.

Fixes: ce5ec440994b ("tcp: ensure epoll edge trigger wakeup when write queue is empty")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Reported-by: Vladimir Rutsky <rutsky@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -914,6 +914,22 @@ static int tcp_send_mss(struct sock *sk,
 	return mss_now;
 }
 
+/* In some cases, both sendpage() and sendmsg() could have added
+ * an skb to the write queue, but failed adding payload on it.
+ * We need to remove it to consume less memory, but more
+ * importantly be able to generate EPOLLOUT for Edge Trigger epoll()
+ * users.
+ */
+static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
+{
+	if (skb && !skb->len) {
+		tcp_unlink_write_queue(skb, sk);
+		if (tcp_write_queue_empty(sk))
+			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
+		sk_wmem_free_skb(sk, skb);
+	}
+}
+
 ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 			 size_t size, int flags)
 {
@@ -1034,6 +1050,7 @@ out:
 	return copied;
 
 do_error:
+	tcp_remove_empty_skb(sk, tcp_write_queue_tail(sk));
 	if (copied)
 		goto out;
 out_err:
@@ -1412,17 +1429,11 @@ out_nopush:
 	sock_zerocopy_put(uarg);
 	return copied + copied_syn;
 
+do_error:
+	skb = tcp_write_queue_tail(sk);
 do_fault:
-	if (!skb->len) {
-		tcp_unlink_write_queue(skb, sk);
-		/* It is the one place in all of TCP, except connection
-		 * reset, where we can be unlinking the send_head.
-		 */
-		tcp_check_send_head(sk, skb);
-		sk_wmem_free_skb(sk, skb);
-	}
+	tcp_remove_empty_skb(sk, skb);
 
-do_error:
 	if (copied + copied_syn)
 		goto out;
 out_err:


