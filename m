Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1428644A27
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiLFRQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiLFRQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:43 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6FEF24
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:42 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id r65-20020a1c4444000000b003d1e906ca23so766812wma.3
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0PKH1s24+3gmn3/Y6+A+itruKtyI1yGS08kAvUXu/Wc=;
        b=OiZ2Rg0XhabTivoQ0014HdKa1zLUOdogfNvdmT3mHOjGuAa68MpOENDatOL2WiLI3H
         edn0imUwy7YlIujTf623aa9dYVU445msvK9c+Jd1ebIuNS122t0c1V/AZ0aBFOYDJDhr
         mpTPFdqX1kEJpJwNFs02GZU2ytgryNz++ArGOejBEWO7EJgAlDiJv6pfuZHLJoGVXihB
         gk6LoR27RqZ5k9iy85jq+s98UeyfM9HMsXCoj7fV9MdHjtJG+OHYnh9d0qNE1TyyY5or
         Onx8oz2w48sZ8wN/jcd0Pj/j51suO+6DJIBH1+AchppVBr4HzZDpi78flaPJiGG5+yOL
         gs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PKH1s24+3gmn3/Y6+A+itruKtyI1yGS08kAvUXu/Wc=;
        b=2G3byuVDi3ALBmmdxuqg1mqLCehSRTFJ+uMe32TR7yVJt1oCb4Bf0XvxZ72/2aobbx
         X03gH+ZA9bOWNCWDS2x+Bw6aiu8ZVz3EsLsOdNPbVHN/G5RfeVt3MqDqKer2b+2EuXgM
         Z9ooe6dRZQQzi0GBjoW77e55PHCmRWpwjy0Etx4ZcPwsuZ16vMZ1nSPpcWFcC2AnmphZ
         JetPWQoNh+RplXpYV+6c++ppAl+gCmJgNsAyNfn9S1u6hFclTDZoDkheWxqFFIzSm3M8
         801pnPJdvxYbJND2v6cYxGwH9Q7wtWY9wZyS0epCzwh/L9DciAqq807YTlYvxRcRgKt4
         H0yw==
X-Gm-Message-State: ANoB5pl94VJ1l+BEjEYF0zyhb0aD03CSNybHG4tzMo+d87GWViUqLjfT
        GhosvJ8YfehIPpzkoeXr+yRZTHoDUB899KPU
X-Google-Smtp-Source: AA0mqf7sE0U8opseaS9bFCPpOPv/R+y/Ge5XouBGMI9nhGIr8OcWq36dyQ+WN3N6p+ja3gI1S5Moyw==
X-Received: by 2002:a05:600c:511c:b0:3cf:6c05:809e with SMTP id o28-20020a05600c511c00b003cf6c05809emr51266695wms.74.1670347000697;
        Tue, 06 Dec 2022 09:16:40 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id z6-20020adfec86000000b002368a6deaf8sm17120439wrn.57.2022.12.06.09.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:39 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 5.4 3/3] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Tue,  6 Dec 2022 18:16:10 +0100
Message-Id: <20221206171614.1183048-9-jannh@google.com>
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
index a8f2605cbd0d..8e67d2e5ff39 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1313,6 +1313,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	spinlock_t *ptl;
 	int count = 0;
 	int i;
+	struct mmu_notifier_range range;
 
 	if (!vma || !vma->vm_file ||
 	    vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE)
@@ -1406,9 +1407,13 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
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
@@ -1493,11 +1498,19 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (down_write_trylock(&mm->mmap_sem)) {
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
 			up_write(&mm->mmap_sem);
 		} else {
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

