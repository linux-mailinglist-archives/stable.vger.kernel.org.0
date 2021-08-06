Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C513E25CB
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244345AbhHFIWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244137AbhHFIVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22EC6606A5;
        Fri,  6 Aug 2021 08:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238059;
        bh=LZf9PPRYKxEEZ+oplejD0zgRJqNJQO6ub14WE+rHuD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlZV8XRs2cJBqHOltA8vYurwuEwTYtIy4tdGt3rEEk8+ss4xCwv7C/AjZSWrpQEPW
         mbIMr5ZQRMzuCPmEStaBmEWkHCrXMG2p2TuJdIJ84jpyfTWVFUq0Cbr+JobrPOOkwj
         kbGh46yQ/iUzMT1RF6mRaYCJaaWVUg/C7X0phS+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 04/35] skmsg: Increase sk->sk_drops when dropping packets
Date:   Fri,  6 Aug 2021 10:16:47 +0200
Message-Id: <20210806081113.860850432@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 781dd0431eb549f9cb1fdddf91a50d985febe884 ]

It is hard to observe packet drops without increasing relevant
drop counters, here we should increase sk->sk_drops which is
a protocol-independent counter. Fortunately psock is always
associated with a struct sock, we can just use psock->sk.

Suggested-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210615021342.7416-9-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 45b3a3adc886..d428368a0d87 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -607,6 +607,12 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 	return sk_psock_skb_ingress(psock, skb);
 }
 
+static void sock_drop(struct sock *sk, struct sk_buff *skb)
+{
+	sk_drops_add(sk, skb);
+	kfree_skb(skb);
+}
+
 static void sk_psock_backlog(struct work_struct *work)
 {
 	struct sk_psock *psock = container_of(work, struct sk_psock, work);
@@ -646,7 +652,7 @@ static void sk_psock_backlog(struct work_struct *work)
 				/* Hard errors break pipe and stop xmit. */
 				sk_psock_report_error(psock, ret ? -ret : EPIPE);
 				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
-				kfree_skb(skb);
+				sock_drop(psock->sk, skb);
 				goto end;
 			}
 			off += ret;
@@ -737,7 +743,7 @@ static void __sk_psock_zap_ingress(struct sk_psock *psock)
 
 	while ((skb = skb_dequeue(&psock->ingress_skb)) != NULL) {
 		skb_bpf_redirect_clear(skb);
-		kfree_skb(skb);
+		sock_drop(psock->sk, skb);
 	}
 	__sk_psock_purge_ingress_msg(psock);
 }
@@ -863,7 +869,7 @@ static int sk_psock_skb_redirect(struct sk_buff *skb)
 	 * return code, but then didn't set a redirect interface.
 	 */
 	if (unlikely(!sk_other)) {
-		kfree_skb(skb);
+		sock_drop(from->sk, skb);
 		return -EIO;
 	}
 	psock_other = sk_psock(sk_other);
@@ -873,14 +879,14 @@ static int sk_psock_skb_redirect(struct sk_buff *skb)
 	 */
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
 		skb_bpf_redirect_clear(skb);
-		kfree_skb(skb);
+		sock_drop(from->sk, skb);
 		return -EIO;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
 	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
 		skb_bpf_redirect_clear(skb);
-		kfree_skb(skb);
+		sock_drop(from->sk, skb);
 		return -EIO;
 	}
 
@@ -970,7 +976,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 	case __SK_DROP:
 	default:
 out_free:
-		kfree_skb(skb);
+		sock_drop(psock->sk, skb);
 	}
 
 	return err;
@@ -1005,7 +1011,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 	sk = strp->sk;
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
-		kfree_skb(skb);
+		sock_drop(sk, skb);
 		goto out;
 	}
 	prog = READ_ONCE(psock->progs.stream_verdict);
@@ -1126,7 +1132,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
 		len = 0;
-		kfree_skb(skb);
+		sock_drop(sk, skb);
 		goto out;
 	}
 	prog = READ_ONCE(psock->progs.stream_verdict);
-- 
2.30.2



