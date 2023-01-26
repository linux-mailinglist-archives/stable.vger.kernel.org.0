Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC0A67C16C
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 01:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjAZAYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 19:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjAZAYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 19:24:24 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E3A22A2B;
        Wed, 25 Jan 2023 16:24:22 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 7so142991pga.1;
        Wed, 25 Jan 2023 16:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CM96+4ruCJJU8nhNgGrZjMZb++bxzndT9HSNrxKvf1o=;
        b=QGMTyEVHh6YOWSPQO6QhW+4fjz1yvbxRbtWLzmzY9MTxIFwIVR7hUrBT3v/WzGzzvI
         GfXz9Kc+0LkUppERgoAu1Hvm7xknxDwECOHUZ6SQBCx5rNHjFQvI0noDYji8gAVYrm14
         w9qCWc2wPZ/C14Iih31gQvztV5tHIFXP2HFMBA8ahQe7PFcX91RwKy4yWPnTI5YQMDi3
         HUwJ4+FFC0zfqir8zNjzCYgDn3btP9fLKKrva67GrSWvhaKmII9p1OzotciMFRn1Bpna
         PX8EAyLBRF3n0pipDXr5i4PbcsISL7BOpLRr7KJBBbTbSO+fHLM38jg4SHoMcBjxnAv+
         m40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CM96+4ruCJJU8nhNgGrZjMZb++bxzndT9HSNrxKvf1o=;
        b=WL03BbGF9aKhshdB6I1de0zcXG5fAU2Q45MuskkYgG7QeiuipfaU0GIfJg02dZV2p5
         A7LRV31mbqjFc+fQ6kpA21wyRR+FPxWc/DrLxmnazHKpGqrjIda2smhkvwHRxI5FzreW
         lLkX3o9akwfFD4dJJgVDNmOm/IBZx71uPDhvuBZwVeYTrfH7sQyBNK2ih2Z0E3fK8+a/
         Bs+VEYcjRdPNo9X25x71hzAylb85G6J1xglEoQmP0fay4z11jWda9osuCONkvt6TbKZU
         06vOzM+UOHEx3cv5e4uzqk8/FKlQbltlo35W3bQgUYl+CWEz00GFSZY1nV/85Feo+hck
         CzAA==
X-Gm-Message-State: AFqh2krrFrPll2RFG4QhhC6oRbJxULre75d6kO39NumcnUtgVh+QiXtb
        WpLzeIKfi/Hy6P2KggscfL9I9apcpi+n3ulTAoE=
X-Google-Smtp-Source: AMrXdXtavfzIqkEATJXVuRF9BtHF3tOg4erHKUxNEB7vkGi3ho5NVQsMM5sj80josQUCgA7D2GnUdhk8isjgxwcsUPc=
X-Received: by 2002:a63:144d:0:b0:481:ef17:f551 with SMTP id
 13-20020a63144d000000b00481ef17f551mr3203862pgu.11.1674692661928; Wed, 25 Jan
 2023 16:24:21 -0800 (PST)
