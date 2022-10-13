Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AF85FDEA2
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJMRHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiJMRHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:07:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00949B1DEE
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 10:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D37B61883
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 17:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C59C433D6;
        Thu, 13 Oct 2022 17:07:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZyLb6e/c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665680858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BE1L4x+mD4YMyGGBuNaj+fYUlDB9/viP1KMewv8krCQ=;
        b=ZyLb6e/cZZFfNLbDMvfA9OyHrfj9a1yEkAQUJ9f1ADIDU7/7/CXfxzCFugI8S2qFJiiAUB
        XmKlu0XGvkiv2gqEY1diG1Zm1fkCmNPAHfltLECRD5aWYpC0CyFz7SY1qXgUTSvtUvPbqC
        h3dBQUZbCD/vn+2JWiTpf9V14slTE9w=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9204b711 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 13 Oct 2022 17:07:38 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH stable 4.9.y 4.14.y] random: use expired timer rather than wq for mixing fast pool
Date:   Thu, 13 Oct 2022 11:07:31 -0600
Message-Id: <20221013170731.1456197-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9pg8D2cOtoiQYJFYzfkz1RmZY7V_HxRH1WAgd_qXYtPYg@mail.gmail.com>
References: <CAHmME9pg8D2cOtoiQYJFYzfkz1RmZY7V_HxRH1WAgd_qXYtPYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 748bc4dd9e663f23448d8ad7e58c011a67ea1eca upstream.

Previously, the fast pool was dumped into the main pool periodically in
the fast pool's hard IRQ handler. This worked fine and there weren't
problems with it, until RT came around. Since RT converts spinlocks into
sleeping locks, problems cropped up. Rather than switching to raw
spinlocks, the RT developers preferred we make the transformation from
originally doing:

    do_some_stuff()
    spin_lock()
    do_some_other_stuff()
    spin_unlock()

to doing:

    do_some_stuff()
    queue_work_on(some_other_stuff_worker)

This is an ordinary pattern done all over the kernel. However, Sherry
noticed a 10% performance regression in qperf TCP over a 40gbps
InfiniBand card. Quoting her message:

> MT27500 Family [ConnectX-3] cards:
> Infiniband device 'mlx4_0' port 1 status:
> default gid: fe80:0000:0000:0000:0010:e000:0178:9eb1
> base lid: 0x6
> sm lid: 0x1
> state: 4: ACTIVE
> phys state: 5: LinkUp
> rate: 40 Gb/sec (4X QDR)
> link_layer: InfiniBand
>
> Cards are configured with IP addresses on private subnet for IPoIB
> performance testing.
> Regression identified in this bug is in TCP latency in this stack as reported
> by qperf tcp_lat metric:
>
> We have one system listen as a qperf server:
> [root@yourQperfServer ~]# qperf
>
> Have the other system connect to qperf server as a client (in this
> case, it’s X7 server with Mellanox card):
> [root@yourQperfClient ~]# numactl -m0 -N0 qperf 20.20.20.101 -v -uu -ub --time 60 --wait_server 20 -oo msg_size:4K:1024K:*2 tcp_lat

Rather than incur the scheduling latency from queue_work_on, we can
instead switch to running on the next timer tick, on the same core. This
also batches things a bit more -- once per jiffy -- which is okay now
that mix_interrupt_randomness() can credit multiple bits at once.

Reported-by: Sherry Yang <sherry.yang@oracle.com>
Tested-by: Paul Webb <paul.x.webb@oracle.com>
Cc: Sherry Yang <sherry.yang@oracle.com>
Cc: Phillip Goerl <phillip.goerl@oracle.com>
Cc: Jack Vogel <jack.vogel@oracle.com>
Cc: Nicky Veitch <nicky.veitch@oracle.com>
Cc: Colm Harrington <colm.harrington@oracle.com>
Cc: Ramanan Govindarajan <ramanan.govindarajan@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: stable@vger.kernel.org
Fixes: 58340f8e952b ("random: defer fast pool mixing to worker")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index bf5f0149d9d4..174dd139d2f3 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -894,7 +894,7 @@ struct fast_pool {
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
-	struct work_struct mix;
+	struct timer_list mix;
 };
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
@@ -946,9 +946,9 @@ int __cold random_online_cpu(unsigned int cpu)
 }
 #endif
 
-static void mix_interrupt_randomness(struct work_struct *work)
+static void mix_interrupt_randomness(unsigned long data)
 {
-	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
+	struct fast_pool *fast_pool = (struct fast_pool *)data;
 	/*
 	 * The size of the copied stack pool is explicitly 2 longs so that we
 	 * only ever ingest half of the siphash output each time, retaining
@@ -1000,10 +1000,14 @@ void add_interrupt_randomness(int irq)
 	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
-	if (unlikely(!fast_pool->mix.func))
-		INIT_WORK(&fast_pool->mix, mix_interrupt_randomness);
+	if (unlikely(!fast_pool->mix.data))
+		setup_timer(&fast_pool->mix, mix_interrupt_randomness, (unsigned long)fast_pool);
+
 	fast_pool->count |= MIX_INFLIGHT;
-	queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
+	if (!timer_pending(&fast_pool->mix)) {
+		fast_pool->mix.expires = jiffies;
+		add_timer_on(&fast_pool->mix, raw_smp_processor_id());
+	}
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
-- 
2.37.3

