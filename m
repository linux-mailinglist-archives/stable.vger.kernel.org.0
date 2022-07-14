Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E57D575743
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 23:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbiGNV4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 17:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiGNV4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 17:56:32 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5800E2CE00
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 14:56:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id v12so4080280edc.10
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 14:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2h7rSRvHiDfpV/JqGRkiaejTHAdpZEG7Nka6Pnjwvpo=;
        b=FAJHcFc6Pyx6GGP8vdmgf+D87FHKZIDU4UUfWsXA0WewkwL17U/1QlPKqu4O/F8LE9
         JfpMTCmZoPBCS8TLm4xmpgZBOQo9wDEYpKkuh3sullDTs4kLFk+Oybo3QTYXyGsvBZDD
         VeeHRypWibElYQzySO6Uhn086bFCNc6RzuQPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2h7rSRvHiDfpV/JqGRkiaejTHAdpZEG7Nka6Pnjwvpo=;
        b=PoHQJ93n7KGMY8i7YFzS904Lll7OyIIRtw90YO7Yid5GqLe18LlyMiqULqGGm4m7Qj
         Ch9FZBDhkHF+Q3uX/mc/ZGlLp+qAFKkIG6G/nn1VfjMume5iWfme2cdIamHSBOQY1rKY
         VNWRQF1htVLvdaAa/bpSWkisXgiJyoHMSndTzOJFkcL++yvT3jZ1X1GQYVjUq8+hLfF9
         fVrweLqDKLcvPg1Gct10euSiyMTw4JLR0PunGDjkzmARC63jWHpuAVOpt9/YEO7laLlz
         TzORtxCtoj4nCzGbxv7sXQ9758MDn5xmnro7ZnsxiqD9ew5e8CD0/jcifz13yDQdvwiK
         jbEA==
X-Gm-Message-State: AJIora/4qJ/5K1wwddhLA0G24CUwuvTwh9TuUitKeIS/bvU5ECjA99SJ
        LYKNOZt09fxgBJgpKaQls1YxXkV454WUyJ9vdXQ=
X-Google-Smtp-Source: AGRyM1tfuOxRG/7sneVX8P5Beuo0M9sUDbWzskMaZkjccv5fHxOgVJXHKS+DSneM+NQKKYhBLSGU1Q==
X-Received: by 2002:a50:ce1d:0:b0:43a:742f:9db3 with SMTP id y29-20020a50ce1d000000b0043a742f9db3mr15001264edi.308.1657835789728;
        Thu, 14 Jul 2022 14:56:29 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id f15-20020a17090631cf00b0072a66960843sm505350ejf.51.2022.07.14.14.56.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 14:56:29 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so1979014wmb.3
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 14:56:28 -0700 (PDT)
X-Received: by 2002:a7b:cd97:0:b0:3a2:dfcf:dd2d with SMTP id
 y23-20020a7bcd97000000b003a2dfcfdd2dmr16997798wmj.68.1657835788646; Thu, 14
 Jul 2022 14:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220713152436.2294819-1-nathan@kernel.org> <20220714143005.73c71cf8@kernel.org>
 <CAHk-=wi+O_3+uef45jxj1+GhT+H0vXs9iz8rpjk49vCiyLS4DA@mail.gmail.com>
In-Reply-To: <CAHk-=wi+O_3+uef45jxj1+GhT+H0vXs9iz8rpjk49vCiyLS4DA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 14:56:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjeVbrd3HOMh-t8968pMgZUFs6uP-p45Fn8qr27j8D0aQ@mail.gmail.com>
Message-ID: <CAHk-=wjeVbrd3HOMh-t8968pMgZUFs6uP-p45Fn8qr27j8D0aQ@mail.gmail.com>
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

On Thu, Jul 14, 2022 at 2:51 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But if this particular one causes problems for maintainers, I can
> easily just take it right away just cherry-pick it from my own
> test-tree to my "main" tree.

Oh, and as I did that cherry-pick, I suddenly remembered that I think
PeterZ had a slightly different version of it - the one I picked up is
Nathan's "v2".

PeterZ, do you have preferences? I've waited this long, I might as
well wait a bit more before I push out whatever version people prefer.

              Linus
