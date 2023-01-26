Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A615A67C1D9
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 01:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbjAZAiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 19:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbjAZAiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 19:38:17 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FA364693
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 16:38:11 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z11so555435ede.1
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 16:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kPGzIQn/yC7I4PMSm/BhNLWJz75dQ27geDgXzSkjTEI=;
        b=pR9t7gPw92TX4Op6jnwsqpLEnvMeUf2bMccpBm2w3vzuuJjZ8fyHuqxsLf9qlFbYIR
         s9qFII1/XKxc1g5q77oS8oIu+/KGDovpGWFamVIJbdbhjCiZpBUFyxcApAGy7D1MBH+L
         7UCymwM6RA6mLVPjMER1/oblGuSqI2ieJ0QcqAJd/F0b2PKyjRJYAA6b+VcV6qR2qt4q
         EJzvDYc5eJErm2PogPXYixNNAJnPWBUg5aBhBH3tFL/EEXBbDqtsA+B3sQf+av7RuMms
         rhp7KX7e9bG90bzW8whWbjH1BMYs07kNqNz4wrCHMCnfa8iO2wLxjZZfPEkAzRkaFIZD
         caEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPGzIQn/yC7I4PMSm/BhNLWJz75dQ27geDgXzSkjTEI=;
        b=L24m3fGTMr8uh0+TMOcrweGrsUrIvdyDfJkrJvM1HBMULfFBrDO84TxHap+dFNJpfz
         hlsZih5jIqTkuhOuZBup+TSknkEqh8LMkDHQGLL08wLFwqdipMzdTXqVeKweIFvkVrzv
         iyPITlxHDrYiNMreJflaN8cWquBkPPO9ZFtuZ59qPP89ix9N8elqGtjwqW5bxUdCxe4u
         VbNVvstvdsZXXhSxQSa/nIOJ5c/2vZwLShoE3NwKyi2yHzJugB2yzjtRLqhfY51j2cmA
         hT3FYTgM55HJTriUfdgjnFE0a3Xs1qHGh5U3VtDPtfM4qGV/HblQgH4dN39tjiQV0wJb
         qdNw==
X-Gm-Message-State: AO0yUKUV/hf/HB8RQllb1SzseGpP6NKXwWOT7CF7qtD07HUn/PEogJPE
        WEv4g50yJgWxDrbtH7zLCIjLoY15lX7GLKJdRVOe3A==
X-Google-Smtp-Source: AK7set/92BOJrwXhfPvabeWT1IOYWPTjlypUFc0izHR0fwZEPOBiX4/G+rGCVw1IHggZSPJfoEIceMeX4zPdW6GwqUM=
X-Received: by 2002:aa7:ca42:0:b0:4a0:8fd6:34c2 with SMTP id
 j2-20020aa7ca42000000b004a08fd634c2mr1389214edt.67.1674693489832; Wed, 25 Jan
 2023 16:38:09 -0800 (PST)
