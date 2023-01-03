Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B431665C4DF
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 18:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbjACRPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 12:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238561AbjACROa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 12:14:30 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695351183F
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:14:11 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k26-20020a05600c1c9a00b003d972646a7dso20715836wms.5
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 09:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z0basaap9JXDJIVD9Qq5mJHN/FB38LTvi8YWrxsKWX8=;
        b=BN6/RJCSuxzvqv45ZMSdcUulJ84FKGFB/Ze4BxrxVm+CZ/O2V2MG4r05WVIzdi3LMc
         AzJ643kAlC+SmBsgK1lqHQMcYNF7gXDzDGez8v1/lNzX5V8M+o+V1DM9IEd1TiEWnrTf
         XtLW2wnw4I8d1sWb5pXWf0Q7P1maNzOIyP+NEGoCoZ6du6EzkWYiRqYVCbNW1KBtnZBt
         x6pG5QePSRTJcM+ldsZL054Isb7HPsrAOGbJO9BBzRACTNMK1/gGfXKbCix2zra18Ji6
         KN8SGK1vV8VpoDhtmEnVb6ONQyQtTmz5N46Xt3iThHlqqLm6V6sHbmAPqBP0AfCR0pkl
         Dwzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z0basaap9JXDJIVD9Qq5mJHN/FB38LTvi8YWrxsKWX8=;
        b=ucVC9RroGNYDahkBOW14QAVp7Ui/ZKI/ZfdLiFTiyG8JDUDi5Wzstzo3OaVUSMhuY7
         HTcD7PTv+pJwgJ7ldhxA0eA6cxl3JqmCNJW+xu17dVXZ1in4YMorNNM+lZjReehiqaFb
         LIQGawraaT/XCCXt3Y5NudHSrw7uEWOf4EgT1tapAktfOf6hM6hEOQJ0QooD5wXwNim/
         5Wc9K+QsArwvulEMQcUEcIWu1vEgLyYrZntK9YLZpMF8JbMwsupOWa3NrNEbCAqgetwC
         BOpOcN53/6prtYIzbxTkQpXXDZQjUeeSuaq2fDpRE8zC6G1oGJHFdV/5JTeKuJZV+yaG
         Yy0A==
X-Gm-Message-State: AFqh2kpbxS9yyncHOEuJ4UtwpmR081N6MBvgMegf5pQ+PJ5aDeDSy7Gi
        +5egZLs+R+XlI7Wb4vzzXwa0ofPSfNGyF2+p
X-Google-Smtp-Source: AMrXdXuZzCu4vLpjRWqY/gGh+OUunq4FaAqP4nnF7B0UBqnE/8SOS99Q9uDEHXPeDEOWjr6GuXiSpw==
X-Received: by 2002:a05:600c:1c86:b0:3d1:bad1:9b0c with SMTP id k6-20020a05600c1c8600b003d1bad19b0cmr4208004wms.1.1672766049821;
        Tue, 03 Jan 2023 09:14:09 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:1ad8:6267:8f:ab55])
        by smtp.gmail.com with ESMTPSA id h10-20020a05600c2caa00b003c701c12a17sm51549363wmc.12.2023.01.03.09.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:14:09 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH v3 stable 4.19 2/2] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Tue,  3 Jan 2023 18:13:57 +0100
Message-Id: <20230103171357.286343-2-jannh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230103171357.286343-1-jannh@google.com>
References: <20230103171357.286343-1-jannh@google.com>
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
index 0a4cace1cfc4..60f7df987567 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1303,13 +1303,20 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
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
 				mm_dec_nr_ptes(mm);
 				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
+				mmu_notifier_invalidate_range_end(mm, addr,
+								  end);
 			}
 			up_write(&mm->mmap_sem);
 		}
-- 
2.39.0.314.g84b9a713c41-goog

