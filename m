Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA93C64A5EC
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 18:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiLLRcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 12:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLLRct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 12:32:49 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25DAEA6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:32:46 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id y16so12892326wrm.2
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5C9kI8SgZJmSI1TlAclMjxHv7RPCNM7AH9sGx7kYp8U=;
        b=EakQPkEN3TvI9KhiR4YTQEHuyf6SpMFr+2qwGY1LlgkOt7T6CVSFFEyILQAs2lf11w
         YH4EnwX40Jey9RaG6PUn7cM/pfiqmKjFvngs2suQOwrbUGwj1HS6+jbSQv9GZi8uuodC
         LkGeQk/ZzvoXYCkEYB7R/Jk9y4IUUk9nRMxQIWAQNvMYIRV2aZnrlZ7yeRa83MkYC+Ig
         RBsJTjgoGV2dbo+Latcz4jN+bLGBSW6sio/MvkWCu12MQSVhYteaNSIr98Nu5dGSwlMd
         0L50GPtSwYMR5k5RMg7GSwdSVfNGvqX3ML+5Qb9qNwyi4m5lAqf4duxY8xcLwhzvtgFt
         s6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5C9kI8SgZJmSI1TlAclMjxHv7RPCNM7AH9sGx7kYp8U=;
        b=yf9uDutyXMvexHNJL+FtS6rG6xK+RgVCkU2Raw3Lxcz4LrAnIdejn+kk5iIf2hhDos
         R6x/de3jINoUE2z33fXSMB4nXQZzVKTwKqiXeY6MJ9WYCtMUBBumxLust0YJMTIoknhQ
         jtaCaReEGx1U/WyJ2lngpOAfhEJF39lt8cWnpg+jvb0VhTaR50WvZ1bEkZMEUEhmQsnO
         vSZqmMTO5H5bFnQ6yo/J1QyKEzHFWHmf8ev2buGK0KsNluhfUM2jv+B9xyrf/Kor9TQw
         sU4q+NSDTwNBDmLKvh/KvSv71QUG34TFAJ+9KxJ+EgLofa9bNcHKk1e1TUdIEFBvo2+h
         2Dig==
X-Gm-Message-State: ANoB5pkr1UR+1ukDWEOq0uHH83Max0TTrEYOucLVCTB+2f6fvs84Z+Ba
        6PMsx5ajOiaVTpwnkrSjr236bXK7GznNHiJ2
X-Google-Smtp-Source: AA0mqf4/jDxMMp5JEE3S1OJvZr2LJYp51IIOdrGK67k76aQXZhe42byl5gSga1DWEu0PFzLzFvT5gQ==
X-Received: by 2002:a05:6000:256:b0:242:e80:7ce0 with SMTP id m22-20020a056000025600b002420e807ce0mr630510wrz.2.1670866365029;
        Mon, 12 Dec 2022 09:32:45 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d108:797c:2f44:5af6])
        by smtp.gmail.com with ESMTPSA id fc18-20020a05600c525200b003cfd64b6be1sm12961964wmb.27.2022.12.12.09.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 09:32:44 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 stable 4.19 2/2] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Mon, 12 Dec 2022 18:32:36 +0100
Message-Id: <20221212173238.963128-2-jannh@google.com>
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
index 0f217bb9b534..bddc1a20653d 100644
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
2.39.0.rc1.256.g54fd8350bd-goog

