Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612695753F4
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 19:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiGNRWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 13:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGNRWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 13:22:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBA54F642;
        Thu, 14 Jul 2022 10:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=htDFA1Y7dlEasSYr1rXrw+KJdNZ2vQTs/F4G7+dnxHc=; b=vF7uoe/sCJwSIeJJcf4y6HPKM2
        Q3yipjaZYv0Hmbou/nWc9Iy5EkFsMo+uDuFtNRjlgF9TyVfjrjcmF9BpPxq2VBZ5qauRgwsK8IrVi
        83yuE0iiD52ag2wAsQdie4D8f+5aRmsf+ZGGjqIi/cmVrxCUVEB2hQREKYgCHcpjTr2fby2czP3rC
        W/V8zgXnXHl+hDE111cklWOQhqbKxMcFNBRzldUrIE2sfJMyre3XWmkSuiGpYvzcXljmNPBJCKB6k
        3GsnI3G4n4h7z46pDkwqFMt5vZLUAr0WiAuPU9F1RdmUf4AY80A5pwqkSi1GK9LjfdgQxFAVpjDy5
        ivJO228w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oC2XM-009XzV-3L; Thu, 14 Jul 2022 17:22:04 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id AD80B980185; Thu, 14 Jul 2022 19:22:02 +0200 (CEST)
Date:   Thu, 14 Jul 2022 19:22:02 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Boris Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        kvm list <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>, patches@kernelci.org,
        Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        lkft-triage@lists.linaro.org,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
Message-ID: <YtBQutgSh2j3mFNB@worktop.programming.kicks-ass.net>
References: <20220712183238.844813653@linuxfoundation.org>
 <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net>
 <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
 <6b4337f4-d1de-7ba3-14e8-3ad0f9b18788@redhat.com>
 <8BEC3365-FC09-46C5-8211-518657C0308E@alien8.de>
 <CAHk-=wj4vtoWZPMXJU-B9qW1zLHsoA1Qb2P0NW=UFhZmrCrf9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj4vtoWZPMXJU-B9qW1zLHsoA1Qb2P0NW=UFhZmrCrf9Q@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 10:02:57AM -0700, Linus Torvalds wrote:

> I like Peter's more obvious use of FASTYOP_LENGTH, but this is just disgusting:
> 
>     #define FASTOP_SIZE (8 << ((FASTOP_LENGTH > 8) & 1) <<
> ((FASTOP_LENGTH > 16) & 1))
> 
> I mean, I understand what it's doing, but just two lines above it the
> code has a "ilog2()" use that already depends on the fact that you can
> use ilog2() as a constant compile-time expression.
> 
> And guess what? The code could just use roundup_pow_of_two(), which is
> designed exactly like ilog2() to be used for compile-time constant
> values.

But NR_FASTOP isn't used in ASM.

> So the code should just use
> 
>     #define FASTOP_SIZE roundup_pow_of_two(FASTOP_LENGTH)
> 
> and be a lot more legible, wouldn't it?

If only :/ FASTOP_SIZE is used in ASM, which means we've got to play by
GNU-as rules, and them are aweful.
