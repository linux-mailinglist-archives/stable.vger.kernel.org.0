Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAC12C69D
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 14:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfE1Mfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 08:35:42 -0400
Received: from foss.arm.com ([217.140.101.70]:56620 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbfE1Mfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 08:35:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0738780D;
        Tue, 28 May 2019 05:35:42 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 198F23F5AF;
        Tue, 28 May 2019 05:35:40 -0700 (PDT)
Date:   Tue, 28 May 2019 13:35:34 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: Fix the arm64_personality() syscall wrapper
 redirection
Message-ID: <20190528123534.GA26178@lakrids.cambridge.arm.com>
References: <20190528113934.55295-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528113934.55295-1-catalin.marinas@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
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

Evidently I failed to test this case; sorry about that.

FWIW:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

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
>  
>  asmlinkage long sys_ni_syscall(const struct pt_regs *);
>  #define __arm64_sys_ni_syscall	sys_ni_syscall
