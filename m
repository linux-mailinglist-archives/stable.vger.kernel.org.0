Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1B5113243
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfLDSHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbfLDSHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:07:00 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DE8E20674;
        Wed,  4 Dec 2019 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482819;
        bh=gmEmMwBpratgRQVW/qWF9gmbRLer7I/p+Mnl3cfi5xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmR8FX3UOcFS0Q/Def3bV/MC3MHt6VUiHTzew3VfL6mX34Tm7IwAF0WT4bhmMAo0d
         U+S6TrQRmOcyPqSYXMf240t+324nvhLqb+87ZBSimrzzG5D9NHsQD3ilTosjDfd+Rf
         ECxCt9BypuPIkux509n7xfZ8YNUbEx7Ni9oQ0+gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 140/209] net: fix possible overflow in __sk_mem_raise_allocated()
Date:   Wed,  4 Dec 2019 18:55:52 +0100
Message-Id: <20191204175332.945381018@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
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
index 780c6c0a86f04..0af46cbd3649c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1232,7 +1232,7 @@ static inline void sk_sockets_allocated_inc(struct sock *sk)
 	percpu_counter_inc(sk->sk_prot->sockets_allocated);
 }
 
-static inline int
+static inline u64
 sk_sockets_allocated_read_positive(struct sock *sk)
 {
 	return percpu_counter_read_positive(sk->sk_prot->sockets_allocated);
diff --git a/net/core/sock.c b/net/core/sock.c
index 7ccbcd853cbce..90ccbbf9e6b00 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2357,7 +2357,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	}
 
 	if (sk_has_memory_pressure(sk)) {
-		int alloc;
+		u64 alloc;
 
 		if (!sk_under_memory_pressure(sk))
 			return 1;
-- 
2.20.1



