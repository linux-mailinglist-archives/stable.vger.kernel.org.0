Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E645260A28A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiJXLpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbiJXLoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:44:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1234A74352;
        Mon, 24 Oct 2022 04:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7BAC6127D;
        Mon, 24 Oct 2022 11:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961B1C433D6;
        Mon, 24 Oct 2022 11:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611602;
        bh=owFmSv/S9DLDU2vakvxfkdD4+u8AbGA58BI/lh6hDm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjZg8daD7jty5py2r90oPRMx43IR64QFR4GOwhpH6I8Z8B6YbJG3XpFCfIpmMOr2C
         ydQsAuoev7xdHHqFj3u8HNhDtyOc5FtBGYj2/+2wZRZ6RTwHXvPrdSwspwdctRY9DK
         hjJSymyuoQTWQaLJYYMg9yjWvTgFjgGZLtQbpbxA=
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
Subject: [PATCH 4.9 040/159] random: use expired timer rather than wq for mixing fast pool
Date:   Mon, 24 Oct 2022 13:29:54 +0200
Message-Id: <20221024112950.838950804@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/char/random.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

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
@@ -946,9 +946,9 @@ int __cold random_online_cpu(unsigned in
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
 


