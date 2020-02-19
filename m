Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995F4165258
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 23:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgBSWSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 17:18:47 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33753 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgBSWSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 17:18:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582150725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t4dWbfDiBHwImdpUMRDqWIfPY/KNi0AOQIAKQaELdH8=;
        b=Ymr0AEEZ1X+DDQ/4cnmivJ33hly/nzodyPMVCiSFFrbiMxMgzta0nQ7gIr8nAOjKQAxbja
        ItUIa5277CJtz16gDR7DBiji1eFqnF8aac2ymYrFuiJ4vkcvy21BkgzsVajB1gj62sQGat
        0wnEmivIJRlOms7iq6WtELEQhU4lP/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-5djg45DCOe6lE25lXFkYEQ-1; Wed, 19 Feb 2020 17:18:35 -0500
X-MC-Unique: 5djg45DCOe6lE25lXFkYEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86E3C8017DF;
        Wed, 19 Feb 2020 22:18:33 +0000 (UTC)
Received: from t490s (ovpn-116-51.phx2.redhat.com [10.3.116.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4867C60BE2;
        Wed, 19 Feb 2020 22:18:32 +0000 (UTC)
Date:   Wed, 19 Feb 2020 17:18:30 -0500
From:   Rafael Aquini <aquini@redhat.com>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        mhocko@suse.com, kirill.shutemov@linux.intel.com,
        mgorman@techsingularity.net
Subject: Re: +
 mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa.patch
 added to -mm tree
Message-ID: <20200219221830.GB2660@t490s>
References: <20200219215735.D5dq8%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219215735.D5dq8%akpm@linux-foundation.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 19, 2020 at 01:57:35PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm, numa: fix bad pmd by atomically check for pmd_trans_huge when marking page tables prot_numa
> has been added to the -mm tree.  Its filename is
>      mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Mel Gorman <mgorman@techsingularity.net>
> Subject: mm, numa: fix bad pmd by atomically check for pmd_trans_huge when marking page tables prot_numa
> 
> : A user reported a bug against a distribution kernel while running a
> : proprietary workload described as "memory intensive that is not swapping"
> : that is expected to apply to mainline kernels.  The workload is
> : read/write/modifying ranges of memory and checking the contents.  They
> : reported that within a few hours that a bad PMD would be reported followed
> : by a memory corruption where expected data was all zeros.  A partial
> : report of the bad PMD looked like
> : 
> :   [ 5195.338482] ../mm/pgtable-generic.c:33: bad pmd ffff8888157ba008(000002e0396009e2)
> :   [ 5195.341184] ------------[ cut here ]------------
> :   [ 5195.356880] kernel BUG at ../mm/pgtable-generic.c:35!
> :   ....
> :   [ 5195.410033] Call Trace:
> :   [ 5195.410471]  [<ffffffff811bc75d>] change_protection_range+0x7dd/0x930
> :   [ 5195.410716]  [<ffffffff811d4be8>] change_prot_numa+0x18/0x30
> :   [ 5195.410918]  [<ffffffff810adefe>] task_numa_work+0x1fe/0x310
> :   [ 5195.411200]  [<ffffffff81098322>] task_work_run+0x72/0x90
> :   [ 5195.411246]  [<ffffffff81077139>] exit_to_usermode_loop+0x91/0xc2
> :   [ 5195.411494]  [<ffffffff81003a51>] prepare_exit_to_usermode+0x31/0x40
> :   [ 5195.411739]  [<ffffffff815e56af>] retint_user+0x8/0x10
> : 
> : Decoding revealed that the PMD was a valid prot_numa PMD and the bad PMD
> : was a false detection.  The bug does not trigger if automatic NUMA
> : balancing or transparent huge pages is disabled.
> : 
> : The bug is due a race in change_pmd_range between a pmd_trans_huge and
> : pmd_nond_or_clear_bad check without any locks held.  During the
> : pmd_trans_huge check, a parallel protection update under lock can have
> : cleared the PMD and filled it with a prot_numa entry between the transhuge
> : check and the pmd_none_or_clear_bad check.
> : 
> : While this could be fixed with heavy locking, it's only necessary to make
> : a copy of the PMD on the stack during change_pmd_range and avoid races.  A
> : new helper is created for this as the check if quite subtle and the
> : existing similar helpful is not suitable.  This passed 154 hours of
> : testing (usually triggers between 20 minutes and 24 hours) without
> : detecting bad PMDs or corruption.  A basic test of an autonuma-intensive
> : workload showed no significant change in behaviour.
> 
> Although Mel withdrew the patch on the face of LKML comment
> https://lkml.org/lkml/2017/4/10/922 the race window aforementioned is
> still open, and we have reports of Linpack test reporting bad residuals
> after the bad PMD warning is observed.  In addition to that, bad
> rss-counter and non-zero pgtables assertions are triggered on mm teardown
> for the task hitting the bad PMD.
> 
>  host kernel: mm/pgtable-generic.c:40: bad pmd 00000000b3152f68(8000000d2d2008e7)
>  ....
>  host kernel: BUG: Bad rss-counter state mm:00000000b583043d idx:1 val:512
>  host kernel: BUG: non-zero pgtables_bytes on freeing mm: 4096
> 
> The issue is observed on a v4.18-based distribution kernel, but the race
> window is expected to be applicable to mainline kernels, as well.
> 
> Link: http://lkml.kernel.org/r/20200216191800.22423-1-aquini@redhat.com
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/mprotect.c |   38 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> --- a/mm/mprotect.c~mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa
> +++ a/mm/mprotect.c
> @@ -161,6 +161,31 @@ static unsigned long change_pte_range(st
>  	return pages;
>  }
>  
> +/*
> + * Used when setting automatic NUMA hinting protection where it is
> + * critical that a numa hinting PMD is not confused with a bad PMD.
> + */
> +static inline int pmd_none_or_clear_bad_unless_trans_huge(pmd_t *pmd)
> +{
> +	pmd_t pmdval = pmd_read_atomic(pmd);
> +
> +	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	barrier();
> +#endif
> +
> +	if (pmd_none(pmdval))
> +		return 1;
> +	if (pmd_trans_huge(pmdval))
> +		return 0;
> +	if (unlikely(pmd_bad(pmdval))) {
> +		pmd_clear_bad(pmd);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
>  		pud_t *pud, unsigned long addr, unsigned long end,
>  		pgprot_t newprot, int dirty_accountable, int prot_numa)
> @@ -178,8 +203,17 @@ static inline unsigned long change_pmd_r
>  		unsigned long this_pages;
>  
>  		next = pmd_addr_end(addr, end);
> -		if (!is_swap_pmd(*pmd) && !pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)
> -				&& pmd_none_or_clear_bad(pmd))
> +
> +		/*
> +		 * Automatic NUMA balancing walks the tables with mmap_sem
> +		 * held for read. It's possible a parallel update to occur
> +		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
> +		 * check leading to a false positive and clearing.
> +		 * Hence, it's ecessary to atomically read the PMD value
                               ^^^^^^^^
Andrew, 

Sorry I only noticed now, but there's a minor typo in he comment above.
It should read "necessary" instead.

Do you need me reposting?

-- Rafael

> +		 * for all the checks.
> +		 */
> +		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
> +		     pmd_none_or_clear_bad_unless_trans_huge(pmd))
>  			goto next;
>  
>  		/* invoke the mmu notifier if the pmd is populated */
> _
> 
> Patches currently in -mm which might be from mgorman@techsingularity.net are
> 
> mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa.patch
> 

