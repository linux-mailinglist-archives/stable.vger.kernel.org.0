Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490953AAE0
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfFIRWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbfFIQoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F6722084A;
        Sun,  9 Jun 2019 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098678;
        bh=8NrHvciYl7iZDiy0ojH3V9vaNykkCz2ERsh3Uc0+DIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pk5YdxxNY4n7jTQ+4B3rfbzILU/FY50yCZ7GFDhHvMeaUc6rshK+CHjHgLpQ00Dzj
         yyK8lTdP+mBEXXGoN57ORyMZ2XUvly6mK61F89R6w1dk+1BXgZtp4g7Q6XTyOt3hiT
         F/ejlZooItx7OQ68qdw8gSeT5ibrOvou/03CkbDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 21/70] net/tls: replace the sleeping lock around RX resync with a bit lock
Date:   Sun,  9 Jun 2019 18:41:32 +0200
Message-Id: <20190609164128.816131509@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit e52972c11d6b1262964db96d65934196db621685 ]

Commit 38030d7cb779 ("net/tls: avoid NULL-deref on resync during device removal")
tried to fix a potential NULL-dereference by taking the
context rwsem.  Unfortunately the RX resync may get called
from soft IRQ, so we can't use the rwsem to protect from
the device disappearing.  Because we are guaranteed there
can be only one resync at a time (it's called from strparser)
use a bit to indicate resync is busy and make device
removal wait for the bit to get cleared.

Note that there is a leftover "flags" field in struct
tls_context already.

Fixes: 4799ac81e52a ("tls: Add rx inline crypto offload")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h    |    4 ++++
 net/tls/tls_device.c |   27 +++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -199,6 +199,10 @@ struct tls_offload_context_tx {
 	(ALIGN(sizeof(struct tls_offload_context_tx), sizeof(void *)) +        \
 	 TLS_DRIVER_STATE_SIZE)
 
+enum tls_context_flags {
+	TLS_RX_SYNC_RUNNING = 0,
+};
+
 struct cipher_context {
 	char *iv;
 	char *rec_seq;
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -570,10 +570,22 @@ void tls_device_write_space(struct sock
 	}
 }
 
+static void tls_device_resync_rx(struct tls_context *tls_ctx,
+				 struct sock *sk, u32 seq, u64 rcd_sn)
+{
+	struct net_device *netdev;
+
+	if (WARN_ON(test_and_set_bit(TLS_RX_SYNC_RUNNING, &tls_ctx->flags)))
+		return;
+	netdev = READ_ONCE(tls_ctx->netdev);
+	if (netdev)
+		netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk, seq, rcd_sn);
+	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
+}
+
 void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct net_device *netdev = tls_ctx->netdev;
 	struct tls_offload_context_rx *rx_ctx;
 	u32 is_req_pending;
 	s64 resync_req;
@@ -588,10 +600,10 @@ void handle_device_resync(struct sock *s
 	is_req_pending = resync_req;
 
 	if (unlikely(is_req_pending) && req_seq == seq &&
-	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
-		netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk,
-						      seq + TLS_HEADER_SIZE - 1,
-						      rcd_sn);
+	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0)) {
+		seq += TLS_HEADER_SIZE - 1;
+		tls_device_resync_rx(tls_ctx, sk, seq, rcd_sn);
+	}
 }
 
 static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
@@ -981,7 +993,10 @@ static int tls_device_down(struct net_de
 		if (ctx->rx_conf == TLS_HW)
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_RX);
-		ctx->netdev = NULL;
+		WRITE_ONCE(ctx->netdev, NULL);
+		smp_mb__before_atomic(); /* pairs with test_and_set_bit() */
+		while (test_bit(TLS_RX_SYNC_RUNNING, &ctx->flags))
+			usleep_range(10, 200);
 		dev_put(netdev);
 		list_del_init(&ctx->list);
 


