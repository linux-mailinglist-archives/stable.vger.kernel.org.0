Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726B35F2FEB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJCL5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJCL5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:57:43 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D94B4F3B9;
        Mon,  3 Oct 2022 04:57:40 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAC32139F;
        Mon,  3 Oct 2022 04:57:46 -0700 (PDT)
Received: from e120937-lin (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E11A63F73B;
        Mon,  3 Oct 2022 04:57:38 -0700 (PDT)
Date:   Mon, 3 Oct 2022 12:57:36 +0100
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     Yaxiong Tian <iambestgod@qq.com>
Cc:     sudeep.holla@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Yaxiong Tian <tianyaxiong@kylinos.cn>, stable@vger.kernel.org,
        Jim Quinlan <james.quinlan@broadcom.com>
Subject: Re: [PATCH -next 1/1] firmware: arm_scmi: Fix possible deadlock in
 shmem_tx_prepare()
Message-ID: <YzrOMKiU3yHt5P/k@e120937-lin>
References: <tencent_F612AC315B21CE91A89C20DBD7CE9B5FBB07@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_F612AC315B21CE91A89C20DBD7CE9B5FBB07@qq.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 30, 2022 at 10:14:50AM +0800, Yaxiong Tian wrote:
> From: Yaxiong Tian <tianyaxiong@kylinos.cn>
> 

Hi Tian,

> In shmem_tx_prepare() ,it use spin_until_cond() to wait the chanel to be
> free. Though it can avoid risk about overwriting the old command.But
> when the platform has some problem in setting the chanel to free(such as
> Improper initialization ),it can lead to the chanel never to be free.So
> the os is sticked in it.

On a transport based on shared memory area indeed the busy/free bitflag is
used, on the TX channel, to 'pass' ownership of the channel from the agent
(Linux) to the platform SCMI server: as stated in the inline comment block,
once the Linux agent write his command into the shmem area and set the
channel busy, it HAS TO wait for the channel to be set free again by the
platform to avoid possible corruptions due to a very late command being
deliverd by the platform so late that it could override the next new command
freshly written into the shared memory by the Linux agent.

In other words you CANNOT forcibly grab back the channel ownership on
timeout like you are doing here, because you cannot assume anything on
the status of the SCMI server entity: a misbehaving SCMI server could
deliver a very late reply at any time (since it still thinks to have
ownership) and the possible subsequent corruption in the next queued
TX message would probably generate issues very difficult to spot and
debug.

Inded, in the SCMI Kernel stack we never forcibly free a TX transport
channel on timeout, scmi_clear_channel() is called only on the RX channel
for notifications and delayed response, because the ownership relation
is just the opposite, we are indeed releasing the channel to the platform
after we have processed their messages.

Same we do on a different transport like virtio, in which a virtio buffer,
related a message without a reply, is just lost if the SCMI server never
sent back anything: the only difference is that virtio has usually more
numerous free buffers so we can carry on anyway using some of the other
remaning free buffers.

Moreover, when the SCMI server or a transport ended up in such a broken
state that it does not even release the channel, it means the SCMI
server stack  is in serious trouble, and we (Kernel) do not really want
to do any businness with a backend in such a misbehaving state, the SCMI
server should be fixed; instead, this kind of approach you propose could
even hide some class of transient server-side problems by just ignoring
this condition and grabbing back the channel forcibly.

> In addition when shmem_tx_prepare() called,this
> indicates that the previous transfer has commpleted or timed out.It
> unsuitable for unconditional waiting the chanel to be free.

Note that there could be also the case in which there are many other
threads of executions on different cores trying to send a bunch of SCMI
commands (there are indeed many SCMI drivers currently in the stack) so
all these requests HAVE TO be queued while waiting for the shared
memory area to be free again, so I don't think you can assume in general
that shmem_tx_prepare() is called only after a successfull command completion
or timeout: it is probably true when an SCMI Mailbox transport is
used but it is not neccessarly the case when other shmem based transports
like optee/smc are used. You could have N threads trying to send an SCMI
command, queued, spinning on that loop, while waiting for the channel to
be free: in such a case note that you TX has not even complete, you are
still waiting for the channel the SCMI upper layer TX timeout has NOT
even being started since your the transmission itself is pending (i.e.
send_message has still not returned...)

> 
> So for system stablility,we can add timeout condition in waiting the
> chanel to be free.

In the end, I could agree that it is unfortunate that, if the SCMI Server
gets stuck also the SCMI Linux agent gets stuck while waiting for a free
channel, so that it could be sensible to timeout as you proposed BUT after
the timeout you should NOT carry on, BUT FAIL the whole transmission;
in this scenario, though, it would be tricky to choose a proper timeout
value, because, as said above, the allowed timeout for the spin would
depend on the number of existing queued in-flight transactions: as an
example, if you had N previous pending transmissions and transport with
X ms timeout, I would spin for at least N * X ms before timing out and
failing. (additionally the current tx_prepare() helpers return voids so
you'll need to figure out a way to report an error and stop the transaction
by 'tunnelling' this errors back to .send_message())

Not sure that all of this kind of work would be worth to address some,
maybe transient, error conditions due to a broken SCMI server, BUT in any
case, any kind of timeout you want to introduce in the spin loop MUST
result in a failed transmission until the FREE bitflag is cleared by the
SCMI server; i.e. if that flag won't be cleared EVER by the server, you
have to end up with a sequence of timed-out spinloops and transmission
failures, you definetely cannot recover forcibly like this.

Fix the SCMI server instead.

Thanks,
Cristian

> 
> Fixes: 9dc34d635c67 ("firmware: arm_scmi: Check if platform has released shmem before using")
> Signed-off-by: Yaxiong Tian <tianyaxiong@kylinos.cn>
> Cc: stable@vger.kernel.org
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Jim Quinlan <james.quinlan@broadcom.com>
> ---
>  drivers/firmware/arm_scmi/shmem.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/arm_scmi/shmem.c b/drivers/firmware/arm_scmi/shmem.c
> index 0e3eaea5d852..ae6110a81855 100644
> --- a/drivers/firmware/arm_scmi/shmem.c
> +++ b/drivers/firmware/arm_scmi/shmem.c
> @@ -8,6 +8,7 @@
>  #include <linux/io.h>
>  #include <linux/processor.h>
>  #include <linux/types.h>
> +#include <linux/ktime.h>
>  
>  #include "common.h"
>  
> @@ -29,17 +30,27 @@ struct scmi_shared_mem {
>  	u8 msg_payload[];
>  };
>  
> +#define SCMI_MAX_TX_PREPARE_TIMEOUT_MS 30
> +
>  void shmem_tx_prepare(struct scmi_shared_mem __iomem *shmem,
>  		      struct scmi_xfer *xfer)
>  {
> +	ktime_t stop = ktime_add_ms(ktime_get(), SCMI_MAX_TX_PREPARE_TIMEOUT_MS);
>  	/*
>  	 * Ideally channel must be free by now unless OS timeout last
>  	 * request and platform continued to process the same, wait
>  	 * until it releases the shared memory, otherwise we may endup
>  	 * overwriting its response with new message payload or vice-versa
>  	 */
> -	spin_until_cond(ioread32(&shmem->channel_status) &
> -			SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
> +	spin_until_cond((ioread32(&shmem->channel_status) &
> +			SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE) ||
> +			ktime_after(ktime_get(), stop));
> +
> +	if (unlikely(ktime_after(ktime_get(), stop))) {
> +		pr_err("timed out in shmem_tx_prepare(caller: %pS).\n",
> +					(void *)_RET_IP_);
> +	}
> +
>  	/* Mark channel busy + clear error */
>  	iowrite32(0x0, &shmem->channel_status);
>  	iowrite32(xfer->hdr.poll_completion ? 0 : SCMI_SHMEM_FLAG_INTR_ENABLED,
> -- 
> 2.25.1
> 
