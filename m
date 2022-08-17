Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9A7596A26
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 09:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiHQHRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 03:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiHQHRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 03:17:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD42A6B8D6;
        Wed, 17 Aug 2022 00:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660720640; x=1692256640;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=ZS9/pnsjWMHpVVY5COIkT1/+PC3cjs3sNi1oR7AcMOA=;
  b=dF35UqcFT+sFhKuXL7fgalyd2F36E9Wdh2AaKxauKrEd3G3x++cCxiYS
   q/R/TtX71YOVNCCga3lRygICInyWcdcf58VBT1KakIaDCGCzEGj540byG
   2QhOfCbJVIsfRQl+q43GNAU6Wwv+NU1GVK28v9AawpEH9bZqiVCP1BSgI
   U9+iPfDpKO444ZgpVkzma/fAO17p59uiAIo46wyQhJEdxKsQVUB+SK7IS
   NBe5zasSb6+mK1vKC6O8F+y8urLh4sG4PBkbXUbN8L2Pll3Zhb/gzpI09
   D6Q2YXycDLzGrH6+3F2rUpNr337Ks9LONWajgIjz9Q1Y6cnxM6H7mlauo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="292421017"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="292421017"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 00:17:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="749605160"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 00:17:16 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Alistair Popple <apopple@nvidia.com>,
        Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Xu <peterx@redhat.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, <paulus@ozlabs.org>,
        <linuxppc-dev@lists.ozlabs.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
        <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
        <Yvv/eGfi3LW8WxPZ@xz-m1.local> <871qtfvdlw.fsf@nvdebian.thelocal>
        <YvxWUY9eafFJ27ef@xz-m1.local> <87o7wjtn2g.fsf@nvdebian.thelocal>
Date:   Wed, 17 Aug 2022 15:17:04 +0800
In-Reply-To: <87o7wjtn2g.fsf@nvdebian.thelocal> (Alistair Popple's message of
        "Wed, 17 Aug 2022 15:41:16 +1000")
Message-ID: <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alistair Popple <apopple@nvidia.com> writes:

> Peter Xu <peterx@redhat.com> writes:
>
>> On Wed, Aug 17, 2022 at 11:49:03AM +1000, Alistair Popple wrote:
>>>
>>> Peter Xu <peterx@redhat.com> writes:
>>>
>>> > On Tue, Aug 16, 2022 at 04:10:29PM +0800, huang ying wrote:
>>> >> > @@ -193,11 +194,10 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>> >> >                         bool anon_exclusive;
>>> >> >                         pte_t swp_pte;
>>> >> >
>>> >> > +                       flush_cache_page(vma, addr, pte_pfn(*ptep));
>>> >> > +                       pte = ptep_clear_flush(vma, addr, ptep);
>>> >>
>>> >> Although I think it's possible to batch the TLB flushing just before
>>> >> unlocking PTL.  The current code looks correct.
>>> >
>>> > If we're with unconditionally ptep_clear_flush(), does it mean we should
>>> > probably drop the "unmapped" and the last flush_tlb_range() already since
>>> > they'll be redundant?
>>>
>>> This patch does that, unless I missed something?
>>
>> Yes it does.  Somehow I didn't read into the real v2 patch, sorry!
>>
>>>
>>> > If that'll need to be dropped, it looks indeed better to still keep the
>>> > batch to me but just move it earlier (before unlock iiuc then it'll be
>>> > safe), then we can keep using ptep_get_and_clear() afaiu but keep "pte"
>>> > updated.
>>>
>>> I think we would also need to check should_defer_flush(). Looking at
>>> try_to_unmap_one() there is this comment:
>>>
>>> 			if (should_defer_flush(mm, flags) && !anon_exclusive) {
>>> 				/*
>>> 				 * We clear the PTE but do not flush so potentially
>>> 				 * a remote CPU could still be writing to the folio.
>>> 				 * If the entry was previously clean then the
>>> 				 * architecture must guarantee that a clear->dirty
>>> 				 * transition on a cached TLB entry is written through
>>> 				 * and traps if the PTE is unmapped.
>>> 				 */
>>>
>>> And as I understand it we'd need the same guarantee here. Given
>>> try_to_migrate_one() doesn't do batched TLB flushes either I'd rather
>>> keep the code as consistent as possible between
>>> migrate_vma_collect_pmd() and try_to_migrate_one(). I could look at
>>> introducing TLB flushing for both in some future patch series.
>>
>> should_defer_flush() is TTU-specific code?
>
> I'm not sure, but I think we need the same guarantee here as mentioned
> in the comment otherwise we wouldn't see a subsequent CPU write that
> could dirty the PTE after we have cleared it but before the TLB flush.
>
> My assumption was should_defer_flush() would ensure we have that
> guarantee from the architecture, but maybe there are alternate/better
> ways of enforcing that?
>> IIUC the caller sets TTU_BATCH_FLUSH showing that tlb can be omitted since
>> the caller will be responsible for doing it.  In migrate_vma_collect_pmd()
>> iiuc we don't need that hint because it'll be flushed within the same
>> function but just only after the loop of modifying the ptes.  Also it'll be
>> with the pgtable lock held.
>
> Right, but the pgtable lock doesn't protect against HW PTE changes such
> as setting the dirty bit so we need to ensure the HW does the right
> thing here and I don't know if all HW does.

This sounds sensible.  But I take a look at zap_pte_range(), and find
that it appears that the implementation requires the PTE dirty bit to be
write-through.  Do I miss something?

Hi, Nadav, Can you help?

Best Regards,
Huang, Ying

[snip]
