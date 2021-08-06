Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3BF3E25CF
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244351AbhHFIWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243303AbhHFIV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:21:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB0B61167;
        Fri,  6 Aug 2021 08:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238062;
        bh=eEKZqAgjmEcThEttKHyKHo1qwFUoMaa+zEpU6hFzRxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieQucogLeaNFMprxBWhmJ+ZLCr0uEgVI/kXdU1LOoUhvA1+OMoEgKPK1qHekOAFaE
         cm/4W1pzQVKvYMVXmm59SfMSfA00SwwpWH3z/6L1oakRCRUyP9zNcqx0yn0KKlW2hr
         z+tAQWmXf0oVt0DnOYGSIGsxTQDuNMFYB8m4m3+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 05/35] skmsg: Pass source psock to sk_psock_skb_redirect()
Date:   Fri,  6 Aug 2021 10:16:48 +0200
Message-Id: <20210806081113.890848812@linuxfoundation.org>
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

[ Upstream commit 42830571f1fd9751b3fbf38084bbb253320e185f ]

sk_psock_skb_redirect() only takes skb as a parameter, we
will need to know where this skb is from, so just pass
the source psock to this function as a new parameter.
This patch prepares for the next one.

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210615021342.7416-8-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index d428368a0d87..b088fe07fc00 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -859,7 +859,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 }
 EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 
-static int sk_psock_skb_redirect(struct sk_buff *skb)
+static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
@@ -896,11 +896,12 @@ static int sk_psock_skb_redirect(struct sk_buff *skb)
 	return 0;
 }
 
-static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int verdict)
+static void sk_psock_tls_verdict_apply(struct sk_buff *skb,
+				       struct sk_psock *from, int verdict)
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
-		sk_psock_skb_redirect(skb);
+		sk_psock_skb_redirect(from, skb);
 		break;
 	case __SK_PASS:
 	case __SK_DROP:
@@ -924,7 +925,7 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
-	sk_psock_tls_verdict_apply(skb, psock->sk, ret);
+	sk_psock_tls_verdict_apply(skb, psock, ret);
 	rcu_read_unlock();
 	return ret;
 }
@@ -971,7 +972,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		}
 		break;
 	case __SK_REDIRECT:
-		err = sk_psock_skb_redirect(skb);
+		err = sk_psock_skb_redirect(psock, skb);
 		break;
 	case __SK_DROP:
 	default:
-- 
2.30.2



