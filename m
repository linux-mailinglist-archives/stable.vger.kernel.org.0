Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2549D6665A0
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 22:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbjAKV3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 16:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbjAKV3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 16:29:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A53B06;
        Wed, 11 Jan 2023 13:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8F1B61EDE;
        Wed, 11 Jan 2023 21:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35654C433D2;
        Wed, 11 Jan 2023 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673472542;
        bh=2Zj4Fl1Np9cMpLPAn6Rob3EsxJIMHQ6X0N+DD057Glo=;
        h=Date:To:From:Subject:From;
        b=HKShK6/oVoDRLCbFoms0G/yjJ6ppHfEZ9yY8yyRf3lfrxc9V2JA9PhIWxxDLY3+Sy
         Jyc1/up8Am/Ng88eNPg+dB780ewN6mEi8Q/YquauLK9R/982xbUiNGVjGRCQuIGAEK
         +hg8kDcVT6LbSK82QWHvw1mZTeaAoVRTLtK2/mjw=
Date:   Wed, 11 Jan 2023 13:29:01 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        stable@vger.kernel.org, shy828301@gmail.com,
        kirill.shutemov@linux.intel.com, david@redhat.com,
        jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-anon_vma-race.patch added to mm-hotfixes-unstable branch
Message-Id: <20230111212902.35654C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: fix ->anon_vma race
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-anon_vma-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-anon_vma-race.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/khugepaged: fix ->anon_vma race
Date: Wed, 11 Jan 2023 14:33:51 +0100

If an ->anon_vma is attached to the VMA, collapse_and_free_pmd() requires
it to be locked.  retract_page_tables() bails out if an ->anon_vma is
attached, but does this check before holding the mmap lock (as the comment
above the check explains).

If we racily merge an existing ->anon_vma (shared with a child process)
from a neighboring VMA, subsequent rmap traversals on pages belonging to
the child will be able to see the page tables that we are concurrently
removing while assuming that nothing else can access them.

Repeat the ->anon_vma check once we hold the mmap lock to ensure that
there really is no concurrent page table access.

Link: https://lkml.kernel.org/r/20230111133351.807024-1-jannh@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Jann Horn <jannh@google.com>
Reported-by: Zach O'Keefe <zokeefe@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-anon_vma-race
+++ a/mm/khugepaged.c
@@ -1642,7 +1642,7 @@ static int retract_page_tables(struct ad
 		 * has higher cost too. It would also probably require locking
 		 * the anon_vma.
 		 */
-		if (vma->anon_vma) {
+		if (READ_ONCE(vma->anon_vma)) {
 			result = SCAN_PAGE_ANON;
 			goto next;
 		}
@@ -1671,6 +1671,18 @@ static int retract_page_tables(struct ad
 		if ((cc->is_khugepaged || is_target) &&
 		    mmap_write_trylock(mm)) {
 			/*
+			 * Re-check whether we have an ->anon_vma, because
+			 * collapse_and_free_pmd() requires that either no
+			 * ->anon_vma exists or the anon_vma is locked.
+			 * We already checked ->anon_vma above, but that check
+			 * is racy because ->anon_vma can be populated under the
+			 * mmap lock in read mode.
+			 */
+			if (vma->anon_vma) {
+				result = SCAN_PAGE_ANON;
+				goto unlock_next;
+			}
+			/*
 			 * When a vma is registered with uffd-wp, we can't
 			 * recycle the pmd pgtable because there can be pte
 			 * markers installed.  Skip it only, so the rest mm/vma
_

Patches currently in -mm which might be from jannh@google.com are

mm-khugepaged-fix-anon_vma-race.patch

