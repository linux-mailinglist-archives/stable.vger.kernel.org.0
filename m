Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFB7F083C
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 22:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfKEVYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 16:24:22 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35419 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbfKEVYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 16:24:22 -0500
Received: by mail-oi1-f196.google.com with SMTP id n16so18978224oig.2
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 13:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X84jp384/+IXoKSOIab0zeWDPYpydznZphJvdqgY5n8=;
        b=Qwa9QPI2TDvhTmcuRAwGhSxmxNNUO3UcJRYEi4csQErk0LAnAEVpELD1SlgMRlXIL4
         xmA0+Uf/aalbO1hKsLtQHwDchaN7fdK78vWJ52YviPfgoSGwAru4cBPMfDldY61v1Se+
         Xykbc7H93Ar99v0HwiFIOx2hn+Ehis5j66jkfCq93b+hCJTkK7+T3YEImLdoAtNs6gC0
         KcI+PqaoVf7gHnF6fC7eBiqIi46Wc9wOUb2yp5Cu98rX0hm2NXlk2coBf3VmaE6qQV2j
         VykHqz4amYe20hpilOt23/6b9I4uZgAKzI9cwisPxV3JJYlnq791HC8sO/az7LHBQhrb
         cFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X84jp384/+IXoKSOIab0zeWDPYpydznZphJvdqgY5n8=;
        b=RLSJF5TSwuFx1iJ3mYmOjFzRcuklaVuFF1WB8fDMgPrcOBIzpAZNY0AI65x03oyUZx
         r4HyDv12dWeuFsC4Bx/RH1YWftYteZsqEE+byVovCSx5c9uD7JJhMfFEgclRDlordX+y
         QhfACETVpOIFjyJABPoljReVIJ25NVJ7zZJUmTde9p2f37taFZtUxtLjofGpnr02ilXO
         1DKtCGpeL17qgKPLwZ5K3o/yRDsRL/BJ97UkLwwXC8Scue2VWQi5IxiZ32i1ZDmRsCSX
         Glk0kHAzho8SKLtFhAvGA7d2ks/t3yuqvIH9ffqAZ+xHiec5wrrOjl6UyUd8bKEo8ggz
         YoWQ==
X-Gm-Message-State: APjAAAVlE6efl+kLilqOFP+zhhfyK9k4SUksHx37Op8mLAqmRbISAKvH
        QGaeoQi/Xn5MQLtB7+XKEg6JqAZKLp6rR5hMknaaFA==
X-Google-Smtp-Source: APXvYqxar/+bHInCiMqU3Dp0QBwtkxCXnEKsm9r7PrwyY72XDOIs4CIlgr/dS3qkw6dyFmlqwR/q6B8yPGmxRsJbtK8=
X-Received: by 2002:aca:1210:: with SMTP id 16mr1002978ois.128.1572989061350;
 Tue, 05 Nov 2019 13:24:21 -0800 (PST)
MIME-Version: 1.0
References: <20191029153051.24367-1-catalin.marinas@arm.com>
 <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com> <20191105102902.GB29852@willie-the-truck>
In-Reply-To: <20191105102902.GB29852@willie-the-truck>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 5 Nov 2019 13:24:10 -0800
Message-ID: <CALAqxLV95OuWUjtWOdTKweqWfr4GSgDgf-KNggXiiKsCgsygKg@mail.gmail.com>
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
>
> As an experiment, can you try reverting just the part of the patch that
> removes PTE_DIRTY from the PROT_* definitions? (see below)

So reverting just the bit you sent here re-adding the PTE_DIRTY bit
didn't seem to fix it. I still see things stalling at the boot
animation.

thanks
-john
