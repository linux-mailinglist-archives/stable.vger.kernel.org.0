Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E283DD8FA
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbhHBN4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236231AbhHBNzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7426B6113D;
        Mon,  2 Aug 2021 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912421;
        bh=ImPCBySZwg7mTQZobgxAAJo0iA67emeleqf2EXN0ehc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6H2N91+XJSxyfZAbuP7yVZOWy2OabfAWdlF5txhjRwaAVKezL0g6Ehg/iSpsIzvo
         piIPnI04FoEAxkas2T+yzpasTsYJP6gLAqcqIbCFkJqkp2/QrrFLNJCvW0H7pLEXSJ
         IP69TzVbAYjt+RnR15EMVAR+jTIFNsSoKbZOtJ4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/67] skmsg: Make sk_psock_destroy() static
Date:   Mon,  2 Aug 2021 15:45:14 +0200
Message-Id: <20210802134340.779743297@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 8063e184e49011f6f3f34f6c358dc8a83890bb5b ]

sk_psock_destroy() is a RCU callback, I can't see any reason why
it could be used outside.

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210127221501.46866-1-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 1 -
 net/core/skmsg.c      | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 82126d529798..822c048934e3 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -395,7 +395,6 @@ static inline struct sk_psock *sk_psock_get(struct sock *sk)
 }
 
 void sk_psock_stop(struct sock *sk, struct sk_psock *psock);
-void sk_psock_destroy(struct rcu_head *rcu);
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock);
 
 static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index c4c224a5b9de..5dd5569f89bf 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -676,14 +676,13 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 	kfree(psock);
 }
 
-void sk_psock_destroy(struct rcu_head *rcu)
+static void sk_psock_destroy(struct rcu_head *rcu)
 {
 	struct sk_psock *psock = container_of(rcu, struct sk_psock, rcu);
 
 	INIT_WORK(&psock->gc, sk_psock_destroy_deferred);
 	schedule_work(&psock->gc);
 }
-EXPORT_SYMBOL_GPL(sk_psock_destroy);
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-- 
2.30.2



