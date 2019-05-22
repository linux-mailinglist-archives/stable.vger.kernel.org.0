Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0680271DB
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 23:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbfEVVq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 17:46:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42028 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729691AbfEVVq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 17:46:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id l2so3925476wrb.9
        for <stable@vger.kernel.org>; Wed, 22 May 2019 14:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=szp/NDLHvT5khWnvD71x9gs8fOYkBkeSAPN0W6cYkS4=;
        b=h4yeevFd6T5VdEAhg8P9uUBw56m77Ev03ukgYbaLE5hMBM0yi/RnNZMqPe3Pug9zDK
         9Qx+0LUi/ssxugwoLaNXT10zdmgRGODMUTSccGje07PyKNzyJpFWqBdyfZ0b22Ir52Yw
         ETuzgdMa/TL+KqbVnylCBpy+h5k4oDU4jdzE4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=szp/NDLHvT5khWnvD71x9gs8fOYkBkeSAPN0W6cYkS4=;
        b=CtNmdOt740vSJJ5JbwmCZA2lJDuvnKfbMXlYH+FvvwWfwe7Pgv45idEIGA+jv+IBf2
         i1uT+OUL7O1FRKKF8iAMi+AJkCjfnAk+KNpeTLQ5vrAESpj3B+lDbm4kcFCL2PksAgHR
         CZffNz9nlJEhzTNqeeIF5kXQEFndtnMh3ZHh9dS6dZ497ZDKG61dwM9TTLNaoop1MaBy
         wMDIhjvKqBo4UnrxogWyMu13QGGzZkXjOAf0YJsA9MtFUyVGmDd92ae0YbFI8zJHFA7z
         QYpxhFKWuZjeJXr/yHDaXEJ7wQD0JQhRdvDG8WjESl7FDvbWnIt60/NAykmegB6HDcf4
         /nhA==
X-Gm-Message-State: APjAAAUiaEDcw7+Qt4yzFBIzqtaxk+Di5PhPS4cMZT4DdNE+k8ykVgJp
        zAb4qUQeyk9g1uq1cZgDLVEjdiphKjz/1TvdQYOyxw+HceASQw==
X-Google-Smtp-Source: APXvYqxzRm2wyhdezcc9JFKObS3Kzo0UeG3AqyD1XldOofN4SRRPX5vUrnQ/8LASZ24EHqxHlDmsLzubW9MTGB9hVRA=
X-Received: by 2002:adf:e352:: with SMTP id n18mr33543wrj.82.1558561587493;
 Wed, 22 May 2019 14:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190520115245.439864225@linuxfoundation.org> <20190520115253.074303494@linuxfoundation.org>
In-Reply-To: <20190520115253.074303494@linuxfoundation.org>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 22 May 2019 16:46:16 -0500
Message-ID: <CAFxkdArho59CHxZi9K6oOm2NTDp0DL2XNv1TERfbJKqkXAiNVA@mail.gmail.com>
Subject: Re: [PATCH 5.0 119/123] s390/mm: convert to the generic
 get_user_pages_fast code
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 7:30 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> commit 1a42010cdc26bb7e5912984f3c91b8c6d55f089a upstream.
>
> Define the gup_fast_permitted to check against the asce_limit of the
> mm attached to the current task, then replace the s390 specific gup
> code with the generic implementation in mm/gup.c.
>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

While this code seems to work fine upstream, when backported to 5.0 it
fails to build:

