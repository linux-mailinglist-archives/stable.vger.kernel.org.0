Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E37412D9C
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 05:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhIUEBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 00:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhIUEBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 00:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1516B611C5;
        Tue, 21 Sep 2021 03:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632196779;
        bh=7OFVjzBNfyXXNiMg++zl6W4YbQ+GkChXNDPM6C4fm5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n3XB9+ugrNqVsTPmuetwR6tFfbxIb+a2Z7toWMqN0Dy+j2Cbd7wAA1OEPwy8tAEbZ
         ZjOua8+cY72aS72AP8eojwewsPQkKUXi2TtXcnk2kUzalmAKD01uRtWYX+3OA8Gepk
         B87YzxW/IBbfeVyitYV3IaTEAdLqdcLDfGb17WGpYDIka9EhrHUme/0D12blfxBtCu
         eJPWLehJsL7qkqgkblKCHlkbCjcuZ/ek106F5zZEGKWvfpWeQoNGGFGljGLDpsIpv1
         OlBIdUGF7H3tJPgr997lQ9+w/Fo16rZSiWOXwAFb2KxZM19MDil9rGz75CswVKOYZB
         7O9rHggfmZiQA==
Date:   Mon, 20 Sep 2021 20:59:33 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, efault@gmx.de,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: Re: [PATCH v2] x86/setup: call early_reserve_memory() earlier
Message-ID: <YUlYpWhGCxpJ9diw@archlinux-ax161>
References: <20210920120421.29276-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210920120421.29276-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 02:04:21PM +0200, Juergen Gross wrote:
> Commit a799c2bd29d19c565 ("x86/setup: Consolidate early memory
> reservations") introduced early_reserve_memory() to do all needed
> initial memblock_reserve() calls in one function. Unfortunately the
> call of early_reserve_memory() is done too late for Xen dom0, as in
> some cases a Xen hook called by e820__memory_setup() will need those
> memory reservations to have happened already.
> 
> Move the call of early_reserve_memory() before the call of
> e820__memory_setup() in order to avoid such problems.
> 
> Cc: stable@vger.kernel.org
> Fixes: a799c2bd29d19c565 ("x86/setup: Consolidate early memory reservations")
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

I had issues on an AMD Ryzen 3 4300G based system with v1. v2 does not
trigger any boot issues on that same machine or an Intel i5-4210U based
system that I also test with.

Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
> V2:
> - update comment (Jan Beulich, Boris Petkov)
> - move call down in setup_arch() (Mike Galbraith)
> ---
>  arch/x86/kernel/setup.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 79f164141116..40ed44ead063 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -830,6 +830,20 @@ void __init setup_arch(char **cmdline_p)
>  
>  	x86_init.oem.arch_setup();
>  
> +	/*
> +	 * Do some memory reservations *before* memory is added to memblock, so
> +	 * memblock allocations won't overwrite it.
> +	 *
> +	 * After this point, everything still needed from the boot loader or
> +	 * firmware or kernel text should be early reserved or marked not RAM in
> +	 * e820. All other memory is free game.
> +	 *
> +	 * This call needs to happen before e820__memory_setup() which calls the
> +	 * xen_memory_setup() on Xen dom0 which relies on the fact that those
> +	 * early reservations have happened already.
> +	 */
> +	early_reserve_memory();
> +
>  	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
>  	e820__memory_setup();
>  	parse_setup_data();
> @@ -876,18 +890,6 @@ void __init setup_arch(char **cmdline_p)
>  
>  	parse_early_param();
>  
> -	/*
> -	 * Do some memory reservations *before* memory is added to
> -	 * memblock, so memblock allocations won't overwrite it.
> -	 * Do it after early param, so we could get (unlikely) panic from
> -	 * serial.
> -	 *
> -	 * After this point everything still needed from the boot loader or
> -	 * firmware or kernel text should be early reserved or marked not
> -	 * RAM in e820. All other memory is free game.
> -	 */
> -	early_reserve_memory();
> -
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  	/*
>  	 * Memory used by the kernel cannot be hot-removed because Linux
> -- 
> 2.26.2
> 
> 
