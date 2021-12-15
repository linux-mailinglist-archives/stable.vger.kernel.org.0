Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0E4475E9F
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245524AbhLORX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245336AbhLORXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D185AC061761;
        Wed, 15 Dec 2021 09:22:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6770D619E9;
        Wed, 15 Dec 2021 17:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D218C36AE2;
        Wed, 15 Dec 2021 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588978;
        bh=jpTpdXblQba3n8rFoJEdIF2qlzquKCofoB3mpAyQGc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6yoDw5UVqMrppICPadoOx15f4cI38ZGZ4eusZZv43oJR/F3nspG8XDq3hySZIXZt
         2JXtts/hZ/DaImaURkCGSAKmFfcUL5gEqH3ZiyInkzT3oX9g8ztDPjED/i9MUAoGaZ
         xnEPYXwd1AzsOSQtqkZuVT8Lfe0SWyH1/eXiYXv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/42] inet: use #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING consistently
Date:   Wed, 15 Dec 2021 18:20:48 +0100
Message-Id: <20211215172026.893979780@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a9418924552e52e63903cbb0310d7537260702bf ]

Since commit 4e1beecc3b58 ("net/sock: Add kernel config
SOCK_RX_QUEUE_MAPPING"),
sk_rx_queue_mapping access is guarded by CONFIG_SOCK_RX_QUEUE_MAPPING.

Fixes: 54b92e841937 ("tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f7fea3a7c5e64..62a67fdc344cd 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -721,7 +721,7 @@ static struct request_sock *inet_reqsk_clone(struct request_sock *req,
 
 	sk_node_init(&nreq_sk->sk_node);
 	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
-#ifdef CONFIG_XPS
+#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
 #endif
 	nreq_sk->sk_incoming_cpu = req_sk->sk_incoming_cpu;
-- 
2.33.0



