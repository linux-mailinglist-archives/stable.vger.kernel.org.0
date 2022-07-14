Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9929157510B
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 16:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiGNOqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 10:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238585AbiGNOqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 10:46:36 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A613ED66;
        Thu, 14 Jul 2022 07:46:31 -0700 (PDT)
Received: from [127.0.0.1] (unknown [213.235.133.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3779B1EC02F2;
        Thu, 14 Jul 2022 16:46:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1657809986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5cmqaebev+OrEXkdVAl5bhvGnR6ErnLFH2dom36H8nw=;
        b=fSuNUgXSH2+ZvBaYI1R1ahe+ogNfUfZPNaUqGlz/vEX5az+A8OfzjwnSyd/e1jGxk4lJPt
        e9vavppkUZkH/Naw5VcPNDyz/w3F/anZ4ThJat3wKSpHjWaZUBArBTi504UFq0pt55ys2A
        GmWti1ddl+0z62XRa+T4vYpFR2/doZ0=
Date:   Thu, 14 Jul 2022 14:46:22 +0000
From:   Boris Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
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
        =?ISO-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
In-Reply-To: <6b4337f4-d1de-7ba3-14e8-3ad0f9b18788@redhat.com>
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com> <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com> <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com> <Ys/bYJ2bLVfNBjFI@nazgul.tnic> <6b4337f4-d1de-7ba3-14e8-3ad0f9b18788@redhat.com>
Message-ID: <8BEC3365-FC09-46C5-8211-518657C0308E@alien8.de>
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

On July 14, 2022 1:46:53 PM UTC, Paolo Bonzini <pbonzini@redhat=2Ecom> wrot=
e:
>Please leave that one out as Peter suggested a better fix and I have that=
 queued for Linus=2E

Already zapped=2E

Thx=2E

--=20
Sent from a small device: formatting sux and brevity is inevitable=2E 
