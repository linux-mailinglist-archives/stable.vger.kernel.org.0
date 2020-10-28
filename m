Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956FD29D6A9
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbgJ1WRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731441AbgJ1WRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:17:12 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6D3C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:17:12 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id t13so893770ljk.12
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T3cqq/NCYbTXYrF1TPKJhjFGrojFTr6Vs4M/e3juExo=;
        b=vHWozAGFqMpE7ggVelY+F2jS1kMR2nSt1Yk9nJlD6AAg+OUfG1xGn3eYW8v457b2nU
         Sm/+yTkS7qN1Gs/Odp2HfGjKKxpC6VQOgqnJfspet+MfHCvkS1jeQQSCukzHFxlZD7YF
         WLjJauesFmQhnosBRh7E2dfg5F9NUnD3KU9Sr7LATbF3GUK3yDLNQVG5iwQMFcsDh3BO
         KTnXkpWSaeQ7oy07H1SC7JIUOf3B7DacFJbF+jMsvTnu8Q+KOhDOiptmA2Kf5x+jDHPU
         81ZACzEow/DJmNKXH3l9zBEMjzuKfOgGSHBW2fe0mLoQNVWik+UiEnq0MSUMhOQpg9pj
         9PZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T3cqq/NCYbTXYrF1TPKJhjFGrojFTr6Vs4M/e3juExo=;
        b=KGKYw6Ft+SFYRtT2YyBSmvmD+vL2Bog2SLAdB2MN20yiP7OVSH7OObYccaVzh4I4Pm
         +qPPo6HRynZczH1tcHhPAn9/KVtETgH+cii7C8k9HXCCdrwea0MuDBoxQNLy/nvorJPG
         phTzCCW9gwk1xdx/qdOAhFQltPcgEl0dDtFX1mdQxogb1j9dvq/ak/uxeRo8kTUtYCjD
         8qTZWmnsqnibDs92XZaz+WnHdGX+DZlN7h/RXhF4kwU/LWyiPSU49JNC8nuTtxbj2EX+
         lYPgee3uPrm7nZwoXQcQzMiVbCXohMxMnWI9v402xQojnbES6rjD5H/7IVwdB0zlbrHI
         7q9g==
X-Gm-Message-State: AOAM531/UqJRJPDy+MfV2ytL9dNCVeTRfajnh+DMLPz6juCKUP50EoNR
        LXkZ1zviXGAv6jKAYIXapJ7lMrD3kE04jNQ/3ZkG7TjtVA8=
X-Google-Smtp-Source: ABdhPJwlwDQMF3LHnuk4kQId499nf+MAFapv086WNS3mOjg8mkPXn9Wv1Y0YDCbQat01jYZQYKX3xEqRi2pw0BvLurk=
X-Received: by 2002:a17:906:48b:: with SMTP id f11mr651163eja.293.1603913866632;
 Wed, 28 Oct 2020 12:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201021204426.36069-1-mike.kravetz@oracle.com> <20201022081538-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201022081538-mutt-send-email-mst@kernel.org>
