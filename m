Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF17E1C84F4
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 10:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgEGIjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 04:39:00 -0400
Received: from terminus.zytor.com ([198.137.202.136]:33073 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgEGIjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 04:39:00 -0400
Received: from [IPv6:2601:646:8600:3281:6547:66ee:1a90:d675] ([IPv6:2601:646:8600:3281:6547:66ee:1a90:d675])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 0478cW5L3345498
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 7 May 2020 01:38:34 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 0478cW5L3345498
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020042201; t=1588840714;
        bh=Sizgvkow12UlMRPJ88fhJx797WUVfBKXkAG1rgsf2c0=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=pWbvTKbdT3Z9ZpBWKXPBwtJZAXHQfyZjxv1fcHlmU8Y2WI0GKZS+bXW4jKfNVOxuB
         Q1aUV/RIeBosekLXwBmHgCOLaXwaEdyrEzND79HYWl7bbg/rat7qzgs/z1XbXJIh7K
         g5fexfthTHnVCZVWCEsfogbhr8EJmZSoD+dWOFmVK5+SQXg0rAMwIB6Sn0qpAjOryn
         UEmjvXWYSGbNW/8dkn9FMpSsobxxiWlOXcLQrRhPSW1fUj4IZxpXndZ7adrC+MFIGJ
         Q465ut3P1RuXTNwH70HdrtMO4CKS6QfXVYt9OO4xmM+otX7z5fCnDmByw9gRabNsxA
         HOQo13cFyMatg==
Date:   Thu, 07 May 2020 01:38:26 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <ef7d077424554abebbd0d46738c90163@AcuMS.aculab.com>
References: <20200505174423.199985-1-ndesaulniers@google.com> <CAMzpN2idWF2_4wtPebM2B2HVyksknr9hAqK8HJi_vjQ06bgu2g@mail.gmail.com> <60b16c05ca9e4954a7e4fcdd3075e23d@AcuMS.aculab.com> <7C32CF96-0519-4C32-B66B-23AD9C1F1F52@zytor.com> <ef7d077424554abebbd0d46738c90163@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: RE: [PATCH] x86: bitops: fix build regression
To:     David Laight <David.Laight@ACULAB.COM>,
        "'Brian Gerst'" <brgerst@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
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
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
From:   hpa@zytor.com
Message-ID: <3559DCF4-0E59-48DF-8500-D4BA2852975D@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On May 7, 2020 1:35:01 AM PDT, David Laight <David=2ELaight@ACULAB=2ECOM> w=
rote:
>From: hpa@zytor=2Ecom
>> Sent: 07 May 2020 08:59
>> On May 7, 2020 12:44:44 AM PDT, David Laight
><David=2ELaight@ACULAB=2ECOM> wrote:
>> >From: Brian Gerst
>> >> Sent: 07 May 2020 07:18
>> >=2E=2E=2E
>> >> > --- a/arch/x86/include/asm/bitops=2Eh
>> >> > +++ b/arch/x86/include/asm/bitops=2Eh
>> >> > @@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long
>> >*addr)
>> >> >         if (__builtin_constant_p(nr)) {
>> >> >                 asm volatile(LOCK_PREFIX "orb %1,%0"
>> >> >                         : CONST_MASK_ADDR(nr, addr)
>> >> > -                       : "iq" (CONST_MASK(nr) & 0xff)
>> >> > +                       : "iq" ((u8)(CONST_MASK(nr) & 0xff))
>> >>
>> >> I think a better fix would be to make CONST_MASK() return a u8
>value
>> >> rather than have to cast on every use=2E
>> >
>> >Or assign to a local variable - then it doesn't matter how
>> >the value is actually calculated=2E So:
>> >			u8 mask =3D CONST_MASK(nr);
>> >			asm volatile(LOCK_PREFIX "orb %1,%0"
>> >				: CONST_MASK_ADDR(nr, addr)
>> >				: "iq" mask
>> >
>> >	David
>> >
>> >-
>> >Registered Address Lakeside, Bramley Road, Mount Farm, Milton
>Keynes,
>> >MK1 1PT, UK
>> >Registration No: 1397386 (Wales)
>>=20
>> "const u8" please=2E=2E=2E
>
>Why, just a waste of disk space=2E
>
>	David
>
>-
>Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes,
>MK1 1PT, UK
>Registration No: 1397386 (Wales)

Descriptive=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
