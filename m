Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B51557573C
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 23:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbiGNVwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 17:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240760AbiGNVwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 17:52:15 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB93491D7
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 14:52:12 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id os14so5798920ejb.4
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 14:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gCwGv/e/gf0C6iderKEIRJdi0X+OWhvleA0ffjecAUA=;
        b=dxV59InvESm2MJqKBf3+U1Ds3/hawDeEnGZ38sSmB5Il756bzpwxIre3Atc0Q1lkzC
         hyBFGJ3TV2g0q8oktcCZOMFI8cRxHm73bG0bhfMCqzN/UjJnIR7jKT4a9XBskQw9dd6h
         OqDy+jIwcgGlmmWZTsqokmdOnUKSxRvScSSq0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gCwGv/e/gf0C6iderKEIRJdi0X+OWhvleA0ffjecAUA=;
        b=iueIucrlTqgNIoqAXK5ZdHwIFVIUeeT+zOTqkX2AKwcM9TprnQ46GaXYYN9jd+Eg2i
         KereHqRkn66QnEdKNEggI1SKbEj2No2K7uNCDsD+LB22Xr7veIRG4OoB+L4r6rHMX/Td
         vCt9GQupygGWg+G4cljUmkIMpxFkJWw4h5SDIrZ8DBBtcCngwQjIjQEHS02V+MLyXSEO
         ljzRjDEfrQgfMRCpH5r2j5srSfSqNM0RZKIgaLCkwkneT946Omfy6Lob7Klfe0t0kg52
         fReSLAjLHZ67nQu0W2PU3LQSo0LvSFwdcfz3E9sypoImleQK+piuMhQo5LhIsTPjmv7Q
         7NBg==
X-Gm-Message-State: AJIora9nXEFT5RoCrvvoE0tz2RIcCUZV0xz/TewT7TyiN7beU4Bu7pKL
        tNzeLzJSgdHzEM5afm/DFaYtBb/8EPMuhQiR9aE=
X-Google-Smtp-Source: AGRyM1vcpcnICn1f154QQetljG5hKyLJX/UTfPGm66Xp6aHafWQMDelQU4VKhCcTWRhUiD2YB/LYCQ==
X-Received: by 2002:a17:907:3f04:b0:6e8:4b0e:438d with SMTP id hq4-20020a1709073f0400b006e84b0e438dmr10649786ejc.391.1657835530833;
        Thu, 14 Jul 2022 14:52:10 -0700 (PDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id b18-20020a170906d11200b0072b4e4cd346sm1148862ejz.188.2022.07.14.14.52.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 14:52:09 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id h17so4363849wrx.0
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 14:52:09 -0700 (PDT)
X-Received: by 2002:a5d:544b:0:b0:21d:70cb:b4a2 with SMTP id
 w11-20020a5d544b000000b0021d70cbb4a2mr9822619wrv.281.1657835528671; Thu, 14
 Jul 2022 14:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220713152436.2294819-1-nathan@kernel.org> <20220714143005.73c71cf8@kernel.org>
In-Reply-To: <20220714143005.73c71cf8@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 14:51:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi+O_3+uef45jxj1+GhT+H0vXs9iz8rpjk49vCiyLS4DA@mail.gmail.com>
Message-ID: <CAHk-=wi+O_3+uef45jxj1+GhT+H0vXs9iz8rpjk49vCiyLS4DA@mail.gmail.com>
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

On Thu, Jul 14, 2022 at 2:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Hi, sorry to bother, any idea on the ETA for this fix getting into
> Linus's tree? I'm trying to figure out if we should wait with
> forwarding the networking trees or this will take a while.

Well, I have that patch by now in my own clang tree, but was holding
it off just because I was expecting a few other fixes for the fallout.

But if this particular one causes problems for maintainers, I can
easily just take it right away just cherry-pick it from my own
test-tree to my "main" tree.

            Linus
