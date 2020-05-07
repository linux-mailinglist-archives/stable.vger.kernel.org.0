Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311991C9B23
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 21:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgEGTbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 15:31:55 -0400
Received: from terminus.zytor.com ([198.137.202.136]:45865 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgEGTby (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 15:31:54 -0400
Received: from [IPv6:2601:646:8600:3281:6547:66ee:1a90:d675] ([IPv6:2601:646:8600:3281:6547:66ee:1a90:d675])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 047JVQfh3526709
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 7 May 2020 12:31:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 047JVQfh3526709
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020042201; t=1588879887;
        bh=KE1Z5fw6ohOckf8wSoQnCowGQBds5ZKNZR3BEwYeyEg=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=diBzyttgruastg6TqrrbhDE00dWFbIySD01pQ8S1/yuYc48lvPH0h95qvE8Na0EeT
         WIvVKOdl6tfwQxaOlytjPfXBCqE2cR/9MWiJo13OLHGJNn1eQHxUMF70yBFfAswzEL
         CQzbPbrzUgKPsimuMEHvACZonqqamq5JZay7lBTrRC/2K4SnruCL1Wr8CMBfzR5pEI
         x2fdERyhHJ3Gc2Ad/nImKmU5w8UsiPQXz4XqCBwAPUpfM7bkpYv5emzH9OojYdLlai
         wbi6skR+XQ2U/UAYiMZxNkzp29SXGcB6XWJK/46XiT/1ZIPZmfNhGrZEy2EslrSeHL
         7UX1/YpAbBcNQ==
Date:   Thu, 07 May 2020 12:31:19 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <9c701ca55bc442c1899a70896f3ea73e@AcuMS.aculab.com>
References: <20200505174423.199985-1-ndesaulniers@google.com> <CAMzpN2idWF2_4wtPebM2B2HVyksknr9hAqK8HJi_vjQ06bgu2g@mail.gmail.com> <6A99766A-59FB-42DF-9350-80EA671A42B0@zytor.com> <CAMzpN2iCgr0rb=MCYPGMx8tcfLq2qdzv0h7YnX5hkzBB+O7JJQ@mail.gmail.com> <9c701ca55bc442c1899a70896f3ea73e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: RE: [PATCH] x86: bitops: fix build regression
To:     David Laight <David.Laight@ACULAB.COM>,
        "'Brian Gerst'" <brgerst@gmail.com>
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
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
From:   hpa@zytor.com
Message-ID: <A6FD91D2-8D3A-4767-B6AD-D35B056C58C4@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On May 7, 2020 8:09:35 AM PDT, David Laight <David=2ELaight@ACULAB=2ECOM> w=
rote:
>From: Brian Gerst
>> Sent: 07 May 2020 14:32
>=2E=2E=2E
>> I think the bug this worked around was that the compiler didn't
>detect
>> that CONST_MASK(nr) was also constant and doesn't need to be put into
>> a register=2E  The question is does that bug still exist on compiler
>> versions we care about?
>
>Hmmm=2E=2E=2E
>That ought to have been fixed instead of worrying about the fact
>that an invalid register was used=2E
>
>Alternatively is there any reason not to use the bts/btc instructions?
>Yes, I know they'll do wider accesses, but variable bit numbers do=2E
>It is also possible that the assembler will support constant bit
>numbers >=3D 32 by adding to the address offset=2E
>
>	David
>
>-
>Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes,
>MK1 1PT, UK
>Registration No: 1397386 (Wales)

They're slower, and for unaligned locked fields can be severely so=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
