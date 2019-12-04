Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC4011317E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbfLDR76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:59:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfLDR75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:59:57 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CD2F2073B;
        Wed,  4 Dec 2019 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482397;
        bh=rQ5ldQcxVnKsALniRRUFyzeOtkp1YGSrRvd9GjrfY3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMk95Z780lR5msphRm0cfobc7Hov/vS5mqtz9vWL19eQ8Amxv8dXIrkl5yNjBKPF5
         Z4fhCqxYazbiS1pHyS3w+fQw699dIOqxbXEUNMnxROvJXpBq+pEAYGlItfJgQ7hFOK
         jV9ZX6qtUQtlEpfqsubgyxBE5MVPvskqvUIyZ8c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 70/92] net: fix possible overflow in __sk_mem_raise_allocated()
Date:   Wed,  4 Dec 2019 18:50:10 +0100
Message-Id: <20191204174334.516953712@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5bf325a53202b8728cf7013b72688c46071e212e ]

With many active TCP sockets, fat TCP sockets could fool
__sk_mem_raise_allocated() thanks to an overflow.

They would increase their share of the memory, instead
of decreasing it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 2 +-
 net/core/sock.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5ed4786a2058b..de4434284a34b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1282,7 +1282,7 @@ static inline void sk_sockets_allocated_inc(struct sock *sk)
 	percpu_counter_inc(prot->sockets_allocated);
 }
 
-static inline int
+static inline u64
 sk_sockets_allocated_read_positive(struct sock *sk)
 {
 	struct proto *prot = sk->sk_prot;
diff --git a/net/core/sock.c b/net/core/sock.c
index 8aa4a5f895723..0f4c15fcd87d3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2122,7 +2122,7 @@ int __sk_mem_schedule(struct sock *sk, int size, int kind)
 	}
 
 	if (sk_has_memory_pressure(sk)) {
-		int alloc;
+		u64 alloc;
 
 		if (!sk_under_memory_pressure(sk))
 			return 1;
-- 
2.20.1



