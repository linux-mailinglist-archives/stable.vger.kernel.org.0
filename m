Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A19B4E489C
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 22:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbiCVVrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 17:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiCVVr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 17:47:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0647F5F8C1;
        Tue, 22 Mar 2022 14:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99B86615B1;
        Tue, 22 Mar 2022 21:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3C8C340EE;
        Tue, 22 Mar 2022 21:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985560;
        bh=vksHlh41Yl8TntR4WEXfMzLzqp4dQjqNQcVeZWBmRXI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=kBzVph6uHpG5u7ts3Lowr6XsitPhMfna0Tw9PvqqB5J8umZ/w7LKMaAQE46N5cw4B
         c5P5IW7TtpPd1ltOob5kQcKROBkO5AI0+IYlZp4a/dOP1qXhfc35exp4VTrDxJJy7g
         unis9W2tc8uU0g3+xvOPHfGIglVgVM8VdrGpwscc=
Date:   Tue, 22 Mar 2022 14:45:59 -0700
To:     vbabka@suse.cz, stable@vger.kernel.org, oleg@redhat.com,
        Liam.Howlett@oracle.com, hughd@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 147/227] mempolicy: mbind_range() set_policy() after vma_merge()
Message-Id: <20220322214559.ED3C8C340EE@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mempolicy: mbind_range() set_policy() after vma_merge()

v2.6.34 commit 9d8cebd4bcd7 ("mm: fix mbind vma merge problem") introduced
vma_merge() to mbind_range(); but unlike madvise, mlock and mprotect, it
put a "continue" to next vma where its precedents go to update flags on
current vma before advancing: that left vma with the wrong setting in the
infamous vma_merge() case 8.

v3.10 commit 1444f92c8498 ("mm: merging memory blocks resets mempolicy")
tried to fix that in vma_adjust(), without fully understanding the issue.

v3.11 commit 3964acd0dbec ("mm: mempolicy: fix mbind_range() &&
vma_adjust() interaction") reverted that, and went about the fix in the
right way, but chose to optimize out an unnecessary mpol_dup() with a
prior mpol_equal() test.  But on tmpfs, that also pessimized out the vital
call to its ->set_policy(), leaving the new mbind unenforced.

The user visible effect was that the pages got allocated on the local
node (happened to be 0), after the mbind() caller had specifically
asked for them to be allocated on node 1.  There was not any page
migration involved in the case reported: the pages simply got allocated
on the wrong node.

Just delete that optimization now (though it could be made conditional on
vma not having a set_policy).  Also remove the "next" variable: it turned
out to be blameless, but also pointless.

Link: https://lkml.kernel.org/r/319e4db9-64ae-4bca-92f0-ade85d342ff@google.com
Fixes: 3964acd0dbec ("mm: mempolicy: fix mbind_range() && vma_adjust() interaction")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/mempolicy.c~mempolicy-mbind_range-set_policy-after-vma_merge
+++ a/mm/mempolicy.c
@@ -786,7 +786,6 @@ static int vma_replace_policy(struct vm_
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
 {
-	struct vm_area_struct *next;
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
@@ -801,8 +800,7 @@ static int mbind_range(struct mm_struct
 	if (start > vma->vm_start)
 		prev = vma;
 
-	for (; vma && vma->vm_start < end; prev = vma, vma = next) {
-		next = vma->vm_next;
+	for (; vma && vma->vm_start < end; prev = vma, vma = vma->vm_next) {
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 
@@ -817,10 +815,6 @@ static int mbind_range(struct mm_struct
 				 anon_vma_name(vma));
 		if (prev) {
 			vma = prev;
-			next = vma->vm_next;
-			if (mpol_equal(vma_policy(vma), new_pol))
-				continue;
-			/* vma_merge() joined vma && vma->next, case 8 */
 			goto replace;
 		}
 		if (vma->vm_start != vmstart) {
_
