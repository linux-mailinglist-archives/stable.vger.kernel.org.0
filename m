Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2380E582E35
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbiG0RJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241494AbiG0RJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D5550070;
        Wed, 27 Jul 2022 09:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 328F0601CE;
        Wed, 27 Jul 2022 16:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8D2C433C1;
        Wed, 27 Jul 2022 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940045;
        bh=GBLhn2OafOSRHiZdxxixnE1Zh/XffNtLQVF4iym9OZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMg7QcorZUb+Yz1FLB3d/5axaHx3+Ui0JmrBhCx7VS86NIGBuUISwWpJwO2kmtfTe
         i4Sx8NLIk/SXNyTkUe1QBOqUvGH5mUK2Mq+anbTGLBzsUrgUUSi60AGMb82a3pbTUe
         UgnVTgWN4ahRE7YfePiKJ/RMvDDMivwFVAnVcdzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/201] net/tls: Fix race in TLS device down flow
Date:   Wed, 27 Jul 2022 18:09:50 +0200
Message-Id: <20220727161031.305424966@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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
index 4775431cbd38..4e33150cfb9e 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -97,13 +97,16 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
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
 
@@ -194,8 +197,7 @@ void tls_device_sk_destruct(struct sock *sk)
 		clean_acked_data_disable(inet_csk(sk));
 	}
 
-	if (refcount_dec_and_test(&tls_ctx->refcount))
-		tls_device_queue_ctx_destruction(tls_ctx);
+	tls_device_queue_ctx_destruction(tls_ctx);
 }
 EXPORT_SYMBOL_GPL(tls_device_sk_destruct);
 
-- 
2.35.1



