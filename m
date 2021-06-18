Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C620D3AC205
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 06:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhFREZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 00:25:47 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37069 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231987AbhFREZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 00:25:14 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4G5m4S5Qndz9t0k; Fri, 18 Jun 2021 14:23:04 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
In-Reply-To: <20210528182752.1852002-1-nathan@kernel.org>
References: <20210528182752.1852002-1-nathan@kernel.org>
Subject: Re: [PATCH] powerpc/barrier: Avoid collision with clang's __lwsync macro
Message-Id: <162398828610.1363949.4994127237137922755.b4-ty@ellerman.id.au>
Date:   Fri, 18 Jun 2021 13:51:26 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 28 May 2021 11:27:52 -0700, Nathan Chancellor wrote:
> A change in clang 13 results in the __lwsync macro being defined as
> __builtin_ppc_lwsync, which emits 'lwsync' or 'msync' depending on what
> the target supports. This breaks the build because of -Werror in
> arch/powerpc, along with thousands of warnings:
> 
>  In file included from arch/powerpc/kernel/pmc.c:12:
>  In file included from include/linux/bug.h:5:
>  In file included from arch/powerpc/include/asm/bug.h:109:
>  In file included from include/asm-generic/bug.h:20:
>  In file included from include/linux/kernel.h:12:
>  In file included from include/linux/bitops.h:32:
>  In file included from arch/powerpc/include/asm/bitops.h:62:
>  arch/powerpc/include/asm/barrier.h:49:9: error: '__lwsync' macro redefined [-Werror,-Wmacro-redefined]
>  #define __lwsync()      __asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
>         ^
>  <built-in>:308:9: note: previous definition is here
>  #define __lwsync __builtin_ppc_lwsync
>         ^
>  1 error generated.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/barrier: Avoid collision with clang's __lwsync macro
      https://git.kernel.org/powerpc/c/015d98149b326e0f1f02e44413112ca8b4330543

cheers
