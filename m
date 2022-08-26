Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042CD5A1DDA
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbiHZA4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 20:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbiHZA4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 20:56:12 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F75C8768;
        Thu, 25 Aug 2022 17:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661475371; x=1693011371;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=eHgZdT1se+5eBqgsr/sRIR9P3jAvQggbXOvU+BKI2EI=;
  b=bV43J7Na/P50nLPBvD711JQ80RbXhH9cx89dd9t9CnZO04m+sD7SjSds
   LvtAHOnp4ZsAhfaflMYmp1fjXZIDxDxUZqfHzs8qqRAi2ec/+M4+aY/C9
   pjanN9u/fHAay3FrxuhrVNR1TXKTZ1ItjUTvBFMpeh2NDFjsF8HC6tVNr
   B1oIQbFh9b1QC3q81AKZOwIqmJYqgrG8H3CyciGXWLIi7tG8bf9iXkYa0
   iv3U3ijg1eI1lFpAjh6sQCEya5FQ0kvmD8HuPU04rBoapKW1baC5aDF+c
   T9YoAuAgAVMJw37aqRt7CZoJGR1xPKI/Q3o6/8FevUb25vZAH2nlU2Bo7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="291973428"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="291973428"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 17:56:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="587107455"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 17:56:06 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
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
        Logan Gunthorpe <logang@deltatee.com>, <paulus@ozlabs.org>,
        <linuxppc-dev@lists.ozlabs.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] mm/migrate_device.c: Flush TLB while holding PTL
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
        <87sfll2jfc.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <87y1vcdjzs.fsf@nvdebian.thelocal>
Date:   Fri, 26 Aug 2022 08:56:04 +0800
In-Reply-To: <87y1vcdjzs.fsf@nvdebian.thelocal> (Alistair Popple's message of
        "Fri, 26 Aug 2022 08:35:17 +1000")
Message-ID: <87fshj3jrv.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alistair Popple <apopple@nvidia.com> writes:

> "Huang, Ying" <ying.huang@intel.com> writes:
>
>> Alistair Popple <apopple@nvidia.com> writes:
>>
>>> When clearing a PTE the TLB should be flushed whilst still holding the
>>> PTL to avoid a potential race with madvise/munmap/etc. For example
>>> consider the following sequence:
>>>
>>>   CPU0                          CPU1
>>>   ----                          ----
>>>
>>>   migrate_vma_collect_pmd()
>>>   pte_unmap_unlock()
>>>                                 madvise(MADV_DONTNEED)
>>>                                 -> zap_pte_range()
>>>                                 pte_offset_map_lock()
>>>                                 [ PTE not present, TLB not flushed ]
>>>                                 pte_unmap_unlock()
>>>                                 [ page is still accessible via stale TLB ]
>>>   flush_tlb_range()
>>>
>>> In this case the page may still be accessed via the stale TLB entry
>>> after madvise returns. Fix this by flushing the TLB while holding the
>>> PTL.
>>>
>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>> Reported-by: Nadav Amit <nadav.amit@gmail.com>
>>> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
>>> Cc: stable@vger.kernel.org
>>>
>>> ---
>>>
>>> Changes for v3:
>>>
>>>  - New for v3
>>> ---
>>>  mm/migrate_device.c | 5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 27fb37d..6a5ef9f 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -254,13 +254,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>  		migrate->dst[migrate->npages] = 0;
>>>  		migrate->src[migrate->npages++] = mpfn;
>>>  	}
>>> -	arch_leave_lazy_mmu_mode();
>>> -	pte_unmap_unlock(ptep - 1, ptl);
>>>
>>>  	/* Only flush the TLB if we actually modified any entries */
>>>  	if (unmapped)
>>>  		flush_tlb_range(walk->vma, start, end);
>>
>> It appears that we can increase "unmapped" only if ptep_get_and_clear()
>> is used?
>
> In other words you mean we only need to increase unmapped if pte_present
> && !anon_exclusive?
>
> Agree, that's a good optimisation to make. However I'm just trying to
> solve a data corruption issue (not dirtying the page) here, so will post
> that as a separate optimisation patch. Thanks.

OK.  Then the patch looks good to me.  Feel free to add my,

Reviewed-by: "Huang, Ying" <ying.huang@intel.com>

Best Regards,
Huang, Ying

>>
>>> +	arch_leave_lazy_mmu_mode();
>>> +	pte_unmap_unlock(ptep - 1, ptl);
>>> +
>>>  	return 0;
>>>  }
>>>
>>>
>>> base-commit: ffcf9c5700e49c0aee42dcba9a12ba21338e8136
