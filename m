Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708FC5753A1
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 19:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbiGNRCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 13:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiGNRCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 13:02:31 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1076B5721D;
        Thu, 14 Jul 2022 10:02:30 -0700 (PDT)
Received: from nazgul.tnic (unknown [213.235.133.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D23681EC0513;
        Thu, 14 Jul 2022 19:02:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1657818144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0GRgQQRhSQyl2gobdZAwwP+EFKkYqBFGJjhmFPW3yPQ=;
        b=YIzSUhRvcJR7wKTM4+79/lg+XaSrcqKLiugT7KWvJAVE4crRVVS2+CAS0dOC1x50DomQPp
        FLPw9Jf//9OqB6bjZ0h84x8sq3bmQEEheHqUl2nq2ub+J0lLz5x7tBvKxetgaNF88MZF25
        D7VtiZ2gar85UrNH3ao0GdoZeX1erhc=
Date:   Thu, 14 Jul 2022 19:00:46 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
Message-ID: <YtBLe5AziniDm/Wt@nazgul.tnic>
References: <20220712183238.844813653@linuxfoundation.org>
 <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net>
 <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
 <CAHk-=wjdafFUFwwQNvNQY_D32CBXnp6_V=DL2FpbbdstVxafow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjdafFUFwwQNvNQY_D32CBXnp6_V=DL2FpbbdstVxafow@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 09:51:40AM -0700, Linus Torvalds wrote:
> Oh, absolutely. Doing an -rc7 is normal.

Good. I'm gathering all the fallout fixes and will send them to you on
Sunday, if nothing unexpected happens.

> Right now the question isn't whether an rc7 happens, but whether we'll
> need an rc8. We'll see.

Right, we'll see what additional fallout happens next week. I'll try to
Cc you on such reports so that you're aware.

> Oh, I do hate the hw-embargoed stuff that doesn't get all the usual
> testing in all our automation.

Tell me about it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
