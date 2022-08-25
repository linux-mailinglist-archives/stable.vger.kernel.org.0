Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A425A0615
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbiHYBim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiHYBiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:38:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845D29C517;
        Wed, 24 Aug 2022 18:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661391430; x=1692927430;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=FTVuUuJ4Lc3bgKKtX+XXFr3/nIW0Mm2/GA4OVkkE7hw=;
  b=cklqAYI5cKYZS/yq77KLD+6zAEYAeicBz7BOBoCK/tBONEQFjbxs+Iyf
   L9Z2JQO41ybeDbh8/zv1mUyDBa7/OBZhEg5pELVw9WiMSPd2/u7ZAJMc+
   F15K3+45VKNpOZy65unpiCzSZb/undfsJLMOMBVXYSZZP6qz/0dOJ2rdK
   CSBFUU76QK3Iz1FhW6CYFk/m+Jk1P0qh+Aaf5FloST8qRqLbih7fIzKll
   btEvAYsbWC4kjlUV4em/+NXIeWENuGNOFlL5JJLSsCq/jKEQoF91zn8q1
   g8ncxrat4hu9FWVGDTH69yeFmwCLxpXhZnQBxYGa3LOi+/sbKbkL182/q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="294119178"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="294119178"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 18:36:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="586663677"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 18:36:50 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
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
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/migrate_device.c: Flush TLB while holding PTL
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
Date:   Thu, 25 Aug 2022 09:36:39 +0800
In-Reply-To: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
        (Alistair Popple's message of "Wed, 24 Aug 2022 13:03:37 +1000")
Message-ID: <87sfll2jfc.fsf@yhuang6-desk2.ccr.corp.intel.com>
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

> When clearing a PTE the TLB should be flushed whilst still holding the
> PTL to avoid a potential race with madvise/munmap/etc. For example
> consider the following sequence:
>
>   CPU0                          CPU1
>   ----                          ----
>
>   migrate_vma_collect_pmd()
>   pte_unmap_unlock()
>                                 madvise(MADV_DONTNEED)
>                                 -> zap_pte_range()
>                                 pte_offset_map_lock()
>                                 [ PTE not present, TLB not flushed ]
>                                 pte_unmap_unlock()
>                                 [ page is still accessible via stale TLB ]
>   flush_tlb_range()
>
> In this case the page may still be accessed via the stale TLB entry
> after madvise returns. Fix this by flushing the TLB while holding the
> PTL.
>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reported-by: Nadav Amit <nadav.amit@gmail.com>
> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
> Cc: stable@vger.kernel.org
>
> ---
>
> Changes for v3:
>
>  - New for v3
> ---
>  mm/migrate_device.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 27fb37d..6a5ef9f 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -254,13 +254,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  		migrate->dst[migrate->npages] = 0;
>  		migrate->src[migrate->npages++] = mpfn;
>  	}
> -	arch_leave_lazy_mmu_mode();
> -	pte_unmap_unlock(ptep - 1, ptl);
>  
>  	/* Only flush the TLB if we actually modified any entries */
>  	if (unmapped)
>  		flush_tlb_range(walk->vma, start, end);

It appears that we can increase "unmapped" only if ptep_get_and_clear()
is used?

Best Regards,
Huang, Ying

> +	arch_leave_lazy_mmu_mode();
> +	pte_unmap_unlock(ptep - 1, ptl);
> +
>  	return 0;
>  }
>  
>
> base-commit: ffcf9c5700e49c0aee42dcba9a12ba21338e8136
