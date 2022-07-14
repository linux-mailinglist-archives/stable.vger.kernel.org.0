Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B598575778
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 00:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240734AbiGNWPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 18:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiGNWPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 18:15:16 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DCF4B0C1
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 15:15:13 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eq6so4141124edb.6
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 15:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=my5qru7kqzoTpYDlsQu0xITwTY0Hh5OwELAs4fo4zY8=;
        b=GlxE5oHtW5ud5Gv1JPWcbZYuF3saChl7AfUSHMcR8VnMAQUPu3EyIxoSwUEBh1Hgwk
         HF+iMgE2YpvcbSLjfG3zCrrHZFrev3/gq0aYQDBwtDW0Inkpe4XSpw1hB1mA6Vp2mRr2
         rUZibpS2GWUgVhEDprX250UIjPcUhfUQHcB3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=my5qru7kqzoTpYDlsQu0xITwTY0Hh5OwELAs4fo4zY8=;
        b=b4FrcnyWmIADekPmaJV8mox6+1dQW7hZORuZwPsFge78JXBAVp68K3fml+UkKeQXkA
         tu/jzr9kvHElwoFiaIXdoQ5IvcHBFF8gFzGWL+VLGRBF7BR2QhAqEv6/IfNsbxzojngy
         4smyBP2VtQuSgSREjPIt+b3hEmGRChrWWZSi0JwmChBCLX+zylGtV3SFB2wdnVRkeQ2x
         R/FVN6RCg9sMI9bIu+YwdPd1skMbhM0yYcuEcGl5a5y8oANLMOPY3LFVv/8YQQsM7tXj
         ul46wtVrAELBqe9b8F93/9cnldwBBn5T44Y92WX2G8eig86LuvleZ6Pe59KPIhaIeK4Y
         TQFg==
X-Gm-Message-State: AJIora/Yg/98cJ7l8gIyVTMN8tWjc51j1pKpm/qHrevI884uEH2UU2Yh
        VYL5i84W3q9PHaiZ7d0UZCOgFL2wrBhW2CpT7HA=
X-Google-Smtp-Source: AGRyM1uagIxthLvW2P/7SjKf7AYicelfUCTPrCMMNiMa+CICniuIbOSqNHsdkJCDdG7GBZeAKluVXA==
X-Received: by 2002:a05:6402:3219:b0:43b:6f3:8ccb with SMTP id g25-20020a056402321900b0043b06f38ccbmr15039814eda.345.1657836912248;
        Thu, 14 Jul 2022 15:15:12 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id vp21-20020a17090712d500b006feba31171bsm1218806ejb.11.2022.07.14.15.15.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 15:15:10 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id j29-20020a05600c1c1d00b003a2fdafdefbso2004808wms.2
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 15:15:10 -0700 (PDT)
X-Received: by 2002:a05:600c:34c9:b0:3a0:5072:9abe with SMTP id
 d9-20020a05600c34c900b003a050729abemr11134747wmq.8.1657836910095; Thu, 14 Jul
 2022 15:15:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220713152436.2294819-1-nathan@kernel.org> <20220714143005.73c71cf8@kernel.org>
 <CAHk-=wi+O_3+uef45jxj1+GhT+H0vXs9iz8rpjk49vCiyLS4DA@mail.gmail.com> <20220714145652.22cf4878@kernel.org>
In-Reply-To: <20220714145652.22cf4878@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 15:14:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgqJFV45497fBfc1HS3Oaoqi3pfenZ0XM3uqFGYz8wTQQ@mail.gmail.com>
Message-ID: <CAHk-=wgqJFV45497fBfc1HS3Oaoqi3pfenZ0XM3uqFGYz8wTQQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        stable <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
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

On Thu, Jul 14, 2022 at 2:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> I have clang 13, let me double check this fix is enough for the build
> to complete without disabling WERROR.

I have clang 14 locally, and it builds fine with that (and doesn't
build without it).

I actually normally build the kernel with both gcc and clang. My
"upstream" kernel I build with gcc, and then I have my "private random
collection of patches" kernel that I build with clang and that are
just rebased on top of the kernel-of-the-day.

This is all entirely for historical reasons - part of my "private
random collection of patches" used to be the "asm goto with outputs",
which had clang support first.

But then the reason I never even noticed the build breakage with the
retbleed patches until much too late was that those I just had as a
third fork off my upstream kernel, so despite me usually building with
clang too, that only got attention from gcc.

So it's really just a microcosm version of the exact same bigger issue
we always have with those embargoed hw security patches: they end up
missing out on all the usual test environments.

Anyway, I cherry-picked Nathan's patch from my clang tree and pushed
it out as commit db886979683a ("x86/speculation: Use DECLARE_PER_CPU
for x86_spec_ctrl_current").

                 Linus
