Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED92926BF2A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgIPI0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 04:26:31 -0400
Received: from mail.skyhub.de ([5.9.137.197]:47556 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgIPI0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 04:26:30 -0400
Received: from zn.tnic (p200300ec2f0c3e00e4ebe415c26f1039.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:3e00:e4eb:e415:c26f:1039])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6FD311EC0330;
        Wed, 16 Sep 2020 10:26:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600244787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K8XdDNTffEBxVg9FrlI2e4DT7s1P+rkY7MIdNMA1C5M=;
        b=GHkvpiG8emGCxbDRJHOoMkKsQkFlhypg1SRq2InapTS5RXayF9QHQPcvVJ5IHZIQoYv6Ka
        /TKUXf6h22TOPcNKeDjh1Kd6hkdq3yML0sk5ZmN/TNjd4LoQqa2IqeEikdHp/URq0JJPy4
        mUc/t7BmJ/+7QyzD2hXW+FY4tDWvRxU=
Date:   Wed, 16 Sep 2020 10:26:21 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Bill Wendling <morbo@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] x86/smap: Fix the smap_save() asm
Message-ID: <20200916082621.GB2643@zn.tnic>
References: <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
 <441AA771-A859-4145-9425-E9D041580FE4@amacapital.net>
 <7233f4cf-5b1d-0fca-0880-f1cf2e6e765b@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7233f4cf-5b1d-0fca-0880-f1cf2e6e765b@citrix.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 12:40:30AM +0100, Andrew Cooper wrote:
> It's worse than that.  Even when stating that %rsp is modified in the
> asm, the generated code sequence is still buggy, for recent Clang and GCC.
> 
> https://godbolt.org/z/ccz9v7
> 
> It's clearly not safe to ever use memory operands with pushf/popf asm
> fragments.

So I went and singlestepped your snippet in gdb. And it all seems to
work - it is simply a bit confusing: :-)

eflags         0x246               [ PF ZF IF ]

=> 0x000055555555505d <main+13>:        9c      pushfq
0x7fffffffe440: 0x00007fffffffe540      0x0000000000000000
0x7fffffffe450: 0x0000000000000000      0x00007ffff7e0ecca
0x7fffffffe460: 0x00007fffffffe548      0x00000001ffffe7c9
0x7fffffffe470: 0x0000555555555050      0x00007ffff7e0e8f8
0x7fffffffe480: 0x0000000000000000      0x0c710afd7e78681b

those lines under the "=>" line are the stack contents printed with

$ x/10gx $sp

Then, we will pop into 0x8(%rsp):

=> 0x55555555505e <main+14>:    popq   0x8(%rsp)
0x7fffffffe438: 0x0000000000000346      0x00007fffffffe540
0x7fffffffe448: 0x0000000000000000      0x0000000000000000
0x7fffffffe458: 0x00007ffff7e0ecca      0x00007fffffffe548
0x7fffffffe468: 0x00000001ffffe7c9      0x0000555555555050
0x7fffffffe478: 0x00007ffff7e0e8f8      0x0000000000000000

Now, POP copies the value pointed to by %rsp, *increments* the stack
pointer and *then* computes the effective address of the operand. It
says so in the SDM too (thanks peterz!):

"If the ESP register is used as a base register for addressing a
destination operand in memory, the POP instruction computes the
effective address of the operand after it increments the ESP register."

*That*s why, FLAGS is in 0x7fffffffe448! which is %rsp + 8.

Basically flags is there *twice* on the stack:

(gdb) x/10x 0x7fffffffe438
0x7fffffffe438: 0x0000000000000346      0x00007fffffffe540
		^^^^^^^^^^^^^^^^^^
0x7fffffffe448: 0x0000000000000346      0x0000000000000000
		^^^^^^^^^^^^^^^^^^
0x7fffffffe458: 0x00007ffff7e0ecca      0x00007fffffffe548
0x7fffffffe468: 0x00000001ffffe7c9      0x0000555555555050
0x7fffffffe478: 0x00007ffff7e0e8f8      0x0000000000000000

and now we read the second copy into %rsi.

=> 0x555555555062 <main+18>:    mov    0x8(%rsp),%rsi
0x7fffffffe440: 0x00007fffffffe540      0x0000000000000346
0x7fffffffe450: 0x0000000000000000      0x00007ffff7e0ecca
0x7fffffffe460: 0x00007fffffffe548      0x00000001ffffe7c9
0x7fffffffe470: 0x0000555555555050      0x00007ffff7e0e8f8
0x7fffffffe480: 0x0000000000000000      0x0c710afd7e78681b

Looks like it works as designed.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
