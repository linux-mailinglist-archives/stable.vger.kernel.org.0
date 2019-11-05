Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A682FF03C9
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 18:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388969AbfKERG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 12:06:56 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46095 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388177AbfKERG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 12:06:56 -0500
Received: by mail-ot1-f66.google.com with SMTP id n23so8006955otr.13
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 09:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=js1uxvkfzEyBhJbrD075nNWII8JzENFVnKOhOHwJl0c=;
        b=ufCs9BolzEkqRByAVsa8+synCHx2vRDpnP4wHgR1ZpH60dRyAIJ5J24ENmMXwFVMdR
         6R8QScpxUSvFmNTet4L6Ae7vglDkX3iQrVvgd0k1R8s3nkZ3DVvdFW5ok/zVGeS7RttK
         ScYb9Z26qvnvrC74TOMqZEQoWGTQXWH64hI8Xw98euy9eK2zWOd4TlQ5MceSgciuALVG
         XPjr2URYPRnGZXei8LVKKiBtPMCo0cfoPJTfLDRuSYa9/lb1odX+TdXSaUi1aFnjG/98
         8oAou5WYctetK9BARQP5Fu8UG+H+3gjcq5oI+dcX0NlCy/ff08xtMslzDT6dRIWDaCST
         XrHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=js1uxvkfzEyBhJbrD075nNWII8JzENFVnKOhOHwJl0c=;
        b=kN7vWLCbP6+URs3OOBRB69JgRxaSUTgyEv2AeOwbw62jekoqe/G+h9nIpIiDsyG0K1
         YQRsGSianl5gL7ozjbur+G3fig574s9/T0MRmNOOHx0TZ7e8UURJ66YvS3h779+bgf3f
         TFCULyWv1IOrI7O+lqyyOeyDfaZTsnJDPzCTX8BYSfbAwl1cAOpOXHreOBWu/CGE93lO
         MRE4DotHgJieNX2uoSOvSO7/d69ESb8QblV/uH4CGgXySMUyExw13zqm65Ag1EEvJpG7
         zJv3Sf6qZpdAuCGxbLOFxrdoDMXGMGIQ/XZr328wKfYJENeb/ogpJB+nbB4so1PTN/Z+
         CZuQ==
X-Gm-Message-State: APjAAAVLSz4E8F3Ao0bBQnNklyZCP0g0NFVbs75BS0b9cYsEIkTgBLpW
        Vq+9CoOKoDbtUUF/KWTZSJUzeKNSxahoPQY8eldw4w==
X-Google-Smtp-Source: APXvYqyMGp5bxtuxTJTvpilLnFijhnFa4MNrxfrfPtgWx2N81ySl2ufK5cRfXk+NaIY3HCQ2OpuDSuyqjCjqfS6FYlo=
X-Received: by 2002:a9d:630c:: with SMTP id q12mr23091720otk.332.1572973615034;
 Tue, 05 Nov 2019 09:06:55 -0800 (PST)
MIME-Version: 1.0
References: <20191029153051.24367-1-catalin.marinas@arm.com>
 <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com> <20191105102902.GB29852@willie-the-truck>
In-Reply-To: <20191105102902.GB29852@willie-the-truck>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 5 Nov 2019 09:06:43 -0800
Message-ID: <CALAqxLVT-SK0-nNUmbDWa3kkZED2z+pcryzuue9c=n42shu3kA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default
To:     Will Deacon <will@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>,
        Alistair Delva <adelva@google.com>,
        Sandeep Patil <sspatil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 5, 2019 at 2:29 AM Will Deacon <will@kernel.org> wrote:
>
> Hi John,
>
> On Mon, Nov 04, 2019 at 05:16:42PM -0800, John Stultz wrote:
> > On Tue, Oct 29, 2019 at 8:31 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > >
> > > Shared and writable mappings (__S.1.) should be clean (!dirty) initially
> > > and made dirty on a subsequent write either through the hardware DBM
> > > (dirty bit management) mechanism or through a write page fault. A clean
> > > pte for the arm64 kernel is one that has PTE_RDONLY set and PTE_DIRTY
> > > clear.
> > >
> > > The PAGE_SHARED{,_EXEC} attributes have PTE_WRITE set (PTE_DBM) and
> > > PTE_DIRTY clear. Prior to commit 73e86cb03cf2 ("arm64: Move PTE_RDONLY
> > > bit handling out of set_pte_at()"), it was the responsibility of
> > > set_pte_at() to set the PTE_RDONLY bit and mark the pte clean if the
> > > software PTE_DIRTY bit was not set. However, the above commit removed
> > > the pte_sw_dirty() check and the subsequent setting of PTE_RDONLY in
> > > set_pte_at() while leaving the PAGE_SHARED{,_EXEC} definitions
> > > unchanged. The result is that shared+writable mappings are now dirty by
> > > default
> > >
> > > Fix the above by explicitly setting PTE_RDONLY in PAGE_SHARED{,_EXEC}.
> > > In addition, remove the superfluous PTE_DIRTY bit from the kernel PROT_*
> > > attributes.
> > >
> > > Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
> > > Cc: <stable@vger.kernel.org> # 4.14.x-
> > > Cc: Will Deacon <will@kernel.org>
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> >
> > Hey,
> >   So I'm not yet sure why, but I've just validated that this patch is
> > causing trouble with booting AOSP on HiKey960 with 5.4-rc6 (-rc5 works
> > fine).
>
> Hmm. Annoying this wasn't spotted by CI.
>
> > Its odd, because the system does boot and is alive, but seems to stall
> > out at the boot animation, and userland never finishes coming up to
> > the home screen. It just sits there without a useful error message
> > that I can find so far.  Reverting just this patch seems to solve it
> > and it boots all the way.
>
> Given that I don't think the HiKey960 supports h/w DBM, my initial guess
> is that the GPU is stuck on a page fault.
>
> > I'll try to dig further to see what might be going on (the mali driver
> > is a prime suspect here), but I wanted to raise the flag since we're
> > at the end of the -rc cycle.
>
> What exactly are you using for the mali driver?

I've got an old r10p0 bifrost blob we were given and kernel patches
I've carried forward since then.

Again, I don't want to distract you too much for something that may be
related to a blob driver. I mostly just wanted to raise a flag in case
there was something off that might affect others.

> As an experiment, can you try reverting just the part of the patch that
> removes PTE_DIRTY from the PROT_* definitions? (see below)

I'll give this a try! Feel free to let me know if there's anything
else I should test.

thanks
-john