From:   Mina Almasry <almasrymina@google.com>
Date:   Wed, 28 Oct 2020 12:37:35 -0700
Message-ID: <CAHS8izMnu49eSSZQmazwh8g7viGYeqq08ZmM-1CwJGg22L-Xpg@mail.gmail.com>
Subject: Re: [PATCH] hugetlb_cgroup: fix reservation accounting
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Linux-MM <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 22, 2020 at 5:21 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Oct 21, 2020 at 01:44:26PM -0700, Mike Kravetz wrote:
> > Michal Privoznik was using "free page reporting" in QEMU/virtio-balloon
> > with hugetlbfs and hit the warning below.  QEMU with free page hinting
> > uses fallocate(FALLOC_FL_PUNCH_HOLE) to discard pages that are reported
> > as free by a VM. The reporting granularity is in pageblock granularity.
> > So when the guest reports 2M chunks, we fallocate(FALLOC_FL_PUNCH_HOLE)
> > one huge page in QEMU.
> >
> > [  315.251417] ------------[ cut here ]------------
> > [  315.251424] WARNING: CPU: 7 PID: 6636 at mm/page_counter.c:57 page_counter_uncharge+0x4b/0x50
> > [  315.251425] Modules linked in: ...
> > [  315.251466] CPU: 7 PID: 6636 Comm: qemu-system-x86 Not tainted 5.9.0 #137
> > [  315.251467] Hardware name: Gigabyte Technology Co., Ltd. X570 AORUS PRO/X570 AORUS PRO, BIOS F21 07/31/2020
> > [  315.251469] RIP: 0010:page_counter_uncharge+0x4b/0x50
> > ...
> > [  315.251479] Call Trace:
> > [  315.251485]  hugetlb_cgroup_uncharge_file_region+0x4b/0x80
> > [  315.251487]  region_del+0x1d3/0x300
> > [  315.251489]  hugetlb_unreserve_pages+0x39/0xb0
> > [  315.251492]  remove_inode_hugepages+0x1a8/0x3d0
> > [  315.251495]  ? tlb_finish_mmu+0x7a/0x1d0
> > [  315.251497]  hugetlbfs_fallocate+0x3c4/0x5c0
> > [  315.251519]  ? kvm_arch_vcpu_ioctl_run+0x614/0x1700 [kvm]
> > [  315.251522]  ? file_has_perm+0xa2/0xb0
> > [  315.251524]  ? inode_security+0xc/0x60
> > [  315.251525]  ? selinux_file_permission+0x4e/0x120
> > [  315.251527]  vfs_fallocate+0x146/0x290
> > [  315.251529]  __x64_sys_fallocate+0x3e/0x70
> > [  315.251531]  do_syscall_64+0x33/0x40
> > [  315.251533]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > ...
> > [  315.251542] ---[ end trace 4c88c62ccb1349c9 ]---
> >
> > Investigation of the issue uncovered bugs in hugetlb cgroup reservation
> > accounting.  This patch addresses the found issues.
> >
> > Fixes: 075a61d07a8e ("hugetlb_cgroup: add accounting for shared mappings")
> > Cc: <stable@vger.kernel.org>
> > Reported-by: Michal Privoznik <mprivozn@redhat.com>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>
> > ---
> >  mm/hugetlb.c | 20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 67fc6383995b..b853a11de14f 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -655,6 +655,8 @@ static long region_del(struct resv_map *resv, long f, long t)
> >                       }
> >
> >                       del += t - f;
> > +                     hugetlb_cgroup_uncharge_file_region(
> > +                             resv, rg, t - f);
> >
> >                       /* New entry for end of split region */
> >                       nrg->from = t;
> > @@ -667,9 +669,6 @@ static long region_del(struct resv_map *resv, long f, long t)
> >                       /* Original entry is trimmed */
> >                       rg->to = f;
> >
> > -                     hugetlb_cgroup_uncharge_file_region(
> > -                             resv, rg, nrg->to - nrg->from);
> > -
> >                       list_add(&nrg->link, &rg->link);
> >                       nrg = NULL;
> >                       break;
> > @@ -685,17 +684,17 @@ static long region_del(struct resv_map *resv, long f, long t)
> >               }
> >
> >               if (f <= rg->from) {    /* Trim beginning of region */
> > -                     del += t - rg->from;
> > -                     rg->from = t;
> > -
> >                       hugetlb_cgroup_uncharge_file_region(resv, rg,
> >                                                           t - rg->from);
> > -             } else {                /* Trim end of region */
> > -                     del += rg->to - f;
> > -                     rg->to = f;
> >
> > +                     del += t - rg->from;
> > +                     rg->from = t;
> > +             } else {                /* Trim end of region */
> >                       hugetlb_cgroup_uncharge_file_region(resv, rg,
> >                                                           rg->to - f);
> > +
> > +                     del += rg->to - f;
> > +                     rg->to = f;
> >               }
> >       }
> >
> > @@ -2454,6 +2453,9 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
> >
> >               rsv_adjust = hugepage_subpool_put_pages(spool, 1);
> >               hugetlb_acct_memory(h, -rsv_adjust);
> > +             if (deferred_reserve)
> > +                     hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
> > +                                     pages_per_huge_page(h), page);
> >       }
> >       return page;
> >
> > --
> > 2.25.4
>

Sorry for the late review. Looks good to me.

Reviewed-by: Mina Almasry <almasrymina@google.com>
