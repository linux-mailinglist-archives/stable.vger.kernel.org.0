Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F09D357B9D
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 06:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhDHE4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 00:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhDHE43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 00:56:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF13611C2;
        Thu,  8 Apr 2021 04:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617857779;
        bh=Dh8EBh8o4mdoCP4ktf58imRPni3ZO2VzlY4tEcTKB8M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jG4gPnD0Qzce2goNw/RB7tjtByhkqfh5qhtNMcvmn/cHPXSZKoF3QK42E/6y460QU
         7RUsHS5XFoT9GLz0WOL7z/P025WGynHQK7YHb0od0Zovxgt+8LgfPaKFL9HT78Wge8
         z5Nuhzg6jsL6jK49yPy8aSHUhszQzy8pTftg3u41ViY8GOqmo9Uwt7CtzLVjsg+h5R
         PJXU+PsANssqUjfx9djCGVxgXO/eY3mtYbY7o8xe0XCHe18FkvmJtfea9MNY+spsFr
         fGTgY71LMOodabtBsIt1Gklqjw7nlq0iKemF1A8SJ36cRL83uyb/p0OTcRmv8HQ4cn
         fXMdqjKtZ9Krw==
Received: by mail-io1-f41.google.com with SMTP id x17so889998iog.2;
        Wed, 07 Apr 2021 21:56:19 -0700 (PDT)
X-Gm-Message-State: AOAM533c2ZzxkI5M6V+GrH/XjhfLugvWVAGaHikkHVd0aw0DlPYXgXku
        B2yoBJ3VVvI24KHFXMbSgDF7DW27WZJXVjReess=
X-Google-Smtp-Source: ABdhPJzyOxI5ZGpU3sUGR5wjZHZHQvJPFW98pSD4hFAs4ti6u4LZYjwYTOeT+mICbsmXJIKNIDZFe9EX6NrViJ/qN/I=
X-Received: by 2002:a05:6602:2be1:: with SMTP id d1mr5151464ioy.148.1617857778420;
 Wed, 07 Apr 2021 21:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210406112404.2671507-1-chenhuacai@loongson.cn>
 <0338A250-3BF9-4B96-B9DE-61BE573CBB4C@goldelico.com> <3e27d0e0-4494-7a94-e0d7-046fb8898603@wanyeetech.com>
 <alpine.DEB.2.21.2104062343250.65251@angie.orcam.me.uk> <CAAhV-H7V2ykFqCv8n8pYs1ujbUYNy5UqPu21VPyj_Qzx5y8upQ@mail.gmail.com>
 <alpine.DEB.2.21.2104071530370.65251@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2104071530370.65251@angie.orcam.me.uk>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Thu, 8 Apr 2021 12:56:06 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7AH3JDHH-Ru_qhTZZt1zE69n4Yvskn8iDi0EPegXfHvQ@mail.gmail.com>
Message-ID: <CAAhV-H7AH3JDHH-Ru_qhTZZt1zE69n4Yvskn8iDi0EPegXfHvQ@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Fix a longstanding error in div64.h
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Zhou Yanjie <zhouyu@wanyeetech.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Ralf Baechle <ralf@linux-mips.org>,
        stable <stable@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Maciej,

On Wed, Apr 7, 2021 at 9:38 PM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> On Wed, 7 Apr 2021, Huacai Chen wrote:
>
> > >  This code is rather broken in an obvious way, starting from:
> > >
> > >         unsigned long long __n;                                         \
> > >                                                                         \
> > >         __high = *__n >> 32;                                            \
> > >         __low = __n;                                                    \
> > >
> > > where `__n' is used uninitialised.  Since this is my code originally I'll
> > > look into it; we may want to reinstate `do_div' too, which didn't have to
> > > be removed in the first place.
> > I think we can reuse the generic do_div().
>
>  We can, but it's not clear to me if this is optimal.  We have a DIVMOD
> instruction which original code took advantage of (although I can see
> potential in reusing bits from include/asm-generic/div64.h).  The two
> implementations would have to be benchmarked against each other across a
> couple of different CPUs.
The original MIPS do_div() has "h" constraint, and this is also the
reason why Ralf rewrote this file. How can we reintroduce do_div()
without "h" constraint?

Huacai
>
> > >  Huacai, thanks for your investigation!  Please be more careful in
> > > verifying your future submissions however.
> > Sorry, I thought there is only one bug in div64.h, but in fact there
> > are three...
>
>  This just shows the verification you made was not good enough, hence my
> observation.
>
>   Maciej
