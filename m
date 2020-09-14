Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C273F26842E
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 07:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgINFnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 01:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgINFnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 01:43:03 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EA9C2192A;
        Mon, 14 Sep 2020 05:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600062199;
        bh=btGwiYUkU53Jy4j049GtVI8nD4s/KYGcKzzkilnTtcE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=N4wtrVtlDsYhr4X+iUSf9pTZqTXkOXBXp4rFK94nq2Oi3sN0dJuHYEaW70VUGFRc3
         PERGD5ebv2jNkDSc+yM4ytv9VXX7L/byv6KtxKwqnK/nfT3VcIu4wjitfL8gL2pjo8
         oKFIu2/g3GNpEingghwVFQ+1DsRU1vafAH8LQ55M=
Received: by mail-oi1-f174.google.com with SMTP id x19so16623716oix.3;
        Sun, 13 Sep 2020 22:43:19 -0700 (PDT)
X-Gm-Message-State: AOAM533TC+xZ+6SQ54Z70AmoxMUBBBEqxrgJBQrDN6Vly+lKZPzVahiN
        EQxzwZJfcwB4D9zbmZf16/jVrt1WVmCbAHz1S5s=
X-Google-Smtp-Source: ABdhPJwHY+CLdurRIhKknwldTre1l+g3D6rGk4MIhKEeeTUl6b0SHxcF0G2/oFaZ877pdwhSfxbQcV8VofTfRTHtvPE=
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr7890035oic.33.1600062198923;
 Sun, 13 Sep 2020 22:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200812004158.GA1447296@rani.riverdale.lan> <20200812004308.1448603-1-nivedita@alum.mit.edu>
 <CA+icZUVdTT1Vz8ACckj-SQyKi+HxJyttM52s6HUtCDLFCKbFgQ@mail.gmail.com>
 <CAKwvOdmHxsLzou=6WN698LOGq9ahWUmztAHfUYYAUcgpH1FGRA@mail.gmail.com>
 <20200825145652.GA780995@rani.riverdale.lan> <20200913223455.GA349140@rani.riverdale.lan>
In-Reply-To: <20200913223455.GA349140@rani.riverdale.lan>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 14 Sep 2020 08:43:07 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFnuzdmPxCytCbFdgtLo8Bb4k247ePgbLuZ1mANEn=azw@mail.gmail.com>
Message-ID: <CAMj1kXFnuzdmPxCytCbFdgtLo8Bb4k247ePgbLuZ1mANEn=azw@mail.gmail.com>
Subject: Re: [PATCH v2] x86/boot/compressed: Disable relocation relaxation
To:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Sep 2020 at 01:34, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> On Tue, Aug 25, 2020 at 10:56:52AM -0400, Arvind Sankar wrote:
> > On Sat, Aug 15, 2020 at 01:56:49PM -0700, Nick Desaulniers wrote:
> > > Hi Ingo,
> > > I saw you picked up Arvind's other series into x86/boot.  Would you
> > > mind please including this, as well?  Our CI is quite red for x86...
> > >
> > > EOM
> > >
> >
> > Hi Ingo, while this patch is unnecessary after the series in
> > tip/x86/boot, it is still needed for 5.9 and older. Would you be able to
> > send it in for the next -rc? It shouldn't hurt the tip/x86/boot series,
> > and we can add a revert on top of that later.
> >
> > Thanks.
>
> Ping.
>
> https://lore.kernel.org/lkml/20200812004308.1448603-1-nivedita@alum.mit.edu/

Acked-by: Ard Biesheuvel <ardb@kernel.org>
