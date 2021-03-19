Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757F1341A3B
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 11:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhCSKkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 06:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhCSKkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 06:40:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5CF464E6B;
        Fri, 19 Mar 2021 10:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616150400;
        bh=upXug4xn2cSMI3wX/C88hwIqnigSyE+kWd7XvhtAWx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQb6LIQ+LxulZcdqI5di1q2vhaiBCfkZzN/03rB+k9dHwWyRKyPN/OOsr8N61AUbo
         G3jMqaXi6SkyXAdKwTI7qhfei+qX80s/hsKBQhHzn1eaPqbDtXf652VHZ/ku150Gmx
         xZ1JdJjteMr9mPTKNoaojWKGPIZgJD50OblpFWD4=
Date:   Fri, 19 Mar 2021 11:39:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nicolas Boichat <drinkcat@chromium.org>
Cc:     stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [for-stable-4.19 PATCH 1/2] vmlinux.lds.h: Create section for
 protection against instrumentation
Message-ID: <YFR/fQIePjDQcO5W@kroah.com>
References: <20210318235416.794798-1-drinkcat@chromium.org>
 <20210319075410.for-stable-4.19.1.I222f801866f71be9f7d85e5b10665cd4506d78ec@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319075410.for-stable-4.19.1.I222f801866f71be9f7d85e5b10665cd4506d78ec@changeid>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 07:54:15AM +0800, Nicolas Boichat wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> commit 6553896666433e7efec589838b400a2a652b3ffa upstream.
> 
> Some code pathes, especially the low level entry code, must be protected
> against instrumentation for various reasons:
> 
>  - Low level entry code can be a fragile beast, especially on x86.
> 
>  - With NO_HZ_FULL RCU state needs to be established before using it.
> 
> Having a dedicated section for such code allows to validate with tooling
> that no unsafe functions are invoked.
> 
> Add the .noinstr.text section and the noinstr attribute to mark
> functions. noinstr implies notrace. Kprobes will gain a section check
> later.
> 
> Provide also a set of markers: instrumentation_begin()/end()
> 
> These are used to mark code inside a noinstr function which calls
> into regular instrumentable text section as safe.
> 
> The instrumentation markers are only active when CONFIG_DEBUG_ENTRY is
> enabled as the end marker emits a NOP to prevent the compiler from merging
> the annotation points. This means the objtool verification requires a
> kernel compiled with this option.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Link: https://lkml.kernel.org/r/20200505134100.075416272@linutronix.de
> 
> [Nicolas: context conflicts in:
> 	arch/powerpc/kernel/vmlinux.lds.S
> 	include/asm-generic/vmlinux.lds.h
> 	include/linux/compiler.h
> 	include/linux/compiler_types.h]
> Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>

Did you build this on x86?

I get the following build error:

ld:./arch/x86/kernel/vmlinux.lds:20: syntax error

And that line looks like:

 . = ALIGN(8); *(.text.hot .text.hot.*) *(.text .text.fixup) *(.text.unlikely .text.unlikely.*) *(.text.unknown .text.unknown.*) . = ALIGN(8); __noinstr_text_start = .; *(.__attribute__((noinline)) __attribute__((no_instrument_function)) __attribute((__section__(".noinstr.text"))).text) __noinstr_text_end = .; *(.text..refcount) *(.ref.text) *(.meminit.text*) *(.memexit.text*)

So I'm going to drop both of these patches from the queue.

thanks,

greg k-h
