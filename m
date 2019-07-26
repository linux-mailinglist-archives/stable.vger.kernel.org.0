Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7303B76D9D
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389506AbfGZPch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389489AbfGZPcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:32:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3463322CBD;
        Fri, 26 Jul 2019 15:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155154;
        bh=psKLgr5doZxAykiCMrNVLh/WfEgRaqJgeuPExRYmPpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s22IF84VTEKHOzWpM9fJs7STa7eWZe42qKk2DpRFxGsJjofmo/5XwHf83A3hTOzvH
         +vyRLlBDyL/P9vIhBb9OaTiqFWrrcxq6zk79q8y9y54MnKO6DL3Q4KourAH8PSG92U
         BOM+fJdRZ45uoZ3QSoLGLcpsBxGzuY1Xk+ZOp3Uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Prout <aprout@ll.mit.edu>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Jonathan Looney <jtl@netflix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 20/50] tcp: be more careful in tcp_fragment()
Date:   Fri, 26 Jul 2019 17:24:55 +0200
Message-Id: <20190726152302.653452094@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b617158dc096709d8600c53b6052144d12b89fab ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h     |    5 +++++
 net/ipv4/tcp_output.c |   13 +++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1646,6 +1646,11 @@ static inline struct sk_buff *tcp_rtx_qu
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
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1289,6 +1289,7 @@ int tcp_fragment(struct sock *sk, enum t
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *buff;
 	int nsize, old_factor;
+	long limit;
 	int nlen;
 	u8 flags;
 
@@ -1299,8 +1300,16 @@ int tcp_fragment(struct sock *sk, enum t
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


