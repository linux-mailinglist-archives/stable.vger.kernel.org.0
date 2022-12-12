Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E3A64A5F0
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 18:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiLLRcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 12:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbiLLRcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 12:32:53 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5B7E0F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:32:49 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h16so3921540wrz.12
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cnCEuIxgtLh0uks0WZG9h0Vph+pJpJv+4KkiXuwg67w=;
        b=TR5UXdOKLkuQUVVWnbe/qZ7Vmpi9KYcMWhq/UJYZYIbf6W/SCJ57q1dHc4VqpAdtYX
         t5ysyfOc4uU8dAhO5fEkCYADRnu+ozgi1GGopO8T4Fp/gz5Gi5u0vkFryFbzt/fyzcBH
         +434ZYhxIIz6hVQuGP58ZJiNxzHFN7mPkZVG3Jtc1EKdWZFyLpQBsUiEyJtLo8q/G80S
         wfwt/FUoyCaetRiKUGV3WpLrDPf3Anr5ymxSPjPNxMDiiPJ5+vXOvb69EqPEbGYXLG+/
         adw9io1NpLpNDc6KYDEheqxrbUh1TuuuKxleFOFXZPq3hFe4Ct3lneeuPV2vhV2ZM6a/
         DQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cnCEuIxgtLh0uks0WZG9h0Vph+pJpJv+4KkiXuwg67w=;
        b=ADSJoOcAaf2AzTtTHXwpxXF+pXD/JIhmpRA1iiH5o9dPQJBv70cPDEq0cz6UESXoCm
         6tyRxSVxVdVzzELWsex9sQIkhntrnAiggShI5dNoQV8GCEJyRlTvKjWMEJXqVskK37SM
         BR7ixaVT4LeQneE9I+NyoT3XO8jD2+g90aGcXEzYyh2FuOPZwO70fymjQQ2+aHTScMsS
         3u6rteMEBZhgF0Q6dT6WO3kt8p+JCQkAnovkNe4RDG9soSe0f+u7LNY0dA+f//QAmvxJ
         PYdCe8V1Ghg7q1/gRTUXWCxHjC1tJUdyz/IaEE85A/jWI+s82XycB96dzuhnr6lQEwvT
         sP1g==
X-Gm-Message-State: ANoB5pkOugKLrEZUpHg0KpHcsBwyL2wWXN946Q7x8UiHp3s61lfBgF78
        hN8MKUPVU7JPv+0I5I1fzqmei/7yLYjej/NO
X-Google-Smtp-Source: AA0mqf5g6gScQrqary+MHQqOSQR6KtGeJzuLTaGVn2T9Fp4bektud6duW55a5nk5WOLDbCxjebhSEg==
X-Received: by 2002:a5d:5f04:0:b0:24b:b245:9f06 with SMTP id cl4-20020a5d5f04000000b0024bb2459f06mr738256wrb.1.1670866367652;
        Mon, 12 Dec 2022 09:32:47 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d108:797c:2f44:5af6])
        by smtp.gmail.com with ESMTPSA id z17-20020adfdf91000000b00241d544c9b1sm11041360wrl.90.2022.12.12.09.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 09:32:46 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 stable 4.9,4.14 2/2] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Mon, 12 Dec 2022 18:32:38 +0100
Message-Id: <20221212173238.963128-4-jannh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
In-Reply-To: <20221212173238.963128-1-jannh@google.com>
References: <20221212173238.963128-1-jannh@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Any codepath that zaps page table entries must invoke MMU notifiers to
ensure that secondary MMUs (like KVM) don't keep accessing pages which
aren't mapped anymore.  Secondary MMUs don't hold their own references to
pages that are mirrored over, so failing to notify them can lead to page
use-after-free.

I'm marking this as addressing an issue introduced in commit f3f0e1d2150b
("khugepaged: add support of collapse for tmpfs/shmem pages"), but most of
the security impact of this only came in commit 27e1f8273113 ("khugepaged:
enable collapse pmd for pte-mapped THP"), which actually omitted flushes
for the removal of present PTEs, not just for the removal of empty page
tables.

Link: https://lkml.kernel.org/r/20221129154730.2274278-3-jannh@google.com
Link: https://lkml.kernel.org/r/20221128180252.1684965-3-jannh@google.com
Link: https://lkml.kernel.org/r/20221125213714.4115729-3-jannh@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[manual backport: this code was refactored from two copies into a common
helper between 5.15 and 6.0;
pmd collapse for PTE-mapped THP was only added in 5.4;
MMU notifier API changed between 4.19 and 5.4]
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/khugepaged.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7825f3af5c6d..a85e4dd6cbf1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1304,13 +1304,20 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (down_write_trylock(&mm->mmap_sem)) {
 			if (!khugepaged_test_exit(mm)) {
-				spinlock_t *ptl = pmd_lock(mm, pmd);
+				spinlock_t *ptl;
+				unsigned long end = addr + HPAGE_PMD_SIZE;
+
+				mmu_notifier_invalidate_range_start(mm, addr,
+								    end);
+				ptl = pmd_lock(mm, pmd);
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				spin_unlock(ptl);
 				atomic_long_dec(&mm->nr_ptes);
 				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
+				mmu_notifier_invalidate_range_end(mm, addr,
+								  end);
 			}
 			up_write(&mm->mmap_sem);
 		}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

