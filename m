Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF4767A888
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 02:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjAYB6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 20:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjAYB6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 20:58:14 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB2A38008
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 17:58:13 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id y8-20020a170902b48800b00192a600df83so9944595plr.15
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 17:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CLeT8Nf/jj+XeEyGWZaHUysjcWhO2WN556Qt8YbZFTA=;
        b=bXlVQRumzm40VAjDslHGOuknPuAdE9sb0L4akt62AYYiNfF1nl/PE9a3K4+mhxfxbU
         qlOjlx9HYpNZ7nlKZHVgHB0Q1n9WvvwyURl+Khn4oVXSDFDI5stAZNLD/GV7mYuhnAmX
         4fP31lq2dBuIKqP7/dpZqBG1jQWdaE4UbMixSINcYMwJN6K9z5usFxW1G1RYeQzjzLmE
         IuTvdJPPP3texNImaofSkc7EevfsFsTYsDDWMHluYgcK4K8lzmtm33VRfk8XHHm/C1AO
         JzwN7PIDjhXbMVtdks4HwD6HiFKY6CPRKEfjrxQ0G2uWsS+SXuQvOj6jyB/oyIkb1ojY
         XkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CLeT8Nf/jj+XeEyGWZaHUysjcWhO2WN556Qt8YbZFTA=;
        b=d2YE8/umVdHHFHTl+24AeDFxYsPoTPF9wi/zKUTUtN6jXe/PlboctIZAGJT0LwjYfC
         wk8fzLw0TOJGPeLAz/GYsmCQa6BvSSVM96VumYLNq90iTQ3rAkyLhj0PRBEeb6egoACP
         qOKelBRG7/beS+2WcGleHsX8JgV4jTQtoDwuJ1yCBBNzs9hBBX+wUAAGy3dwcZnIcQ+n
         SSQ7ShVPriA/3hW+mdZrAH+YnfFC9iiYO7jKs3ntFBpTXBOroXBKX+NkJXzuXP1TwCk8
         gm4urdi9Yc6tkVGCsm9/VGTEAdpAwOxYyOH3XaSUxe5BmN6NNbchFqfBDTd6Uj2SoLjh
         TaIw==
X-Gm-Message-State: AFqh2koRjyicPIP1GtPPA9GPZazlWpsFYGrHa/DBrIDqKHAg0EuGF950
        B5rNSpOW3ItTmckmIvRp7uKnRFP4f5HV
X-Google-Smtp-Source: AMrXdXuhZDEkZKkDLUre49lmdMlmiICegzf6uQdbSopmZQDIYG8wsakARMsaTdDgeLxTwvPxruwcgZi2TTo/
X-Received: from zokeefe3.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1b6])
 (user=zokeefe job=sendgmr) by 2002:a62:6d04:0:b0:578:9709:615f with SMTP id
 i4-20020a626d04000000b005789709615fmr3520547pfc.45.1674611892894; Tue, 24 Jan
 2023 17:58:12 -0800 (PST)
Date:   Tue, 24 Jan 2023 17:57:38 -0800
In-Reply-To: <20230125015738.912924-1-zokeefe@google.com>
Mime-Version: 1.0
References: <20230125015738.912924-1-zokeefe@google.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230125015738.912924-2-zokeefe@google.com>
Subject: [PATCH 2/2] mm/MADV_COLLAPSE: catch !none !huge !bad pmd lookups
From:   "Zach O'Keefe" <zokeefe@google.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Yang Shi <shy828301@gmail.com>,
        "Zach O'Keefe" <zokeefe@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 34488399fa08 ("mm/madvise: add file and shmem support to
MADV_COLLAPSE") we make the following change to find_pmd_or_thp_or_none():

	-       if (!pmd_present(pmde))
	-               return SCAN_PMD_NULL;
	+       if (pmd_none(pmde))
	+               return SCAN_PMD_NONE;

This was for-use by MADV_COLLAPSE file/shmem codepaths, where MADV_COLLAPSE
might identify a pte-mapped hugepage, only to have khugepaged race-in, free
the pte table, and clear the pmd.  Such codepaths include:

A) If we find a suitably-aligned compound page of order HPAGE_PMD_ORDER
   already in the pagecache.
B) In retract_page_tables(), if we fail to grab mmap_lock for the target
   mm/address.

