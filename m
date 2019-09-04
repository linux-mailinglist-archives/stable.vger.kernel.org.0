Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BABBA8F4F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbfIDSC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388480AbfIDSC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:02:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F5F7206B8;
        Wed,  4 Sep 2019 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620177;
        bh=S7xatoxrGILk99eVCvzdkYSlzdr6JTKpzXUvC1KZTXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Katmvyh/McfW65BQCY/4ra7uAfeB+s+hpjnOb7AHg7BdqWusoAHBI5G06p/JQeFg9
         xAGQEgnrGv/zqkJn7H8vwV09pIS9RQZrZ8ZVybLVMQwrOVK3mbwd6Dd2g7sYMlnBsR
         D72fnbJwX4jcNOikJ4xSPsrvU0Xn0Ghk6d1ATm+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <edumazet@google.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 19/57] net/smc: make sure EPOLLOUT is raised
Date:   Wed,  4 Sep 2019 19:53:47 +0200
Message-Id: <20190904175303.768062015@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>

[ Upstream commit 4651d1802f7063e4d8c0bcad957f46ece0c04024 ]

Currently, we are only explicitly setting SOCK_NOSPACE on a write timeout
for non-blocking sockets. Epoll() edge-trigger mode relies on SOCK_NOSPACE
being set when -EAGAIN is returned to ensure that EPOLLOUT is raised.
Expand the setting of SOCK_NOSPACE to non-blocking sockets as well that can
use SO_SNDTIMEO to adjust their write timeout. This mirrors the behavior
that Eric Dumazet introduced for tcp sockets.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ursula Braun <ubraun@linux.ibm.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_tx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -70,13 +70,11 @@ static int smc_tx_wait_memory(struct smc
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct smc_connection *conn = &smc->conn;
 	struct sock *sk = &smc->sk;
-	bool noblock;
 	long timeo;
 	int rc = 0;
 
 	/* similar to sk_stream_wait_memory */
 	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
-	noblock = timeo ? false : true;
 	add_wait_queue(sk_sleep(sk), &wait);
 	while (1) {
 		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
@@ -91,8 +89,8 @@ static int smc_tx_wait_memory(struct smc
 			break;
 		}
 		if (!timeo) {
-			if (noblock)
-				set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+			/* ensure EPOLLOUT is subsequently generated */
+			set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 			rc = -EAGAIN;
 			break;
 		}


