Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94C612E9A4
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 19:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgABSBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 13:01:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42431 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbgABSBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 13:01:43 -0500
Received: from [172.58.107.60] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1in4mw-0007Lz-Sp; Thu, 02 Jan 2020 18:01:39 +0000
Date:   Thu, 2 Jan 2020 19:01:33 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amanieu d'Antras <amanieu@gmail.com>, will.deacon@arm.com
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] arm64: Implement copy_thread_tls
Message-ID: <20200102180130.hmpipoiiu3zsl2d6@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200102172413.654385-3-amanieu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200102172413.654385-3-amanieu@gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 06:24:08PM +0100, Amanieu d'Antras wrote:
> This is required for clone3 which passes the TLS value through a
> struct rather than a register.
> 
> Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: <stable@vger.kernel.org> # 5.3.x

This looks sane to me but I'd like an ack from someone who knows his arm
from his arse before taking this. :)
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

> ---
>  arch/arm64/Kconfig          |  1 +
>  arch/arm64/kernel/process.c | 10 +++++-----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b1b4476ddb83..e688dfad0b72 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -138,6 +138,7 @@ config ARM64
>  	select HAVE_CMPXCHG_DOUBLE
>  	select HAVE_CMPXCHG_LOCAL
>  	select HAVE_CONTEXT_TRACKING
> +	select HAVE_COPY_THREAD_TLS
>  	select HAVE_DEBUG_BUGVERBOSE
>  	select HAVE_DEBUG_KMEMLEAK
>  	select HAVE_DMA_CONTIGUOUS
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 71f788cd2b18..d54586d5b031 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -360,8 +360,8 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
>  
>  asmlinkage void ret_from_fork(void) asm("ret_from_fork");
>  
> -int copy_thread(unsigned long clone_flags, unsigned long stack_start,
> -		unsigned long stk_sz, struct task_struct *p)
> +int copy_thread_tls(unsigned long clone_flags, unsigned long stack_start,
> +		unsigned long stk_sz, struct task_struct *p, unsigned long tls)
>  {
>  	struct pt_regs *childregs = task_pt_regs(p);
>  
> @@ -394,11 +394,11 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  		}
>  
>  		/*
> -		 * If a TLS pointer was passed to clone (4th argument), use it
> -		 * for the new thread.
> +		 * If a TLS pointer was passed to clone, use it for the new
> +		 * thread.
>  		 */
>  		if (clone_flags & CLONE_SETTLS)
> -			p->thread.uw.tp_value = childregs->regs[3];
> +			p->thread.uw.tp_value = tls;
>  	} else {
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		childregs->pstate = PSR_MODE_EL1h;
> -- 
> 2.24.1
> 
