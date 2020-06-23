Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8596C2064CB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389229AbgFWV1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388539AbgFWUQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A81542073E;
        Tue, 23 Jun 2020 20:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943399;
        bh=m/2JE2rT+Paibu0VmyrxoGCzTRL7oQHg/PwXjAzflgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPh2U70HUg13bZz1i0uT2hiu9MGvzvCHpfDjB+PevFGG69bbJxwKRn4ZaoHRy0OEL
         o/CfucACeNZReS9RtdKvB+CXxid3MFsWWE4cD3++uZqbaIz0X0XomJWS1nB0u8Jx0f
         W3DaLu640koJG5kCeTJj5ajDWD3gRuVkKmokMfIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 377/477] bpf: sockmap: Dont attach programs to UDP sockets
Date:   Tue, 23 Jun 2020 21:56:14 +0200
Message-Id: <20200623195425.352558802@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit f6fede8569689dd31e7b0ed15024b25e5ce2e2e5 ]

The stream parser infrastructure isn't set up to deal with UDP
sockets, so we mustn't try to attach programs to them.

I remember making this change at some point, but I must have lost
it while rebasing or something similar.

Fixes: 7b98cd42b049 ("bpf: sockmap: Add UDP support")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20200611172520.327602-1-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 050bfac97cfb5..7e858c1dd7113 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -417,10 +417,7 @@ static int sock_map_get_next_key(struct bpf_map *map, void *key, void *next)
 	return 0;
 }
 
-static bool sock_map_redirect_allowed(const struct sock *sk)
-{
-	return sk->sk_state != TCP_LISTEN;
-}
+static bool sock_map_redirect_allowed(const struct sock *sk);
 
 static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
@@ -501,6 +498,11 @@ static bool sk_is_udp(const struct sock *sk)
 	       sk->sk_protocol == IPPROTO_UDP;
 }
 
+static bool sock_map_redirect_allowed(const struct sock *sk)
+{
+	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
+}
+
 static bool sock_map_sk_is_suitable(const struct sock *sk)
 {
 	return sk_is_tcp(sk) || sk_is_udp(sk);
-- 
2.25.1



