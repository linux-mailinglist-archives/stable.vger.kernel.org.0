Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C90597EB2
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 08:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243362AbiHRGey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 02:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiHRGey (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 02:34:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF1D4BD23;
        Wed, 17 Aug 2022 23:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660804493; x=1692340493;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version:content-transfer-encoding;
  bh=+do2uA89fmz0CDWVL3JlfrwCb7Glq9Xqu12lfvGSbEI=;
  b=E2JpuFH0NyTb24nDfISeq8f4j+T9xq2+gzNDP6wBMn8ABcjJLjXhWjHf
   buCd6nXjF428W3zfQobab/2T5XBukYByRrOrWK5QI76UTc6ZoX1U+ud+9
   R8k+y+iZA3EVLpAQuyfneyLfGAMhVGu6+FQVT/oZb2p9uRrMkWMAg/nQs
   RylP6/wJWz2muDNU4wsTye6UNzwrbrjmLGfuOqxEWPLOkEZoiD4aYp0qn
   1HSmuFqdsnJfhfIjHRvAFikfQcMShEfijF5QGM3uUE+mqnHdbc8D1aMA5
   k/wZTTOhQ20eKvY+apEIVkEOQFWAA0x/KWxrVdEUMUhaSfUGGNfVy4rrk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="290245533"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="290245533"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 23:34:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="935680965"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 23:34:48 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Alistair Popple <apopple@nvidia.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
        <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
        <Yvv/eGfi3LW8WxPZ@xz-m1.local> <871qtfvdlw.fsf@nvdebian.thelocal>
        <YvxWUY9eafFJ27ef@xz-m1.local> <87o7wjtn2g.fsf@nvdebian.thelocal>
        <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
        <Yv1BJKb5he3dOHdC@xz-m1.local>
Date:   Thu, 18 Aug 2022 14:34:45 +0800
In-Reply-To: <Yv1BJKb5he3dOHdC@xz-m1.local> (Peter Xu's message of "Wed, 17
        Aug 2022 15:27:32 -0400")
Message-ID: <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> On Wed, Aug 17, 2022 at 02:41:19AM -0700, Nadav Amit wrote:
>> 4. Having multiple TLB flushing infrastructures makes all of these
>> discussions very complicated and unmaintainable. I need to convince myse=
lf
>> in every occasion (including this one) whether calls to
>> flush_tlb_batched_pending() and tlb_flush_pending() are needed or not.
>>=20
>> What I would like to have [3] is a single infrastructure that gets a
>> =E2=80=9Cticket=E2=80=9D (generation when the batching started), the old=
 PTE and the new PTE
>> and checks whether a TLB flush is needed based on the arch behavior and =
the
>> current TLB generation. If needed, it would update the =E2=80=9Cticket=
=E2=80=9D to the new
>> generation. Andy wanted a ring for pending TLB flushes, but I think it i=
s an
>> overkill with more overhead and complexity than needed.
>>=20
>> But the current situation in which every TLB flush is a basis for long
>> discussions and prone to bugs is impossible.
>>=20
>> I hope it helps. Let me know if you want me to revive the patch-set or o=
ther
>> feedback.
>>=20
>> [1] https://lore.kernel.org/all/20220711034615.482895-5-21cnbao@gmail.co=
m/
>> [2] https://lore.kernel.org/all/20220718120212.3180-13-namit@vmware.com/
>> [3] https://lore.kernel.org/all/20210131001132.3368247-16-namit@vmware.c=
om/
>
> I need more reading on tlb code and also [3] which looks useful to me.
> It's definitely sad to make tlb flushing so complicated.  It'll be great =
if
> things can be sorted out someday.
>
> In this specific case, the only way to do safe tlb batching in my mind is:
>
> 	pte_offset_map_lock();
> 	arch_enter_lazy_mmu_mode();
>         // If any pending tlb, do it now
>         if (mm_tlb_flush_pending())
> 		flush_tlb_range(vma, start, end);
>         else
>                 flush_tlb_batched_pending();

I don't think we need the above 4 lines.  Because we will flush TLB
before we access the pages.  Can you find any issue if we don't use the
above 4 lines?

Best Regards,
Huang, Ying

>         loop {
>                 ...
>                 pte =3D ptep_get_and_clear();
>                 ...
>                 if (pte_present())
>                         unmapped++;
>                 ...
>         }
> 	if (unmapped)
> 		flush_tlb_range(walk->vma, start, end);
> 	arch_leave_lazy_mmu_mode();
> 	pte_unmap_unlock();
>
> I may miss something, but even if not it already doesn't look pretty.
>
> Thanks,
