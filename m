Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AED812E9AC
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 19:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgABSCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 13:02:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42457 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgABSCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 13:02:52 -0500
Received: from [172.58.107.60] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1in4o4-0007SY-A3; Thu, 02 Jan 2020 18:02:49 +0000
Date:   Thu, 2 Jan 2020 19:02:43 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amanieu d'Antras <amanieu@gmail.com>, will.deacon@arm.com
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/7] arm: Implement copy_thread_tls
Message-ID: <20200102180241.ialbcdhaikqltkfm@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200102172413.654385-4-amanieu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200102172413.654385-4-amanieu@gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 06:24:09PM +0100, Amanieu d'Antras wrote:
> This is required for clone3 which passes the TLS value through a
> struct rather than a register.
> 
> Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: <stable@vger.kernel.org> # 5.3.x

Again, looks good to me but I'd like an ack from someone closer to the
architecture itself.
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

> ---
>  arch/arm/Kconfig          | 1 +
>  arch/arm/kernel/process.c | 6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index ba75e3661a41..96dab76da3b3 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -72,6 +72,7 @@ config ARM
>  	select HAVE_ARM_SMCCC if CPU_V7
>  	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
>  	select HAVE_CONTEXT_TRACKING
> +	select HAVE_COPY_THREAD_TLS
>  	select HAVE_C_RECORDMCOUNT
>  	select HAVE_DEBUG_KMEMLEAK
>  	select HAVE_DMA_CONTIGUOUS if MMU
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index cea1c27c29cb..46e478fb5ea2 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -226,8 +226,8 @@ void release_thread(struct task_struct *dead_task)
>  asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
>  
>  int
> -copy_thread(unsigned long clone_flags, unsigned long stack_start,
> -	    unsigned long stk_sz, struct task_struct *p)
> +copy_thread_tls(unsigned long clone_flags, unsigned long stack_start,
> +	    unsigned long stk_sz, struct task_struct *p, unsigned long tls)
>  {
>  	struct thread_info *thread = task_thread_info(p);
>  	struct pt_regs *childregs = task_pt_regs(p);
> @@ -261,7 +261,7 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	clear_ptrace_hw_breakpoint(p);
>  
>  	if (clone_flags & CLONE_SETTLS)
> -		thread->tp_value[0] = childregs->ARM_r3;
> +		thread->tp_value[0] = tls;
>  	thread->tp_value[1] = get_tpuser();
>  
>  	thread_notify(THREAD_NOTIFY_COPY, thread);
> -- 
> 2.24.1
> 
