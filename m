Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0BF987BAC
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406518AbfHINqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406924AbfHINqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACAE02171F;
        Fri,  9 Aug 2019 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358371;
        bh=RkWgbaP0z7+WD+QgWN07YaCbTxNTfwFHr/z1yWrNCgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RW5GcGOKxHFoOmnKdJ91AnIQVi87szU6YeLt2rpDAr9bOKtVT5gHSx0+Bb+jiGVUb
         b/IqQ9i5ZcaaBh0vmFTzr0uG7gnVrYL2TNGTUIImyQAAlyw7i8th5gcRVex7fIh3cn
         bgOJA8r/C8qS6F0MrBLvay7hL77U4wbOcajarEPc=
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
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 05/21] tcp: be more careful in tcp_fragment()
Date:   Fri,  9 Aug 2019 15:45:09 +0200
Message-Id: <20190809134241.798600233@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h     | 17 +++++++++++++++++
 net/ipv4/tcp_output.c | 11 ++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 77438a8406ecf..0410fd29d5695 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1526,6 +1526,23 @@ static inline void tcp_check_send_head(struct sock *sk, struct sk_buff *skb_unli
 		tcp_sk(sk)->highest_sack = NULL;
 }
 
+static inline struct sk_buff *tcp_rtx_queue_head(const struct sock *sk)
+{
+	struct sk_buff *skb = tcp_write_queue_head(sk);
+
+	if (skb == tcp_send_head(sk))
+		skb = NULL;
+
+	return skb;
+}
+
+static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
+{
+	struct sk_buff *skb = tcp_send_head(sk);
+
+	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
+}
+
 static inline void __tcp_add_write_queue_tail(struct sock *sk, struct sk_buff *skb)
 {
 	__skb_queue_tail(&sk->sk_write_queue, skb);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 53edd60fd3817..76ffce0c18aeb 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1151,6 +1151,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *buff;
 	int nsize, old_factor;
+	long limit;
 	int nlen;
 	u8 flags;
 
@@ -1161,7 +1162,15 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf + 0x20000)) {
+	/* tcp_sendmsg() can overshoot sk_wmem_queued by one full size skb.
+	 * We need some allowance to not penalize applications setting small
+	 * SO_SNDBUF values.
+	 * Also allow first and last skb in retransmit queue to be split.
+	 */
+	limit = sk->sk_sndbuf + 2 * SKB_TRUESIZE(GSO_MAX_SIZE);
+	if (unlikely((sk->sk_wmem_queued >> 1) > limit &&
+		     skb != tcp_rtx_queue_head(sk) &&
+		     skb != tcp_rtx_queue_tail(sk))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}
-- 
2.20.1



