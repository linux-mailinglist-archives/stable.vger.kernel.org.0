Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843D41C9B15
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 21:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgEGT3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 15:29:53 -0400
Received: from terminus.zytor.com ([198.137.202.136]:54263 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgEGT3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 15:29:53 -0400
Received: from [IPv6:2601:646:8600:3281:6547:66ee:1a90:d675] ([IPv6:2601:646:8600:3281:6547:66ee:1a90:d675])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 047JTFWT3526223
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 7 May 2020 12:29:17 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 047JTFWT3526223
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020042201; t=1588879758;
        bh=oMuTSM+aenjMY6wnxSPIpZxcMGTGHNcIWJGGr/PBUHg=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=a5Huglbyy7CI17USh/5x8pPgRMvYdF8VgvylNOPkeaEqEjZxeRc3FDKQlGoYMXn9C
         9s1AeunyVpKe3Q+QoqzVMuqvMODjPqJrrCuGiSMJy1rQBbI5pCfQztxQw+8+h7JZEO
         v3LzN2SIK+ZXyPvdbGA5LjH7d1+YDKfJXO8WklUF93YYB0EKJ6PGwlZIsgpVMA2HjF
         7ZC8WrzfLEeNDsQs5wrLHBaNHGBVcf23bjB6Tk/CArhdYYMckb9aLV2mzqoOzeFPdE
         1xS+KjxQf0K+BrduhEFb6MWNu1SaGfAChzL5+un/gv8NAIsJoQam+n8jMy8biEcVOS
         EO+QCxH4V/RZQ==
Date:   Thu, 07 May 2020 12:29:08 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <20200507113422.GA3762@hirez.programming.kicks-ass.net>
References: <20200505174423.199985-1-ndesaulniers@google.com> <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com> <20200507113422.GA3762@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>, x86@kernel.org,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
From:   hpa@zytor.com
Message-ID: <C98D29AB-442F-4DF8-8B72-9F6483A7222A@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On May 7, 2020 4:34:22 AM PDT, Peter Zijlstra <peterz@infradead=2Eorg> wrot=
e:
>On Tue, May 05, 2020 at 11:07:24AM -0700, hpa@zytor=2Ecom wrote:
>> On May 5, 2020 10:44:22 AM PDT, Nick Desaulniers
><ndesaulniers@google=2Ecom> wrote:
>
>> >@@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long
>*addr)
>> > 	if (__builtin_constant_p(nr)) {
>> > 		asm volatile(LOCK_PREFIX "orb %1,%0"
>> > 			: CONST_MASK_ADDR(nr, addr)
>> >-			: "iq" (CONST_MASK(nr) & 0xff)
>> >+			: "iq" ((u8)(CONST_MASK(nr) & 0xff))
>> > 			: "memory");
>> > 	} else {
>> > 		asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
>> >@@ -74,7 +74,7 @@ arch_clear_bit(long nr, volatile unsigned long
>*addr)
>> > 	if (__builtin_constant_p(nr)) {
>> > 		asm volatile(LOCK_PREFIX "andb %1,%0"
>> > 			: CONST_MASK_ADDR(nr, addr)
>> >-			: "iq" (CONST_MASK(nr) ^ 0xff));
>> >+			: "iq" ((u8)(CONST_MASK(nr) ^ 0xff)));
>> > 	} else {
>> > 		asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
>> > 			: : RLONG_ADDR(addr), "Ir" (nr) : "memory");
>>=20
>> Drop & 0xff and change ^ 0xff to ~=2E
>
>But then we're back to sparse being unhappy, no? The thing with ~ is
>that it will set high bits which will be truncated, which makes sparse
>sad=2E

In that case, sparse is just broken=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
