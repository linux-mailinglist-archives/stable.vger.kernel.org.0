Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807BA2C085E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbgKWMtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732876AbgKWMtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 445182158C;
        Mon, 23 Nov 2020 12:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135751;
        bh=JmS8CxDV314MF4Bfjg+ViKziSFyaKBDWi0Zl/JzIv/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2sStCZNhXkbgL1TTK4xuvM5aC6+BNoEJSJxCR3jM4TK4gnPfWSFwkwTGshHtDepaZ
         zsj0NnoX4TxnozCWfCp5vTADM5KM0vdmmDCRc5zfoFTUJxFerFhcEWj9LKs8G43j8C
         HzLSn4ENxA+yfteh+1Yi1R3pS+AnNZ7IAYpQybGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 152/252] bpf, sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
Date:   Mon, 23 Nov 2020 13:21:42 +0100
Message-Id: <20201123121842.926766955@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 36cd0e696a832a00247fca522034703566ac8885 ]

Fix sockmap sk_skb programs so that they observe sk_rcvbuf limits. This
allows users to tune SO_RCVBUF and sockmap will honor them.

We can refactor the if(charge) case out in later patches. But, keep this
fix to the point.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/160556568657.73229.8404601585878439060.stgit@john-XPS-13-9370
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c   | 20 ++++++++++++++++----
 net/ipv4/tcp_bpf.c |  3 ++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 30ddca6db6c6b..f41b06e60ad90 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -170,10 +170,12 @@ static int sk_msg_free_elem(struct sock *sk, struct sk_msg *msg, u32 i,
 	struct scatterlist *sge = sk_msg_elem(msg, i);
 	u32 len = sge->length;
 
-	if (charge)
-		sk_mem_uncharge(sk, len);
-	if (!msg->skb)
+	/* When the skb owns the memory we free it from consume_skb path. */
+	if (!msg->skb) {
+		if (charge)
+			sk_mem_uncharge(sk, len);
 		put_page(sg_page(sge));
+	}
 	memset(sge, 0, sizeof(*sge));
 	return len;
 }
@@ -403,6 +405,9 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	int copied = 0, num_sge;
 	struct sk_msg *msg;
 
+	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
+		return -EAGAIN;
+
 	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	if (unlikely(!msg))
 		return -EAGAIN;
@@ -418,7 +423,14 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 		return num_sge;
 	}
 
-	sk_mem_charge(sk, skb->len);
+	/* This will transition ownership of the data from the socket where
+	 * the BPF program was run initiating the redirect to the socket
+	 * we will eventually receive this data on. The data will be released
+	 * from skb_consume found in __tcp_bpf_recvmsg() after its been copied
+	 * into user buffers.
+	 */
+	skb_set_owner_r(skb, sk);
+
 	copied = skb->len;
 	msg->sg.start = 0;
 	msg->sg.size = copied;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index d85ba32dc6e7a..24e1be45d4cd7 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -45,7 +45,8 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 			if (likely(!peek)) {
 				sge->offset += copy;
 				sge->length -= copy;
-				sk_mem_uncharge(sk, copy);
+				if (!msg_rx->skb)
+					sk_mem_uncharge(sk, copy);
 				msg_rx->sg.size -= copy;
 
 				if (!sge->length) {
-- 
2.27.0



