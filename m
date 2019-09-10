Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4218AF109
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 20:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfIJSam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 14:30:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58755 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfIJSam (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 14:30:42 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46SYW11NV4z9sCJ;
        Wed, 11 Sep 2019 04:30:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1568140238;
        bh=f4U1zO2/pzQQfC6HW1AIvY8jEzHpvz5Va9YInwDeUe4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=bjPAWTkE2pbHDx9ZvsEug69vxtE8M/T3yz/Qd+vrB8ielWshLQ6SaPq+mGAbac2ct
         ej7BQXJYmyEQPMX3ETl4iM0BYuRfmYzjTKbXwy4HtOyNGtv4OsKWUBy/cmESiekcao
         Z834pvArUYWOFG+n9JeXwhoSFnFKZrvnQ2Sho6LOfVE/jSSzKMPyPp6EzJm3o2vK68
         9LD6Ksr+s2ZbX2GMGy6yLQwXSWDU3uqJutIHuvElI5FuD1XlF0Ebdb6AcTN5E5aF/6
         g4IL+72+IJ3MKpJKGUF4TeWwSR727VCuDDNP99bgDwOMKKoLNyXXV9lsYbMLTxlVhW
         ucSd4fpHnrS4A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Segher Boessenkool <segher@kernel.crashing.org>
Cc:     David Laight <David.Laight@aculab.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
In-Reply-To: <20190904231554.GA42450@archlinux-threadripper>
References: <878srdv206.fsf@mpe.ellerman.id.au> <20190828175322.GA121833@archlinux-threadripper> <CAKwvOdmXbYrR6n-cxKt3XxkE4Lmj0sSoZBUtHVb0V2LTUFHmug@mail.gmail.com> <20190828184529.GC127646@archlinux-threadripper> <6801a83ed6d54d95b87a41c57ef6e6b0@AcuMS.aculab.com> <20190903055553.GC60296@archlinux-threadripper> <20190903193128.GC9749@gate.crashing.org> <20190904002401.GA70635@archlinux-threadripper> <1bcd7086f3d24dfa82eec03980f30fbc@AcuMS.aculab.com> <20190904130135.GN9749@gate.crashing.org> <20190904231554.GA42450@archlinux-threadripper>
Date:   Wed, 11 Sep 2019 04:30:38 +1000
Message-ID: <87mufcypf5.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> writes:
> On Wed, Sep 04, 2019 at 08:01:35AM -0500, Segher Boessenkool wrote:
>> On Wed, Sep 04, 2019 at 08:16:45AM +0000, David Laight wrote:
>> > From: Nathan Chancellor [mailto:natechancellor@gmail.com]
>> > > Fair enough so I guess we are back to just outright disabling the
>> > > warning.
>> > 
>> > Just disabling the warning won't stop the compiler generating code
>> > that breaks a 'user' implementation of setjmp().
>> 
>> Yeah.  I have a patch (will send in an hour or so) that enables the
>> "returns_twice" attribute for setjmp (in <asm/setjmp.h>).  In testing
>> (with GCC trunk) it showed no difference in code generation, but
>> better save than sorry.
>> 
>> It also sets "noreturn" on longjmp, and that *does* help, it saves a
>> hundred insns or so (all in xmon, no surprise there).
>> 
>> I don't think this will make LLVM shut up about this though.  And
>> technically it is right: the C standard does say that in hosted mode
>> setjmp is a reserved name and you need to include <setjmp.h> to access
>> it (not <asm/setjmp.h>).
>
> It does not fix the warning, I tested your patch.
>
>> So why is the kernel compiled as hosted?  Does adding -ffreestanding
>> hurt anything?  Is that actually supported on LLVM, on all relevant
>> versions of it?  Does it shut up the warning there (if not, that would
>> be an LLVM bug)?
>
> It does fix this warning because -ffreestanding implies -fno-builtin,
> which also solves the warning. LLVM has supported -ffreestanding since
> at least 3.0.0. There are some parts of the kernel that are compiled
> with this and it probably should be used in more places but it sounds
> like there might be some good codegen improvements that are disabled
> with it:
>
> https://lore.kernel.org/lkml/CAHk-=wi-epJZfBHDbKKDZ64us7WkF=LpUfhvYBmZSteO8Q0RAg@mail.gmail.com/

For xmon.c and crash.c I think using -ffreestanding would be fine.
They're both crash/debug code, so we don't care about minor optimisation
differences. If anything we don't want the compiler being too clever
when generating that code.

cheers