MIME-Version: 1.0
References: <20230125225358.2576151-1-zokeefe@google.com> <CAHbLzkpJkMGF-HAZt-yqz-S9TEPW=4UWaZ0GJjs=tufrv2R8EQ@mail.gmail.com>
In-Reply-To: <CAHbLzkpJkMGF-HAZt-yqz-S9TEPW=4UWaZ0GJjs=tufrv2R8EQ@mail.gmail.com>
From:   "Zach O'Keefe" <zokeefe@google.com>
Date:   Wed, 25 Jan 2023 16:37:33 -0800
Message-ID: <CAAa6QmSEYAGu+HCRLS8di6CF6aGPYf--MTDabh=_ixw-wpruCA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/MADV_COLLAPSE: catch !none !huge !bad pmd lookups
To:     Yang Shi <shy828301@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 25, 2023 at 4:24 PM Yang Shi <shy828301@gmail.com> wrote:
>
> On Wed, Jan 25, 2023 at 2:54 PM Zach O'Keefe <zokeefe@google.com> wrote:
> >
> > In commit 34488399fa08 ("mm/madvise: add file and shmem support to
> > MADV_COLLAPSE") we make the following change to find_pmd_or_thp_or_none():
> >
> >         -       if (!pmd_present(pmde))
> >         -               return SCAN_PMD_NULL;
> >         +       if (pmd_none(pmde))
> >         +               return SCAN_PMD_NONE;
> >
> > This was for-use by MADV_COLLAPSE file/shmem codepaths, where MADV_COLLAPSE
> > might identify a pte-mapped hugepage, only to have khugepaged race-in, free
> > the pte table, and clear the pmd.  Such codepaths include:
> >
> > A) If we find a suitably-aligned compound page of order HPAGE_PMD_ORDER
> >    already in the pagecache.
> > B) In retract_page_tables(), if we fail to grab mmap_lock for the target
> >    mm/address.
> >
> > In these cases, collapse_pte_mapped_thp() really does expect a none (not
> > just !present) pmd, and we want to suitably identify that case separate
> > from the case where no pmd is found, or it's a bad-pmd (of course, many
> > things could happen once we drop mmap_lock, and the pmd could plausibly
> > undergo multiple transitions due to intervening fault, split, etc).
> > Regardless, the code is prepared install a huge-pmd only when the existing
> > pmd entry is either a genuine pte-table-mapping-pmd, or the none-pmd.
> >
> > However, the commit introduces a logical hole; namely, that we've allowed
> > !none- && !huge- && !bad-pmds to be classified as genuine
> > pte-table-mapping-pmds.  One such example that could leak through are swap
> > entries.  The pmd values aren't checked again before use in
> > pte_offset_map_lock(), which is expecting nothing less than a genuine
> > pte-table-mapping-pmd.
> >
> > We want to put back the !pmd_present() check (below the pmd_none() check),
> > but need to be careful to deal with subtleties in pmd transitions and
> > treatments by various arch.
> >
> > The issue is that __split_huge_pmd_locked() temporarily clears the present
> > bit (or otherwise marks the entry as invalid), but pmd_present()
> > and pmd_trans_huge() still need to return true while the pmd is in this
> > transitory state.  For example, x86's pmd_present() also checks the
> > _PAGE_PSE , riscv's version also checks the _PAGE_LEAF bit, and arm64 also
> > checks a PMD_PRESENT_INVALID bit.
> >
> > Covering all 4 cases for x86 (all checks done on the same pmd value):
> >
> > 1) pmd_present() && pmd_trans_huge()
> >    All we actually know here is that the PSE bit is set. Either:
> >    a) We aren't racing with __split_huge_page(), and PRESENT or PROTNONE
> >       is set.
> >       => huge-pmd
> >    b) We are currently racing with __split_huge_page().  The danger here
> >       is that we proceed as-if we have a huge-pmd, but really we are
> >       looking at a pte-mapping-pmd.  So, what is the risk of this
> >       danger?
> >
> >       The only relevant path is:
> >
> >         madvise_collapse() -> collapse_pte_mapped_thp()
> >
> >       Where we might just incorrectly report back "success", when really
> >       the memory isn't pmd-backed.  This is fine, since split could
> >       happen immediately after (actually) successful madvise_collapse().
> >       So, it should be safe to just assume huge-pmd here.
> >
> > 2) pmd_present() && !pmd_trans_huge()
> >    Either:
> >    a) PSE not set and either PRESENT or PROTNONE is.
> >       => pte-table-mapping pmd (or PROT_NONE)
> >    b) devmap.  This routine can be called immediately after
> >       unlocking/locking mmap_lock -- or called with no locks held (see
> >       khugepaged_scan_mm_slot()), so previous VMA checks have since been
> >       invalidated.
> >
> > 3) !pmd_present() && pmd_trans_huge()
> >   Not possible.
> >
> > 4) !pmd_present() && !pmd_trans_huge()
> >   Neither PRESENT nor PROTNONE set
> >   => not present
> >
> > I've checked all archs that implement pmd_trans_huge() (arm64, riscv,
> > powerpc, longarch, x86, mips, s390) and this logic roughly translates
> > (though devmap treatment is unique to x86 and powerpc, and (3) doesn't
> > necessarily hold in general -- but that doesn't matter since !pmd_present()
> > always takes failure path).
> >
> > Also, add a comment above find_pmd_or_thp_or_none() to help future
> > travelers reason about the validity of the code; namely, the possible
> > mutations that might happen out from under us, depending on how
> > mmap_lock is held (if at all).
> >
> > Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> > Reported-by: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Zach O'Keefe <zokeefe@google.com>
> > Cc: stable@vger.kernel.org
>
> Reviewed-by: Yang Shi <shy828301@gmail.com>

Thanks for your time as always, Yang!

Best,
Zach

> >
> > ---
> > Request that this be pulled into stable since it's theoretically
> > possible (though I have no reproducer) that while mmap_lock is dropped,
> > racing thp migration installs a pmd migration entry which then has a path to
> > be consumed, unchecked, by pte_offset_map().
> >
> > v1 -> v2: Fix typo
> > ---
> >  mm/khugepaged.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 9548644bdb56..1face2ae5877 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -943,6 +943,10 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> >         return SCAN_SUCCEED;
> >  }
> >
> > +/*
> > + * See pmd_trans_unstable() for how the result may change out from
> > + * underneath us, even if we hold mmap_lock in read.
> > + */
> >  static int find_pmd_or_thp_or_none(struct mm_struct *mm,
> >                                    unsigned long address,
> >                                    pmd_t **pmd)
> > @@ -961,8 +965,12 @@ static int find_pmd_or_thp_or_none(struct mm_struct *mm,
> >  #endif
> >         if (pmd_none(pmde))
> >                 return SCAN_PMD_NONE;
> > +       if (!pmd_present(pmde))
> > +               return SCAN_PMD_NULL;
> >         if (pmd_trans_huge(pmde))
> >                 return SCAN_PMD_MAPPED;
> > +       if (pmd_devmap(pmde))
> > +               return SCAN_PMD_NULL;
> >         if (pmd_bad(pmde))
> >                 return SCAN_PMD_NULL;
> >         return SCAN_SUCCEED;
> > --
> > 2.39.1.456.gfc5497dd1b-goog
> >