In these cases, collapse_pte_mapped_thp() really does expect a none (not
just !present) pmd, and we want to suitably identify that case separate
from the case where no pmd is found, or it's a bad-pmd (of course, many
things could happen once we drop mmap_lock, and the pmd could plausibly
undergo multiple transitions due to intervening fault, split, etc).
Regardless, the code is prepared install a huge-pmd only when the existing
pmd entry is either a genuine pte-table-mapping-pmd, or the none-pmd.

However, the commit introduces a logical hole; namely, that we've allowed
!none- && !huge- && !bad-pmds to be classified as genuine
pte-table-mapping-pmds.  One such example that could leak through are swap
entries.  The pmd values aren't checked again before use in
pte_offset_map_lock(), which is expecting nothing less than a genuine
pte-table-mapping-pmd.

We want to put back the !pmd_present() check (below the pmd_none() check),
but need to be careful to deal with subtleties in pmd transitions and
treatments by various arch.

The issue is that __split_huge_pmd_locked() temporarily clears the present
bit (or otherwise marks the entry as invalid), but pmd_present()
and pmd_trans_huge() still need to return true while the pmd is in this
transitory state.  For example, x86's pmd_present() also checks the
_PAGE_PSE , riscv's version also checks the _PAGE_LEAF bit, and arm64 also
checks a PMD_PRESENT_INVALID bit.

Covering all 4 cases for x86 (all checks done on the same pmd value):

1) pmd_present() && pmd_trans_huge()
   All we actually know here is that the PSE bit is set. Either:
   a) We aren't racing with __split_huge_page(), and PRESENT or PROTNONE
      is set.
      => huge-pmd
   b) We are currently racing with __split_huge_page().  The danger here
      is that we proceed as-if we have a huge-pmd, but really we are
      looking at a pte-mapping-pmd.  So, what is the risk of this
      danger?

      The only relevant path is:

	madvise_collapse() -> collapse_pte_mapped_thp()

      Where we might just incorrectly report back "success", when really
      the memory isn't pmd-backed.  This is fine, since split could
      happen immediately after (actually) successful madvise_collapse().
      So, it should be safe to just assume huge-pmd here.

2) pmd_present() && !pmd_trans_huge()
   Either:
   a) PSE not set and either PRESENT or PROTNONE is.
      => pte-table-mapping pmd (or PROT_NONE)
   b) devmap.  This routine can be called immediately after
      unlocking/locking mmap_lock -- or called with no locks held (see
      khugepaged_scan_mm_slot()), so previous VMA checks have since been
      invalidated.

3) !pmd_present() && pmd_trans_huge()
  Not possible.

4) !pmd_present() && !pmd_trans_huge()
  Neither PRESENT nor PROTNONE set
  => not present

I've checked all archs that implement pmd_trans_huge() (arm64, riscv,
powerpc, longarch, x86, mips, s390) and this logic roughly translates
(though devmap treatment is unique to x86 and powerpc, and (3) doesn't
necessarily hold in general -- but that doesn't matter since !pmd_present()
always takes failure path).

Also, add a comment above find_pmd_or_thp_or_none() to help future
travelers reason about the validity of the code; namely, the possible
mutations that might happen out from under us, depending on how
mmap_lock is held (if at all).

Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: stable@vger.kernel.org

---
Request that this be pulled into stable since it's theoretically
possible (though I have no reproducer) that while mmap_lock is dropped,
racing thp migration installs a pmd migration entry which then has a path to
be consumed, unchecked, by pte_offset_map().
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa38cae240b9..7ea668bbea70 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -941,6 +941,10 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 	return SCAN_SUCCEED;
 }
 
+/*
+ * See pmd_trans_unstable() for how the result may change out from
+ * underneath us, even if we hold mmap_lock in read.
+ */
 static int find_pmd_or_thp_or_none(struct mm_struct *mm,
 				   unsigned long address,
 				   pmd_t **pmd)
@@ -959,8 +963,12 @@ static int find_pmd_or_thp_or_none(struct mm_struct *mm,
 #endif
 	if (pmd_none(pmde))
 		return SCAN_PMD_NONE;
+	if (!pmd_present(pmde))
+		return SCAN_PMD_NULL;
 	if (pmd_trans_huge(pmde))
 		return SCAN_PMD_MAPPED;
+	if (pmd_devmap(pmd))
+		return SCAN_PMD_NULL;
 	if (pmd_bad(pmde))
 		return SCAN_PMD_NULL;
 	return SCAN_SUCCEED;
-- 
2.39.1.405.gd4c25cc71f-goog

