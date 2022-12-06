Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67387644A2B
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiLFRRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiLFRQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:16:47 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6E9326F1
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:16:46 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id n7so11687685wms.3
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ng9NZeBZqbTnG1sAcSagMlFal36lyYXPRzohhjYKRtI=;
        b=Hl/FGnoS3ck/e+lTjg+dJBiaYUrkZ9JWxpFXkkUQHnmsE+nxNXUbx0hcZtqLH9Px1a
         xQ2aI2oUMPqDJPEzQ6gcM6S1ZdaR2ST14Ar/d7OZMfARTRg2ntBTSrV0k6ePMQJ4FpBq
         0WJisvvU3TrBquFLMqx0hEC37i4l3uzur97xFYUsuCuNelhCYcldrzuV7WyLf1FFX3k8
         GkHw7tuQAjW3RW1Ydhc0gr5gZyf9ePZT6tk5rvCiRC40o7GWJjckiMbg+bIvyniMA7zP
         ez9qHu3dw24ubm/p+mlTJKP6L8uSMTSU+pm/HFFmbg1sYo+n65dWXtT1BwFyq5re+gVH
         MycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ng9NZeBZqbTnG1sAcSagMlFal36lyYXPRzohhjYKRtI=;
        b=quR/+ErKV37EjGh82FqDbMoa+jHGUZaynTBOvxdmqZO6VMsk+jzzn9Rc9J4kOdl+PH
         qfqIupx0+OQCNQjXDWOInlXfroRi751fMjKBPupgrBJP9kGlCicUcF20HbwTd0d0j6t3
         hApwlV2C3l+Uy+BwpETIpPMDj/dBk6NyWHQq5LTky5to2VTZuXI6div93oyqxIAazmsW
         9HP1WH2X+zcFxJ/S4dW5QM0EJHbuYWJwpmK6BkiyaGdI45SXXkZJffPuLC0T6ueGK4N+
         KVF8noqPbiTrL+hXXPLET+ZRWt9lgsF4kva8i52oaqoMWWxgILZJxSPNDBlvxMHnKXDe
         Y9kw==
X-Gm-Message-State: ANoB5pnVvdwuRu1dyp6/tZG4Ol7N2xcfnpJ/3t8FhRIwOk/FeCsxEUcr
        ccuoQIgsOJIUyhzOOZDpgikFnfj4YrWyI4qN
X-Google-Smtp-Source: AA0mqf6TXZKwQkfRsTYl7BWPbPtJ7QF+z5d41gVlc4Fn/7QZQPfhZejQwdYagN3KmynDJSo3OYVMpg==
X-Received: by 2002:a7b:ca45:0:b0:3c4:bda1:7c57 with SMTP id m5-20020a7bca45000000b003c4bda17c57mr67988776wml.6.1670347004804;
        Tue, 06 Dec 2022 09:16:44 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:d775:c942:f0bf:947f])
        by smtp.gmail.com with ESMTPSA id k4-20020adfd844000000b0023659925b2asm17496264wrl.51.2022.12.06.09.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:16:44 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Subject: [PATCH stable 6.0 3/3] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Tue,  6 Dec 2022 18:16:13 +0100
Message-Id: <20221206171614.1183048-12-jannh@google.com>
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
[backported, no changes necessary]
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/khugepaged.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1155d356d3ac..5935765bcb33 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1380,6 +1380,7 @@ static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *v
 				  unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t pmd;
+	struct mmu_notifier_range range;
 
 	mmap_assert_write_locked(mm);
 	if (vma->vm_file)
@@ -1391,8 +1392,12 @@ static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *v
 	if (vma->anon_vma)
 		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
 
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, addr,
+				addr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
 	tlb_remove_table_sync_one();
+	mmu_notifier_invalidate_range_end(&range);
 	mm_dec_nr_ptes(mm);
 	page_table_check_pte_clear_range(mm, addr, pmd);
 	pte_free(mm, pmd_pgtable(pmd));
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

