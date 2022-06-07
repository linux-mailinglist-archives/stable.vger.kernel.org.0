Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A11541C98
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382562AbiFGWCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354515AbiFGWCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:02:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C183424E1CB;
        Tue,  7 Jun 2022 12:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58EB061917;
        Tue,  7 Jun 2022 19:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCE1C385A2;
        Tue,  7 Jun 2022 19:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629252;
        bh=ucIaXTRbVB/oL/7bl68xYrtIpt1U6H0UrivdO4ahS1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8LYjj+I5mrX0ynIRqh8vWCV7awnFk6LGj8CN3j10HcEJUMXwVa8EoeiklpcA7CPB
         yjNobT6srLlc+BgtsGttNb0lZ0n4DEPyZM/gG+zrJTh/dYh3R0sAG1HLINXinH0VxY
         si96CXhbgZ9VzKF9hNlfp9BV/SsWKup5HzvYQ588=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 623/879] crypto: cryptd - Protect per-CPU resource by disabling BH.
Date:   Tue,  7 Jun 2022 19:02:21 +0200
Message-Id: <20220607165020.935015007@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 91e8bcd7b4da182e09ea19a2c73167345fe14c98 ]

The access to cryptd_queue::cpu_queue is synchronized by disabling
preemption in cryptd_enqueue_request() and disabling BH in
cryptd_queue_worker(). This implies that access is allowed from BH.

If cryptd_enqueue_request() is invoked from preemptible context _and_
soft interrupt then this can lead to list corruption since
cryptd_enqueue_request() is not protected against access from
soft interrupt.

Replace get_cpu() in cryptd_enqueue_request() with local_bh_disable()
to ensure BH is always disabled.
Remove preempt_disable() from cryptd_queue_worker() since it is not
needed because local_bh_disable() ensures synchronisation.

Fixes: 254eff771441 ("crypto: cryptd - Per-CPU thread implementation...")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/cryptd.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index a1bea0f4baa8..668095eca0fa 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -39,6 +39,10 @@ struct cryptd_cpu_queue {
 };
 
 struct cryptd_queue {
+	/*
+	 * Protected by disabling BH to allow enqueueing from softinterrupt and
+	 * dequeuing from kworker (cryptd_queue_worker()).
+	 */
 	struct cryptd_cpu_queue __percpu *cpu_queue;
 };
 
@@ -125,28 +129,28 @@ static void cryptd_fini_queue(struct cryptd_queue *queue)
 static int cryptd_enqueue_request(struct cryptd_queue *queue,
 				  struct crypto_async_request *request)
 {
-	int cpu, err;
+	int err;
 	struct cryptd_cpu_queue *cpu_queue;
 	refcount_t *refcnt;
 
-	cpu = get_cpu();
+	local_bh_disable();
 	cpu_queue = this_cpu_ptr(queue->cpu_queue);
 	err = crypto_enqueue_request(&cpu_queue->queue, request);
 
 	refcnt = crypto_tfm_ctx(request->tfm);
 
 	if (err == -ENOSPC)
-		goto out_put_cpu;
+		goto out;
 
-	queue_work_on(cpu, cryptd_wq, &cpu_queue->work);
+	queue_work_on(smp_processor_id(), cryptd_wq, &cpu_queue->work);
 
 	if (!refcount_read(refcnt))
-		goto out_put_cpu;
+		goto out;
 
 	refcount_inc(refcnt);
 
-out_put_cpu:
-	put_cpu();
+out:
+	local_bh_enable();
 
 	return err;
 }
@@ -162,15 +166,10 @@ static void cryptd_queue_worker(struct work_struct *work)
 	cpu_queue = container_of(work, struct cryptd_cpu_queue, work);
 	/*
 	 * Only handle one request at a time to avoid hogging crypto workqueue.
-	 * preempt_disable/enable is used to prevent being preempted by
-	 * cryptd_enqueue_request(). local_bh_disable/enable is used to prevent
-	 * cryptd_enqueue_request() being accessed from software interrupts.
 	 */
 	local_bh_disable();
-	preempt_disable();
 	backlog = crypto_get_backlog(&cpu_queue->queue);
 	req = crypto_dequeue_request(&cpu_queue->queue);
-	preempt_enable();
 	local_bh_enable();
 
 	if (!req)
-- 
2.35.1



