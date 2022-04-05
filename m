Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE3C4F321B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbiDEJBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237545AbiDEImr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:42:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816C0E0F6;
        Tue,  5 Apr 2022 01:35:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08FCFB81B13;
        Tue,  5 Apr 2022 08:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDBBC385A1;
        Tue,  5 Apr 2022 08:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147699;
        bh=1DgkdNFO6r6H+hSygsx8JZmtOvDEknQ6vZRdHvFtBQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWFpmCXN58YV/PKEeXSIMEc7Hc4gCx2/sjVy0Xa3sR7rRGAo6RSecuz8wgZ0sZG4L
         IbQC1kOiSz7uo4iq/8Bfn3Dym+iI7CAAF2DiQv/S764UxZs3rXfH68Vf2UDuuM2xKl
         EYpTWPSGcIHZY9Ys3URg4IOOqnsg0k3GstTciayE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 0090/1017] mempolicy: mbind_range() set_policy() after vma_merge()
Date:   Tue,  5 Apr 2022 09:16:43 +0200
Message-Id: <20220405070356.865599231@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 4e0906008cdb56381638aa17d9c32734eae6d37a upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -783,7 +783,6 @@ static int vma_replace_policy(struct vm_
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
 {
-	struct vm_area_struct *next;
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
@@ -798,8 +797,7 @@ static int mbind_range(struct mm_struct
 	if (start > vma->vm_start)
 		prev = vma;
 
-	for (; vma && vma->vm_start < end; prev = vma, vma = next) {
-		next = vma->vm_next;
+	for (; vma && vma->vm_start < end; prev = vma, vma = vma->vm_next) {
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 
@@ -813,10 +811,6 @@ static int mbind_range(struct mm_struct
 				 new_pol, vma->vm_userfaultfd_ctx);
 		if (prev) {
 			vma = prev;
-			next = vma->vm_next;
-			if (mpol_equal(vma_policy(vma), new_pol))
-				continue;
-			/* vma_merge() joined vma && vma->next, case 8 */
 			goto replace;
 		}
 		if (vma->vm_start != vmstart) {


