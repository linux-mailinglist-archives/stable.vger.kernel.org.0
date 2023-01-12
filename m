Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A9F66677A
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbjALAPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbjALAPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A0BD111;
        Wed, 11 Jan 2023 16:15:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D084B81CDE;
        Thu, 12 Jan 2023 00:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C39AC433EF;
        Thu, 12 Jan 2023 00:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482508;
        bh=HfO0Q1dxU0znNge8JeoGGW2KET85CW1EM07OvudTBvQ=;
        h=Date:To:From:Subject:From;
        b=Dz2U7gwDrV1jl6xH1sc5zYfp1oSCgAHvWdjFypzgoVDbRc68bEw+RVDAO3yk6xkrO
         ZSW8wZjbn8aSzH1O81tvmJu9t3OEO8SxmTw9WLLEf5UgS+GTq97tRTPBIv4oQIE9lG
         itCVVyBSdQ0y0ezAUsBkcld1fwlpT4u8bBj1nZVU=
Date:   Wed, 11 Jan 2023 16:15:07 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, hughd@google.com, david@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-restore-shmem_huge_deny-precedence-over-madv_collapse.patch removed from -mm tree
Message-Id: <20230112001508.1C39AC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE
has been removed from the -mm tree.  Its filename was
     mm-shmem-restore-shmem_huge_deny-precedence-over-madv_collapse.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/shmem: restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE
Date: Sat, 24 Dec 2022 00:20:35 -0800

SHMEM_HUGE_DENY is for emergency use by the admin, to disable allocation
of shmem huge pages if, for example, a dangerous bug is found in their
usage: see "deny" in Documentation/mm/transhuge.rst.  An app using
madvise(,,MADV_COLLAPSE) should not be allowed to override it: restore its
precedence over shmem_huge_force.

Restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE.

Link: https://lkml.kernel.org/r/20221224082035.3197140-2-zokeefe@google.com
Fixes: 7c6c6cc4d3a2 ("mm/shmem: add flag to enforce shmem THP in hugepage_vma_check()")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-restore-shmem_huge_deny-precedence-over-madv_collapse
+++ a/mm/shmem.c
@@ -478,12 +478,10 @@ bool shmem_is_huge(struct vm_area_struct
 	if (vma && ((vma->vm_flags & VM_NOHUGEPAGE) ||
 	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
 		return false;
-	if (shmem_huge_force)
-		return true;
-	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return true;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
+	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
+		return true;
 
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
_

Patches currently in -mm which might be from zokeefe@google.com are


