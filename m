Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA5876606
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 14:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfGZMiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 08:38:21 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40939 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbfGZMiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 08:38:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9F2E6572;
        Fri, 26 Jul 2019 08:38:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 26 Jul 2019 08:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ymcBFN
        4+qUvOYjOr2w00VVQxIZyBF3+QD4E5eh9+G5o=; b=AMSFhc8wnxpMYIG7tiLL03
        btB8AgiWEpW0tDY4San6HNKaJvueT4fLP08guOYzKPSawr+Qyir95gsDq7MIuMcF
        WambtZB0zhnHczBQnE4efdxUnAnqBE4TfJtr06SBHMe7pi3Y1hqExRpZitPOqd4Q
        W2bS64AFhjQjkIBo083okNsNaRSvyARW49EwLqqMfb0P708Ij2uf254wBH2WX2xm
        Ak+AI3vEPEn6lVVqrwC3zT8PpVyFzdVGEgV3ZPDgvvsvzB7GXQvotYPhdtQuIqBU
        UfwZMC1t+RYLTwAAnBogl6oc818qMxWbR5Us3rWWlam8PuIIRbdliZ43Rn41DNsA
        ==
X-ME-Sender: <xms:OvQ6Xbjw5x_5e8zI4juIZ5ahUqxnmLqe92jDvIC2FPa9lynU318JTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:OvQ6XVbFJsh4cKpNJOpWiVLtLGOdWnxJgZRN23x3rwm2lUj7kDcfTw>
    <xmx:OvQ6XXE-92GMXsrUGbUyXkzTj37nWeu7Q3TBJO4ny3K9yxXpjHK9tQ>
    <xmx:OvQ6Xb-eVQi4xqOYStbFrd0LgWcA8Ri4Dx-JWIzZqaP0S-Zu_n723w>
    <xmx:O_Q6XeW12Zap1NS_5jNLCscXHqBMXF_1jDpiQTHk8t6Oi30-AukK0A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA81F80059;
        Fri, 26 Jul 2019 08:38:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tcp: be more careful in tcp_fragment()" failed to apply to 4.14-stable tree
To:     edumazet@google.com, aprout@ll.mit.edu, cpaasch@apple.com,
        davem@davemloft.net, jonathan.lemon@gmail.com, jtl@netflix.com,
        mkubecek@suse.cz, ncardwell@google.com, ycheng@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jul 2019 14:38:14 +0200
Message-ID: <1564144694159130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b617158dc096709d8600c53b6052144d12b89fab Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 19 Jul 2019 11:52:33 -0700
Subject: [PATCH] tcp: be more careful in tcp_fragment()

Some applications set tiny SO_SNDBUF values and expect
TCP to just work. Recent patches to address CVE-2019-11478
broke them in case of losses, since retransmits might
be prevented.

We should allow these flows to make progress.

This patch allows the first and last skb in retransmit queue
to be split even if memory limits are hit.

It also adds the some room due to the fact that tcp_sendmsg()
and tcp_sendpage() might overshoot sk_wmem_queued by about one full
TSO skb (64KB size). Note this allowance was already present
in stable backports for kernels < 4.15

Note for < 4.15 backports :
 tcp_rtx_queue_tail() will probably look like :

static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
{
	struct sk_buff *skb = tcp_send_head(sk);

	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
}

Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Andrew Prout <aprout@ll.mit.edu>
Tested-by: Andrew Prout <aprout@ll.mit.edu>
Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Tested-by: Michal Kubecek <mkubecek@suse.cz>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Christoph Paasch <cpaasch@apple.com>
Cc: Jonathan Looney <jtl@netflix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f42d300f0cfa..e5cf514ba118 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1709,6 +1709,11 @@ static inline struct sk_buff *tcp_rtx_queue_head(const struct sock *sk)
 	return skb_rb_first(&sk->tcp_rtx_queue);
 }
 
+static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
+{
+	return skb_rb_last(&sk->tcp_rtx_queue);
+}
+
 static inline struct sk_buff *tcp_write_queue_head(const struct sock *sk)
 {
 	return skb_peek(&sk->sk_write_queue);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 4af1f5dae9d3..6e4afc48d7bb 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1288,6 +1288,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *buff;
 	int nsize, old_factor;
+	long limit;
 	int nlen;
 	u8 flags;
 
@@ -1298,8 +1299,16 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
-		     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE)) {
+	/* tcp_sendmsg() can overshoot sk_wmem_queued by one full size skb.
+	 * We need some allowance to not penalize applications setting small
+	 * SO_SNDBUF values.
+	 * Also allow first and last skb in retransmit queue to be split.
+	 */
+	limit = sk->sk_sndbuf + 2 * SKB_TRUESIZE(GSO_MAX_SIZE);
+	if (unlikely((sk->sk_wmem_queued >> 1) > limit &&
+		     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE &&
+		     skb != tcp_rtx_queue_head(sk) &&
+		     skb != tcp_rtx_queue_tail(sk))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}

