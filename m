Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E895C76DE7
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387667AbfGZPZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbfGZPZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:25:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 416AB22CB8;
        Fri, 26 Jul 2019 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154755;
        bh=B8hvJYZQVC03+qX3gtI0idWXSttmN3iZlKFBqPdTpYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rq3uoG6qnT+DkhTX8OZp+rDE1Pr5MqATcfveWotHSlRSdBPueBA+VL4CCuL97UlfD
         35py7ttUoAuzaw9QRPm30UcuQxBQJwLnTJZhWEcExd+7TmpYNh/w10ruLmdWeK1VnE
         FuZw2B/f0Tx5cCl6I5h1wMIxsmST/PnPt5IqmAe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 16/66] net/tls: make sure offload also gets the keys wiped
Date:   Fri, 26 Jul 2019 17:24:15 +0200
Message-Id: <20190726152303.567642912@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit acd3e96d53a24d219f720ed4012b62723ae05da1 ]

Commit 86029d10af18 ("tls: zero the crypto information from tls_context
before freeing") added memzero_explicit() calls to clear the key material
before freeing struct tls_context, but it missed tls_device.c has its
own way of freeing this structure. Replace the missing free.

Fixes: 86029d10af18 ("tls: zero the crypto information from tls_context before freeing")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h    |    1 +
 net/tls/tls_device.c |    2 +-
 net/tls/tls_main.c   |    4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -313,6 +313,7 @@ struct tls_offload_context_rx {
 	(ALIGN(sizeof(struct tls_offload_context_rx), sizeof(void *)) + \
 	 TLS_DRIVER_STATE_SIZE)
 
+void tls_ctx_free(struct tls_context *ctx);
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 int tls_sk_query(struct sock *sk, int optname, char __user *optval,
 		int __user *optlen);
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -61,7 +61,7 @@ static void tls_device_free_ctx(struct t
 	if (ctx->rx_conf == TLS_HW)
 		kfree(tls_offload_ctx_rx(ctx));
 
-	kfree(ctx);
+	tls_ctx_free(ctx);
 }
 
 static void tls_device_gc_task(struct work_struct *work)
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -251,7 +251,7 @@ static void tls_write_space(struct sock
 	ctx->sk_write_space(sk);
 }
 
-static void tls_ctx_free(struct tls_context *ctx)
+void tls_ctx_free(struct tls_context *ctx)
 {
 	if (!ctx)
 		return;
@@ -643,7 +643,7 @@ static void tls_hw_sk_destruct(struct so
 
 	ctx->sk_destruct(sk);
 	/* Free ctx */
-	kfree(ctx);
+	tls_ctx_free(ctx);
 	icsk->icsk_ulp_data = NULL;
 }
 


