Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99F3666781
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbjALAPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjALAPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2128D11F;
        Wed, 11 Jan 2023 16:15:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66EE8B81D92;
        Thu, 12 Jan 2023 00:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F570C433EF;
        Thu, 12 Jan 2023 00:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482532;
        bh=nqYnhvCD2FoAX8VHrPhxAzffPwBx05p+cxXvDxTBTIY=;
        h=Date:To:From:Subject:From;
        b=dZxCIxtZxm1vP1j2HwaNNydDq8EMrxgEodIpsKLsQ8ValluBDDc2wykFPpiRs6aGn
         HL6rtwL8A7tVH+ZqyilwBAdbRMQkwopaDCnPDD1e05Y+lxg88+OE/Wr7Hf2BTr5w2O
         66lMXJTqPg2Q794dwB+J0airchEYRsJEEq5sBrLc=
Date:   Wed, 11 Jan 2023 16:15:30 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, stable@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nommu-fix-split_vma-map_count-error.patch removed from -mm tree
Message-Id: <20230112001532.0F570C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nommu: fix split_vma() map_count error
has been removed from the -mm tree.  Its filename was
     nommu-fix-split_vma-map_count-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: nommu: fix split_vma() map_count error
Date: Mon, 9 Jan 2023 20:58:20 +0000

During the maple tree conversion of nommu, an error in counting the VMAs
was introduced by counting the existing VMA again.  The counting used to
be decremented by one and incremented by two, but now it only increments
by two.  Fix the counting error by moving the increment outside the
setup_vma_to_mm() function to the callers.

Link: https://lkml.kernel.org/r/20230109205809.956325-1-Liam.Howlett@oracle.com
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/nommu.c~nommu-fix-split_vma-map_count-error
+++ a/mm/nommu.c
@@ -559,7 +559,6 @@ void vma_mas_remove(struct vm_area_struc
 
 static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 {
-	mm->map_count++;
 	vma->vm_mm = mm;
 
 	/* add the VMA to the mapping */
@@ -587,6 +586,7 @@ static void mas_add_vma_to_mm(struct ma_
 	BUG_ON(!vma->vm_region);
 
 	setup_vma_to_mm(vma, mm);
+	mm->map_count++;
 
 	/* add the VMA to the tree */
 	vma_mas_store(vma, mas);
@@ -1347,6 +1347,7 @@ int split_vma(struct mm_struct *mm, stru
 	if (vma->vm_file)
 		return -ENOMEM;
 
+	mm = vma->vm_mm;
 	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
@@ -1398,6 +1399,7 @@ int split_vma(struct mm_struct *mm, stru
 	mas_set_range(&mas, vma->vm_start, vma->vm_end - 1);
 	mas_store(&mas, vma);
 	vma_mas_store(new, &mas);
+	mm->map_count++;
 	return 0;
 
 err_mas_preallocate:
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_empty_area_rev-lower-bound-validation.patch
maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

