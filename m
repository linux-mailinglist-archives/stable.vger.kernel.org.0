Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AFE3C5402
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349368AbhGLH4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351559AbhGLHv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CC7661158;
        Mon, 12 Jul 2021 07:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076146;
        bh=1wh+hlo9u7tbMYgp8IqsJ9IsTLEOF8v0TxXfNHENTs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/isvR+xGDzun3YI5VIuO7/pMhmab99lWMzcgfBjYqRCELo4i/ZrF51DC5rK9idpA
         ZJiCQvbxfYKQHEyMviquftndawKG/D7SElra0Jny3W2FVl4fC2kl2qbdYIkWor5ZCr
         oCQk4tTu+KJMgisCkLYi0rXlD1xBGeVuD7OKSlw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 516/800] skmsg: Teach sk_psock_verdict_apply() to return errors
Date:   Mon, 12 Jul 2021 08:08:59 +0200
Message-Id: <20210712061022.130838491@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 1581a6c1c3291a8320b080f4411345f60229976d ]

Currently sk_psock_verdict_apply() is void, but it handles some
error conditions too. Its caller is impossible to learn whether
it succeeds or fails, especially sk_psock_verdict_recv().

Make it return int to indicate error cases and propagate errors
to callers properly.

Fixes: ef5659280eb1 ("bpf, sockmap: Allow skipping sk_skb parser program")
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210615021342.7416-7-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index dd22ca838754..539c83a45665 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -847,7 +847,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 
-static void sk_psock_skb_redirect(struct sk_buff *skb)
+static int sk_psock_skb_redirect(struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
@@ -858,7 +858,7 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	 */
 	if (unlikely(!sk_other)) {
 		kfree_skb(skb);
-		return;
+		return -EIO;
 	}
 	psock_other = sk_psock(sk_other);
 	/* This error indicates the socket is being torn down or had another
@@ -868,19 +868,20 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
 		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
-		return;
+		return -EIO;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
 	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
 		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
-		return;
+		return -EIO;
 	}
 
 	skb_queue_tail(&psock_other->ingress_skb, skb);
 	schedule_work(&psock_other->work);
 	spin_unlock_bh(&psock_other->ingress_lock);
+	return 0;
 }
 
 static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int verdict)
@@ -917,14 +918,15 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 
-static void sk_psock_verdict_apply(struct sk_psock *psock,
-				   struct sk_buff *skb, int verdict)
+static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
+				  int verdict)
 {
 	struct sock *sk_other;
-	int err = -EIO;
+	int err = 0;
 
 	switch (verdict) {
 	case __SK_PASS:
+		err = -EIO;
 		sk_other = psock->sk;
 		if (sock_flag(sk_other, SOCK_DEAD) ||
 		    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
@@ -957,13 +959,15 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		}
 		break;
 	case __SK_REDIRECT:
-		sk_psock_skb_redirect(skb);
+		err = sk_psock_skb_redirect(skb);
 		break;
 	case __SK_DROP:
 	default:
 out_free:
 		kfree_skb(skb);
 	}
+
+	return err;
 }
 
 static void sk_psock_write_space(struct sock *sk)
@@ -1130,7 +1134,8 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
-	sk_psock_verdict_apply(psock, skb, ret);
+	if (sk_psock_verdict_apply(psock, skb, ret) < 0)
+		len = 0;
 out:
 	rcu_read_unlock();
 	return len;
-- 
2.30.2



