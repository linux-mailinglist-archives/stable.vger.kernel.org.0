Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6CE644A1B
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbiLFRQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiLFRQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:29 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7259E2188D
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:28 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id m14so24445648wrh.7
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0xyPzMK8aZT42PU9SFloI5pO/HMq7geQSaF2uDGzpg=;
        b=peSpwC2anpKoImJ1wUf7retz31009uPQhtJOwag+lnvh+mIiC8kLKJxCO09XJym9hg
         zC7pIN6u8QQ3BfDkUPUmzBZGzbT6BFj9lZMZOtup85Y1kFS/7fao1SgTTgsgInVV1Kt4
         TlqjIoaTXnj3W/Ot88tCOaE/XeOgayt6aNKtTlF+zzLnKlllIHHEW64JKhwZQRq7a6jI
         2+sZzjSoqTB35UbP0vlLxoikt9bfWRoBferbuquK4UwjfPU9JhXh0fzTbq0R4k+2a08C
         X4lNR6lPNVim6I+mAZKYEuNGVONK7BjMuNChW1aO/fU2TclFRjnlJHbnuquADqzvbrPq
         8YMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0xyPzMK8aZT42PU9SFloI5pO/HMq7geQSaF2uDGzpg=;
        b=EkLBpoIWZ4KR9XTaS+ttn2Fmy2a2IkJXtzwBs8F71Do1b5+IUMnVKA2zAbeIfXPhDJ
         4EqvQjRePjXaA8Wlemyct3CBT6NMnxprU8MAIJEgYOlCvTfeSjLIJUSjLJm+jWtjiPTc
         DoZGYy/R2JN00XtyA63mrljdTZ8HpV9gWuuOvYLA4+KMMdkxq6FfgGPHbcHEvIM3hN5V
         dKT5Hm07JDcncFswp6guLF8ldZLFPWLNltUN1LW1ZQcg0kU2FqEmdcfRTN/q9ug8rmti
         c+SvMJR78apA01M6bL/qU+rlpA4oi+ECylLF5KuSzP3FLuJUhS831XNMOx8WeiMmn2yK
         7iAg==
X-Gm-Message-State: ANoB5pmtJkyEfjyitTuHCwUhH43moUgp412Ry4+zVNZl5CuPWD4e0Qz8
        kFaqSU7Duttwg8nm+bggp5iywjrg0I/3BrFZ
X-Google-Smtp-Source: AA0mqf4/OXced4oOf1NhuTbmp/7q9foSAWknfk5H0+xXuKTC/Epv92jA3DhqYmypl1edbFf0pMhL2A==
X-Received: by 2002:adf:fb45:0:b0:241:ea14:f22b with SMTP id c5-20020adffb45000000b00241ea14f22bmr37077859wrs.460.1670346986978;
        Tue, 06 Dec 2022 09:16:26 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id h130-20020a1c2188000000b003b4fdbb6319sm25209861wmh.21.2022.12.06.09.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:26 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 4.9,4.14 2/2] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Tue,  6 Dec 2022 18:16:03 +0100
Message-Id: <20221206171614.1183048-2-jannh@google.com>
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
helper between 5.15 and 6.0;
pmd collapse for PTE-mapped THP was only added in 5.4;
MMU notifier API changed between 4.19 and 5.4]
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/khugepaged.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f67c02010add..7ad88b9e5a65 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1291,13 +1291,20 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
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
2.39.0.rc0.267.gcb52ba06e7-goog

