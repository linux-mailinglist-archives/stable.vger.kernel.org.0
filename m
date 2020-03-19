Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC38718BF86
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 19:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgCSSnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 14:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgCSSnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 14:43:05 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A3D820787;
        Thu, 19 Mar 2020 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584643384;
        bh=+vgcHdLhhtb+ajyUNxQekv1ON55TgPbVwgX7E6jDLgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sUxpqcgD6Y93HTuHXg5h0Qz3nt+L3A2TfD5OrDS6vZ8dvWZqSV0Ki0TnxUUiJZY6Q
         dmxl/GTcRwlUaw07dL8J++h7uq24D+3hFk7zw4A3UrD2mm33dnZnboHUQD/mDwb2A8
         j03xPtn5geOFe+RB9aX1Wv2ZMxGhr7rDHuARE9K0=
Date:   Thu, 19 Mar 2020 18:42:59 +0000
From:   Will Deacon <will@kernel.org>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: compat: Fix syscall number of compat_clock_getres
Message-ID: <20200319184258.GC27141@willie-the-truck>
References: <20200319141138.19343-1-vincenzo.frascino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319141138.19343-1-vincenzo.frascino@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 02:11:38PM +0000, Vincenzo Frascino wrote:
> The syscall number of compat_clock_getres was erroneously set to 247
> instead of 264. This causes the vDSO fallback of clock_getres to land
> on the wrong syscall.
> 
> Address the issue fixing the syscall number of compat_clock_getres.
> 
> Fixes: 53c489e1dfeb6 ("arm64: compat: Add missing syscall numbers")
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> ---
>  arch/arm64/include/asm/unistd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> index 1dd22da1c3a9..803039d504de 100644
> --- a/arch/arm64/include/asm/unistd.h
> +++ b/arch/arm64/include/asm/unistd.h
> @@ -25,8 +25,8 @@
>  #define __NR_compat_gettimeofday	78
>  #define __NR_compat_sigreturn		119
>  #define __NR_compat_rt_sigreturn	173
> -#define __NR_compat_clock_getres	247
>  #define __NR_compat_clock_gettime	263
> +#define __NR_compat_clock_getres	264
>  #define __NR_compat_clock_gettime64	403
>  #define __NR_compat_clock_getres_time64	406

Ha, what a howler. I'll queue this one as a fix.

Will
