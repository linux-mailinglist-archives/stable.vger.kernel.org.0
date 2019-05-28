Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F3B2C5D0
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 13:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfE1Lvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 07:51:44 -0400
Received: from foss.arm.com ([217.140.101.70]:55854 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbfE1Lvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 07:51:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D58B8341;
        Tue, 28 May 2019 04:51:43 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E856E3F59C;
        Tue, 28 May 2019 04:51:42 -0700 (PDT)
Date:   Tue, 28 May 2019 12:51:40 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm64: Fix the arm64_personality() syscall wrapper
 redirection
Message-ID: <20190528115140.GG20809@fuggles.cambridge.arm.com>
References: <20190528113934.55295-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528113934.55295-1-catalin.marinas@arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 28, 2019 at 12:39:34PM +0100, Catalin Marinas wrote:
> Following commit 4378a7d4be30 ("arm64: implement syscall wrappers"), the
> syscall function names gained the '__arm64_' prefix. Ensure that we
> have the correct #define for redirecting a default syscall through a
> wrapper.
> 
> Fixes: 4378a7d4be30 ("arm64: implement syscall wrappers")
> Cc: <stable@vger.kernel.org> # 4.19.x-
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/kernel/sys.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
> index 6f91e8116514..162a95ed0881 100644
> --- a/arch/arm64/kernel/sys.c
> +++ b/arch/arm64/kernel/sys.c
> @@ -50,7 +50,7 @@ SYSCALL_DEFINE1(arm64_personality, unsigned int, personality)
>  /*
>   * Wrappers to pass the pt_regs argument.
>   */
> -#define sys_personality		sys_arm64_personality
> +#define __arm64_sys_personality		__arm64_sys_arm64_personality

Cheers, I've picked this up as a fix for -rc3.

Will
