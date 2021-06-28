Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C5E3B6763
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 19:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhF1RQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 13:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbhF1RQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 13:16:03 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A903C061574
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 10:13:37 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 110-20020a9d0a770000b0290466fa79d098so2880604otg.9
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 10:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=z9klk8Z34nOqGCgG0SoA5hqHrLNOmQoouehFtbCfYMo=;
        b=YZEHW7IMYXIaxc8A94TIrtq0GMza5FMAWBGfBJnfq04y3jPmhFruaFfhXdDjA87/Ro
         TFnbXO1OvubEHCO7Bj7TVSbv3Mcq6Ah11Btph3iGrYk9AaErpl5XJ6qMUPmCmrOqm1+T
         R93U1YVa7Jktfkgq752Mfeei/bFrqVZJ9ULCvOCgqroFSqZHa6s300KTEImd8zFPzMc0
         pT3xgdPXqbKSLC/pRKVZFry82RJN43V1kWxfZ9FKnxx2vb+QOpRRZ5SHdwMJNM7X3qRW
         16OckXiOv765su4/UKPna7rPuTGLrqTDo4A6j0C9PS8ktAcxefE6U0e68IMMfilA7/L5
         ybXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=z9klk8Z34nOqGCgG0SoA5hqHrLNOmQoouehFtbCfYMo=;
        b=ibIP6dx6UzUD8U+pdaar18zR+J0r7NK4rtCqumokUvjWC4Js29f4AsrXfn2HtqRLr7
         WVzIQrmMWy6Ilq/VX9uhh3HG4/+8+Ly8WNgdLOrcduRtRdQuovgYe4vV0WMD6sGwa8LV
         2RZWgim+9ow+IQhN0DqyHsK2usvL2MRNj7/kC1P5KK4nxGXxxqyyZDCUTEuhCI5QUE1H
         v1ZQ+5PViAgtLUSVsneQldFNFMVSsRsTEao7LliF0tVQpu11G9wDMuhzn8q5AzwtbXj+
         XMLyb8hMYIaaZYIO+dfIx8k1qt6F5jlze12ulpsaBUXMqcdIqF6itYE1ypbCkQVugiq/
         bWDQ==
X-Gm-Message-State: AOAM531YuNFfVsstkqJAXx2pdJZhyhQxfhGNuwj2TUpauObBaCv1c8IQ
        bM1VXLZyUSMV8uE89Ci4zzK7zw==
X-Google-Smtp-Source: ABdhPJyi4mIY5wczFdcTQoyfv/1FDfaMjSssUOUUErF6OfmCZVq1Dj3awDlifC2ekaXhFlydEVwToA==
X-Received: by 2002:a9d:364a:: with SMTP id w68mr522746otb.33.1624900416525;
        Mon, 28 Jun 2021 10:13:36 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id e10sm326556oig.15.2021.06.28.10.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 10:13:35 -0700 (PDT)
Date:   Mon, 28 Jun 2021 10:12:57 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, Alex Shi <alexs@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
In-Reply-To: <YNm93fkIPrqMwHzd@kroah.com>
Message-ID: <366846c0-245a-771e-7a1-4a307ac6e5e1@google.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com> <YMrU4FRkrQ7AVo5d@kroah.com> <YNNMGjoMajhPNyiK@kroah.com> <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com> <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org> <c2bf7b2-a2d9-95a1-e322-4cf4b8613e9@google.com>
 <6b253bc4-2562-d1bb-18f2-517cfad5d5e7@google.com> <YNm93fkIPrqMwHzd@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021, Greg Kroah-Hartman wrote:
