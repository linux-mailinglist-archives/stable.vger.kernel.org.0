Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC656E696D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 18:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjDRQZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 12:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbjDRQZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 12:25:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C118BB8A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 09:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC38162D92
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 16:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3626C433D2;
        Tue, 18 Apr 2023 16:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681835151;
        bh=cENXe2EVKKOZ45xsdUHsRD20iZU1EGOtnTQexJaMYPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tyBZ3KURhpCp8SN9WCM66qSmePBZJ8haNGC5PsxiFolNKximAuNOKgeEwe1ntlS+h
         +wUSLUk68/QLQOnWfieiNwU2HaxB3Iu/bEtwO3Cr2iAFd3u9PmJe1kCS/QU3S/lcdA
         NqfwYqJaocL7j/SCWV+6tvCQqxnzuwH2EHA7aNjs=
Date:   Tue, 18 Apr 2023 18:25:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rtmutex: Add acquire semantics for rtmutex lock
 acquisition slow path
Message-ID: <2023041854-cranium-prone-b9fa@gregkh>
References: <20230418154315.9PD52J2N@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418154315.9PD52J2N@linutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 05:43:15PM +0200, Sebastian Andrzej Siewior wrote:
> From: Mel Gorman <mgorman@techsingularity.net>
> 
> commit 1c0908d8e441631f5b8ba433523cf39339ee2ba0 upstream.
> 
> Jan Kara reported the following bug triggering on 6.0.5-rt14 running dbench
> on XFS on arm64.
> 
>  kernel BUG at fs/inode.c:625!
>  Internal error: Oops - BUG: 0 [#1] PREEMPT_RT SMP
>  CPU: 11 PID: 6611 Comm: dbench Tainted: G            E   6.0.0-rt14-rt+ #1
>  pc : clear_inode+0xa0/0xc0
>  lr : clear_inode+0x38/0xc0
>  Call trace:
>   clear_inode+0xa0/0xc0
>   evict+0x160/0x180
>   iput+0x154/0x240
>   do_unlinkat+0x184/0x300
>   __arm64_sys_unlinkat+0x48/0xc0
>   el0_svc_common.constprop.4+0xe4/0x2c0
>   do_el0_svc+0xac/0x100
>   el0_svc+0x78/0x200
>   el0t_64_sync_handler+0x9c/0xc0
>   el0t_64_sync+0x19c/0x1a0
> 
> It also affects 6.1-rc7-rt5 and affects a preempt-rt fork of 5.14 so this
> is likely a bug that existed forever and only became visible when ARM
> support was added to preempt-rt. The same problem does not occur on x86-64
> and he also reported that converting sb->s_inode_wblist_lock to
> raw_spinlock_t makes the problem disappear indicating that the RT spinlock
> variant is the problem.
> 
> Which in turn means that RT mutexes on ARM64 and any other weakly ordered
> architecture are affected by this independent of RT.
> 
> Will Deacon observed:
> 
>   "I'd be more inclined to be suspicious of the slowpath tbh, as we need to
>    make sure that we have acquire semantics on all paths where the lock can
>    be taken. Looking at the rtmutex code, this really isn't obvious to me
>    -- for example, try_to_take_rt_mutex() appears to be able to return via
>    the 'takeit' label without acquire semantics and it looks like we might
>    be relying on the caller's subsequent _unlock_ of the wait_lock for
>    ordering, but that will give us release semantics which aren't correct."
> 
> Sebastian Andrzej Siewior prototyped a fix that does work based on that
> comment but it was a little bit overkill and added some fences that should
> not be necessary.
> 
> The lock owner is updated with an IRQ-safe raw spinlock held, but the
> spin_unlock does not provide acquire semantics which are needed when
> acquiring a mutex.
> 
> Adds the necessary acquire semantics for lock owner updates in the slow path
> acquisition and the waiter bit logic.
> 
> It successfully completed 10 iterations of the dbench workload while the
> vanilla kernel fails on the first iteration.
> 
> [ bigeasy@linutronix.de: Initial prototype fix ]
> 
> Fixes: 700318d1d7b38 ("locking/rtmutex: Use acquire/release semantics")
> Fixes: 23f78d4a03c5 ("[PATCH] pi-futex: rt mutex core")
> Reported-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20221202100223.6mevpbl7i6x5udfd@techsingularity.net
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> Could this be please backported to 5.15 and earlier? It is already part
> of the 6.X kernels. I asked about this by the end of January and I'm
> kindly asking again ;)

I thought this was only an issues when using the out-of-tree RT patches
with these kernels, right?  Or is it relevant for 5.15.y from kernel.org
without anything else?

> This patch applies against v5.15. Should it not apply to earlier
> versions, please let me know an I kindly provide a backport.

How far back should it go?

> I received reports that this fixes "mysterious" crashes and that is how
> I noticed that it is not part of the earlier kernels.

Again, isn't this only needed for -rt kernels?

thanks,

greg k-h
