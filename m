Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7B0F1198
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 09:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfKFI7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 03:59:44 -0500
Received: from foss.arm.com ([217.140.110.172]:36060 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfKFI7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 03:59:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F38B930E;
        Wed,  6 Nov 2019 00:59:42 -0800 (PST)
Received: from arrakis.emea.arm.com (unknown [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE9493F71A;
        Wed,  6 Nov 2019 00:59:41 -0800 (PST)
Date:   Wed, 6 Nov 2019 08:59:39 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Will Deacon <will@kernel.org>, Alistair Delva <adelva@google.com>,
        Sandeep Patil <sspatil@google.com>,
        stable <stable@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Steve Capper <Steve.Capper@arm.com>
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by
 default
Message-ID: <20191106085939.GC21133@arrakis.emea.arm.com>
References: <20191029153051.24367-1-catalin.marinas@arm.com>
 <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com>
 <20191105102902.GB29852@willie-the-truck>
 <20191105165433.GD22987@arrakis.emea.arm.com>
 <CALAqxLWYJvHO3YYbQHmgg0yThx_kqM7HBFnnxrcWkG1-LXeCQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLWYJvHO3YYbQHmgg0yThx_kqM7HBFnnxrcWkG1-LXeCQQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 01:17:11PM -0800, John Stultz wrote:
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

Thanks for confirming. I'm not sure about all the interactions in your
kernel but just looking at commit 747a70e60b72 it likely needs to be
reverted anyway. I'll send a separate patch and hopefully Steve can
confirm that it doesn't break the original hugetlb use-case.

-- 
Catalin
