Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE2C4A9093
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 23:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350718AbiBCWTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 17:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiBCWTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 17:19:13 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA9EC061714;
        Thu,  3 Feb 2022 14:19:13 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id j2so12918778ejk.6;
        Thu, 03 Feb 2022 14:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GOu/1THglDVeJl3U7MMSrfyxTvyCi8aFtyQJKOPt1yo=;
        b=Bkxytx1rYCwS7T3hdaz6quufzPxCnjE+wsE5ldbaUW5t8fCGwpg505DKUwCU7oEcWu
         6Apaly4e9E/MpN0+MVpfHbPNW4lCkJUnWXeIkflNFURTUP5FGMGs+B/8rb5G8hK748L+
         7x9qH2FoOoewr/gQQoNh+LNcw+eZv21u3BKkhYK6YQwGSu5TulCA7ZLace6IcmTfnI/L
         tnJlip18l6nXRLWAnzbn+iDSG63aeQH0NPEn/XSoVbSb2PkhE5MGs8exnVYgn5Uxb1k/
         gbHmrmSLGke6jdHWI8B0KagLzMm+Ytgpi1QW+JJJKbEzT/lEnCL35tiQJaWea8VmWcOm
         7xNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GOu/1THglDVeJl3U7MMSrfyxTvyCi8aFtyQJKOPt1yo=;
        b=YrC7ojW6Lg0IeKrhyqiLX7a4LQsRbwxlZ+jFvx49teaj40BqtLUV/yHZT9QVsUwBfU
         Yy2iDIUpUKNil1AmzCbczGMDGSGNeQQellEeurdQ/Z7ip5Mlzolnt6fZ3iajMk1RfeZF
         vFpzReHtvoz/utEYFh1w9YGI6JBArudycQlPRvhhx3i+XkVPY/0k4kUxNqtvbXVbtfDF
         CDUN2lFo5MoIAei4/leh9JHcwFsKAffK5CNjDtOTyikHQeo7aBqaGQe0UpzvN2i6o5Gy
         NOfb9ldm98edPJlDkkEUyNYKnpNOU9pAzujOWwXWfE9b0R5uBIAcVxLA5zxYCuJclR5G
         hMHQ==
X-Gm-Message-State: AOAM531DBCpm+tf+5QsFH2Rg6F/LM550Aazzbn9NqeZZDUPcliCOWz40
        PLR/yGBpHI7WwsRe7Gf1pnQl6sz6ljY+GKzo06uG2XcMagU=
X-Google-Smtp-Source: ABdhPJxI8SMxBz0kZoZ/OkQC6HVudR43k5HUeEvEqSyhCy3Q02/zu7na+zZTa14XBq/mhwevczEjO49BPLpith+IgMs=
X-Received: by 2002:a17:907:6e1a:: with SMTP id sd26mr22848ejc.270.1643926751588;
 Thu, 03 Feb 2022 14:19:11 -0800 (PST)
MIME-Version: 1.0
References: <20220203182641.824731-1-shy828301@gmail.com> <20220203141226.d510a9fe3fb1f55fc75926e5@linux-foundation.org>
In-Reply-To: <20220203141226.d510a9fe3fb1f55fc75926e5@linux-foundation.org>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 3 Feb 2022 14:18:56 -0800
Message-ID: <CAHbLzkpb2Bs8buDOAGCt7hpjy2824HfK3RsTHM+gbzmZ1wvKRA@mail.gmail.com>
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 3, 2022 at 2:12 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu,  3 Feb 2022 10:26:41 -0800 Yang Shi <shy828301@gmail.com> wrote:
>
> > v4: * s/Treated/Treat per David
> >     * Collected acked-by tag from David
> > v3: * Fixed the fix tag, the one used by v2 was not accurate
> >     * Added comment about the risk calling page_mapcount() per David
> >     * Fix pagemap
> > v2: * Added proper fix tag per Jann Horn
> >     * Rebased to the latest linus's tree
>
> The v2->v4 delta shows changes which aren't described above?

They are.

v4: * s/Treated/Treat per David
      * Collected acked-by tag from David
v3: * Fixed the fix tag, the one used by v2 was not accurate
      * Added comment about the risk calling page_mapcount() per David
      * Fix pagemap

>
> --- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4
> +++ a/fs/proc/task_mmu.c
> @@ -469,9 +469,12 @@ static void smaps_account(struct mem_siz
>          * If any subpage of the compound page mapped with PTE it would elevate
>          * page_count().
>          *
> -        * Treated regular migration entries as mapcount == 1 without reading
> -        * mapcount since calling page_mapcount() for migration entries is
> -        * racy against THP splitting.
> +        * The page_mapcount() is called to get a snapshot of the mapcount.
> +        * Without holding the page lock this snapshot can be slightly wrong as
> +        * we cannot always read the mapcount atomically.  It is not safe to
> +        * call page_mapcount() even with PTL held if the page is not mapped,
> +        * especially for migration entries.  Treat regular migration entries
> +        * as mapcount == 1.
>          */
>         if ((page_count(page) == 1) || migration) {
>                 smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
> @@ -1393,6 +1396,7 @@ static pagemap_entry_t pte_to_pagemap_en
>  {
>         u64 frame = 0, flags = 0;
>         struct page *page = NULL;
> +       bool migration = false;
>
>         if (pte_present(pte)) {
>                 if (pm->show_pfn)
> @@ -1414,13 +1418,14 @@ static pagemap_entry_t pte_to_pagemap_en
>                         frame = swp_type(entry) |
>                                 (swp_offset(entry) << MAX_SWAPFILES_SHIFT);
>                 flags |= PM_SWAP;
> +               migration = is_migration_entry(entry);
>                 if (is_pfn_swap_entry(entry))
>                         page = pfn_swap_entry_to_page(entry);
>         }
>
>         if (page && !PageAnon(page))
>                 flags |= PM_FILE;
> -       if (page && page_mapcount(page) == 1)
> +       if (page && !migration && page_mapcount(page) == 1)
>                 flags |= PM_MMAP_EXCLUSIVE;
>         if (vma->vm_flags & VM_SOFTDIRTY)
>                 flags |= PM_SOFT_DIRTY;
> @@ -1436,6 +1441,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
>         spinlock_t *ptl;
>         pte_t *pte, *orig_pte;
>         int err = 0;
> +       bool migration = false;
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>         ptl = pmd_trans_huge_lock(pmdp, vma);
> @@ -1476,11 +1482,12 @@ static int pagemap_pmd_range(pmd_t *pmdp
>                         if (pmd_swp_uffd_wp(pmd))
>                                 flags |= PM_UFFD_WP;
>                         VM_BUG_ON(!is_pmd_migration_entry(pmd));
> +                       migration = is_migration_entry(entry);
>                         page = pfn_swap_entry_to_page(entry);
>                 }
>  #endif
>
> -               if (page && page_mapcount(page) == 1)
> +               if (page && !migration && page_mapcount(page) == 1)
>                         flags |= PM_MMAP_EXCLUSIVE;
>
>                 for (; addr != end; addr += PAGE_SIZE) {
> _
>
