Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728B323351A
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 17:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgG3PNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 11:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG3PNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 11:13:18 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50964C061575
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 08:13:18 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so28309865eje.7
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 08:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vfXGH/CEwaBaC/kQBLI8IC/drfAO5muRPoqQ1huaXOI=;
        b=McJOS71UhOePjQddHfrQt53FnJHJC0kuVMQu/+RnujQmsJPvqSwPBy9z8zCkrYYY2T
         9ZdqgPN5eXpDFXra002a1uwK/liS5BLPcUlejRgFdKW3LooogLoj/fjnfsXkdw8i5Vup
         f9PivRMEUHpTG9rhzJAdaWOlFMSurvCygaBEe0eBbeCKDY8s2kxeS+Rm2sdWUTIACFat
         UOxs1fCjkyUlRBca/MYzag7GDk3MvtA6RhKZzFYXtxGfQGKGvuSxhn/fzdUD/F341109
         Chcye3SKwaQBxN/tHr/LWyEEx7wP9nkvRA1tU6nzUS10GF65XzNFLZKPbZ4E187wWFYU
         bKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vfXGH/CEwaBaC/kQBLI8IC/drfAO5muRPoqQ1huaXOI=;
        b=smhbUTFZrJgyrBZSs1rYUyI5kjToQXTdubh/fdJt4Zs0IcnHa0Mwq9j5CFlUn8QpD0
         rOIdbhyiwPEsaOc0wromf7Qwk/6+MggFEhm2RFw51/sedQHFG45Lzo4W0eTWxEcjlAIS
         TCFm4Ez8bUbigoM0WVcj2ED+ORdO5DPRnJ+pkHnutv76/BPHa7rQGTNgwNZG+UsNIxLc
         KflwT8obGfyDXXY3BnYchuWWMXXqO0rFz089SdTpparAmAY/fI42p/b6AUcQxqZsxE+j
         7TILgtcxo92ynPHnyKf4sjRS+Nyp+hJfFxRYCjrY4+LeZtrgz1vlvoWMnQnuXmenqsfU
         eW/g==
X-Gm-Message-State: AOAM532OTtGg5CzSB+qOIm5uFTd306MLWDbTFD5jGGHhKQYTmQmVe+gN
        Gq8+qpNTutO17dV4wFN9Gm9ZQlZE42YoLvEqONj17A==
X-Google-Smtp-Source: ABdhPJzunWv9jHlXQYg33b+C7Rtiu1eMksfQIE/LP2+0U+iyZFw1c/zddv7AfbByWB/s7vUMZbTHhoeQHHnKibfLQVo=
X-Received: by 2002:a17:906:694b:: with SMTP id c11mr2989856ejs.232.1596121996817;
 Thu, 30 Jul 2020 08:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200729215152.662225-1-samitolvanen@google.com> <20200730122201.GM25149@gaia>
In-Reply-To: <20200730122201.GM25149@gaia>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Thu, 30 Jul 2020 08:13:05 -0700
Message-ID: <CABCJKucS-DXPkHMCPKpbFduZApRdw=1DL4+YhULAsUNn=o-dTA@mail.gmail.com>
Subject: Re: [PATCH] arm64/alternatives: move length validation inside the subsection
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 5:22 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Wed, Jul 29, 2020 at 02:51:52PM -0700, Sami Tolvanen wrote:
> > Commit f7b93d42945c ("arm64/alternatives: use subsections for replacement
> > sequences") breaks LLVM's integrated assembler, because due to its
> > one-pass design, it cannot compute instruction sequence lengths before the
> > layout for the subsection has been finalized. This change fixes the build
> > by moving the .org directives inside the subsection, so they are processed
> > after the subsection layout is known.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1078
> > Cc: <stable@vger.kernel.org> # 4.14+
>
> Commit f7b93d42945c went in 5.8-rc4. Why is this cc stable from 4.14? If
> Will picks it up for 5.8, it doesn't even need a cc stable.

Greg or Sasha can probably answer why, but this patch is in 4.14.189,
4.19.134, 5.4.53, and 5.7.10, which ended up breaking some downstream
Android kernel builds.

> Please add a Fixes: tag as well.

Sure, I'll send v2 shortly with the tag. Thanks.

Sami
