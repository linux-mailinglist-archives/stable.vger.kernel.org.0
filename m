Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC65E234C
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 21:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403882AbfJWT2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 15:28:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46414 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732759AbfJWT2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 15:28:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id e15so12692999pgu.13
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 12:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=QJMKuPm1ZdNgJTUIJxAw1L1Yjlm4cw9iye5XkWCnBqw=;
        b=chLu7Rkn1anFUB5doiAWbIOsB5CoPrd/wBLbr21Y99KS80dzYjM8j9Ek9g+rYsL5qp
         6qcFXB0lTKb/2AmjhlXeYkKttXT1kZQcKR7P/nHYw76Onm0ATebaDOneFAYlCZG4qSb3
         z3FY2cfGszWRTwj+LMkwicC0G1XMlwL0q2WIkvhUqY7ZX2UWjwK/MfMMy5+EsC3zy9id
         QUvUxedi+MKaZqfMQsJPVr0H90BvN/z2Gmv8poKMx9O3vPADoxNiE8k7oxaYiALWkbxx
         yUEVaxfOo/SNgB/ttmt7RKICNf7OqeYqpTIVsI2DqJbhgW3a2D/vx1/LetB76c55dgkB
         3x4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=QJMKuPm1ZdNgJTUIJxAw1L1Yjlm4cw9iye5XkWCnBqw=;
        b=Fl7Ezl/tSibyBzPFbG+XtEufL7o6rVanIQIyLKx9AGUkGM1J9OpoL9i/RdDQqLtnCH
         GGBk41GAr5dGchgVDppXYiadd+4i0a0G0ZDwMkrdCtaFi4LioGqakIkirldT/ij2Nmm1
         9m1/d0wymEw1GBDT9+FjS4oV0JCasqMQMh2vUMOAHRowyxhzcDbmvUcTNpQ4CGKHY4/N
         Yxrt4rJ8N0MhwRNZMLZ3kkn+MHbq+2s5HnN+ZRB4MokoZnJEeuwBtBxDql5o9mGZtWeG
         Bn8bypcP5GyscVM04GhS7fh62OMwkozcMh6Xbq6uiljcjKELY9a2hqNdHuNuAC4q96TG
         dWWw==
X-Gm-Message-State: APjAAAUfg39Xx0Lst3We05XJNWwKPdCQB8zSyYZiIH4uqwAQAOy03/fq
        BMZJJCWus47KCCnuXrESjgBazg==
X-Google-Smtp-Source: APXvYqy4xhI6y0ND4tiBbrpIZjsepQLlOS6my2AixHG/oB4Scrljr+5IA3zv9Qh4hYChNSBHuA2yRg==
X-Received: by 2002:a65:6456:: with SMTP id s22mr11083996pgv.287.1571858918213;
        Wed, 23 Oct 2019 12:28:38 -0700 (PDT)
Received: from [100.112.92.218] ([104.133.9.106])
        by smtp.gmail.com with ESMTPSA id dw19sm58444pjb.27.2019.10.23.12.28.37
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 12:28:37 -0700 (PDT)
Date:   Wed, 23 Oct 2019 12:28:36 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Yang Shi <yang.shi@linux.alibaba.com>
cc:     hughd@google.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, gavin.dg@linux.alibaba.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
In-Reply-To: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com>
Message-ID: <alpine.LSU.2.11.1910231157570.1088@eggly.anvils>
References: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 24 Oct 2019, Yang Shi wrote:

