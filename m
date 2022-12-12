Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1020764A155
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiLLNij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbiLLNhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:37:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F6A13E38
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:37:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EED23B80D4D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B4BC433EF;
        Mon, 12 Dec 2022 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852251;
        bh=sKf3ZsI9gfQOtDSJE8Q/mGlMTz916LM0ih6v0olB0y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBanNlnFM2DAKebJB/k1/CV+nbbz2bAapKN/REFk7RqjIEU4c4+omGgpRqtjddT4h
         xCOTCHI4l4GuO/gJgIHyjuO+4QNJQxSoldV2qJ6fR6e9NVSr0xQDG1WwA4onRzmJvh
         2O5V8t/KhMs9M5pO44jNqgpQK3AldMvOyPEN4MAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jann Horn <jannh@google.com>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 044/157] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date:   Mon, 12 Dec 2022 14:16:32 +0100
Message-Id: <20221212130936.317089732@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.35.1



