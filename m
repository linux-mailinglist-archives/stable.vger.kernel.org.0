Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCDB5FE0DB
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiJMSPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiJMSMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:12:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CCA2DCA;
        Thu, 13 Oct 2022 11:09:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A269F61A3F;
        Thu, 13 Oct 2022 18:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF02BC433B5;
        Thu, 13 Oct 2022 18:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684087;
        bh=Qgu883AQmFoIRpgdwPNsgCs+MfY/HWZXNTNzgBkZpX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2oc5OwkxgIXDer7JS6JyRj3kaUPrQ4LbqvAckThNUDeHaZsj4DKWLQieyuTtEC88
         2ebsCHVhHnfEDa2N3wMp/hKpjBjVLBucUViGExuSOUcYrdNLzYKS8zRArcQiggoYMd
         NDM6eFFx9HWOhd6NQai8t0djNXChDB6jiaenbhRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Yang <sherry.yang@oracle.com>,
        Paul Webb <paul.x.webb@oracle.com>,
        Phillip Goerl <phillip.goerl@oracle.com>,
        Jack Vogel <jack.vogel@oracle.com>,
        Nicky Veitch <nicky.veitch@oracle.com>,
        Colm Harrington <colm.harrington@oracle.com>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Tejun Heo <tj@kernel.org>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.0 20/34] random: use expired timer rather than wq for mixing fast pool
Date:   Thu, 13 Oct 2022 19:52:58 +0200
Message-Id: <20221013175147.042953145@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -923,17 +923,20 @@ struct fast_pool {
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
-	struct work_struct mix;
+	struct timer_list mix;
 };
 
+static void mix_interrupt_randomness(struct timer_list *work);
+
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
 #ifdef CONFIG_64BIT
 #define FASTMIX_PERM SIPHASH_PERMUTATION
-	.pool = { SIPHASH_CONST_0, SIPHASH_CONST_1, SIPHASH_CONST_2, SIPHASH_CONST_3 }
+	.pool = { SIPHASH_CONST_0, SIPHASH_CONST_1, SIPHASH_CONST_2, SIPHASH_CONST_3 },
 #else
 #define FASTMIX_PERM HSIPHASH_PERMUTATION
-	.pool = { HSIPHASH_CONST_0, HSIPHASH_CONST_1, HSIPHASH_CONST_2, HSIPHASH_CONST_3 }
+	.pool = { HSIPHASH_CONST_0, HSIPHASH_CONST_1, HSIPHASH_CONST_2, HSIPHASH_CONST_3 },
 #endif
+	.mix = __TIMER_INITIALIZER(mix_interrupt_randomness, 0)
 };
 
 /*
@@ -975,7 +978,7 @@ int __cold random_online_cpu(unsigned in
 }
 #endif
 
-static void mix_interrupt_randomness(struct work_struct *work)
+static void mix_interrupt_randomness(struct timer_list *work)
 {
 	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
 	/*
@@ -1029,10 +1032,11 @@ void add_interrupt_randomness(int irq)
 	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
-	if (unlikely(!fast_pool->mix.func))
-		INIT_WORK(&fast_pool->mix, mix_interrupt_randomness);
 	fast_pool->count |= MIX_INFLIGHT;
-	queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
+	if (!timer_pending(&fast_pool->mix)) {
+		fast_pool->mix.expires = jiffies;
+		add_timer_on(&fast_pool->mix, raw_smp_processor_id());
+	}
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 


