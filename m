Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAD61C8413
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 09:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgEGH7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 03:59:41 -0400
Received: from terminus.zytor.com ([198.137.202.136]:41511 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgEGH7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 03:59:41 -0400
Received: from [IPv6:2601:646:8600:3281:d918:a6fd:d52c:4754] ([IPv6:2601:646:8600:3281:d918:a6fd:d52c:4754])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 0477xAJT3336894
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 7 May 2020 00:59:10 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 0477xAJT3336894
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020042201; t=1588838351;
        bh=QcutLOCTnJxVMrJr2hvrS8R5JE5w+xhrOu5seWrSXig=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=edDncOw6ExGuJsk6POL7egz6dy6fPWjFEWh3td3E9oMv5SXP0TJbKzQatvtT4mA/j
         FIW8/LpQww4n+9WGTUWqSD2T0iWg4UjNAE4DsNqkc/mf0UV8BDhUqPBwsKqMo8R2AM
         /PTK+lZWRYBujbzoOQIPodZXEvkh9sty32cJT/KBGuBA8xPCyX2CdzirMHzK0f+rfy
         0hwDI7S6Mq6sAVqr6gwuogD8Y6ZN4V2SvhbMUtya6HiJ06MbItx1CqUemLfdJvNpYB
         urzr+rNBVisCE/9E879nByfmNSPBNjvZX7mduX3QwON++dhPNTNACREVYz/i1RqVqa
         8pnWGB4jymFKw==
Date:   Thu, 07 May 2020 00:59:03 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <60b16c05ca9e4954a7e4fcdd3075e23d@AcuMS.aculab.com>
References: <20200505174423.199985-1-ndesaulniers@google.com> <CAMzpN2idWF2_4wtPebM2B2HVyksknr9hAqK8HJi_vjQ06bgu2g@mail.gmail.com> <60b16c05ca9e4954a7e4fcdd3075e23d@AcuMS.aculab.com>
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
Message-ID: <7C32CF96-0519-4C32-B66B-23AD9C1F1F52@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On May 7, 2020 12:44:44 AM PDT, David Laight <David=2ELaight@ACULAB=2ECOM> =
wrote:
>From: Brian Gerst
>> Sent: 07 May 2020 07:18
>=2E=2E=2E
>> > --- a/arch/x86/include/asm/bitops=2Eh
>> > +++ b/arch/x86/include/asm/bitops=2Eh
>> > @@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long
>*addr)
>> >         if (__builtin_constant_p(nr)) {
>> >                 asm volatile(LOCK_PREFIX "orb %1,%0"
>> >                         : CONST_MASK_ADDR(nr, addr)
>> > -                       : "iq" (CONST_MASK(nr) & 0xff)
>> > +                       : "iq" ((u8)(CONST_MASK(nr) & 0xff))
>>=20
>> I think a better fix would be to make CONST_MASK() return a u8 value
>> rather than have to cast on every use=2E
>
>Or assign to a local variable - then it doesn't matter how
>the value is actually calculated=2E So:
>			u8 mask =3D CONST_MASK(nr);
>			asm volatile(LOCK_PREFIX "orb %1,%0"
>				: CONST_MASK_ADDR(nr, addr)
>				: "iq" mask
>
>	David
>
>-
>Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes,
>MK1 1PT, UK
>Registration No: 1397386 (Wales)

"const u8" please=2E=2E=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
