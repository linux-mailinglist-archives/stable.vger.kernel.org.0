Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD17B3B1F0D
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 18:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFWQ4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 12:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWQ4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 12:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAE0661166;
        Wed, 23 Jun 2021 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624467228;
        bh=LYw9KrT6EWFOgPNN/mSPq1gLbniFMd56VlhiOD0vkTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IibWNZt/FIjXHm36gyNpg8hezTQlzpNp5AEMv5DeH29SOsR0F5s56LAqJQy5NcaGn
         MDGdSPMDbBBcGZ1fHzqA0vI5mEmn+gGpae5QMDvCpm4YstexLVA4Mlz7oGatL+4Nhm
         a39+LHJIRevqFTnA4ulSYh6llWagO2ThiNtVNi8s=
Date:   Wed, 23 Jun 2021 18:53:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
Message-ID: <YNNnGTjtjYtUhV6M@kroah.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com>
 <YMrU4FRkrQ7AVo5d@kroah.com>
 <YNNMGjoMajhPNyiK@kroah.com>
 <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 09:44:14AM -0700, Hugh Dickins wrote:
> On Wed, 23 Jun 2021, Greg Kroah-Hartman wrote:
> > On Thu, Jun 17, 2021 at 06:51:44AM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, Jun 16, 2021 at 04:02:32PM -0700, Hugh Dickins wrote:
> > > > Hi Greg,
> > > > 
> > > > Linus has taken in a group of mm/thp commits Cc stable today:
> > > > 
> > > > 504e070dc08f mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
> > > > 22061a1ffabd mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
> > > > 31657170deaf mm/thp: fix page_address_in_vma() on file THP tails
> > > > 494334e43c16 mm/thp: fix vma_address() if virtual address below file offset
> > > > 732ed55823fc mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
> > > > 3b77e8c8cde5 mm/thp: make is_huge_zero_pmd() safe and quicker
> > > > 99fa8a48203d mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
> > > > ffc90cbb2970 mm, thp: use head page in __migration_entry_wait()
> > > > 
> > > > and I expect some more to follow in a few days time (thanks Andrew).
> > > > 
> > > > No problem with the commits themselves, but I'm aware that some of them
> > > > have dependencies on other commits not yet in stable, which I have to
> > > > sort out for you now.
> > > > 
> > > > I'd prefer to avoid a deluge of "does not apply" messages, so ask you
> > > > please to hold off trying to merge these into stable trees for a few days:
> > > > I'll get back to you with what's needed for them to apply.
> > > 
> > > Not a problem, thanks for the heads up, I'll restrain from running my
> > > scripts on the above patches until you say it's safe to :)
> > 
> > Any word on this?
> 
> I have a "matrix" of what's needed ready, but I'm still waiting on
> "I expect some more to follow in a few days time (thanks Andrew)":
> I believe akpm does still intend to send them in to Linus for 5.13
> this week, but they've not gone yet.
> 
> So eleven don't yet have SHA1s (of SignOffs by Linus) to include.
> Ten of them (I'm calling pvmw1 through pvmw10) are progressive
> mods to one function page_vma_mapped_walk(), which were split off
> from the previous patches to help review.  Those ones are easy:
> they all apply cleanly to all releases in which they are needed,
> so no special backports from me required.
> 
> But there's a final futex-pgoff one, which does not apply cleanly
> to 5.4 or 4.9: so that one I do have to send you variants of, and
> cannot until it's in Linus's tree.
> 
> You could proceed with just the first eight already in the tree;
> but it's all (bar the last) part of the same collection of fixes.
> I think better to keep them together - unless Andrew or Linus
> prefers to hold the eleven back until 5.14-rc.
> 
> Here's the "matrix" and notes I assembled for your delectation
> (and I verified yesterday that your latest releases do not add any
> complications); but I'm not yet attaching the tarball of variants,
> which I expect to update for futex-pgoff when it goes in.
> 
> 5.12.12         5.10.45      5.4.127      4.19.195     4.14.237     4.9.273
>                                                        4.14/0001    << chpick
>                 5.10/0001    << chpick    << chpick    << chpick    << chpick
>                 5.10/0002    << chpick    << chpick    << chpick
>                 5.10/0003    << chpick    << chpick    << chpick
> ffc90cbb2970    << chpick    << chpick
> 99fa8a48203d    5.10/0005    << chpick    << chpick
> 3b77e8c8cde5    << chpick    << chpick    << chpick
> 732ed55823fc    << chpick    5.04/0007    << chpick    << chpick
> 494334e43c16    << chpick    5.04/0008    4.19/0007    << chpick
> 31657170deaf    << chpick    << chpick    << chpick    << chpick
> 22061a1ffabd    5.10/0010    5.04/0010    << chpick
> 504e070dc08f    5.10/0011    5.04/0011    4.19/0010    4.14/0008   4.09/0003
> pvmw1-pvmw10    << chpick    << chpick    << chpick    << chpick
> futex-pgoff     << chpick    5.04/0022    << chpick    << chpick   4.09/0004
> 
> Already in 5.13-rc7:
> ffc90cbb2970 mm, thp: use head page in __migration_entry_wait()
> 99fa8a48203d mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
> 3b77e8c8cde5 mm/thp: make is_huge_zero_pmd() safe and quicker
> 732ed55823fc mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
> 494334e43c16 mm/thp: fix vma_address() if virtual address below file offset
> 31657170deaf mm/thp: fix page_address_in_vma() on file THP tails
> 22061a1ffabd mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
> 504e070dc08f mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
> 
> Expected in 5.13 final:
> pvmw1        mm: page_vma_mapped_walk(): use page for pvmw->page
> pvmw2        mm: page_vma_mapped_walk(): settle PageHuge on entry
> pvmw3        mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
> pvmw4        mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
> pvmw5        mm: page_vma_mapped_walk(): crossing page table boundary
> pvmw6        mm: page_vma_mapped_walk(): add a level of indentation
> pvmw7        mm: page_vma_mapped_walk(): use goto instead of while (1)
> pvmw8        mm: page_vma_mapped_walk(): get vma_address_end() earlier
> pvmw9        mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
> pvmw10       mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
> futex-pgoff  mm, futex: fix shared futex pgoff on shmem huge page
> 
> Antecedents which get added into some older kernels:
> 4.14/0001 91241681c62a include/linux/mmdebug.h: make VM_WARN* non-rvals
> 5.10/0001 a4055888629b (part) mm: add VM_WARN_ON_ONCE_PAGE() macro
> 5.10/0002 e0af87ff7afc mm/rmap: remove unneeded semicolon in page_not_mapped()
> 5.10/0003 b7e188ec98b1 mm/rmap: use page_not_mapped in try_to_unmap()
> 
> Nothing special for 5.12.12: all 19 can be cherry-picked cleanly.
> 
> Antecedents and fixedups for 5.10.45 and older:
> 5.10/0001-mm-add-VM_WARN_ON_ONCE_PAGE-macro.patch
> 5.10/0002-mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
> 5.10/0003-mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
> 5.10/0005-mm-thp-fix-__split_huge_pmd_locked-on-shmem-migratio.patch
> 5.10/0010-mm-thp-unmap_mapping_page-to-fix-THP-truncate_cleanu.patch
> 5.10/0011-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 
> Fixedups for 5.4.127 and older:
> 5.04/0007-mm-thp-try_to_unmap-use-TTU_SYNC-for-safe-splitting.patch
> 5.04/0008-mm-thp-fix-vma_address-if-virtual-address-below-file.patch
> 5.04/0010-mm-thp-unmap_mapping_page-to-fix-THP-truncate_cleanu.patch
> 5.04/0011-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 5.04/0022-mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
> 
> Fixedups for 4.19.195 and older:
> 4.19/0007-mm-thp-fix-vma_address-if-virtual-address-below-file.patch
> 4.19/0010-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 
> (Why does matrix say not to port ffc90cbb2970 "use head page" to 4.19
> and older?  It is correct, and would apply to them: but they do not
> have put_and_wait_on_page_locked(), so it may behave worse on them.)
> 
> Antecedent and fixedup for 4.14.237 and older:
> 4.14/0001-include-linux-mmdebug.h-make-VM_WARN-non-rvals.patch
> 4.14/0008-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 
> Fixedups for 4.9.273:
> 4.09/0003-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 4.09/0004-mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
> 
> No backports to 4.4.273: it's too old and different for these.
> 
> Does that make sense to you?

Thanks for the information, yes this makes sense.  I'll wait until it
all "lands properly" in Linus's tree, there's no rush from me, I just
wanted to make sure these did not get lost somewhere.

thanks so much.

greg k-h
