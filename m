Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F503D618B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhGZPcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238219AbhGZP34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B56C60240;
        Mon, 26 Jul 2021 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315823;
        bh=CF7GFJy7KTFzpoOWMamtE3v9ARq/1RU6cio6suD5H7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/c2IJJcc9Dk9uSRi8FkUnDxY4lboiTRJYKgDi/vKi5PyTSrErJHArGVxHJ3K/qeL
         x1Oj/O83DeujK/x21O8Hh/FIZPhVaYI31PooihuL9aL4Dslj/MDWuQeyPX6jkUDjju
         iSiRRyZO4keTHGO2NK2LFs8ySaaO8nB6P6fJtZ40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 082/223] bpf, sockmap: Fix potential memory leak on unlikely error case
Date:   Mon, 26 Jul 2021 17:37:54 +0200
Message-Id: <20210726153848.927007604@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 7e6b27a69167f97c56b5437871d29e9722c3e470 ]

If skb_linearize is needed and fails we could leak a msg on the error
handling. To fix ensure we kfree the msg block before returning error.
Found during code review.

Fixes: 4363023d2668e ("bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/bpf/20210712195546.423990-2-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 539c83a45665..b2410a1bfa23 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -531,10 +531,8 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	if (skb_linearize(skb))
 		return -EAGAIN;
 	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
-	if (unlikely(num_sge < 0)) {
-		kfree(msg);
+	if (unlikely(num_sge < 0))
 		return num_sge;
-	}
 
 	copied = skb->len;
 	msg->sg.start = 0;
@@ -553,6 +551,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 {
 	struct sock *sk = psock->sk;
 	struct sk_msg *msg;
+	int err;
 
 	/* If we are receiving on the same sock skb->sk is already assigned,
 	 * skip memory accounting and owner transition seeing it already set
@@ -571,7 +570,10 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * into user buffers.
 	 */
 	skb_set_owner_r(skb, sk);
-	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	if (err < 0)
+		kfree(msg);
+	return err;
 }
 
 /* Puts an skb on the ingress queue of the socket already assigned to the
@@ -582,12 +584,16 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 {
 	struct sk_msg *msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	struct sock *sk = psock->sk;
+	int err;
 
 	if (unlikely(!msg))
 		return -EAGAIN;
 	sk_msg_init(msg);
 	skb_set_owner_r(skb, sk);
-	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	if (err < 0)
+		kfree(msg);
+	return err;
 }
 
 static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
-- 
2.30.2



