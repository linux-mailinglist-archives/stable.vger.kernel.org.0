Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A662C0B33
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388885AbgKWNVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:21:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732115AbgKWMij (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0361E208C3;
        Mon, 23 Nov 2020 12:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135117;
        bh=+sK01hi0rnrA/lMt/5EK4AdiyttN3Lz8ctblLdB3zBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ta29MHAI1y8HlAcXTpeVX2K2jGw3JGe+wDev7X1J9EOLRQYV9XeGo+XEDanIWO0sr
         2HwM08gUUF+vKew+lHkqvP+sc8YlfAgpdbqoG70WFb+6oalzAPUYsUUi1qR8QONbT/
         dy9gl+SdPk9EiPUYigFlMLz41JA9uEa8Lsx5i3zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/158] bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self
Date:   Mon, 23 Nov 2020 13:22:18 +0100
Message-Id: <20201123121825.244351034@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 6fa9201a898983da731fca068bb4b5c941537588 ]

If a socket redirects to itself and it is under memory pressure it is
possible to get a socket stuck so that recv() returns EAGAIN and the
socket can not advance for some time. This happens because when
redirecting a skb to the same socket we received the skb on we first
check if it is OK to enqueue the skb on the receiving socket by checking
memory limits. But, if the skb is itself the object holding the memory
needed to enqueue the skb we will keep retrying from kernel side
and always fail with EAGAIN. Then userspace will get a recv() EAGAIN
error if there are no skbs in the psock ingress queue. This will continue
until either some skbs get kfree'd causing the memory pressure to
reduce far enough that we can enqueue the pending packet or the
socket is destroyed. In some cases its possible to get a socket
stuck for a noticeable amount of time if the socket is only receiving
skbs from sk_skb verdict programs. To reproduce I make the socket
memory limits ridiculously low so sockets are always under memory
pressure. More often though if under memory pressure it looks like
a spurious EAGAIN error on user space side causing userspace to retry
and typically enough has moved on the memory side that it works.

To fix skip memory checks and skb_orphan if receiving on the same
sock as already assigned.

For SK_PASS cases this is easy, its always the same socket so we
can just omit the orphan/set_owner pair.

For backlog cases we need to check skb->sk and decide if the orphan
and set_owner pair are needed.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/160556572660.73229.12566203819812939627.stgit@john-XPS-13-9370
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 72 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 19 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ddb1b7d94c998..17cc1edd149cb 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -399,38 +399,38 @@ out:
 }
 EXPORT_SYMBOL_GPL(sk_msg_memcopy_from_iter);
 
-static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
+static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
+						  struct sk_buff *skb)
 {
-	struct sock *sk = psock->sk;
-	int copied = 0, num_sge;
 	struct sk_msg *msg;
 
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
-		return -EAGAIN;
+		return NULL;
+
+	if (!sk_rmem_schedule(sk, skb, skb->truesize))
+		return NULL;
 
 	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	if (unlikely(!msg))
-		return -EAGAIN;
-	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
-		kfree(msg);
-		return -EAGAIN;
-	}
+		return NULL;
 
 	sk_msg_init(msg);
-	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
+	return msg;
+}
+
+static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
+					struct sk_psock *psock,
+					struct sock *sk,
+					struct sk_msg *msg)
+{
+	int num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
+	int copied;
+
 	if (unlikely(num_sge < 0)) {
 		kfree(msg);
 		return num_sge;
 	}
 
-	/* This will transition ownership of the data from the socket where
-	 * the BPF program was run initiating the redirect to the socket
-	 * we will eventually receive this data on. The data will be released
-	 * from skb_consume found in __tcp_bpf_recvmsg() after its been copied
-	 * into user buffers.
-	 */
-	skb_set_owner_r(skb, sk);
-
 	copied = skb->len;
 	msg->sg.start = 0;
 	msg->sg.size = copied;
@@ -442,6 +442,40 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	return copied;
 }
 
+static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
+{
+	struct sock *sk = psock->sk;
+	struct sk_msg *msg;
+
+	msg = sk_psock_create_ingress_msg(sk, skb);
+	if (!msg)
+		return -EAGAIN;
+
+	/* This will transition ownership of the data from the socket where
+	 * the BPF program was run initiating the redirect to the socket
+	 * we will eventually receive this data on. The data will be released
+	 * from skb_consume found in __tcp_bpf_recvmsg() after its been copied
+	 * into user buffers.
+	 */
+	skb_set_owner_r(skb, sk);
+	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+}
+
+/* Puts an skb on the ingress queue of the socket already assigned to the
+ * skb. In this case we do not need to check memory limits or skb_set_owner_r
+ * because the skb is already accounted for here.
+ */
+static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb)
+{
+	struct sk_msg *msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
+	struct sock *sk = psock->sk;
+
+	if (unlikely(!msg))
+		return -EAGAIN;
+	sk_msg_init(msg);
+	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+}
+
 static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 			       u32 off, u32 len, bool ingress)
 {
@@ -787,7 +821,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		 * retrying later from workqueue.
 		 */
 		if (skb_queue_empty(&psock->ingress_skb)) {
-			err = sk_psock_skb_ingress(psock, skb);
+			err = sk_psock_skb_ingress_self(psock, skb);
 		}
 		if (err < 0) {
 			skb_queue_tail(&psock->ingress_skb, skb);
-- 
2.27.0



