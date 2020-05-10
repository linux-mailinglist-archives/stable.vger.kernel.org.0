Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C283D1CCB1C
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 14:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgEJMet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 08:34:49 -0400
Received: from terminus.zytor.com ([198.137.202.136]:57941 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbgEJMes (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 May 2020 08:34:48 -0400
Received: from [IPv6:2601:646:8600:3281:5dc5:5678:c737:4336] ([IPv6:2601:646:8600:3281:5dc5:5678:c737:4336])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 04ACXuV4568776
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Sun, 10 May 2020 05:33:59 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 04ACXuV4568776
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020042201; t=1589114040;
        bh=7P8+ApyU8rGNqq7/nbyLaPmrJ7F5ICigtbcLd7mTIRw=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=lFeaUOdq+XumhFZG4Zr077W8Fv3g7q/pZ7No97nir7SxYcSW1xV+VYkXFNRr6Z6ee
         XRDfHgujjvnadDG8XbdgSsZlf8RmjoIRwYMzTDNPw37Wej9jEIpwYFCaDS9/xDNQcE
         SFGREaXFUqu+g6ihUuUIacu7aY8HgWv9Q/aCpPg6kYUCT8ek/22zU6KSIQk8l9YCGi
         z8g+u4JoytL1mH7wb8+K6BcNKOWu47b3eXC4BoaVTFxYRTZ+gwq6mpq7OpJhIQk2yi
         irPh1Tc4F/lecNs3eUOahYt2chP8FEl4vQB/pxicPNE34TKd4uCvmkyyPrvKj31x44
         HabQ6f/iQ5CEw==
Date:   Sun, 10 May 2020 05:33:48 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <b1072e7116774e0c9e6e7e6f55bae4a3@AcuMS.aculab.com>
References: <20200505174423.199985-1-ndesaulniers@google.com> <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com> <20200507113422.GA3762@hirez.programming.kicks-ass.net> <CAMzpN2hXUYvLuTA63N56ef4DEzyWXt_uVVq6PV0r8YQT-YN42g@mail.gmail.com> <CAKwvOd=a3MR7osKBpbq=d41ieo7G9FtOp5Kok5por1P5ZS9s4g@mail.gmail.com> <CAKwvOd=Ogbp0oVgmF2B9cePjyWnvLLFRSp2EnaonA-ZFN3K7Dg@mail.gmail.com> <CAMzpN2gu4stkRKTsMTVxyzckO3SMhfA+dmCnSu6-aMg5QAA_JQ@mail.gmail.com> <CAKwvOd=hVKrFU+imSGeX+MEKMpW97gE7bzn1C637qdns9KSnUA@mail.gmail.com> <8f53b69e-86cc-7ff9-671e-5e0a67ff75a2@zytor.com> <b1072e7116774e0c9e6e7e6f55bae4a3@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: RE: [PATCH] x86: bitops: fix build regression
To:     David Laight <David.Laight@ACULAB.COM>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brian Gerst <brgerst@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
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
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
From:   hpa@zytor.com
Message-ID: <216F48DF-7DB5-4F0F-8072-10DBF2F70612@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On May 10, 2020 4:59:17 AM PDT, David Laight <David=2ELaight@ACULAB=2ECOM> =
wrote:
>From: Peter Anvin
>> Sent: 08 May 2020 18:32
>> On 2020-05-08 10:21, Nick Desaulniers wrote:
>> >>
>> >> One last suggestion=2E  Add the "b" modifier to the mask operand:
>"orb
>> >> %b1, %0"=2E  That forces the compiler to use the 8-bit register name
>> >> instead of trying to deduce the width from the input=2E
>> >
>> > Ah right:
>https://gcc=2Egnu=2Eorg/onlinedocs/gcc/Extended-Asm=2Ehtml#x86Operandmodi=
fiers
>> >
>> > Looks like that works for both compilers=2E  In that case, we can
>likely
>> > drop the `& 0xff`, too=2E  Let me play with that, then I'll hopefully
>> > send a v3 today=2E
>> >
>>=20
>> Good idea=2E I requested a while ago that they document these
>modifiers; they
>> chose not to document them all which in some ways is good; it shows
>what they
>> are willing to commit to indefinitely=2E
>
>I thought the intention here was to explicitly do a byte access=2E
>If the constant bit number has had a div/mod by 8 done on it then
>the address can be misaligned - so you mustn't do a non-byte sized
>locked access=2E
>
>OTOH the original base address must be aligned=2E
>
>Looking at some instruction timing, BTS/BTR aren't too bad if the
>bit number is a constant=2E But are 6 or 7 clocks slower if it is in %cl=
=2E
>Given these are locked RMW bus cycles they'll always be slow!
>
>How about an asm multi-part alternative that uses a byte offset
>and byte constant if the compiler thinks the mask is constant
>or a 4-byte offset and 32bit mask if it doesn't=2E
>
>The other alternative is to just use BTS/BTS and (maybe) rely on the
>assembler to add in the word offset to the base address=2E
>
>	David
>
>-
>Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes,
>MK1 1PT, UK
>Registration No: 1397386 (Wales)

I don't understand what you are getting at here=2E

The intent is to do a byte access=2E The "multi-part asm" you are talking =
about is also already there=2E=2E=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
