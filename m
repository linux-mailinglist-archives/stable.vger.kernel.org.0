Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCD75FDDE0
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 18:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJMQCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 12:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJMQCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 12:02:20 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16E4C104526;
        Thu, 13 Oct 2022 09:02:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DB0713D5;
        Thu, 13 Oct 2022 09:02:25 -0700 (PDT)
Received: from e120937-lin (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADF3C3F67D;
        Thu, 13 Oct 2022 09:02:17 -0700 (PDT)
Date:   Thu, 13 Oct 2022 17:02:15 +0100
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     YaxiongTian <iambestgod@outlook.com>
Cc:     iambestgod@qq.com, james.quinlan@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, sudeep.holla@arm.com,
        tianyaxiong@kylinos.cn
Subject: Re: [PATCH -next 1/1] firmware: arm_scmi: Fix possible deadlock in
 shmem_tx_prepare()
Message-ID: <Y0g2d/pw6yCoA3Nc@e120937-lin>
References: <Y0V6Q7ZJ3GjBwWub@e120937-lin>
 <KL1PR01MB3510AD021B2258CB789466E3D5259@KL1PR01MB3510.apcprd01.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <KL1PR01MB3510AD021B2258CB789466E3D5259@KL1PR01MB3510.apcprd01.prod.exchangelabs.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 03:05:43PM +0800, YaxiongTian wrote:
> Hi Cristian
> 
>    There may be a problem with my qq email client,   I don't see my mail in
> the
> 
> communityI had to switch outlook email.Forgive me if you've received
> multiple emails.
> 
No worries.

> >Problem is anyway, as you said, you'll have to pick this timeout from the
> >related transport scmi_desc (even if as of now the max_rx_timeout for
> >all existent shared mem transport is the same..) and this means anyway
> >adding more complexity to the chain of calls to just to print a warn of
> >some kind in a rare error-situation from which you cannot recover anyway.
> 
>   Yes,it has add more complexity about Monitorring this time.For system
> stability,the safest thing to do is to abort the transmission.But this will
> lose performance due to more complexity in such unusual situation.
> 
> >Due to other unrelated discussions, I was starting to think about
> >exposing some debug-only (Kconfig dependent) SCMI stats like timeouts,
> errors,
> >unpexpected/OoO/late_replies in order to ease the debug and monitoring
> >of the health of a running SCMI stack: maybe this could be a place where
> >to flag this FW issues without changing the spinloop above (or
> >to add the kind of timeout you mentioned but only when some sort of
> >CONFIG_SCMI_DEBUG is enabled...)...still to fully think it through, though.
> 
>   I think it should active report warn or err rather than user queries the
> information manually.(i.e fs_debug way).Becasue in system startup\S1\S3\S4,
> user can not queries this flag in Fw,they need get stuck message
> immediately.
> 

Looking more closely at this, I experimented a bit with an SCMI stack based on
mailbox transport in which I had forcefully set the spin_until_cond() to
spin forever.

Even though on a normal SCMI system when the SCMI stack fails at boot
the system is supposed to boot anyway (maybe slower), this particular
failure in TX path led indeed to a system that does not boot at all and
spits out an infinite sequence of:

[ 2924.499486] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2924.505596] rcu:     2-...0: (0 ticks this GP) idle=1be4/1/0x4000000000000000 softirq=50/50 fqs=364757
[ 2924.514672]  (detected by 4, t=730678 jiffies, g=-1119, q=134 ncpus=6)
[ 2924.521215] Task dump for CPU 2:
[ 2924.524445] task:kworker/u12:0   state:R  running task     stack:    0 pid:    9 ppid:     2 flags:0x0000000a
[ 2924.534391] Workqueue: events_unbound deferred_probe_work_func
[ 2924.540244] Call trace:
[ 2924.542691]  __switch_to+0xe4/0x1b8
[ 2924.546189]  deferred_probe_work_func+0xa4/0xf8
[ 2924.550731]  process_one_work+0x208/0x480
[ 2924.554754]  worker_thread+0x230/0x428
[ 2924.558514]  kthread+0x114/0x120
[ 2924.561752]  ret_from_fork+0x10/0x20

I imagine this is the annoying thing you want to avoid.

So experimenting a bit with a patch similar to yours (ignoring the timeout
config issues and using the static cnt to temporarily stuck and revive the SCMI
transport)

------>8-----
diff --git a/drivers/firmware/arm_scmi/shmem.c b/drivers/firmware/arm_scmi/shmem.c
index 0e3eaea5d852..6dde669abd03 100644
--- a/drivers/firmware/arm_scmi/shmem.c
+++ b/drivers/firmware/arm_scmi/shmem.c
@@ -8,6 +8,7 @@
 #include <linux/io.h>
 #include <linux/processor.h>
 #include <linux/types.h>
 
 #include "common.h"
 
@@ -29,17 +30,28 @@ struct scmi_shared_mem {
        u8 msg_payload[];
 };
 
+static int cnt = 50;
 void shmem_tx_prepare(struct scmi_shared_mem __iomem *shmem,
                      struct scmi_xfer *xfer)
 {
+       ktime_t stop;
+
        /*
         * Ideally channel must be free by now unless OS timeout last
         * request and platform continued to process the same, wait
         * until it releases the shared memory, otherwise we may endup
         * overwriting its response with new message payload or vice-versa
         */
-       spin_until_cond(ioread32(&shmem->channel_status) &
-                       SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
+       stop = ktime_add_ms(ktime_get(), 35);
+       spin_until_cond(((--cnt > 0) && ioread32(&shmem->channel_status) &
+                       SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE) ||
+                       ktime_after(ktime_get(), stop));
+       if (ktime_after(ktime_get(), stop)) {
+               pr_warn_once("TX Timeout !\n");
+               cnt = 10;
+               return;
+       }
+
        /* Mark channel busy + clear error */
        iowrite32(0x0, &shmem->channel_status);
        iowrite32(xfer->hdr.poll_completion ? 0 : SCMI_SHMEM_FLAG_INTR_ENABLED,
----8<-------------

With the above I had in fact a system that could boot even with a
failing/stuck SCMI transport, but, as expected the SCMI stack
functionality was totally compromised after the first timeout with no
possibility to recover.

Moreover I was thinking at what could happen if later on after boot the
SCMI server should end in some funny/hogged condition so that it is,
only temporarily, a bit slower to answer and release the channel: with
the current implemenation the Kernel agent will spin just a little bit
more waiting for the channel to be freed and then everything carries
without much hassle, while with this possible new timing-out solution
we could end up dropping that transmission and compromising the whole
transport fucntionality for all the subsequent transmissions.

So, again, I'm not sure it is worth making such a change even for debug
purposes, given that in the worst scenario above you end up with a
system stuck at boot but for which the SCMI stack is anyway compromised
and where the only solution is fixing the server FW really.

I'll ask Sudeep is thoughts about the possible hang.

Thanks,
Cristian
