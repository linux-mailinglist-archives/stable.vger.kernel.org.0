Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4703D6062
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhGZPWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236832AbhGZPWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31B6060E09;
        Mon, 26 Jul 2021 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315351;
        bh=VRE5bSpf18f+dHUFqZrYTKAhh4tgXuEPHpXLDJDLOco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNWmg7Yebe2DN4g88BeldGVamgUAmoTj7LSz40W0ax+qY7qoaemTWHVkXlh5r8wIr
         N3p3ze+LdV1SKTZbeLb+naHDEVZjyffXEqo4T0r7iYEBEWBsF/1aIVYPaHyJkYaALp
         zqmKIPDrlQLLunF4GgtWQx7Yyvr2EX1SUGgcyZ14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/167] bpf, sockmap: Fix potential memory leak on unlikely error case
Date:   Mon, 26 Jul 2021 17:38:14 +0200
Message-Id: <20210726153841.453111153@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index 923a1d0f84ca..c4c224a5b9de 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -433,10 +433,8 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
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
@@ -455,6 +453,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 {
 	struct sock *sk = psock->sk;
 	struct sk_msg *msg;
+	int err;
 
 	/* If we are receiving on the same sock skb->sk is already assigned,
 	 * skip memory accounting and owner transition seeing it already set
@@ -473,7 +472,10 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
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
@@ -484,12 +486,16 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
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



