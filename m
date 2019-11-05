Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37DAF085A
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 22:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfKEVaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 16:30:02 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40866 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730163AbfKEVaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 16:30:01 -0500
Received: by mail-oi1-f193.google.com with SMTP id 22so859947oip.7
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 13:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MKex/i2q2cLUhnrOZHb/aTfSgxLlxLOB7hwQ/W42MOw=;
        b=yxFFwBbFJuRUmrLRu10ZGRWzKFrK7/48YyA7Ncx1ZigYrzwB8XSeGTQmsue6WKWmSJ
         Xfe0oir5wnBLctIZp9L+juUiBycM6ZTvBtI+BNK4TtUaT7fcE75tSlsPnxEHp9UKahbz
         2hpMQA0b1ljhgjAucbg/dmSp2YGsqIQSvrhr5/r/p+eVAgFppBggggHoTEoj4hUxiryz
         Od37e8JexbJXGc9eI2TCXsU0X2LxLGic4ZFevFWgFwqpifNeSD15vXG1GGJlLQtgZXav
         t5TZWpVaSxnlO3F7KDScwucNanRdQ8eZ9FhGnEM+wUILlxc9m8A2ymCJzDbA8wLDhXr5
         2URw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MKex/i2q2cLUhnrOZHb/aTfSgxLlxLOB7hwQ/W42MOw=;
        b=DfI6tpHZnY2ffxl4sXjEgDT1bDO8gOAuNpudw9de+6TL4adBlrrXGj4Ew8g9CYGZQI
         VtH6o3HBxyY+oGN2zr2bLz4akh5hls9mkZoBuv2yiAwZuBkjQHy2qRl7mupoeVJRHASJ
         +CJjnuaIeACjcgFXBDj+5yRHrXSGOS6z4Cfx9yqWg/SHCEyvdJQp0BLrlgcl8YHz5i0/
         hbSHEsdj47xAkcajH5T5yFikmBy1qQ05o/9ADI5XAL/l0sLHgAr4vhqU6BA231GcJqZR
         Q8ahE8Y3XOHShJykj/ZMlvWHBO4kES370wAnffyzK+KuUeo3DtbtjLLiAM7cUpSX8X2O
         W6gQ==
X-Gm-Message-State: APjAAAWinffY9kiQf2YbA9B7WNFaaLVZrwDIcVD5k73wRFZcw22nbLKq
        Bt5sBODbWLpTOo9dbDbL/OMgEPV87J+u5sckoqiD2w==
X-Google-Smtp-Source: APXvYqyzj5HURLTlobaqoi8hTKrbUECVIYX+Szr2iuPljx86BKtHnCHUZsYoXa9CppTgl3WUix0tHrwd6NrPPAarr4s=
X-Received: by 2002:aca:3a41:: with SMTP id h62mr990522oia.97.1572989400562;
 Tue, 05 Nov 2019 13:30:00 -0800 (PST)
MIME-Version: 1.0
References: <20191029153051.24367-1-catalin.marinas@arm.com>
 <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com>
 <20191105102902.GB29852@willie-the-truck> <20191105165433.GD22987@arrakis.emea.arm.com>
 <CALAqxLWYJvHO3YYbQHmgg0yThx_kqM7HBFnnxrcWkG1-LXeCQQ@mail.gmail.com>
In-Reply-To: <CALAqxLWYJvHO3YYbQHmgg0yThx_kqM7HBFnnxrcWkG1-LXeCQQ@mail.gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 5 Nov 2019 13:29:49 -0800
Message-ID: <CALAqxLVeRKmJdwUZe3h1dBVyMsnPFNkEw5ckB08NFsJ7dwTvPw@mail.gmail.com>
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>, Alistair Delva <adelva@google.com>,
        Sandeep Patil <sspatil@google.com>,
        stable <stable@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Steve Capper <Steve.Capper@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 5, 2019 at 1:17 PM John Stultz <john.stultz@linaro.org> wrote:
> On Tue, Nov 5, 2019 at 8:54 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Tue, Nov 05, 2019 at 10:29:03AM +0000, Will Deacon wrote:
> > > On Mon, Nov 04, 2019 at 05:16:42PM -0800, John Stultz wrote:
> > > > On Tue, Oct 29, 2019 at 8:31 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > >
> > > > > Shared and writable mappings (__S.1.) should be clean (!dirty) initially
> > > > > and made dirty on a subsequent write either through the hardware DBM
> > > > > (dirty bit management) mechanism or through a write page fault. A clean
> > > > > pte for the arm64 kernel is one that has PTE_RDONLY set and PTE_DIRTY
> > > > > clear.
> > > > >
> > > > > The PAGE_SHARED{,_EXEC} attributes have PTE_WRITE set (PTE_DBM) and
> > > > > PTE_DIRTY clear. Prior to commit 73e86cb03cf2 ("arm64: Move PTE_RDONLY
> > > > > bit handling out of set_pte_at()"), it was the responsibility of
> > > > > set_pte_at() to set the PTE_RDONLY bit and mark the pte clean if the
> > > > > software PTE_DIRTY bit was not set. However, the above commit removed
> > > > > the pte_sw_dirty() check and the subsequent setting of PTE_RDONLY in
> > > > > set_pte_at() while leaving the PAGE_SHARED{,_EXEC} definitions
> > > > > unchanged. The result is that shared+writable mappings are now dirty by
> > > > > default
> > > > >
> > > > > Fix the above by explicitly setting PTE_RDONLY in PAGE_SHARED{,_EXEC}.
> > > > > In addition, remove the superfluous PTE_DIRTY bit from the kernel PROT_*
> > > > > attributes.
> > > > >
> > > > > Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
> > > > > Cc: <stable@vger.kernel.org> # 4.14.x-
> > > > > Cc: Will Deacon <will@kernel.org>
> > > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > [...]
> > > As an experiment, can you try reverting just the part of the patch that
> > > removes PTE_DIRTY from the PROT_* definitions? (see below)
> >
> > Another thing worth trying is reverting commit 747a70e60b72 ("arm64: Fix
> > copy-on-write referencing in HugeTLB") when this patch is applied. That
> > commit is not just about hugetlb but changes pte_same() to ignore
> > PTE_RDONLY on the assumption that this is set by set_pte_at(). We
> > subsequently changed set_pte_at() to drop PTE_RDONLY.
>
> Just to confirm, reverting 747a70e60b72 instead of aa57157be69f also
> seems to avoid the issue I'm seeing.
>
> I've not tried Will patch but I'll do that next. Though its not clear
> if you wanted me to revert 747a70e60b72 on top of Will's test patch or
> not?

Not sure if its useful data, but while Will's patch on its own didn't
change the behavior, it along with reverting 747a70e60b72 seems to
work the same as just reverting 747a70e60b72 alone.

thanks
-john