BUILDSTDERR: In file included from ./include/linux/mm.h:98,
BUILDSTDERR:                  from mm/gup.c:6:
BUILDSTDERR: mm/gup.c: In function '__get_user_pages_fast':
BUILDSTDERR: ./arch/s390/include/asm/pgtable.h:1277:28: error: too
many arguments to function 'gup_fast_permitted'
BUILDSTDERR:  #define gup_fast_permitted gup_fast_permitted
BUILDSTDERR:                             ^~~~~~~~~~~~~~~~~~
BUILDSTDERR: mm/gup.c:1856:6: note: in expansion of macro 'gup_fast_permitted'
BUILDSTDERR:   if (gup_fast_permitted(start, nr_pages, write)) {

It is missing upstream commit ad8cfb9c42ef83ecf4079bc7d77e6557648e952b
mm/gup: Remove the 'write' parameter from gup_fast_permitted()

Justin
>
> ---
>  arch/s390/Kconfig               |    1
>  arch/s390/include/asm/pgtable.h |   12 +
>  arch/s390/mm/Makefile           |    2
>  arch/s390/mm/gup.c              |  291 ----------------------------------------
>  4 files changed, 14 insertions(+), 292 deletions(-)
>
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -148,6 +148,7 @@ config S390
>         select HAVE_FUNCTION_TRACER
>         select HAVE_FUTEX_CMPXCHG if FUTEX
>         select HAVE_GCC_PLUGINS
> +       select HAVE_GENERIC_GUP
>         select HAVE_KERNEL_BZIP2
>         select HAVE_KERNEL_GZIP
>         select HAVE_KERNEL_LZ4
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1264,6 +1264,18 @@ static inline pte_t *pte_offset(pmd_t *p
>  #define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
>  #define pte_unmap(pte) do { } while (0)
>
> +static inline bool gup_fast_permitted(unsigned long start, int nr_pages)
> +{
> +       unsigned long len, end;
> +
> +       len = (unsigned long) nr_pages << PAGE_SHIFT;
> +       end = start + len;
> +       if (end < start)
> +               return false;
> +       return end <= current->mm->context.asce_limit;
> +}
> +#define gup_fast_permitted gup_fast_permitted
> +
>  #define pfn_pte(pfn,pgprot) mk_pte_phys(__pa((pfn) << PAGE_SHIFT),(pgprot))
>  #define pte_pfn(x) (pte_val(x) >> PAGE_SHIFT)
>  #define pte_page(x) pfn_to_page(pte_pfn(x))
> --- a/arch/s390/mm/Makefile
> +++ b/arch/s390/mm/Makefile
> @@ -4,7 +4,7 @@
>  #
>
>  obj-y          := init.o fault.o extmem.o mmap.o vmem.o maccess.o
> -obj-y          += page-states.o gup.o pageattr.o pgtable.o pgalloc.o
> +obj-y          += page-states.o pageattr.o pgtable.o pgalloc.o
>
>  obj-$(CONFIG_CMM)              += cmm.o
>  obj-$(CONFIG_HUGETLB_PAGE)     += hugetlbpage.o
> --- a/arch/s390/mm/gup.c
> +++ /dev/null
> @@ -1,291 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - *  Lockless get_user_pages_fast for s390
> - *
> - *  Copyright IBM Corp. 2010
> - *  Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
> - */
> -#include <linux/sched.h>
> -#include <linux/mm.h>
> -#include <linux/hugetlb.h>
> -#include <linux/vmstat.h>
> -#include <linux/pagemap.h>
> -#include <linux/rwsem.h>
> -#include <asm/pgtable.h>
> -
> -/*
> - * The performance critical leaf functions are made noinline otherwise gcc
> - * inlines everything into a single function which results in too much
> - * register pressure.
> - */
> -static inline int gup_pte_range(pmd_t pmd, unsigned long addr,
> -               unsigned long end, int write, struct page **pages, int *nr)
> -{
> -       struct page *head, *page;
> -       unsigned long mask;
> -       pte_t *ptep, pte;
> -
> -       mask = (write ? _PAGE_PROTECT : 0) | _PAGE_INVALID | _PAGE_SPECIAL;
> -
> -       ptep = pte_offset_map(&pmd, addr);
> -       do {
> -               pte = *ptep;
> -               barrier();
> -               /* Similar to the PMD case, NUMA hinting must take slow path */
> -               if (pte_protnone(pte))
> -                       return 0;
> -               if ((pte_val(pte) & mask) != 0)
> -                       return 0;
> -               VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
> -               page = pte_page(pte);
> -               head = compound_head(page);
> -               if (!page_cache_get_speculative(head))
> -                       return 0;
> -               if (unlikely(pte_val(pte) != pte_val(*ptep))) {
> -                       put_page(head);
> -                       return 0;
> -               }
> -               VM_BUG_ON_PAGE(compound_head(page) != head, page);
> -               pages[*nr] = page;
> -               (*nr)++;
> -
> -       } while (ptep++, addr += PAGE_SIZE, addr != end);
> -
> -       return 1;
> -}
> -
> -static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
> -               unsigned long end, int write, struct page **pages, int *nr)
> -{
> -       struct page *head, *page;
> -       unsigned long mask;
> -       int refs;
> -
> -       mask = (write ? _SEGMENT_ENTRY_PROTECT : 0) | _SEGMENT_ENTRY_INVALID;
> -       if ((pmd_val(pmd) & mask) != 0)
> -               return 0;
> -       VM_BUG_ON(!pfn_valid(pmd_val(pmd) >> PAGE_SHIFT));
> -
> -       refs = 0;
> -       head = pmd_page(pmd);
> -       page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
> -       do {
> -               VM_BUG_ON(compound_head(page) != head);
> -               pages[*nr] = page;
> -               (*nr)++;
> -               page++;
> -               refs++;
> -       } while (addr += PAGE_SIZE, addr != end);
> -
> -       if (!page_cache_add_speculative(head, refs)) {
> -               *nr -= refs;
> -               return 0;
> -       }
> -
> -       if (unlikely(pmd_val(pmd) != pmd_val(*pmdp))) {
> -               *nr -= refs;
> -               while (refs--)
> -                       put_page(head);
> -               return 0;
> -       }
> -
> -       return 1;
> -}
> -
> -
> -static inline int gup_pmd_range(pud_t pud, unsigned long addr,
> -               unsigned long end, int write, struct page **pages, int *nr)
> -{
> -       unsigned long next;
> -       pmd_t *pmdp, pmd;
> -
> -       pmdp = pmd_offset(&pud, addr);
> -       do {
> -               pmd = *pmdp;
> -               barrier();
> -               next = pmd_addr_end(addr, end);
> -               if (pmd_none(pmd))
> -                       return 0;
> -               if (unlikely(pmd_large(pmd))) {
> -                       /*
> -                        * NUMA hinting faults need to be handled in the GUP
> -                        * slowpath for accounting purposes and so that they
> -                        * can be serialised against THP migration.
> -                        */
> -                       if (pmd_protnone(pmd))
> -                               return 0;
> -                       if (!gup_huge_pmd(pmdp, pmd, addr, next,
> -                                         write, pages, nr))
> -                               return 0;
> -               } else if (!gup_pte_range(pmd, addr, next,
> -                                         write, pages, nr))
> -                       return 0;
> -       } while (pmdp++, addr = next, addr != end);
> -
> -       return 1;
> -}
> -
> -static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
> -               unsigned long end, int write, struct page **pages, int *nr)
> -{
> -       struct page *head, *page;
> -       unsigned long mask;
> -       int refs;
> -
> -       mask = (write ? _REGION_ENTRY_PROTECT : 0) | _REGION_ENTRY_INVALID;
> -       if ((pud_val(pud) & mask) != 0)
> -               return 0;
> -       VM_BUG_ON(!pfn_valid(pud_pfn(pud)));
> -
> -       refs = 0;
> -       head = pud_page(pud);
> -       page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
> -       do {
> -               VM_BUG_ON_PAGE(compound_head(page) != head, page);
> -               pages[*nr] = page;
> -               (*nr)++;
> -               page++;
> -               refs++;
> -       } while (addr += PAGE_SIZE, addr != end);
> -
> -       if (!page_cache_add_speculative(head, refs)) {
> -               *nr -= refs;
> -               return 0;
> -       }
> -
> -       if (unlikely(pud_val(pud) != pud_val(*pudp))) {
> -               *nr -= refs;
> -               while (refs--)
> -                       put_page(head);
> -               return 0;
> -       }
> -
> -       return 1;
> -}
> -
> -static inline int gup_pud_range(p4d_t p4d, unsigned long addr,
> -               unsigned long end, int write, struct page **pages, int *nr)
> -{
> -       unsigned long next;
> -       pud_t *pudp, pud;
> -
> -       pudp = pud_offset(&p4d, addr);
> -       do {
> -               pud = *pudp;
> -               barrier();
> -               next = pud_addr_end(addr, end);
> -               if (pud_none(pud))
> -                       return 0;
> -               if (unlikely(pud_large(pud))) {
> -                       if (!gup_huge_pud(pudp, pud, addr, next, write, pages,
> -                                         nr))
> -                               return 0;
> -               } else if (!gup_pmd_range(pud, addr, next, write, pages,
> -                                         nr))
> -                       return 0;
> -       } while (pudp++, addr = next, addr != end);
> -
> -       return 1;
> -}
> -
> -static inline int gup_p4d_range(pgd_t pgd, unsigned long addr,
> -               unsigned long end, int write, struct page **pages, int *nr)
> -{
> -       unsigned long next;
> -       p4d_t *p4dp, p4d;
> -
> -       p4dp = p4d_offset(&pgd, addr);
> -       do {
> -               p4d = *p4dp;
> -               barrier();
> -               next = p4d_addr_end(addr, end);
> -               if (p4d_none(p4d))
> -                       return 0;
> -               if (!gup_pud_range(p4d, addr, next, write, pages, nr))
> -                       return 0;
> -       } while (p4dp++, addr = next, addr != end);
> -
> -       return 1;
> -}
> -
> -/*
> - * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
> - * back to the regular GUP.
> - * Note a difference with get_user_pages_fast: this always returns the
> - * number of pages pinned, 0 if no pages were pinned.
> - */
> -int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
> -                         struct page **pages)
> -{
> -       struct mm_struct *mm = current->mm;
> -       unsigned long addr, len, end;
> -       unsigned long next, flags;
> -       pgd_t *pgdp, pgd;
> -       int nr = 0;
> -
> -       start &= PAGE_MASK;
> -       addr = start;
> -       len = (unsigned long) nr_pages << PAGE_SHIFT;
> -       end = start + len;
> -       if ((end <= start) || (end > mm->context.asce_limit))
> -               return 0;
> -       /*
> -        * local_irq_save() doesn't prevent pagetable teardown, but does
> -        * prevent the pagetables from being freed on s390.
> -        *
> -        * So long as we atomically load page table pointers versus teardown,
> -        * we can follow the address down to the the page and take a ref on it.
> -        */
> -       local_irq_save(flags);
> -       pgdp = pgd_offset(mm, addr);
> -       do {
> -               pgd = *pgdp;
> -               barrier();
> -               next = pgd_addr_end(addr, end);
> -               if (pgd_none(pgd))
> -                       break;
> -               if (!gup_p4d_range(pgd, addr, next, write, pages, &nr))
> -                       break;
> -       } while (pgdp++, addr = next, addr != end);
> -       local_irq_restore(flags);
> -
> -       return nr;
> -}
> -
> -/**
> - * get_user_pages_fast() - pin user pages in memory
> - * @start:     starting user address
> - * @nr_pages:  number of pages from start to pin
> - * @write:     whether pages will be written to
> - * @pages:     array that receives pointers to the pages pinned.
> - *             Should be at least nr_pages long.
> - *
> - * Attempt to pin user pages in memory without taking mm->mmap_sem.
> - * If not successful, it will fall back to taking the lock and
> - * calling get_user_pages().
> - *
> - * Returns number of pages pinned. This may be fewer than the number
> - * requested. If nr_pages is 0 or negative, returns 0. If no pages
> - * were pinned, returns -errno.
> - */
> -int get_user_pages_fast(unsigned long start, int nr_pages, int write,
> -                       struct page **pages)
> -{
> -       int nr, ret;
> -
> -       might_sleep();
> -       start &= PAGE_MASK;
> -       nr = __get_user_pages_fast(start, nr_pages, write, pages);
> -       if (nr == nr_pages)
> -               return nr;
> -
> -       /* Try to get the remaining pages with get_user_pages */
> -       start += nr << PAGE_SHIFT;
> -       pages += nr;
> -       ret = get_user_pages_unlocked(start, nr_pages - nr, pages,
> -                                     write ? FOLL_WRITE : 0);
> -       /* Have to be a bit careful with return values */
> -       if (nr > 0)
> -               ret = (ret < 0) ? nr : ret + nr;
> -       return ret;
> -}
>
>
