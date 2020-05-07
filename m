Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688BB1C9B1D
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 21:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgEGTa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 15:30:27 -0400
Received: from terminus.zytor.com ([198.137.202.136]:57983 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgEGTa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 15:30:27 -0400
Received: from [IPv6:2601:646:8600:3281:6547:66ee:1a90:d675] ([IPv6:2601:646:8600:3281:6547:66ee:1a90:d675])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 047JU6CB3526329
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 7 May 2020 12:30:06 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 047JU6CB3526329
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020042201; t=1588879807;
        bh=m0lAyOHoGx1k4YzTje4D7KhG9i4zH9a+UIO21JynQkA=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=Og3DqPf6l861xqxWuiyPyNuU4pi97NvvW9O0+D/WT2BoIFVMYVWnz+ksirKZqnx9g
         1TXrnCYHc6OwJRSiHaXpY+AlkQvr7MlkCL/6LQrXhcYfLKiS88uvFgen5pF4/fTlIa
         Oss3swZ5yMiS4OJCw7ALcqpzXrqnAUS8JUkvQgdR6qNFr1v0TxWhv32pUBZ8rNvnPe
         xJiSNWqOhsEh53wdycUGZ2qghWGVWg8Qhh67MVnwsad0X93fcBscx5A50oR2Ckgl7b
         68CAfCTJEufsK5zDjpF7/mT3S7+TMNvt9BFelv4+nACgez+19fb/cSanapAW7uHDr5
         1x4WdJMkY/SNQ==
Date:   Thu, 07 May 2020 12:29:59 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <CAMzpN2iCgr0rb=MCYPGMx8tcfLq2qdzv0h7YnX5hkzBB+O7JJQ@mail.gmail.com>
References: <20200505174423.199985-1-ndesaulniers@google.com> <CAMzpN2idWF2_4wtPebM2B2HVyksknr9hAqK8HJi_vjQ06bgu2g@mail.gmail.com> <6A99766A-59FB-42DF-9350-80EA671A42B0@zytor.com> <CAMzpN2iCgr0rb=MCYPGMx8tcfLq2qdzv0h7YnX5hkzBB+O7JJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Brian Gerst <brgerst@gmail.com>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        stable <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
From:   hpa@zytor.com
Message-ID: <4AC5875F-4CCD-44D0-9DF6-76A975EC480B@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On May 7, 2020 6:32:24 AM PDT, Brian Gerst <brgerst@gmail=2Ecom> wrote:
>On Thu, May 7, 2020 at 3:02 AM <hpa@zytor=2Ecom> wrote:
>>
>> On May 6, 2020 11:18:09 PM PDT, Brian Gerst <brgerst@gmail=2Ecom>
>wrote:
>> >On Tue, May 5, 2020 at 1:47 PM Nick Desaulniers
>> ><ndesaulniers@google=2Ecom> wrote:
>> >>
>> >> From: Sedat Dilek <sedat=2Edilek@gmail=2Ecom>
>> >>
>> >> It turns out that if your config tickles __builtin_constant_p via
>> >> differences in choices to inline or not, this now produces invalid
>> >> assembly:
>> >>
>> >> $ cat foo=2Ec
>> >> long a(long b, long c) {
>> >>   asm("orb\t%1, %0" : "+q"(c): "r"(b));
>> >>   return c;
>> >> }
>> >> $ gcc foo=2Ec
>> >> foo=2Ec: Assembler messages:
>> >> foo=2Ec:2: Error: `%rax' not allowed with `orb'
>> >>
>> >> The "q" constraint only has meanting on -m32 otherwise is treated
>as
>> >> "r"=2E
>> >>
>> >> This is easily reproducible via
>> >Clang+CONFIG_STAGING=3Dy+CONFIG_VT6656=3Dm,
>> >> or Clang+allyesconfig=2E
>> >>
>> >> Keep the masking operation to appease sparse (`make C=3D1`), add
>back
>> >the
>> >> cast in order to properly select the proper 8b register alias=2E
>> >>
>> >>  [Nick: reworded]
>> >>
>> >> Cc: stable@vger=2Ekernel=2Eorg
>> >> Cc: Jesse Brandeburg <jesse=2Ebrandeburg@intel=2Ecom>
>> >> Link: https://github=2Ecom/ClangBuiltLinux/linux/issues/961
>> >> Link:
>> >https://lore=2Ekernel=2Eorg/lkml/20200504193524=2EGA221287@google=2Eco=
m/
>> >> Fixes: 1651e700664b4 ("x86: Fix bitops=2Eh warning with a moved
>cast")
>> >> Reported-by: Sedat Dilek <sedat=2Edilek@gmail=2Ecom>
>> >> Reported-by: kernelci=2Eorg bot <bot@kernelci=2Eorg>
>> >> Suggested-by: Andy Shevchenko <andriy=2Eshevchenko@intel=2Ecom>
>> >> Suggested-by: Ilie Halip <ilie=2Ehalip@gmail=2Ecom>
>> >> Tested-by: Sedat Dilek <sedat=2Edilek@gmail=2Ecom>
>> >> Signed-off-by: Sedat Dilek <sedat=2Edilek@gmail=2Ecom>
>> >> Signed-off-by: Nick Desaulniers <ndesaulniers@google=2Ecom>
>> >> ---
>> >>  arch/x86/include/asm/bitops=2Eh | 4 ++--
>> >>  1 file changed, 2 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/arch/x86/include/asm/bitops=2Eh
>> >b/arch/x86/include/asm/bitops=2Eh
>> >> index b392571c1f1d=2E=2E139122e5b25b 100644
>> >> --- a/arch/x86/include/asm/bitops=2Eh
>> >> +++ b/arch/x86/include/asm/bitops=2Eh
>> >> @@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long
>*addr)
>> >>         if (__builtin_constant_p(nr)) {
>> >>                 asm volatile(LOCK_PREFIX "orb %1,%0"
>> >>                         : CONST_MASK_ADDR(nr, addr)
>> >> -                       : "iq" (CONST_MASK(nr) & 0xff)
>> >> +                       : "iq" ((u8)(CONST_MASK(nr) & 0xff))
>> >
>> >I think a better fix would be to make CONST_MASK() return a u8 value
>> >rather than have to cast on every use=2E
>> >
>> >Also I question the need for the "q" constraint=2E  It was added in
>> >commit 437a0a54 as a workaround for GCC 3=2E4=2E4=2E  Now that the min=
imum
>> >GCC version is 4=2E6, is this still necessary?
>> >
>> >--
>> >Brian Gerst
>>
>> Yes, "q" is needed on i386=2E
>
>I think the bug this worked around was that the compiler didn't detect
>that CONST_MASK(nr) was also constant and doesn't need to be put into
>a register=2E  The question is does that bug still exist on compiler
>versions we care about?
>
>--
>Brian Gerst

The compiler is free to do that, including for legit reasons (common subex=
pression elimination, especially=2E) So yes=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
