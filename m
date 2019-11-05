Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8AD1F0378
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 17:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfKEQyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 11:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbfKEQyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 11:54:38 -0500
Received: from arrakis.emea.arm.com (unknown [46.69.195.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B280921928;
        Tue,  5 Nov 2019 16:54:36 +0000 (UTC)
Date:   Tue, 5 Nov 2019 16:54:33 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        Alistair Delva <adelva@google.com>,
        Sandeep Patil <sspatil@google.com>,
        stable <stable@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Steve Capper <Steve.Capper@arm.com>
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by
 default
Message-ID: <20191105165433.GD22987@arrakis.emea.arm.com>
References: <20191029153051.24367-1-catalin.marinas@arm.com>
 <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com>
 <20191105102902.GB29852@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105102902.GB29852@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 10:29:03AM +0000, Will Deacon wrote:
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
[...]
> As an experiment, can you try reverting just the part of the patch that
> removes PTE_DIRTY from the PROT_* definitions? (see below)

Another thing worth trying is reverting commit 747a70e60b72 ("arm64: Fix
copy-on-write referencing in HugeTLB") when this patch is applied. That
commit is not just about hugetlb but changes pte_same() to ignore
PTE_RDONLY on the assumption that this is set by set_pte_at(). We
subsequently changed set_pte_at() to drop PTE_RDONLY.

-- 
Catalin