> On Fri, Jun 25, 2021 at 05:38:01PM -0700, Hugh Dickins wrote:
> > On Wed, 23 Jun 2021, Hugh Dickins wrote:
> > > On Wed, 23 Jun 2021, Andrew Morton wrote:
> > > > On Wed, 23 Jun 2021 09:44:14 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > > > 
> > > > > > Any word on this?
> > > > > 
> > > > > I have a "matrix" of what's needed ready, but I'm still waiting on
> > > > > "I expect some more to follow in a few days time (thanks Andrew)":
> > > > > I believe akpm does still intend to send them in to Linus for 5.13
> > > > > this week, but they've not gone yet.
> > > > 
> > > > Linuswards tomorrow.  Is that OK?
> > > 
> > > That's great, thanks Andrew.  Then when they appear in Linus's tree,
> > > I'll complete my notes and tarball, and mail GregKH in reply here.
> > 
> > All in now, thanks: so attached is a tarball of the variants,
> > and here the finalized summary of what each stable needs.
> > 
> > 5.12.13         5.10.46      5.4.128      4.19.195     4.14.237     4.9.273
> >                                                        4.14/0001    << chpick
> >                 5.10/0001    << chpick    << chpick    << chpick    << chpick
> >                 5.10/0002    << chpick    << chpick    << chpick
> >                 5.10/0003    << chpick    << chpick    << chpick
> > ffc90cbb2970    << chpick    << chpick
> > 99fa8a48203d    5.10/0005    << chpick    << chpick
> > 3b77e8c8cde5    << chpick    << chpick    << chpick
> > 732ed55823fc    << chpick    5.04/0007    << chpick    << chpick
> > 494334e43c16    << chpick    5.04/0008    4.19/0007    << chpick
> > 31657170deaf    << chpick    << chpick    << chpick    << chpick
> > 22061a1ffabd    5.10/0010    5.04/0010    << chpick
> > 504e070dc08f    5.10/0011    5.04/0011    4.19/0010    4.14/0008   4.09/0003
> > f003c03^..a7a69d8  chpick    << chpick    << chpick    << chpick
> > fe19bd3dae3d    << chpick    5.04/0022    << chpick    << chpick   4.09/0004
> > 
> > 19 recent THP-related upstream commits for 5.13:
> > ffc90cbb2970 mm, thp: use head page in __migration_entry_wait()
> > 99fa8a48203d mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
> > 3b77e8c8cde5 mm/thp: make is_huge_zero_pmd() safe and quicker
> > 732ed55823fc mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
> > 494334e43c16 mm/thp: fix vma_address() if virtual address below file offset
> > 31657170deaf mm/thp: fix page_address_in_vma() on file THP tails
> > 22061a1ffabd mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
> > 504e070dc08f mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
> > f003c03bd29e mm: page_vma_mapped_walk(): use page for pvmw->page
> > 6d0fd5987657 mm: page_vma_mapped_walk(): settle PageHuge on entry
> > 3306d3119cea mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
> > e2e1d4076c77 mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
> > 448282487483 mm: page_vma_mapped_walk(): crossing page table boundary
> > b3807a91aca7 mm: page_vma_mapped_walk(): add a level of indentation
> > 474466301dfd mm: page_vma_mapped_walk(): use goto instead of while (1)
> > a765c417d876 mm: page_vma_mapped_walk(): get vma_address_end() earlier
> > a9a7504d9bea mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
> > a7a69d8ba88d mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
> > fe19bd3dae3d mm, futex: fix shared futex pgoff on shmem huge page
> > 
> > Antecedents which get added into some older kernels:
> > 4.14/0001 91241681c62a include/linux/mmdebug.h: make VM_WARN* non-rvals
> > 5.10/0001 a4055888629b (part) mm: add VM_WARN_ON_ONCE_PAGE() macro
> > 5.10/0002 e0af87ff7afc mm/rmap: remove unneeded semicolon in page_not_mapped()
> > 5.10/0003 b7e188ec98b1 mm/rmap: use page_not_mapped in try_to_unmap()
> > 
> > Nothing special for 5.12.13: all 19 can be cherry-picked cleanly.
> > 
> > Antecedents and fixedups for 5.10.46 and older:
> > 5.10/0001-mm-add-VM_WARN_ON_ONCE_PAGE-macro.patch
> > 5.10/0002-mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
> > 5.10/0003-mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
> > 5.10/0005-mm-thp-fix-__split_huge_pmd_locked-on-shmem-migratio.patch
> > 5.10/0010-mm-thp-unmap_mapping_page-to-fix-THP-truncate_cleanu.patch
> > 5.10/0011-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> > 
> > Fixedups for 5.4.128 and older:
> > 5.04/0007-mm-thp-try_to_unmap-use-TTU_SYNC-for-safe-splitting.patch
> > 5.04/0008-mm-thp-fix-vma_address-if-virtual-address-below-file.patch
> > 5.04/0010-mm-thp-unmap_mapping_page-to-fix-THP-truncate_cleanu.patch
> > 5.04/0011-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> > 5.04/0022-mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
> > 
> > Fixedups for 4.19.195 and older:
> > 4.19/0007-mm-thp-fix-vma_address-if-virtual-address-below-file.patch
> > 4.19/0010-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> > 
> > (Why does matrix say not to port ffc90cbb2970 "use head page" to 4.19
> > and older?  It is correct, and would apply to them: but they do not
> > have put_and_wait_on_page_locked(), so it may behave worse on them.)
> > 
> > Antecedent and fixedup for 4.14.237 and older:
> > 4.14/0001-include-linux-mmdebug.h-make-VM_WARN-non-rvals.patch
> > 4.14/0008-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> > 
> > Fixedups for 4.9.273:
> > 4.09/0003-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> > 4.09/0004-mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
> > 
> > No backports to 4.4.273: it's too old and different for these.
> 
> Thanks so much for this, and I was able to follow the above directions
> for 5.12, 5.10, and 5.4.

