Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068BC76372
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 12:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGZKZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 06:25:24 -0400
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:33226 "EHLO
        emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfGZKZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 06:25:24 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jul 2019 06:25:22 EDT
Received: from toshiba (85-76-77-1-nat.elisa-mobile.fi [85.76.77.1])
        by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 3008430034;
        Fri, 26 Jul 2019 13:18:17 +0300 (EEST)
Message-ID: <5D3AD35E.FB77B44F@gmail.com>
Date:   Fri, 26 Jul 2019 13:18:06 +0300
From:   Jari Ruusu <jari.ruusu@gmail.com>
MIME-Version: 1.0
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 079/271] x86/atomic: Fix smp_mb__{before,after}_atomic()
References: <20190724191655.268628197@linuxfoundation.org> <20190724191701.954991110@linuxfoundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote:
> [ Upstream commit 69d927bba39517d0980462efc051875b7f4db185 ]
> 
> Recent probing at the Linux Kernel Memory Model uncovered a
> 'surprise'. Strongly ordered architectures where the atomic RmW
> primitive implies full memory ordering and
> smp_mb__{before,after}_atomic() are a simple barrier() (such as x86)
> fail for:
> 
>         *x = 1;
>         atomic_inc(u);
>         smp_mb__after_atomic();
>         r0 = *y;

[snip]

> --- a/arch/x86/include/asm/atomic.h
> +++ b/arch/x86/include/asm/atomic.h
> @@ -54,7 +54,7 @@ static __always_inline void arch_atomic_add(int i, atomic_t *v)
>  {
>         asm volatile(LOCK_PREFIX "addl %1,%0"
>                      : "+m" (v->counter)
> -                    : "ir" (i));
> +                    : "ir" (i) : "memory");
>  }
> 
>  /**

Shouldn't those clobber contraints actually be:  "memory","cc"
That is because addl subl (and other) machine instructions
actually modify the flags register too.

gcc docs say: The "cc" clobber indicates that the assembler
code modifies the flags register.

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
