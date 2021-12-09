Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC6F46ED3C
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 17:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbhLIQlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 11:41:21 -0500
Received: from mail.skyhub.de ([5.9.137.197]:33878 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239675AbhLIQlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 11:41:19 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 13FC61EC04D3;
        Thu,  9 Dec 2021 17:37:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639067860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0nLQ0BMqQ23yc81J1J+FHAbSSeprtKANW3l+l71OuQ=;
        b=XsiLRniZfsshKpCSL78DEBz7Y6xMDdigdCADTE++5aGBZjYaZt4IwEfpS8HXovg53YDA8l
        ftyNhquX9ok4X2TlBHPQKk4ZaTMPUD45KTZxu+MDPfjzBMVydmbo83556Wt/MKlrOJ0UvF
        sp4stXlUKHo7xpagGrPT7t0i7aBTNYA=
Date:   Thu, 9 Dec 2021 17:37:42 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org,
        Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbIw1nUYJ3KlkjJQ@zn.tnic>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YbIu55LZKoK3IVaF@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 06:29:27PM +0200, Mike Rapoport wrote:
> On Thu, Dec 09, 2021 at 04:28:48PM +0100, Borislav Petkov wrote:
> > On Thu, Dec 09, 2021 at 04:26:55PM +0100, Juergen Gross wrote:
> > > Sigh. This will break Xen PV. Again. The comment above the call of
> > > early_reserve_memory() tells you why.
> > 
> > I know. I was just looking at how to fix that particular thing and was
> > going to find you on IRC to talk to you about it...
> 
> The memory reservation in arch/x86/platform/efi/efi.c depends on at least
> two command line parameters, I think it's better put it back later in the
> boot process and move efi_memblock_x86_reserve_range() out of
> early_memory_reserve().
> 
> I.e. revert c0f2077baa41 ("x86/boot: Mark prepare_command_line() __init")
> and 8d48bf8206f7 ("x86/boot: Pull up cmdline preparation and early param
> parsing") and add the patch below on top.
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 49b596db5631..da36b8f8430b 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -713,9 +713,6 @@ static void __init early_reserve_memory(void)
>  
>  	early_reserve_initrd();
>  
> -	if (efi_enabled(EFI_BOOT))
> -		efi_memblock_x86_reserve_range();
> -
>  	memblock_x86_reserve_range_setup_data();
>  
>  	reserve_ibft_region();
> @@ -890,6 +887,9 @@ void __init setup_arch(char **cmdline_p)
>  
>  	parse_early_param();
>  
> +	if (efi_enabled(EFI_BOOT)) {
> +		efi_memblock_x86_reserve_range();
> +
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  	/*
>  	 * Memory used by the kernel cannot be hot-removed because Linux
> 
> -- 

Jürgen and I were thinking about a different fix but that's probably
ok too. But I've said that already about this mess and there's always
something we haven't thought about.

Whatever we do, it needs to be tested by all folks on Cc who already
reported regressions, i.e., Anjaneya, Hugh, John and Patrick.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
