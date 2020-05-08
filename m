Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4D81CB608
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 19:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgEHRcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 13:32:22 -0400
Received: from terminus.zytor.com ([198.137.202.136]:59021 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgEHRcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 13:32:22 -0400
Received: from carbon-x1.hos.anvin.org ([IPv6:2601:646:8600:3281:e7ea:4585:74bd:2ff0])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 048HVftM3921978
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 8 May 2020 10:31:41 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 048HVftM3921978
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020042201; t=1588959104;
        bh=j4Wt5+zHny+jNVeWIommm01rPqJoQDpyDmv65ZQS5Sw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qyX9hwhasKyR0D6xlFQuduuCpCaongWidyAWUxb/fhwYDsxx7V0Mfg1EIX1k21YmX
         nBAyONHj/k8sjGGcKRrDex9b0FjXOWMx2KBZtVizuPQo9zSjzCoSCWNPi1CB2myIIK
         6mlS7GT+BqZCcU0iQ+6qqC5m1o1K9ORGf+h4UFQkrIrlGChUGrklB9GYUKAiW6moF3
         DQyMt39w1+13n709biF1A6K8nz94ih9AeZVZ0Y1otScfo1PwknvYrUyGA64Vi2JJuy
         wkXgU+ZJpjnZCca+JM4BjvvlTmKII+Y763LfO/WBIap8QVGV2k4ADuL988yQ4De3C5
         HXAHTXjBpuM5Q==
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Brian Gerst <brgerst@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com>
 <20200507113422.GA3762@hirez.programming.kicks-ass.net>
 <CAMzpN2hXUYvLuTA63N56ef4DEzyWXt_uVVq6PV0r8YQT-YN42g@mail.gmail.com>
 <CAKwvOd=a3MR7osKBpbq=d41ieo7G9FtOp5Kok5por1P5ZS9s4g@mail.gmail.com>
 <CAKwvOd=Ogbp0oVgmF2B9cePjyWnvLLFRSp2EnaonA-ZFN3K7Dg@mail.gmail.com>
 <CAMzpN2gu4stkRKTsMTVxyzckO3SMhfA+dmCnSu6-aMg5QAA_JQ@mail.gmail.com>
 <CAKwvOd=hVKrFU+imSGeX+MEKMpW97gE7bzn1C637qdns9KSnUA@mail.gmail.com>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <8f53b69e-86cc-7ff9-671e-5e0a67ff75a2@zytor.com>
Date:   Fri, 8 May 2020 10:31:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOd=hVKrFU+imSGeX+MEKMpW97gE7bzn1C637qdns9KSnUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-08 10:21, Nick Desaulniers wrote:
>>
>> One last suggestion.  Add the "b" modifier to the mask operand: "orb
>> %b1, %0".  That forces the compiler to use the 8-bit register name
>> instead of trying to deduce the width from the input.
> 
> Ah right: https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#x86Operandmodifiers
> 
> Looks like that works for both compilers.  In that case, we can likely
> drop the `& 0xff`, too.  Let me play with that, then I'll hopefully
> send a v3 today.
> 

Good idea. I requested a while ago that they document these modifiers; they
chose not to document them all which in some ways is good; it shows what they
are willing to commit to indefinitely.

	-hpa
