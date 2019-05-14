Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5AD1C3B6
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 09:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfENHPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 03:15:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfENHPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 03:15:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC599859FC;
        Tue, 14 May 2019 07:15:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC7D918EE4;
        Tue, 14 May 2019 07:15:39 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id A35EC18089C8;
        Tue, 14 May 2019 07:15:39 +0000 (UTC)
Date:   Tue, 14 May 2019 03:15:39 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     Nadav Amit <namit@vmware.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>,
        Will Deacon <will.deacon@arm.com>, peterz@infradead.org,
        minchan@kernel.org, mgorman@suse.de, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>
Message-ID: <914836977.22577826.1557818139522.JavaMail.zimbra@redhat.com>
In-Reply-To: <45c6096e-c3e0-4058-8669-75fbba415e07@email.android.com>
References: <45c6096e-c3e0-4058-8669-75fbba415e07@email.android.com>
Subject: Re: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.17.163, 10.4.195.30]
Thread-Topic: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Index: AQHVCfj1/ZS8SZ4p0ke1CH5gp1S1IPlIMumf
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 14 May 2019 07:15:40 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
> 
> 
> On May 13, 2019 4:01 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
> 
> 
> On 5/13/19 9:38 AM, Will Deacon wrote:
> > On Fri, May 10, 2019 at 07:26:54AM +0800, Yang Shi wrote:
> >> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> >> index 99740e1..469492d 100644
> >> --- a/mm/mmu_gather.c
> >> +++ b/mm/mmu_gather.c
> >> @@ -245,14 +245,39 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
> >>   {
> >>       /*
> >>        * If there are parallel threads are doing PTE changes on same range
> >> -     * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> >> -     * flush by batching, a thread has stable TLB entry can fail to flush
> >> -     * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> >> -     * forcefully if we detect parallel PTE batching threads.
> >> +     * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
> >> +     * flush by batching, one thread may end up seeing inconsistent PTEs
> >> +     * and result in having stale TLB entries.  So flush TLB forcefully
> >> +     * if we detect parallel PTE batching threads.
> >> +     *
> >> +     * However, some syscalls, e.g. munmap(), may free page tables, this
> >> +     * needs force flush everything in the given range. Otherwise this
> >> +     * may result in having stale TLB entries for some architectures,
> >> +     * e.g. aarch64, that could specify flush what level TLB.
> >>        */
> >> -    if (mm_tlb_flush_nested(tlb->mm)) {
> >> -            __tlb_reset_range(tlb);
> >> -            __tlb_adjust_range(tlb, start, end - start);
> >> +    if (mm_tlb_flush_nested(tlb->mm) && !tlb->fullmm) {
> >> +            /*
> >> +             * Since we can't tell what we actually should have
> >> +             * flushed, flush everything in the given range.
> >> +             */
> >> +            tlb->freed_tables = 1;
> >> +            tlb->cleared_ptes = 1;
> >> +            tlb->cleared_pmds = 1;
> >> +            tlb->cleared_puds = 1;
> >> +            tlb->cleared_p4ds = 1;
> >> +
> >> +            /*
> >> +             * Some architectures, e.g. ARM, that have range invalidation
> >> +             * and care about VM_EXEC for I-Cache invalidation, need
> >> force
> >> +             * vma_exec set.
> >> +             */
> >> +            tlb->vma_exec = 1;
> >> +
> >> +            /* Force vma_huge clear to guarantee safer flush */
> >> +            tlb->vma_huge = 0;
> >> +
> >> +            tlb->start = start;
> >> +            tlb->end = end;
> >>       }
> > Whilst I think this is correct, it would be interesting to see whether
> > or not it's actually faster than just nuking the whole mm, as I mentioned
> > before.
> >
> > At least in terms of getting a short-term fix, I'd prefer the diff below
> > if it's not measurably worse.
> 
> I did a quick test with ebizzy (96 threads with 5 iterations) on my x86
> VM, it shows slightly slowdown on records/s but much more sys time spent
> with fullmm flush, the below is the data.
> 
>                                      nofullmm                 fullmm
> ops (records/s)              225606                  225119
> sys (s)                            0.69                        1.14
> 
> It looks the slight reduction of records/s is caused by the increase of
> sys time.
> 
> >
> > Will
> >
> > --->8
> >
> > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > index 99740e1dd273..cc251422d307 100644
> > --- a/mm/mmu_gather.c
> > +++ b/mm/mmu_gather.c
> > @@ -251,8 +251,9 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
> >         * forcefully if we detect parallel PTE batching threads.
> >         */
> >        if (mm_tlb_flush_nested(tlb->mm)) {
> > +             tlb->fullmm = 1;
> >                __tlb_reset_range(tlb);
> > -             __tlb_adjust_range(tlb, start, end - start);
> > +             tlb->freed_tables = 1;
> >        }
> >
> >        tlb_flush_mmu(tlb);
> 
> 
> I think that this should have set need_flush_all and not fullmm.
> 

Wouldn't that skip the flush?

If fulmm == 0, then __tlb_reset_range() sets tlb->end = 0.
  tlb_flush_mmu
    tlb_flush_mmu_tlbonly
      if (!tlb->end)
         return

Replacing fullmm with need_flush_all, brings the problem back / reproducer hangs.
