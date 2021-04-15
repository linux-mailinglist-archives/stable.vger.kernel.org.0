Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDD1360F62
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhDOPvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhDOPvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 11:51:01 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E782DC061756
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 08:50:37 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id v3so24304547ybi.1
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 08:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fYilzRCKDkKUdgOhlVcbbYfdjO7wy5E8rO0x4orHhLA=;
        b=bEB5pWOw1ZAIEUWzcKl3t4shqwnwqh/rbFNGxWSeVrpats5bWqew/AS8LFT3tNurTV
         6jHs1OBTFCnbQptuEUluJxyy6jAFZreNCZ796HPkZZYWF6zjuAyNvU2xP5WXSfIi1imN
         G+PtFPreT1JLKhpb7n6HpLTFMLjYeOPmAMWVO1Pv97TF2Moj4YGx33apF8aDGkiKCoD+
         lXHJ7DSWzFfkexGt3fEy8QmKmedF0GDdt2t+0ny6YZd63u90gt9NRSp4x5XC+6s4e1ZI
         LWELvd2kjcDBuqEzGn/Ch5dq7WFZ4+Zi5qQV3D0vmU9Dj2Kly+zHrBoVkTZwmo67/CFU
         Zrvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fYilzRCKDkKUdgOhlVcbbYfdjO7wy5E8rO0x4orHhLA=;
        b=ntv+SOHelbGvCT3xgIlQIMTUZV7X7gO/ouHHApsGkdv6iPxVIPoPvhCEAyb5h+1ESR
         rsX7urDoQETcSSgaVP1VkJSv6KDp6wPeJV8PKsDxH0914evknkHd3yBj7d090iTPxU+z
         tVORdWsL9WUb/bLfaxtPPAMrHLCWCaiWfVpml18ofFUrd1Z3UZA7JQMtxiZCvybB0VBY
         fOzsUzJhtttQGQtSv1DuJhJNHy+LGTYs2Jk+4rG6oI3VHRwnItWLFbQLi9069oE+8SYI
         JxJVS+Mh0uZdzegYR9VigF64uR1z6z77UvUBXvqnjLvZcC5ww55W10CMIBjMlLeXkUGZ
         zHEA==
X-Gm-Message-State: AOAM532k0wjuRNGD1jSHkxtRDjMvl74OgtObHst/i67zFMXXz4xFwVlL
        bV0vZsW7m0M6gdtKfdK3F5N8fYgi3WVf+tB96TxCuA==
X-Google-Smtp-Source: ABdhPJzIjnUNpPqqfntRP4pP+GuW6qH1+7UUP1qwaDpRmrDTkNySxQxbfSOI1ocgfp4UGS5eD86r8SdSA8roqJ5pIdM=
X-Received: by 2002:a5b:54a:: with SMTP id r10mr5087018ybp.476.1618501836920;
 Thu, 15 Apr 2021 08:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210414000803.662534-1-nathan@kernel.org> <20210415091743.GB1015@arm.com>
 <YHg+5RSG4XPLlZD8@archlinux-ax161> <20210415140224.GE1015@arm.com>
In-Reply-To: <20210415140224.GE1015@arm.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Thu, 15 Apr 2021 08:50:25 -0700
Message-ID: <CABCJKufDUgPSRQi1ZQRk=upNtziKDJ8rTBHgq2oQpPWS=utrvg@mail.gmail.com>
Subject: Re: [PATCH] arm64: alternatives: Move length validation in alternative_{insn,endif}
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <jiancai@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 7:02 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Thu, Apr 15, 2021 at 06:25:57AM -0700, Nathan Chancellor wrote:
> > On Thu, Apr 15, 2021 at 10:17:43AM +0100, Catalin Marinas wrote:
> > > On Tue, Apr 13, 2021 at 05:08:04PM -0700, Nathan Chancellor wrote:
> > > > After commit 2decad92f473 ("arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is
> > > > set atomically"), LLVM's integrated assembler fails to build entry.S:
> > > >
> > > > <instantiation>:5:7: error: expected assembly-time absolute expression
> > > >  .org . - (664b-663b) + (662b-661b)
> > > >       ^
> > > > <instantiation>:6:7: error: expected assembly-time absolute expression
> > > >  .org . - (662b-661b) + (664b-663b)
> > > >       ^
> > >
> > > I tried the latest Linus' tree and linux-next (defconfig) with this
> > > commit in and I can't get your build error. I used both clang-10 from
> > > Debian stable and clang-11 from Debian sid. So, which clang version did
> > > you use or which kernel config options?
> >
> > Interesting, this reproduces for me with LLVM 12 or newer with just
> > defconfig.
>
> It fails for me as well with clang-12. Do you happen to know why it
> works fine with previous clang versions?

It looks like CONFIG_ARM64_AS_HAS_MTE is not set when we use the
integrated assembler with LLVM 11, and the code that breaks later
versions is gated behind CONFIG_ARM64_MTE.

Sami