MIME-Version: 1.0
References: <20230125225358.2576151-1-zokeefe@google.com>
In-Reply-To: <20230125225358.2576151-1-zokeefe@google.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 25 Jan 2023 16:24:10 -0800
Message-ID: <CAHbLzkpJkMGF-HAZt-yqz-S9TEPW=4UWaZ0GJjs=tufrv2R8EQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/MADV_COLLAPSE: catch !none !huge !bad pmd lookups
To:     "Zach O'Keefe" <zokeefe@google.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 25, 2023 at 2:54 PM Zach O'Keefe <zokeefe@google.com> wrote:
>
> In commit 34488399fa08 ("mm/madvise: add file and shmem support to
> MADV_COLLAPSE") we make the following change to find_pmd_or_thp_or_none():
>
>         -       if (!pmd_present(pmde))
>         -               return SCAN_PMD_NULL;
>         +       if (pmd_none(pmde))
>         +               return SCAN_PMD_NONE;
>
> This was for-use by MADV_COLLAPSE file/shmem codepaths, where MADV_COLLAPSE
> might identify a pte-mapped hugepage, only to have khugepaged race-in, free
> the pte table, and clear the pmd.  Such codepaths include:
>
> A) If we find a suitably-aligned compound page of order HPAGE_PMD_ORDER
>    already in the pagecache.
> B) In retract_page_tables(), if we fail to grab mmap_lock for the target
>    mm/address.
>
> In these cases, collapse_pte_mapped_thp() really does expect a none (not
> just !present) pmd, and we want to suitably identify that case separate
> from the case where no pmd is found, or it's a bad-pmd (of course, many
> things could happen once we drop mmap_lock, and the pmd could plausibly
> undergo multiple transitions due to intervening fault, split, etc).
> Regardless, the code is prepared install a huge-pmd only when the existing
> pmd entry is either a genuine pte-table-mapping-pmd, or the none-pmd.
>
> However, the commit introduces a logical hole; namely, that we've allowed
> !none- && !huge- && !bad-pmds to be classified as genuine
> pte-table-mapping-pmds.  One such example that could leak through are swap
> entries.  The pmd values aren't checked again before use in
> pte_offset_map_lock(), which is expecting nothing less than a genuine
> pte-table-mapping-pmd.
>
> We want to put back the !pmd_present() check (below the pmd_none() check),
> but need to be careful to deal with subtleties in pmd transitions and
> treatments by various arch.
>
> The issue is that __split_huge_pmd_locked() temporarily clears the present
> bit (or otherwise marks the entry as invalid), but pmd_present()
> and pmd_trans_huge() still need to return true while the pmd is in this
> transitory state.  For example, x86's pmd_present() also checks the
> _PAGE_PSE , riscv's version also checks the _PAGE_LEAF bit, and arm64 also
> checks a PMD_PRESENT_INVALID bit.
>
> Covering all 4 cases for x86 (all checks done on the same pmd value):
>
> 1) pmd_present() && pmd_trans_huge()
>    All we actually know here is that the PSE bit is set. Either:
>    a) We aren't racing with __split_huge_page(), and PRESENT or PROTNONE
>       is set.
>       => huge-pmd
>    b) We are currently racing with __split_huge_page().  The danger here
>       is that we proceed as-if we have a huge-pmd, but really we are
>       looking at a pte-mapping-pmd.  So, what is the risk of this
>       danger?
>
>       The only relevant path is:
>
>         madvise_collapse() -> collapse_pte_mapped_thp()
>
>       Where we might just incorrectly report back "success", when really
>       the memory isn't pmd-backed.  This is fine, since split could
>       happen immediately after (actually) successful madvise_collapse().
>       So, it should be safe to just assume huge-pmd here.
>
> 2) pmd_present() && !pmd_trans_huge()
>    Either:
>    a) PSE not set and either PRESENT or PROTNONE is.
>       => pte-table-mapping pmd (or PROT_NONE)
>    b) devmap.  This routine can be called immediately after
>       unlocking/locking mmap_lock -- or called with no locks held (see
>       khugepaged_scan_mm_slot()), so previous VMA checks have since been
>       invalidated.
>
> 3) !pmd_present() && pmd_trans_huge()
>   Not possible.
>
> 4) !pmd_present() && !pmd_trans_huge()
>   Neither PRESENT nor PROTNONE set
>   => not present
>
> I've checked all archs that implement pmd_trans_huge() (arm64, riscv,
> powerpc, longarch, x86, mips, s390) and this logic roughly translates
> (though devmap treatment is unique to x86 and powerpc, and (3) doesn't
> necessarily hold in general -- but that doesn't matter since !pmd_present()
> always takes failure path).
>
> Also, add a comment above find_pmd_or_thp_or_none() to help future
> travelers reason about the validity of the code; namely, the possible
> mutations that might happen out from under us, depending on how
> mmap_lock is held (if at all).
>
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Zach O'Keefe <zokeefe@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Yang Shi <shy828301@gmail.com>

>
> ---
> Request that this be pulled into stable since it's theoretically
> possible (though I have no reproducer) that while mmap_lock is dropped,
> racing thp migration installs a pmd migration entry which then has a path to
> be consumed, unchecked, by pte_offset_map().
>
> v1 -> v2: Fix typo
> ---
>  mm/khugepaged.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9548644bdb56..1face2ae5877 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -943,6 +943,10 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>         return SCAN_SUCCEED;
>  }
>
> +/*
> + * See pmd_trans_unstable() for how the result may change out from
> + * underneath us, even if we hold mmap_lock in read.
> + */
>  static int find_pmd_or_thp_or_none(struct mm_struct *mm,
>                                    unsigned long address,
>                                    pmd_t **pmd)
> @@ -961,8 +965,12 @@ static int find_pmd_or_thp_or_none(struct mm_struct *mm,
>  #endif
>         if (pmd_none(pmde))
>                 return SCAN_PMD_NONE;
> +       if (!pmd_present(pmde))
> +               return SCAN_PMD_NULL;
>         if (pmd_trans_huge(pmde))
>                 return SCAN_PMD_MAPPED;
> +       if (pmd_devmap(pmde))
> +               return SCAN_PMD_NULL;
>         if (pmd_bad(pmde))
>                 return SCAN_PMD_NULL;
>         return SCAN_SUCCEED;
> --
> 2.39.1.456.gfc5497dd1b-goog
>
