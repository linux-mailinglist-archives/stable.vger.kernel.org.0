Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDB2582BF5
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbiG0Qkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239408AbiG0QkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305755A8BD;
        Wed, 27 Jul 2022 09:29:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D55A619D6;
        Wed, 27 Jul 2022 16:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A444C433D6;
        Wed, 27 Jul 2022 16:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939322;
        bh=yGjclRpTTnLqDZq3ND41LUVC58mz1G5Iu0o1J/Ct7w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2VzBTWUjWeRNvaMM4d2vhN2E5ik39NU0oGgAPmP9WnbALYC2+chPqeDuS+LcqxHJ
         8aNows3nCGYRwGZ5gtAGR9z2IU19HypgLhbbcl0oPD1XNPVZd+5sVyqlNiV4zfbqJ3
         YBpxNOFt7idc5+/v4/cNgg1k9YFhxZqCVyjyj8eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/87] net/tls: Fix race in TLS device down flow
Date:   Wed, 27 Jul 2022 18:10:22 +0200
Message-Id: <20220727161010.217002253@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit f08d8c1bb97c48f24a82afaa2fd8c140f8d3da8b ]

Socket destruction flow and tls_device_down function sync against each
other using tls_device_lock and the context refcount, to guarantee the
device resources are freed via tls_dev_del() by the end of
tls_device_down.

In the following unfortunate flow, this won't happen:
- refcount is decreased to zero in tls_device_sk_destruct.
- tls_device_down starts, skips the context as refcount is zero, going
  all the way until it flushes the gc work, and returns without freeing
  the device resources.
- only then, tls_device_queue_ctx_destruction is called, queues the gc
  work and frees the context's device resources.

Solve it by decreasing the refcount in the socket's destruction flow
under the tls_device_lock, for perfect synchronization.  This does not
slow down the common likely destructor flow, in which both the refcount
is decreased and the spinlock is acquired, anyway.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index abb93f7343c5..2c3cf47d730b 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -94,13 +94,16 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
+	if (unlikely(!refcount_dec_and_test(&ctx->refcount)))
+		goto unlock;
+
 	list_move_tail(&ctx->list, &tls_device_gc_list);
 
 	/* schedule_work inside the spinlock
 	 * to make sure tls_device_down waits for that work.
 	 */
 	schedule_work(&tls_device_gc_work);
-
+unlock:
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 }
 
@@ -191,8 +194,7 @@ static void tls_device_sk_destruct(struct sock *sk)
 		clean_acked_data_disable(inet_csk(sk));
 	}
 
-	if (refcount_dec_and_test(&tls_ctx->refcount))
-		tls_device_queue_ctx_destruction(tls_ctx);
+	tls_device_queue_ctx_destruction(tls_ctx);
 }
 
 void tls_device_free_resources_tx(struct sock *sk)
-- 
2.35.1



