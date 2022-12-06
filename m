Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EB4644A1D
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiLFRQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiLFRQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:36 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E7DF24
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:35 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id v7so11707911wmn.0
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SgKfs864rMeiexzGkX34TvVgMs5yHIz+axe7Egt5pCI=;
        b=bLNWOI/rRUdvxRWYTCyOH1KHBe/uvNcI2jmjD6KQyK2TelvbreFppQqbm8tlFPNag9
         qgdupnQBuwCjN6M46lzLHuozuMGU3HbUkkJDlJnN08BY0jDb/iPKllXjmfFFAdxuNRJz
         Pz6ZWgJZvT8zsVgSBGcwE07rTNVVlFdapi8BhdEOPdSKgTJ2N7TKTrcRKfj5CjmuNiVB
         wk6AvZ3eOv1t3BGfekN5wvto2Q/vSqVZ3keslwhrx5kSEKzNZzeff2iFwRWf12OOQqFN
         k1+f8nbQ/0u1RMM0KVrE8OinZCFApJoRwKUs/BUvGEtqOkTYQKzl2gznvW+CxIqJWw/r
         sfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SgKfs864rMeiexzGkX34TvVgMs5yHIz+axe7Egt5pCI=;
        b=50M06S8P50sKjweQo9DLkmztMhTHQM3QScvvZSwXy4XsLGRyx075BBm314L7Zfzn30
         gjR1cZOy6uNnopnI9MsFfel8364Uzx/xYcWjU9QCViH+7hyyDf83ZDIsFFlYVO1ju5Be
         PIxc96RBgSR8QY9zN0XGtEj0fFQTFGcd8bsv/+i6loBzSOq04FiEkanCmKanxQPRIQdL
         3Do00KFGOOpRY2AhO41Yv8fz7jnYsUXMfwZTFwRJHvEqOvVYcuv8l2cROCisjr/gvBlT
         C2WLpo9y9zkIkR5bpAy3lvmrGDPP6IwzPaO8Y+IWIcV0AAQL4LeFqcVL0TQqbnKgNVJx
         HdEA==
X-Gm-Message-State: ANoB5pm24rlg0+Spf1nQRNK84AV7tU36LcSjtEC3GCaNijkqehb/wWpc
        Yj1xCrbaHhYKI2Ujy1GDnXyO3Ng4TMB5Fpw7
X-Google-Smtp-Source: AA0mqf5OBUuvE7SvvJA8BG7gg1Q2nLHdcNext9apUUoHp7L8Skgjuv5fFWDYG9vH+wGq4QA+6P8ipw==
X-Received: by 2002:a05:600c:1da2:b0:3cf:147d:ad9a with SMTP id p34-20020a05600c1da200b003cf147dad9amr51278194wms.33.1670346993693;
        Tue, 06 Dec 2022 09:16:33 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c199100b003c7087f6c9asm26777813wmq.32.2022.12.06.09.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:33 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 5.10,5.15 3/3] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Tue,  6 Dec 2022 18:16:05 +0100
Message-Id: <20221206171614.1183048-4-jannh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
In-Reply-To: <20221206171614.1183048-1-jannh@google.com>
References: <20221206171614.1183048-1-jannh@google.com>
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

commit f268f6cf875f3220afc77bdd0bf1bb136eb54db9 upstream.

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
helper between 5.15 and 6.0]
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/khugepaged.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1735123e462a..fd25d12e85b3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1443,6 +1443,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	spinlock_t *ptl;
 	int count = 0;
 	int i;
+	struct mmu_notifier_range range;
 
 	if (!vma || !vma->vm_file ||
 	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
@@ -1536,9 +1537,13 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	}
 
 	/* step 4: collapse pmd */
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, haddr,
+				haddr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
 	_pmd = pmdp_collapse_flush(vma, haddr, pmd);
 	mm_dec_nr_ptes(mm);
 	tlb_remove_table_sync_one();
+	mmu_notifier_invalidate_range_end(&range);
 	pte_free(mm, pmd_pgtable(_pmd));
 
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
@@ -1622,11 +1627,19 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (mmap_write_trylock(mm)) {
 			if (!khugepaged_test_exit(mm)) {
+				struct mmu_notifier_range range;
+
+				mmu_notifier_range_init(&range,
+							MMU_NOTIFY_CLEAR, 0,
+							NULL, mm, addr,
+							addr + HPAGE_PMD_SIZE);
+				mmu_notifier_invalidate_range_start(&range);
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				mm_dec_nr_ptes(mm);
 				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
+				mmu_notifier_invalidate_range_end(&range);
 			}
 			mmap_write_unlock(mm);
 		} else {
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

