Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEF3575469
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 20:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiGNSHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 14:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiGNSHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 14:07:05 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432F4474DB
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 11:07:04 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id fy29so3693359ejc.12
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 11:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=st47So/rwylJOlwtbMqxK/O46KsROoXn2ouiahN8FRI=;
        b=OP86xzTmkeclqIz/z18UUZ5PkWsI6wb4tfrSdG5oDKVGRV4m1+AlgDRDcTntolmTqx
         RXRW5nF4gn4fIL2bexKbBZdZYAnkTJFAk29svJFVpqdaFKpANdV7QXTjB5Y3JV+r0RfA
         93kXdCaGY6rSZrjvikkesz6sOngtQASnCtDlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=st47So/rwylJOlwtbMqxK/O46KsROoXn2ouiahN8FRI=;
        b=OjejQTUZjoaWspYn7VP4ah9VZI1PxsjAdlx4082Ur8VaKxIV1KWczflSjpYNL5xKMK
         0+7YCcKKJvmAbL5y0H2wJg7thhL5TjEmpxbtEsRqJVWbgyDC1ZPHRsU3qopYbXiaOyUN
         ehEGSp4XHKOcjgTnvZxBT9C2XimYy8Ozr+vqzT1VLCZ8a9JJ+CQGyhEjF9luLO6W9IER
         Mtssw/IaAbp/A9YF4yPjLPzITgnKxeJDQT0DzNoaA32vfzWP7O7ab6nr8aHmrxlpCVlZ
         slfV+4IIKp5dHzVrA+xhh+OS9vjUjpIs0u41rIl6Y78swLaJcqCxZUdGrGmQvf1/E9tl
         xLTg==
X-Gm-Message-State: AJIora+Pgoa/DU910E8oHzGkKyT5JdvPpV20YNBDjgvliQpZljyPq9XF
        NVQRW7wt5zFcMWOQYM71cjNDyBmwRZi9mT/5AFA=
X-Google-Smtp-Source: AGRyM1uILSCYx8JxAD3mIclyQKjJxNaIzOzwM1FJj/nY+L58u6iM5fEy9m6Gpaf70nuiIeBklExYKw==
X-Received: by 2002:a17:907:948a:b0:726:f3d7:c7d6 with SMTP id dm10-20020a170907948a00b00726f3d7c7d6mr10156154ejc.2.1657822022529;
        Thu, 14 Jul 2022 11:07:02 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709060cca00b0070b7875aa6asm943124ejh.166.2022.07.14.11.07.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 11:07:02 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id j22so4845991ejs.2
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 11:07:01 -0700 (PDT)
X-Received: by 2002:a5d:69c2:0:b0:21d:807c:a892 with SMTP id
 s2-20020a5d69c2000000b0021d807ca892mr9404442wrw.274.1657821618605; Thu, 14
 Jul 2022 11:00:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic> <6b4337f4-d1de-7ba3-14e8-3ad0f9b18788@redhat.com>
 <8BEC3365-FC09-46C5-8211-518657C0308E@alien8.de> <CAHk-=wj4vtoWZPMXJU-B9qW1zLHsoA1Qb2P0NW=UFhZmrCrf9Q@mail.gmail.com>
 <YtBQutgSh2j3mFNB@worktop.programming.kicks-ass.net>
In-Reply-To: <YtBQutgSh2j3mFNB@worktop.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 11:00:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjAouqJQ=C4XZVUmWEV9kerNzbOkK9OeErpHshNkcR=gQ@mail.gmail.com>
Message-ID: <CAHk-=wjAouqJQ=C4XZVUmWEV9kerNzbOkK9OeErpHshNkcR=gQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
To:     Peter Zijlstra <peterz@infradead.org>
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
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
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

On Thu, Jul 14, 2022 at 10:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> If only :/ FASTOP_SIZE is used in ASM, which means we've got to play by
> GNU-as rules, and they are awful.

Oh Gods. Yes they are.

            Linus
