Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038FD5755D0
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 21:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbiGNT1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 15:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbiGNT1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 15:27:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609CB49B5A;
        Thu, 14 Jul 2022 12:27:04 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-002-247-249-041.2.247.pool.telefonica.de [2.247.249.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3C4FA1EC0434;
        Thu, 14 Jul 2022 21:26:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1657826818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4MQJTZj6BmKFE8enGCuKKJcgI7E41yi2bEFmH/f2RE=;
        b=WKZJWjPprl/ocjkLjPori4zBGFj2SBPEhyTAfzDr1Ks4lBVL8yIT4mZbt/PR+Ks+M52R4M
        elaR0vHa3qV9grOTlmkZZFb/yyGRPvnYwfvlWuN5yei8RzKiCWr/9QtwZuuC7jE1kiaPTz
        oOCh3xgqvApT0Xo/rmM2Rm687SYBfp4=
Date:   Thu, 14 Jul 2022 19:26:54 +0000
From:   Boris Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Slade Watkins <slade@sladewatkins.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        patches@kernelci.org, Sean Christopherson <seanjc@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>, "H. Peter Anvin" <hpa@zytor.com>,
        =?ISO-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
In-Reply-To: <CAHk-=whYia1fnjJFiJ59xZv4ROqqTfG4crQNWxb71JYJf5B-Lg@mail.gmail.com>
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com> <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com> <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com> <Ys/bYJ2bLVfNBjFI@nazgul.tnic> <6b4337f4-d1de-7ba3-14e8-3ad0f9b18788@redhat.com> <8BEC3365-FC09-46C5-8211-518657C0308E@alien8.de> <CAHk-=wj4vtoWZPMXJU-B9qW1zLHsoA1Qb2P0NW=UFhZmrCrf9Q@mail.gmail.com> <YtBQutgSh2j3mFNB@worktop.programming.kicks-ass.net> <CAHk-=wjAouqJQ=C4XZVUmWEV9kerNzbOkK9OeErpHshNkcR=gQ@mail.gmail.com> <CAHk-=whYia1fnjJFiJ59xZv4ROqqTfG4crQNWxb71JYJf5B-Lg@mail.gmail.com>
Message-ID: <6210C171-BBBD-4FC4-B5FF-68D715941501@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On July 14, 2022 6:16:40 PM UTC, Linus Torvalds <torvalds@linux-foundation=
=2Eorg> wrote:
>So yeah, it would be less dense, but do we care? Wouldn't the "this is
>really simple" be a nice thing? It's not like there are a ton of those
>fastop functions anyway=2E 128 of them? Plus 16 of the "setCC" ones?

I definitely like simple=2E

Along with a comment why we have this magic 16 there=2E

--=20
Sent from a small device: formatting sux and brevity is inevitable=2E 
