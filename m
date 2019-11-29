Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F421910DAF8
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 22:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfK2Vd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 16:33:27 -0500
Received: from pb-smtp20.pobox.com ([173.228.157.52]:57750 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfK2Vd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 16:33:27 -0500
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id E7AA594B11;
        Fri, 29 Nov 2019 16:33:21 -0500 (EST)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=qsjoBcgCxyaID9uJZoXhE7gN8Qg=; b=fJLISc
        TjHDSD+xsDF7WgIN09KBQuxcjL2q2WDxtjlsKM8Fy0bSe/QuB8fih8zzQyw+xh3R
        DgnVQWJQ5mpSq5tXB6PwrBOGDjrXc4+2LBWoBN12nmFkGYninZDaFnR2wXqSQG1y
        Yed3wiffysE99y78dqQzOGhcpQY6yMvLFKeEo=
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id CD3B694B10;
        Fri, 29 Nov 2019 16:33:21 -0500 (EST)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=7emamvWS9iC1jKWQznUYgA1WdYW41jXGMGz2oY925AQ=; b=pZw+3rec2kggzCeUe1aDsbNeZvMmmxD/Z3NNp2tZRa5P2lFgQ/RkKwSliuLBNHB19ndlPDnwVSLUqNHeOIG41azWE8DzmPkCRV8u6GxNO8kEQfum3e2s1aqZI6a75mct+kBuSGcsEANCBNlAeQx/W0tkUPAL/hKEjA//lfAC1vc=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id C152294B0F;
        Fri, 29 Nov 2019 16:33:18 -0500 (EST)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id E396D2DA01D7;
        Fri, 29 Nov 2019 16:33:16 -0500 (EST)
Date:   Fri, 29 Nov 2019 16:33:16 -0500 (EST)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Nick Desaulniers <ndesaulniers@google.com>
cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        clang-built-linux@googlegroups.com, manojgupta@google.com,
        natechancellor@gmail.com, Kees Cook <keescook@chromium.org>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: explicitly place .fixup in .text
In-Reply-To: <20191122185522.20582-1-ndesaulniers@google.com>
Message-ID: <nycvar.YSQ.7.76.1911291614480.8537@knanqh.ubzr>
References: <20191122185522.20582-1-ndesaulniers@google.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: DC23B8F4-12EF-11EA-9534-B0405B776F7B-78420484!pb-smtp20.pobox.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Nov 2019, Nick Desaulniers wrote:

> From: Kees Cook <keescook@chromium.org>
> 
> There's an implicit dependency on the section ordering of the orphaned
> section .fixup that can break arm_copy_from_user if the linker places
> the .fixup section before the .text section. Since .fixup is not
> explicitly placed in the existing ARM linker scripts, the linker is free
> to order it anywhere with respect to the rest of the sections.
> 
> Multiple users from different distros (Raspbian, CrOS) reported kernel
> panics executing seccomp() syscall with Linux kernels linked with LLD.
> 
> Documentation/x86/exception-tables.rst alludes to the ordering
> dependency. The relevant quote:
> 
> ```
> NOTE:
> Due to the way that the exception table is built and needs to be ordered,
> only use exceptions for code in the .text section.  Any other section
> will cause the exception table to not be sorted correctly, and the
> exceptions will fail.
> 
> Things changed when 64-bit support was added to x86 Linux. Rather than
> double the size of the exception table by expanding the two entries
> from 32-bits to 64 bits, a clever trick was used to store addresses
> as relative offsets from the table itself. The assembly code changed
> from::
> 
>     .long 1b,3b
>   to:
>           .long (from) - .
>           .long (to) - .
> 
> and the C-code that uses these values converts back to absolute addresses
> like this::
> 
>         ex_insn_addr(const struct exception_table_entry *x)
>         {
>                 return (unsigned long)&x->insn + x->insn;
>         }
> ```
> 
> Since the addresses stored in the __ex_table are RELATIVE offsets and
> not ABSOLUTE addresses, ordering the fixup anywhere that's not
> immediately preceding .text causes the relative offset of the faulting
> instruction to be wrong, causing the wrong (or no) address of the fixup
> handler to looked up in __ex_table.

This explanation makes no sense.

The above is valid only when ARCH_HAS_RELATIVE_EXTABLE is defined. On 
ARM32 it is not, nor would it make sense to be.


Nicolas
