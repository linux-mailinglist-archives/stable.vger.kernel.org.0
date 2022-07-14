Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E4857536F
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 18:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiGNQxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 12:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbiGNQwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 12:52:49 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B17F2E696
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 09:52:00 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dn9so4457819ejc.7
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 09:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UkKAKPPtro79xKHDPBehtihMhR7Lh7lQwIdzYzaJOZw=;
        b=Mr94LDjwnV8nGBNNVAJX0c9LMeMtH4cDpRa5fj+6lq8ilb1VFMXaD3H2Ik9nf7Im9V
         XZyhuuiBGMSLiEDZ8jkg99ghi7VhgSI6uCGroUHirIu1a+9FR19M3SveBO6J6ruu/gBv
         73wvSSvqkb+WbC+/4GP+cysrOXahEAqgw1UYI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UkKAKPPtro79xKHDPBehtihMhR7Lh7lQwIdzYzaJOZw=;
        b=UvLe2csLM/7lR7BgskaIgSpAWM8E94axeDoxlEeZRlaVC5ywlUIZul2UNVNS3qiMth
         zuX6SEjFRgx/Tg954kfTrjqVEFgapdkNKASwazR6laO371jbnWu0xOZGv+2z5Rg/YPZY
         ZSF35AU2kazNDiHrof32QFoKIJV4lGsoekK5Z2fL8fsZtRjjP+MDQt0jonabjaBB8CSC
         3cydt88/LULZgmDGnOezqAM0QIQTLFwZl2ApquB5XviCT4A8A9LhcNzhIJdPoeIc7bod
         E6JhmEK3vXlveyqoCQ7h7DwKPyjYyWkAb4ZFtdUw2bKUtqlmHfG7Y6SZFEZmHkzWkRq/
         zhUA==
X-Gm-Message-State: AJIora+UVnVMtECyx1KTEekgMKAPCAyo6MUSGUchdQD0StUjVlPyAUtf
        Ck9P4/1Sg7txxLMqZctKQVNb9l5b6Y/+VCeWuWE=
X-Google-Smtp-Source: AGRyM1v95uQLazFUY9xjFxvh3JJz1K5JJCr68BcrA2eR6aCKs0xnO4ElU9nos11FCWx5RXJRydLf2A==
X-Received: by 2002:a17:906:5d0b:b0:726:a043:fcb4 with SMTP id g11-20020a1709065d0b00b00726a043fcb4mr9334390ejt.508.1657817518733;
        Thu, 14 Jul 2022 09:51:58 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id h27-20020a170906719b00b0072aeaa1bb5esm882204ejk.211.2022.07.14.09.51.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 09:51:57 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so1561768wmb.3
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 09:51:57 -0700 (PDT)
X-Received: by 2002:a7b:cd97:0:b0:3a2:dfcf:dd2d with SMTP id
 y23-20020a7bcd97000000b003a2dfcfdd2dmr15971099wmj.68.1657817517167; Thu, 14
 Jul 2022 09:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com> <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
In-Reply-To: <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 09:51:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjdafFUFwwQNvNQY_D32CBXnp6_V=DL2FpbbdstVxafow@mail.gmail.com>
Message-ID: <CAHk-=wjdafFUFwwQNvNQY_D32CBXnp6_V=DL2FpbbdstVxafow@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
To:     Borislav Petkov <bp@alien8.de>
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
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 2:02 AM Borislav Petkov <bp@alien8.de> wrote:
>
> I'm guessing you're thinking of cutting an -rc7 so that people can test
> the whole retbleed mitigation disaster an additional week?

Oh, absolutely. Doing an -rc7 is normal.

Right now the question isn't whether an rc7 happens, but whether we'll
need an rc8. We'll see.

Oh, I do hate the hw-embargoed stuff that doesn't get all the usual
testing in all our automation.

             Linus
