Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F13C53FF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349395AbhGLH4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351483AbhGLHvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A228C61152;
        Mon, 12 Jul 2021 07:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076142;
        bh=vadZ6gUXTYIuU7UT1zYTcy7tACJLaraZF8s0C4ypvD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/+ie9w0YlEVFh5MlGMcFvXhnGKyKd/y4nmi1VpgvXU/OvnWNTPRzrkI5/8I3xzDJ
         V6QFer5QciqU1qRbbaREHKnqcRUFIj6qnSQzZQHix+AfLXr34XfB9etN1fLsE9gaBy
         3UjCVUrjta3E/GWGNoSMAP1pA/6FS2LD23tQkQro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 514/800] skmsg: Clear skb redirect pointer before dropping it
Date:   Mon, 12 Jul 2021 08:08:57 +0200
Message-Id: <20210712061021.906071469@linuxfoundation.org>
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

[ Upstream commit 30b9c54a707db4155735cf71f4600241c1b7b6ff ]

When we drop skb inside sk_psock_skb_redirect(), we have to clear
its skb->_sk_redir pointer too, otherwise kfree_skb() would
misinterpret it as a valid skb->_skb_refdst and dst_release()
would eventually complain.

Fixes: e3526bb92a20 ("skmsg: Move sk_redir from TCP_SKB_CB to skb")
Reported-by: Jiang Wang <jiang.wang@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210615021342.7416-5-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 43ce17a6a585..df545748cd6a 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -866,12 +866,14 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	 * a socket that is in this state so we drop the skb.
 	 */
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
+		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 		return;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
 	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
+		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 		return;
 	}
-- 
2.30.2



