Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96048599331
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 04:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344185AbiHSCvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 22:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344394AbiHSCvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 22:51:36 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F434CCE08;
        Thu, 18 Aug 2022 19:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660877495; x=1692413495;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=4EIcg7RWk2yRi+CSvUOFGKBdAdmQg2lkeFcyyl4c1Jg=;
  b=MAQm/qzGZtALfQNlgWU4xhzpIPSCxEXsgws/OH7C6edZHdhPXSVo3UkL
   eaftOK38EVbj47t9BOOJbkZMnpqnpkswckM1iUs9BqgRcU/O3vBlPc2Xj
   nbjrsqpBRae9qddYqLO26yfh7GsUw2qM4vmVXlY6n1aro/IE936El9PYA
   mNc9jlz5OjbbUQ59SBO/zMKN7rABbtf+79FcCMwioDMNflaeAR00yjJpq
   y5FMDdkc9dQt9EX55Hr6TWHcFpXLzybpJdjkl+w36c0nRu78ySSt6BR5W
   OnhEv9VgwuaoIZmzXjkBxaJh/Fv5jX+NgznhBEETOg/W0ClCOpSuCsu04
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275964302"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="275964302"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 19:51:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="936054349"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 19:51:29 -0700
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
        <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <Yv5QXkS4Bm9pTBeG@xz-m1.local>
Date:   Fri, 19 Aug 2022 10:51:27 +0800
In-Reply-To: <Yv5QXkS4Bm9pTBeG@xz-m1.local> (Peter Xu's message of "Thu, 18
        Aug 2022 10:44:46 -0400")
Message-ID: <874jy9aqts.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> On Thu, Aug 18, 2022 at 02:34:45PM +0800, Huang, Ying wrote:
>> > In this specific case, the only way to do safe tlb batching in my mind is:
>> >
>> > 	pte_offset_map_lock();
>> > 	arch_enter_lazy_mmu_mode();
>> >         // If any pending tlb, do it now
>> >         if (mm_tlb_flush_pending())
>> > 		flush_tlb_range(vma, start, end);
>> >         else
>> >                 flush_tlb_batched_pending();
>> 
>> I don't think we need the above 4 lines.  Because we will flush TLB
>> before we access the pages.
>
> Could you elaborate?

As you have said below, we don't use non-present PTEs and flush present
PTEs before we access the pages.

>> Can you find any issue if we don't use the above 4 lines?
>
> It seems okay to me to leave stall tlb at least within the scope of this
> function. It only collects present ptes and flush propoerly for them.  I
> don't quickly see any other implications to other not touched ptes - unlike
> e.g. mprotect(), there's a strong barrier of not allowing further write
> after mprotect() returns.

Yes.  I think so too.

> Still I don't know whether there'll be any side effect of having stall tlbs
> in !present ptes because I'm not familiar enough with the private dev swap
> migration code.  But I think having them will be safe, even if redundant.

I don't think it's a good idea to be redundant.  That may hide the real
issue.

Best Regards,
Huang, Ying