Yes, I've checked the results, and you've done brilliantly: thanks.

> 
> But things fell apart for 4.19.y, when doing the backport of the longer
> series:
> > f003c03^..a7a69d8  chpick    << chpick    << chpick    << chpick
> 
> That just did not work.

That's very odd.  If that worked on 5.12, 5.10, 5.4 then I don't
understand how it does not work on 4.19: I've had no trouble repeating
it at this end, so can only think that you must have unconsciously
changed procedure in some way on reaching 4.19.

I say "no trouble", but agree "git cherry-pick f003c03^..a7a69d8"
does not work: because linux-stable-rc.git master has not yet been
updated to Linus's current tree, so the tree doesn't contain those
SHA1s.  But you already worked around that correctly on 5.12, 5.10,
5.4; and "the matrix" wasn't expecting you to go back to 5.13 for
those on 4.19 anyway, but to cherry-pick those ten from what you
already correctly prepared for 5.4.  (Perhaps the right command is
"git cherry-pick 461d351e7cd4^..d106cf83e3cb", that's what worked
for me, but I haven't spent long enough thinking whether my tree
is sufficiently identical to yours or not.)

If that's not the issue, the other two possibilities that cross my
mind are: you're sure that you already applied the first ten patches
to that branch, cherry-picking from 5.4 or git-am'ing 0007 and 0010 -
there are mods to mm/page_vma_mapped.c in a couple of those earlier
patches, which are required for clean application of the later mods.

And the other possibility: I did once or twice a few years ago have
trouble with "git cherry-pick xxx^..yyy" syntax: it failed, but the
equivalent series of individual cherry-picks succeeded.  If that was
not simply pilot error, I imagine it was a git bug long since fixed,
but mention individual cherry-picks as perhaps a workaround.

> 
> So could you just send a mbox of patches (or tarball), for the 4.19,
> 4.14, and 4.9 trees?  That would make it much easier to ensure I got
> them all correct.

At risk of irritating you, sorry, I am resisting: the more data I send
you, the more likely I am to mess it up in some stupid way.  Please ask
again and I shall, but I think your success with 5.12, 5.10, 5.4 just
means that you were right to take a break before 4.19, 4.14, 4.4.

Many thanks,
Hugh
