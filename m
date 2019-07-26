Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D549766F2
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfGZNIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbfGZNIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:08:39 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D119218D4;
        Fri, 26 Jul 2019 13:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564146518;
        bh=nyisBE4O2xGmPKme/Zgrvs6HBJR9RJ66g+1LT4Ivjrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LgQXq098EtOVgHG67rjk7dt3bpXrJlPkAQoNpmFWb4NWHDIs142jU+8ycHZhU7s2L
         Emer6MdM1EHnQbBNgkaPghRuN98oX6dv6jGsri2XZ7s7mB2pNt7uQlbnDhLM3q5IQR
         RtmZ//o5SEKJzLsfndCe9lp0gfG61xYdVN0HpgaQ=
Date:   Fri, 26 Jul 2019 14:08:34 +0100
From:   Will Deacon <will@kernel.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm: perf: Mark expected switch fall-through
Message-ID: <20190726130834.coonga4kygk23ojx@willie-the-truck>
References: <20190726112732.19257-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190726112732.19257-1-anders.roxell@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 01:27:32PM +0200, Anders Roxell wrote:
> When fall-through warnings was enabled by default, d93512ef0f0e
> ("Makefile: Globally enable fall-through warning"), we could see the
> following warnings was starting to show up. However, this was originally
> introduced in commit 6ee33c2712fc ("ARM: hw_breakpoint: correct and
> simplify alignment fixup code"). Commit d968d2b801d8 ("ARM: 7497/1:
> hw_breakpoint: allow single-byte watchpoints on all addresses") was
> written with the intent to allow single-byte watchpoints on all
> addresses but forgot to move 'case 1:' down below 'case 2:'.
> 
> ../arch/arm/kernel/hw_breakpoint.c: In function ‘hw_breakpoint_arch_parse’:
> ../arch/arm/kernel/hw_breakpoint.c:609:7: warning: this statement may fall
>  through [-Wimplicit-fallthrough=]
>     if (hw->ctrl.len == ARM_BREAKPOINT_LEN_2)
>        ^
> ../arch/arm/kernel/hw_breakpoint.c:611:3: note: here
>    case 3:
>    ^~~~
> ../arch/arm/kernel/hw_breakpoint.c:613:7: warning: this statement may fall
>  through [-Wimplicit-fallthrough=]
>     if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
>        ^
> ../arch/arm/kernel/hw_breakpoint.c:615:3: note: here
>    default:
>    ^~~~~~~
> 
> Rework so 'case 1:' are next to 'case 3:' and also add '/* Fall through
> */' so that the compiler doesn't warn about fall-through.
> 
> Cc: stable@vger.kernel.org # v3.16
> Fixes: 6ee33c2712fc ("ARM: hw_breakpoint: correct and simplify alignment fixup code")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  arch/arm/kernel/hw_breakpoint.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
> index af8b8e15f589..c14d506969ba 100644
> --- a/arch/arm/kernel/hw_breakpoint.c
> +++ b/arch/arm/kernel/hw_breakpoint.c
> @@ -603,15 +603,17 @@ int hw_breakpoint_arch_parse(struct perf_event *bp,
>  	case 0:
>  		/* Aligned */
>  		break;
> -	case 1:
>  	case 2:
>  		/* Allow halfword watchpoints and breakpoints. */
>  		if (hw->ctrl.len == ARM_BREAKPOINT_LEN_2)
>  			break;
> +		/* Fall through */
> +	case 1:

Why are you moving the 'case 1:' here? AFAICT, your patch now rejects
byte-aligned watchpoints of length 2.

Will