> We have usecase to use tmpfs as QEMU memory backend and we would like to
> take the advantage of THP as well.  But, our test shows the EPT is not
> PMD mapped even though the underlying THP are PMD mapped on host.
> The number showed by /sys/kernel/debug/kvm/largepage is much less than
> the number of PMD mapped shmem pages as the below:
> 
> 7f2778200000-7f2878200000 rw-s 00000000 00:14 262232 /dev/shm/qemu_back_mem.mem.Hz2hSf (deleted)
> Size:            4194304 kB
> [snip]
> AnonHugePages:         0 kB
> ShmemPmdMapped:   579584 kB
> [snip]
> Locked:                0 kB
> 
> cat /sys/kernel/debug/kvm/largepages
> 12
> 
> And some benchmarks do worse than with anonymous THPs.
> 
> By digging into the code we figured out that commit 127393fbe597 ("mm:
> thp: kvm: fix memory corruption in KVM with THP enabled") checks if
> there is a single PTE mapping on the page for anonymous THP when
> setting up EPT map.  But, the _mapcount < 0 check doesn't fit to page
> cache THP since every subpage of page cache THP would get _mapcount
> inc'ed once it is PMD mapped, so PageTransCompoundMap() always returns
> false for page cache THP.  This would prevent KVM from setting up PMD
> mapped EPT entry.
> 
> So we need handle page cache THP correctly.  However, when page cache
> THP's PMD gets split, kernel just remove the map instead of setting up
> PTE map like what anonymous THP does.  Before KVM calls get_user_pages()
> the subpages may get PTE mapped even though it is still a THP since the
> page cache THP may be mapped by other processes at the mean time.
> 
> Checking its _mapcount and whether the THP has PTE mapped or not.
> Although this may report some false negative cases (PTE mapped by other
> processes), it looks not trivial to make this accurate.
> 
> With this fix /sys/kernel/debug/kvm/largepage would show reasonable
> pages are PMD mapped by EPT as the below:
> 
> 7fbeaee00000-7fbfaee00000 rw-s 00000000 00:14 275464 /dev/shm/qemu_back_mem.mem.SKUvat (deleted)
> Size:            4194304 kB
> [snip]
> AnonHugePages:         0 kB
> ShmemPmdMapped:   557056 kB
> [snip]
> Locked:                0 kB
> 
> cat /sys/kernel/debug/kvm/largepages
> 271
> 
> And the benchmarks are as same as anonymous THPs.
> 

Fixes: dd78fedde4b9 ("rmap: support file thp")

> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> Reported-by: Gang Deng <gavin.dg@linux.alibaba.com>
> Tested-by: Gang Deng <gavin.dg@linux.alibaba.com>
> Suggested-by: Hugh Dickins <hughd@google.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: <stable@vger.kernel.org> 4.8+
> ---
> v2: Adopted the suggestion from Hugh to use _mapcount and compound_mapcount.
>     But I just open coding compound_mapcount to avoid duplicating the
>     definition of compound_mapcount_ptr in two different files.  Since
>     "compound_mapcount" looks self-explained so I'm supposed the open
>     coding would not affect the readability.

No, relying on head[1] is not nice: Matthew's suggestion better.

> 
>  include/linux/page-flags.h | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index f91cb88..954a877 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -622,12 +622,30 @@ static inline int PageTransCompound(struct page *page)
>   *
>   * Unlike PageTransCompound, this is safe to be called only while
>   * split_huge_pmd() cannot run from under us, like if protected by the
> - * MMU notifier, otherwise it may result in page->_mapcount < 0 false
> + * MMU notifier, otherwise it may result in page->_mapcount check false
>   * positives.
> + *
> + * We have to treat page cache THP differently since every subpage of it
> + * would get _mapcount inc'ed once it is PMD mapped.  But, it may be PTE
> + * mapped in the current process so comparing subpage's _mapcount to
> + * compound_mapcount ot filter out PTE mapped case.

s/ ot / to /

>   */
>  static inline int PageTransCompoundMap(struct page *page)
>  {
> -	return PageTransCompound(page) && atomic_read(&page->_mapcount) < 0;
> +	struct page *head;
> +	int map_count;
> +
> +	if (!PageTransCompound(page))
> +		return 0;
> +
> +	if (PageAnon(page))
> +		return atomic_read(&page->_mapcount) < 0;
> +
> +	head = compound_head(page);
> +	map_count = atomic_read(&page->_mapcount);
> +	/* File THP is PMD mapped and not double mapped */

s/ double / PTE /

> +	return map_count >= 0 &&

You have added a map_count >= 0 test there. Okay, not wrong, but not
necessary, and not consistent with what's returned in the PageAnon
case (if this were called for an unmapped page).

But asking for consistency in this function is asking for too much.
It is *very* specialized to the particular places from which it is
called (doesn't really belong in page-flags.h at all), and just so
long as it gives them the right answer most of the time, and errs
on the safe side the rest of the time, it'll do.

(I don't know if it's ever called on a tail page: it would not crash
if it were, but different tail pages may give different answers.)

> +	       map_count == atomic_read(&head[1].compound_mapcount);
>  }
>  
>  /*
> -- 
> 1.8.3.1
> 
> 
