Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA866B3FC3
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCJMzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCJMyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:54:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3643619C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:54:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E6A460AEE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 12:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BCFC433EF;
        Fri, 10 Mar 2023 12:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678452891;
        bh=cN4e/vzA9hB7UmcNbeoEOljCGOZyy8yqiC7TP0J8yWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bNm+PHeDgNDRVPw3jfeOhib78TRAeo+KE/i54NWQ74rwVRGBUGAf6TSPGUt9TtyZQ
         L+KfCMNa7N7VfJkqippvIGx9Tx6i8I+1OA/E+trDja2tNqc0h3EB9k0vlXPjFy0j1d
         luUknQ6vI/JqXJ2ctuKTCOH5ZEruCtluGXGQM2pc=
Date:   Fri, 10 Mar 2023 13:54:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     stable@vger.kernel.org, Pierre Gondois <pierre.gondois@arm.com>
Subject: Re: [PATCH 6.1.y] arm64: efi: Make efi_rt_lock a raw_spinlock
Message-ID: <ZAsolxJ5QxsKTm8n@kroah.com>
References: <167818210919025@kroah.com>
 <20230307164150.2430120-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307164150.2430120-1-ardb@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 05:41:50PM +0100, Ard Biesheuvel wrote:
> From: Pierre Gondois <pierre.gondois@arm.com>
> 
> [ Upstream commit 0e68b5517d3767562889f1d83fdb828c26adb24 ]
> 
> Running a rt-kernel base on 6.2.0-rc3-rt1 on an Ampere Altra outputs
> the following:
>   BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
>   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 9, name: kworker/u320:0
>   preempt_count: 2, expected: 0
>   RCU nest depth: 0, expected: 0
>   3 locks held by kworker/u320:0/9:
>   #0: ffff3fff8c27d128 ((wq_completion)efi_rts_wq){+.+.}-{0:0}, at: process_one_work (./include/linux/atomic/atomic-long.h:41)
>   #1: ffff80000861bdd0 ((work_completion)(&efi_rts_work.work)){+.+.}-{0:0}, at: process_one_work (./include/linux/atomic/atomic-long.h:41)
>   #2: ffffdf7e1ed3e460 (efi_rt_lock){+.+.}-{3:3}, at: efi_call_rts (drivers/firmware/efi/runtime-wrappers.c:101)
>   Preemption disabled at:
>   efi_virtmap_load (./arch/arm64/include/asm/mmu_context.h:248)
>   CPU: 0 PID: 9 Comm: kworker/u320:0 Tainted: G        W          6.2.0-rc3-rt1
>   Hardware name: WIWYNN Mt.Jade Server System B81.03001.0005/Mt.Jade Motherboard, BIOS 1.08.20220218 (SCP: 1.08.20220218) 2022/02/18
>   Workqueue: efi_rts_wq efi_call_rts
>   Call trace:
>   dump_backtrace (arch/arm64/kernel/stacktrace.c:158)
>   show_stack (arch/arm64/kernel/stacktrace.c:165)
>   dump_stack_lvl (lib/dump_stack.c:107 (discriminator 4))
>   dump_stack (lib/dump_stack.c:114)
>   __might_resched (kernel/sched/core.c:10134)
>   rt_spin_lock (kernel/locking/rtmutex.c:1769 (discriminator 4))
>   efi_call_rts (drivers/firmware/efi/runtime-wrappers.c:101)
>   [...]
> 
> This seems to come from commit ff7a167961d1 ("arm64: efi: Execute
> runtime services from a dedicated stack") which adds a spinlock. This
> spinlock is taken through:
> efi_call_rts()
> \-efi_call_virt()
>   \-efi_call_virt_pointer()
>     \-arch_efi_call_virt_setup()
> 
> Make 'efi_rt_lock' a raw_spinlock to avoid being preempted.
> 
> [ardb: The EFI runtime services are called with a different set of
>        translation tables, and are permitted to use the SIMD registers.
>        The context switch code preserves/restores neither, and so EFI
>        calls must be made with preemption disabled, rather than only
>        disabling migration.]
> 
> Fixes: ff7a167961d1 ("arm64: efi: Execute runtime services from a dedicated stack")
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
> Cc: <stable@vger.kernel.org> # v6.1+
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Now queued up, thanks.

greg k-h
