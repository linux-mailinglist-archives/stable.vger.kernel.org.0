Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDFA14834B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404772AbgAXLe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391908AbgAXLe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:34:57 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBEB722527;
        Fri, 24 Jan 2020 11:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865696;
        bh=B8Sf/ztuwijQujQ65GBe6GFH4/Czinnh5+RDWtZNTGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16wabLKsnGkv6zQVKB1HncaPhIm26cxA0ng6eJCbBlKrIs6Z7agY9FgPR2yKo6q+/
         89tqrSVePdlJlcC6TazVINQwds7L9hYFGaovNxh+bEAWkMk81Tq9wjzhcSHT7E/cVT
         uDRiD7z/DdP0tQeNSJtz3m38NskHA/gCKmATW/SM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 601/639] tcp: annotate lockless access to tcp_memory_pressure
Date:   Fri, 24 Jan 2020 10:32:51 +0100
Message-Id: <20200124093204.662654132@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1f142c17d19a5618d5a633195a46f2c8be9bf232 ]

tcp_memory_pressure is read without holding any lock,
and its value could be changed on other cpus.

Use READ_ONCE() to annotate these lockless reads.

The write side is already using atomic ops.

Fixes: b8da51ebb1aa ("tcp: introduce tcp_under_memory_pressure()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 2 +-
 net/ipv4/tcp.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ac4ffe8013d8a..918bfd0d7d1f9 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -261,7 +261,7 @@ static inline bool tcp_under_memory_pressure(const struct sock *sk)
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
-	return tcp_memory_pressure;
+	return READ_ONCE(tcp_memory_pressure);
 }
 /*
  * The next routines deal with comparing 32 bit unsigned ints
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cd8a92e7a39eb..af9361eba64a6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -325,7 +325,7 @@ void tcp_enter_memory_pressure(struct sock *sk)
 {
 	unsigned long val;
 
-	if (tcp_memory_pressure)
+	if (READ_ONCE(tcp_memory_pressure))
 		return;
 	val = jiffies;
 
@@ -340,7 +340,7 @@ void tcp_leave_memory_pressure(struct sock *sk)
 {
 	unsigned long val;
 
-	if (!tcp_memory_pressure)
+	if (!READ_ONCE(tcp_memory_pressure))
 		return;
 	val = xchg(&tcp_memory_pressure, 0);
 	if (val)
-- 
2.20.1



