Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA242F7C9D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbfKKSrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730187AbfKKSrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85DBE21783;
        Mon, 11 Nov 2019 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498072;
        bh=ym/CbtSOg5WT/2U5UyGF36TDXjXD+2kTYEg+1mF4mck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soxd77xtOzB1M2yf5vbGY5twpjy/od47UirLuSCo7kImu2oaf7BHzE0A1CdnRxOfy
         xjCMdzcN5cSY3o8hrzTQx7UF/+yeh7O6NMdaz16OoGhj9TePBbgSyz5kF+0CrUWeIO
         kfzP+8kLiO/LGCogMg06G1kYM4a8kndoPo4axLCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 015/193] net/tls: dont pay attention to sk_write_pending when pushing partial records
Date:   Mon, 11 Nov 2019 19:26:37 +0100
Message-Id: <20191111181501.173100515@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 02b1fa07bb58f5d1f349b5b09eb936739a7b20fc ]

sk_write_pending being not zero does not guarantee that partial
record will be pushed. If the thread waiting for memory times out
the pending record may get stuck.

In case of tls_device there is no path where parial record is
set and writer present in the first place. Partial record is
set only in tls_push_sg() and tls_push_sg() will return an
error immediately. All tls_device callers of tls_push_sg()
will return (and not wait for memory) if it failed.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |    4 +++-
 net/tls/tls_sw.c     |    9 +++------
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -575,9 +575,11 @@ static int tls_device_push_pending_recor
 
 void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 {
-	if (!sk->sk_write_pending && tls_is_partially_sent_record(ctx)) {
+	if (tls_is_partially_sent_record(ctx)) {
 		gfp_t sk_allocation = sk->sk_allocation;
 
+		WARN_ON_ONCE(sk->sk_write_pending);
+
 		sk->sk_allocation = GFP_ATOMIC;
 		tls_push_partial_record(sk, ctx,
 					MSG_DONTWAIT | MSG_NOSIGNAL |
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2182,12 +2182,9 @@ void tls_sw_write_space(struct sock *sk,
 	struct tls_sw_context_tx *tx_ctx = tls_sw_ctx_tx(ctx);
 
 	/* Schedule the transmission if tx list is ready */
-	if (is_tx_ready(tx_ctx) && !sk->sk_write_pending) {
-		/* Schedule the transmission */
-		if (!test_and_set_bit(BIT_TX_SCHEDULED,
-				      &tx_ctx->tx_bitmask))
-			schedule_delayed_work(&tx_ctx->tx_work.work, 0);
-	}
+	if (is_tx_ready(tx_ctx) &&
+	    !test_and_set_bit(BIT_TX_SCHEDULED, &tx_ctx->tx_bitmask))
+		schedule_delayed_work(&tx_ctx->tx_work.work, 0);
 }
 
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *tls_ctx)


