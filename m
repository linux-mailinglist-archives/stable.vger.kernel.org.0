Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7E520443B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 01:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgFVXEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 19:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731375AbgFVXEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 19:04:21 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C2BC061796
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 16:04:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k6so8236884pll.9
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 16:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SzgCWMDg2RKJ2NhPQUi7yzswSotPjadK1/0BdT/7pNM=;
        b=CjobsTwjEzfFB7mg3yto+C37iPxoADkBtXnwx5Zwh1qhWDXJI9D8xzTYannQoMeE59
         wYG8uphNg+tfYmpQDrje8+ZiMkr9C6zDHh05LXr1dxnbGcD7rcatVqb208oPrAX1xxqB
         rMhirMwPU0VMi65dec2Qn/HinSWsI/vcDRVsMIGJs+5yaNri6IK5LoQwvGPcoK+2WLMn
         sqYEhxjSdosxf/hM9s6W6CVJJi/xnF0Je9pZD+TXn6ArUzc0GmkZz3Hco2I6Im31YEfK
         tis4ESU+TFUPNnp/+ik9M+TOUIBnySvS0k8SDIEYVkUGO+TUFQ8DH2mreAVwZRufQBL7
         psPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SzgCWMDg2RKJ2NhPQUi7yzswSotPjadK1/0BdT/7pNM=;
        b=F7SCH77OYBavShW1KviMzBQXarYVBetH5EiuElNXnyOKG4R2hl+CbcwxYylQICZwti
         UZaiYsR+6Pd7WjMd+/RpTN7elVf897Efg5ZZJke7HfFZ4mzbL6kLNH4AAtn5SUMP7tID
         2pVHKmU91L52fr19IFdf4fAWaV4v1oaoBJSfd+H0W4aArM5C65ndC0gL6E3PC9qCnT6m
         2ijC4l2dyB8kYx7s0KHr0J4RCTyrjhCWrRrFjzlKAq6yb85sDcI0ZZ3aB1/i2isfRR0Q
         1blcxD50M0VbHqcJg30lpmNM7B6CorJRhPzkh4u+diAtBR2BRFayFiGQQiGeqgXCJ40Y
         uy/g==
X-Gm-Message-State: AOAM530JaEhm18ShyN74izWrkgvL+pHQBh9/MAouCl/HggmUs6Usy8EI
        ND9rgCFWLXwuPcS40QJNjjw6LDe/w5DSqyngkN2uJQ==
X-Google-Smtp-Source: ABdhPJy9ExQlGK27NrlHcsj2o4KqK8zQSxV/IYN84Vo7oDdUJkzL59yBK014EWuci7pcT/EaZ13XpTPNDdTLyCE+wNI=
X-Received: by 2002:a17:902:fe8b:: with SMTP id x11mr21225140plm.179.1592867060019;
 Mon, 22 Jun 2020 16:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200617210613.95432-1-ndesaulniers@google.com> <20200617212705.tq2q6bi446gydymo@google.com>
In-Reply-To: <20200617212705.tq2q6bi446gydymo@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 22 Jun 2020 16:04:07 -0700
Message-ID: <CAKwvOdniambW9_nVbDnd4A_+bdDdZMd2V1Q=Xw5EJYDGeh=eyQ@mail.gmail.com>
Subject: Re: [PATCH] vmlinux.lds: consider .text.{hot|unlikely}.* part of
 .text too
To:     =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Jian Cai <jiancai@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 17, 2020 at 2:27 PM F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@googl=
e.com> wrote:
>
>
> On 2020-06-17, Nick Desaulniers wrote:
> >ld.bfd's internal linker script considers .text.hot AND .text.hot.* to
> >be part of .text, as well as .text.unlikely and .text.unlikely.*.
>
> >ld.lld will produce .text.hot.*/.text.unlikely.* sections.
>
> Correction to this sentence. lld is not relevant here.
>
> -ffunction-sections combined with profile-guided optimization can
> produce .text.hot.* .text.unlikely.* sections.  Newer clang may produce
> .text.hot. .text.unlikely. (without suffix, but with a trailing dot)
> when -fno-unique-section-names is specified, as an optimization to make
> .strtab smaller.

Then why was the bug report reporting https://reviews.llvm.org/D79600
as the result of a bisection, if LLD is not relevant?  Was the
bisection wrong?

The upstream report wasn't initially public, for no good reason.  So I
didn't include it, but if we end up taking v1, this should have

Link: https://bugs.chromium.org/p/chromium/issues/detail?id=3D1084760

The kernel doesn't use -fno-unique-section-names; is that another flag
that's added by CrOS' compiler wrapper?
https://source.chromium.org/chromiumos/chromiumos/codesearch/+/master:src/t=
hird_party/toolchain-utils/compiler_wrapper/config.go;l=3D110
Looks like no.  It doesn't use `-fno-unique-section-names` or
`-ffunction-sections`.


>
> We've already seen that GCC can place main in .text.startup without
> -ffunction-sections. There may be other non -ffunction-sections cases
> for .text.hot.* or .text.unlikely.*. So it is definitely a good idea to
> be more specific even if we don't care about -ffunction-sections for
> now.
>
> >Make sure to group these together.  Otherwise these orphan sections may
> >be placed outside of the the _stext/_etext boundaries.
> >
> >Cc: stable@vger.kernel.org
> >Link: https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommitdiff;h=
=3Dadd44f8d5c5c05e08b11e033127a744d61c26aee
> >Link: https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommitdiff;h=
=3D1de778ed23ce7492c523d5850c6c6dbb34152655
> >Link: https://reviews.llvm.org/D79600
> >Reported-by: Jian Cai <jiancai@google.com>
> >Debugged-by: Luis Lozano <llozano@google.com>
> >Suggested-by: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>
> >Tested-by: Luis Lozano <llozano@google.com>
> >Tested-by: Manoj Gupta <manojgupta@google.com>
> >Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> >---
> > include/asm-generic/vmlinux.lds.h | 4 +++-
> > 1 file changed, 3 insertions(+), 1 deletion(-)
> >
> >diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vml=
inux.lds.h
> >index d7c7c7f36c4a..fe5aaef169e3 100644
> >--- a/include/asm-generic/vmlinux.lds.h
> >+++ b/include/asm-generic/vmlinux.lds.h
> >@@ -560,7 +560,9 @@
> >  */
> > #define TEXT_TEXT                                                     \
> >               ALIGN_FUNCTION();                                       \
> >-              *(.text.hot TEXT_MAIN .text.fixup .text.unlikely)       \
> >+              *(.text.hot .text.hot.*)                                \
> >+              *(TEXT_MAIN .text.fixup)                                \
> >+              *(.text.unlikely .text.unlikely.*)                      \
> >               NOINSTR_TEXT                                            \
> >               *(.text..refcount)                                      \
> >               *(.ref.text)                                            \
> >--
> >2.27.0.290.gba653c62da-goog
> >



--
Thanks,
~Nick Desaulniers
