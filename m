Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E55F5FB461
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiJKOOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiJKOOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:14:33 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 091997EFEE;
        Tue, 11 Oct 2022 07:14:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5108F23A;
        Tue, 11 Oct 2022 07:14:37 -0700 (PDT)
Received: from e120937-lin (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 143EE3F792;
        Tue, 11 Oct 2022 07:14:29 -0700 (PDT)
Date:   Tue, 11 Oct 2022 15:14:27 +0100
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     Yaxiong Tian <iambestgod@qq.com>
Cc:     james.quinlan@broadcom.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sudeep.holla@arm.com, tianyaxiong@kylinos.cn
Subject: Re: [PATCH -next 1/1] firmware: arm_scmi: Fix possible deadlock in
 shmem_tx_prepare()
Message-ID: <Y0V6Q7ZJ3GjBwWub@e120937-lin>
References: <YzrOMKiU3yHt5P/k@e120937-lin>
 <tencent_38B168A1B211AC1C3F5BAACEB5DF9992E107@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_38B168A1B211AC1C3F5BAACEB5DF9992E107@qq.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 03:46:15PM +0800, Yaxiong Tian wrote:
> >Note that there could be also the case in which there are many other
> >threads of executions on different cores trying to send a bunch of SCMI
> >commands (there are indeed many SCMI drivers currently in the stack) so
> >all these requests HAVE TO be queued while waiting for the shared
> >memory area to be free again, so I don't think you can assume in general
> >that shmem_tx_prepare() is called only after a successfull command completion
> >or timeout: it is probably true when an SCMI Mailbox transport is
> >used but it is not neccessarly the case when other shmem based transports
> >like optee/smc are used. You could have N threads trying to send an SCMI
> >command, queued, spinning on that loop, while waiting for the channel to
> >be free: in such a case note that you TX has not even complete, you are
> >still waiting for the channel the SCMI upper layer TX timeout has NOT
> >even being started since your the transmission itself is pending (i.e.
> >send_message has still not returned...)
> 
> I read the code in optee/smc, scmi_optee_send_message()/smc_send_message()
> have channel lock before shmem_tx_prepare(). The lock was released when 
> transports was completed 、timeout or err. So although they have N threads 
> trying to send an SCMI command, queued, but only one could take up the channel.
> Also only one thread call shmem_tx_prepare() in one channel and spin() in it.
> 
> It is also true in mailboxs or other shmem based transports,because SCMI 
> protocol say:"agent must exclusive the channel."This is very reasonable through 
> the channel lock rather than shared memory.
> 
> So it is simple for selecting timeout period. Because there is only one thread 
> spin() in one channel, so the timeout period only depending on the firmware. 
> In other words this time can be a constant. 
> 

Yes, my bad, I forgot that any shared-mem based transport has some kind
of mechanism to access exclusively the channel for the whole transaction
to avoid some thread can issue a tx_prepare before the previous
transaction has fully completed (i.e. the result in the reply, if any,
was fetched before being overwritten by the next)

> >Not sure that all of this kind of work would be worth to address some,
> >maybe transient, error conditions due to a broken SCMI server, BUT in any
> >case, any kind of timeout you want to introduce in the spin loop MUST
> >result in a failed transmission until the FREE bitflag is cleared by the
> >SCMI server; i.e. if that flag won't be cleared EVER by the server, you
> >have to end up with a sequence of timed-out spinloops and transmission
> >failures, you definetely cannot recover forcibly like this.
> 
> I totally agree above.In such broken SCMI server,users cannot get any Any 
> hints.So I think it at least pr_warn(). We can set prepare_tx_timout parameter 
> in scmi_desc,or just set options for users to check error.
>

Problem is anyway, as you said, you'll have to pick this timeout from the
related transport scmi_desc (even if as of now the max_rx_timeout for
all existent shared mem transport is the same..) and this means anyway
adding more complexity to the chain of calls to just to print a warn of
some kind in a rare error-situation from which you cannot recover anyway.

Due to other unrelated discussions, I was starting to think about
exposing some debug-only (Kconfig dependent) SCMI stats like timeouts, errors,
unpexpected/OoO/late_replies in order to ease the debug and monitoring
of the health of a running SCMI stack: maybe this could be a place where
to flag this FW issues without changing the spinloop above (or
to add the kind of timeout you mentioned but only when some sort of
CONFIG_SCMI_DEBUG is enabled...)...still to fully think it through, though.

Any thoughts ?

Thanks,
Cristian
