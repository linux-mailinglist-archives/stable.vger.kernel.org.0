Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D0765C4E0
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 18:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbjACRPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 12:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbjACROi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 12:14:38 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892A2BA
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:14:22 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so21361674wmb.2
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 09:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0OW5AOdsImyh1kBbcL338F5NOdTuao6iN6bXChklyZg=;
        b=m7q04cwMjQoui2FANrdYEKAn/9ZaoG/UQC6831VWLAu9f9SFmXISHlp95kiHfK77Dx
         jV3vRRS6NjOZQe9TCqgwL5xXEU/XBH/bY4/e4g/qg6EIhgDuyzQ/XNkRa91VSjYGfn4A
         L9yVqb6nK8KeOX8aP8kUYkwnN9n22TnbDKl0rht2Ly0OgK/4GM8hXZAJJH63qDJq35fU
         8EXtcdcVyXgQ5HmnAHXDbjF8ZE9w8w6Y4l9Rg/64xv05upJjc2Y3+8ra64mBl/oNnJai
         9o1cF9/jwCcidARzFh9ySs6Or7LTmch8dP6Y8HbMjHs5f2HBXISyIACfQuBe29qMVDuM
         G0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0OW5AOdsImyh1kBbcL338F5NOdTuao6iN6bXChklyZg=;
        b=IG4W/P9+rLRicuLKWXhjBZ+Jlka23bL/9fbXBNU/x+dQaOy+ZnD1sgtOc+hrzGyDY5
         grgDgeyR5z8UPESfyQd4qjVkremEZ2PwYGqkZoeOtOjG483ODmV36fukDGQM1XAALONV
         ryqIzFqyoJ4gb7IO1y3pnmAe4Kp2+tFfPYMdr5Lmuk38jH/SioTxMRrw9eJqVmXT/dsj
         g+DZCjfnkKf539fqGksCAqkKsrns2luxBt3ZkMPJ2enKaH4mRZZhh6HnErzcFHDa2/Kg
         XeTSJXMWUltJ+DVKF+G5yXMO+ibiV+4ugCrY59gG8kRs9XE4XJbkNtXr/5NQCPUga3mF
         GW4g==
X-Gm-Message-State: AFqh2kpj/P55O7vhp+2XU1PV3tz6Gw8ZTrtlwUEI12NVh2SJIkiKi1rm
        W9hk1Z/GQ27N2PAqQnUoQMO2huv2Yq9v9yWI
X-Google-Smtp-Source: AMrXdXv5v84om0HEy/odePv57WqR8E5L2lcA17EB8fEbGDOj/KjzzOO4fG1uoyfz1FwzMund9IugCg==
X-Received: by 2002:a05:600c:5121:b0:3d1:f779:a187 with SMTP id o33-20020a05600c512100b003d1f779a187mr3830769wms.1.1672766061056;
        Tue, 03 Jan 2023 09:14:21 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:1ad8:6267:8f:ab55])
        by smtp.gmail.com with ESMTPSA id p12-20020a05600c468c00b003cf5ec79bf9sm42411373wmo.40.2023.01.03.09.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:14:20 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH v3 stable 4.9,4.14 2/2] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Tue,  3 Jan 2023 18:14:16 +0100
Message-Id: <20230103171416.286579-2-jannh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230103171416.286579-1-jannh@google.com>
References: <20230103171416.286579-1-jannh@google.com>
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
index 6f8a1b423538..644f0a9c8a55 100644
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
2.39.0.314.g84b9a713c41-goog

