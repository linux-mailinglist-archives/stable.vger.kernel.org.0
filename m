Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B99D2D1D3C
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 23:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgLGWVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 17:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726732AbgLGWVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 17:21:51 -0500
X-Gm-Message-State: AOAM530Y4RPNG7ATFF7QlizZ8f8VkolG0qFPBQr26xnfY+Hvf1lKFAIq
        oEHGMWCSw4PXD4wfhSanfkmjWZY/Wvze8RPGzQg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607379670;
        bh=sCcJWpX0VD2x5M0ltVav0fWl+0sJfwPhBIjWWJfpkN4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bVTkd4MnyNNYU994HaUZmZE3ixj4WvbM/FYdDX/9BQfbbRUimJD8h5MacZdKQJ043
         lCajon207vmafr0LKcu1QKPilFuaaRIFAS+Awf5U9qt+QoCXwwtJr20LRC8zT4U2bI
         5yz5iIYrzZOu8pn1a/k5abgsfYzWk7RZyNutgdNydVQLDaKgdTTcDH4FxPoaFMsCvt
         pfjfQsi1dEJ6MBqSXe51VUm7TfRrDIktlX8NFeVoVDe0hngzOcoKi7rwD3PYmZoQoc
         r/K42iE84gtmFNBIOcL0QjWgKiAKC5ywmLT6TGsDj8ZXk0N4jlJaI6Uxyemg1lcjh5
         DJ7z2eruLIKMw==
X-Google-Smtp-Source: ABdhPJwYygf8qrTUBOO+Wa5ueaT8l0OO95kQFOnCCs59qFKZ8iFSeajVaUu5jMPZiOMxEtjWolWDy7+tP3Rb83ATiJQ=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr14353388otk.108.1607379670012;
 Mon, 07 Dec 2020 14:21:10 -0800 (PST)
MIME-Version: 1.0
References: <X8yoWHNzfl7vHVRA@kroah.com> <20201207172625.2888810-1-dann.frazier@canonical.com>
 <CAMj1kXHdqaso9Vkm3KeKFntMBQeRTkY-fU1GW8K8rcxBbQbKBA@mail.gmail.com>
 <CALdTtnv6VCBjvS-rtUTdhmLHkiJJrY+m4CLW4F8F89NEpZYF7A@mail.gmail.com>
 <CAMj1kXFAn2bJgwpN+SkGQSzXVdssaZ0Sjpspn8n0QQn4MDk5CA@mail.gmail.com> <CALdTtnuT7fVJ17C2nq8kks_rFRGtDySx61tWpt8b+roajyi7vg@mail.gmail.com>
In-Reply-To: <CALdTtnuT7fVJ17C2nq8kks_rFRGtDySx61tWpt8b+roajyi7vg@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 7 Dec 2020 23:20:59 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEPJZTwpM3kWUAsmJDdfsUpBJbuCiDLX9xgfvy4NPb4hQ@mail.gmail.com>
Message-ID: <CAMj1kXEPJZTwpM3kWUAsmJDdfsUpBJbuCiDLX9xgfvy4NPb4hQ@mail.gmail.com>
Subject: Re: [PATCH 4.4] Revert "crypto: arm64/sha - avoid non-standard inline
 asm tricks"
To:     dann frazier <dann.frazier@canonical.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Michael Schaller <misch@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Dec 2020 at 21:36, dann frazier <dann.frazier@canonical.com> wrote:
>
> On Mon, Dec 7, 2020 at 11:29 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Mon, 7 Dec 2020 at 19:08, dann frazier <dann.frazier@canonical.com> wrote:
> > >
> > > On Mon, Dec 7, 2020 at 10:50 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > > > On Mon, 7 Dec 2020 at 18:26, dann frazier <dann.frazier@canonical.com> wrote:
> > > > >
> > > > > This reverts commit c042dd600f4e89b6e7bdffa00aea4d1d3c1e9686.
> > > > >
> > > > > This caused the build to emit ADR_PREL_PG_HI21 relocations in the sha{1,2}_ce
> > > > > modules. This relocation type is not supported by the linux-4.4.y kernel
> > > > > module loader when CONFIG_ARM64_ERRATUM_843419=y, which we have enabled, so
> > > > > these modules now fail to load:
> > > > >
> > > > >   [   37.866250] module sha1_ce: unsupported RELA relocation: 275
> > > > >
> > > > > This issue does not exist with the backport to 4.9+. Bisection shows that
> > > > > this is due to those kernels also having a backport of
> > > > > commit 41c066f ("arm64: assembler: make adr_l work in modules under KASLR")
> > > >
> > > > Hi Dann,
> > > >
> > > > Would it be an option to backport 41c066f as well?
> > >
> > > Hi Ard,
> > >
> > > That was attempted before, but caused a build failure which would
> > > still happen today:
> > >   https://www.spinics.net/lists/stable/msg179709.html
> > > Specifically, head.S still has a 3 argument usage of adr_l. I'm not
> > > sure how to safely fix that up myself.
> > >
> >
> > Given that the original reason for reverting the backport of 41c066f
> > no longer holds (as there are other users of adr_l in v4.4 now), I
> > think the best solution is to backport it again, but with the hunk
> > below folded in. (This just replaces the macro invocation with its
> > output when called with the 3 arguments in question, so the generated
> > code is identical)
> >
> > --- a/arch/arm64/kernel/head.S
> > +++ b/arch/arm64/kernel/head.S
> > @@ -424,7 +424,8 @@ __mmap_switched:
> >         str     xzr, [x6], #8                   // Clear BSS
> >         b       1b
> >  2:
> > -       adr_l   sp, initial_sp, x4
> > +       adrp    x4, initial_sp
> > +       add     sp, x4, :lo12:initial_sp
> >         str_l   x21, __fdt_pointer, x5          // Save FDT pointer
> >         str_l   x24, memstart_addr, x6          // Save PHYS_OFFSET
> >         mov     x29, #0
>
> Thanks Ard - that works. I'll follow-up with a backport patch.
>

Excellent.
