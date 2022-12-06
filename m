Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8701644A21
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbiLFRQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235691AbiLFRQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:40 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D9531EE6
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:39 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d1so24423707wrs.12
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uT6YW3ZpIquMMkC7IKgGnZwg0bSb1DsvmrCtaAZmZwg=;
        b=egriwHWjZuiRHIRSnDBI45iQ5twblyycUwWWSA8mfv/CR/QHHaCN0vef1rCDKEdwCp
         SM2lCASLIb4yvqIT07YQyL2c/hQ0we4gDmSUeAJOiDaWIFSKkR5U/jLq3X45UC4hTbBc
         MnKnd6qtIhOIIQBhvdILAoGpooQaRKHlh5U0A7xCBkaI0HzyOcBPDSWWs2uVjnpgFgSo
         /Hv8x4V5sC7kiPtY2SKkJ9vUPVKEUl5MLBn1a8IEMD/Fe2xmEgDB0Up+u2AZTQgsflVz
         BykKRS9Q0kvV6RW9xdr/tMF0qhe/JavA0wU6SD/kFaMjxRa3Qy/3+L0cO78AwRK8dDJh
         sWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uT6YW3ZpIquMMkC7IKgGnZwg0bSb1DsvmrCtaAZmZwg=;
        b=pKqljATplhufDmEI+wDeKVSs/CUOgJhe6xB0k196wBYZxZkaLL3SCqJDZOHwLjVYP8
         SdxutxzTCFtMybMi8x4zNf1Os3lBdnGpHNGnBf8voMbwqdOud9PTSnUuKQohxk8FcXd7
         cMn26W2wqP2GG64ewV7ylxPeXQVIqTgA2bIoEeTMKKjbZFumReED0B5/lJ0cOEaDnqqk
         Q/ddpx2iWBSEML+6iMyTWl2khDaagoGrM3N79YEKN3ptNB/MvinwtLe1mMidfUL1H17j
         PhRGIPYB0BHcEW2oabnEgRtMNV2kn9kcaATBxQ1FAuqT5/oxHgSOijUKyEgHA+gR107U
         GaDA==
X-Gm-Message-State: ANoB5pnhyV484kpp4jWLq6vp+DfoKOQCe47QJJXqzeM8Bbsc35918XI9
        mOatfAcLrhRXzBzatRiAfLLTBVwC9DvY75aZ
X-Google-Smtp-Source: AA0mqf72vJu6bNv5CIpN9xd7O0WKEmdCSq3YtaHAzOijJm2Pa0dJzscSMnZGBQy/tD9pM4XpSWC+Yg==
X-Received: by 2002:adf:e94c:0:b0:242:41e0:5e55 with SMTP id m12-20020adfe94c000000b0024241e05e55mr12346136wrn.104.1670346997911;
        Tue, 06 Dec 2022 09:16:37 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id l22-20020a05600c4f1600b003d1de805de5sm6561411wmq.16.2022.12.06.09.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:37 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 4.19 2/2] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Tue,  6 Dec 2022 18:16:08 +0100
Message-Id: <20221206171614.1183048-7-jannh@google.com>
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
index 561660966435..b1fed0d2439b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1290,13 +1290,20 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
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
2.39.0.rc0.267.gcb52ba06e7-goog

