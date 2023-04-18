Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389256E6E06
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjDRVXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjDRVXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:23:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DAB9EC9;
        Tue, 18 Apr 2023 14:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B642B63937;
        Tue, 18 Apr 2023 21:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19524C433D2;
        Tue, 18 Apr 2023 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681852967;
        bh=zKtfnFTyYkWw2rIPdPck5Jegz6IxK5vyzJLAjKJ3zrk=;
        h=Date:To:From:Subject:From;
        b=yj0z24cbwm8k3x5banpoOs7IICxLNIeS/jnYz1Gk19YWi7BIfpSn3MqAeGKFMLS1I
         CMk3XDCmfUIkbgLHbZlVEEC8nYGErnfXs8Vhyh7WT0dLERiLvi11wxk5gibwmGdplx
         BUgyzK3LshhU2HvpUtjo8HdIsWt331/c0ONCMkL8=
Date:   Tue, 18 Apr 2023 14:22:46 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rick.p.edgecombe@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-regression-fix-for-unmapped_area_topdown.patch removed from -mm tree
Message-Id: <20230418212247.19524C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: regression fix for unmapped_area{_topdown}
has been removed from the -mm tree.  Its filename was
     mm-mmap-regression-fix-for-unmapped_area_topdown.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: regression fix for unmapped_area{_topdown}
Date: Fri, 14 Apr 2023 14:59:19 -0400

The maple tree limits the gap returned to a window that specifically fits
what was asked.  This may not be optimal in the case of switching search
directions or a gap that does not satisfy the requested space for other
reasons.  Fix the search by retrying the operation and limiting the search
window in the rare occasion that a conflict occurs.

Link: https://lkml.kernel.org/r/20230414185919.4175572-1-Liam.Howlett@oracle.com
Fixes: 3499a13168da ("mm/mmap: use maple tree for unmapped_area{_topdown}")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   48 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-regression-fix-for-unmapped_area_topdown
+++ a/mm/mmap.c
@@ -1518,7 +1518,8 @@ static inline int accountable_mapping(st
  */
 static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap;
+	unsigned long length, gap, low_limit;
+	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 
@@ -1527,12 +1528,29 @@ static unsigned long unmapped_area(struc
 	if (length < info->length)
 		return -ENOMEM;
 
-	if (mas_empty_area(&mas, info->low_limit, info->high_limit - 1,
-				  length))
+	low_limit = info->low_limit;
+retry:
+	if (mas_empty_area(&mas, low_limit, info->high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.index;
 	gap += (info->align_offset - gap) & info->align_mask;
+	tmp = mas_next(&mas, ULONG_MAX);
+	if (tmp && (tmp->vm_flags & VM_GROWSDOWN)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) < gap + length - 1) {
+			low_limit = tmp->vm_end;
+			mas_reset(&mas);
+			goto retry;
+		}
+	} else {
+		tmp = mas_prev(&mas, 0);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			low_limit = vm_end_gap(tmp);
+			mas_reset(&mas);
+			goto retry;
+		}
+	}
+
 	return gap;
 }
 
@@ -1548,7 +1566,8 @@ static unsigned long unmapped_area(struc
  */
 static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap;
+	unsigned long length, gap, high_limit, gap_end;
+	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 	/* Adjust search length to account for worst case alignment overhead */
@@ -1556,12 +1575,31 @@ static unsigned long unmapped_area_topdo
 	if (length < info->length)
 		return -ENOMEM;
 
-	if (mas_empty_area_rev(&mas, info->low_limit, info->high_limit - 1,
+	high_limit = info->high_limit;
+retry:
+	if (mas_empty_area_rev(&mas, info->low_limit, high_limit - 1,
 				length))
 		return -ENOMEM;
 
 	gap = mas.last + 1 - info->length;
 	gap -= (gap - info->align_offset) & info->align_mask;
+	gap_end = mas.last;
+	tmp = mas_next(&mas, ULONG_MAX);
+	if (tmp && (tmp->vm_flags & VM_GROWSDOWN)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) <= gap_end) {
+			high_limit = vm_start_gap(tmp);
+			mas_reset(&mas);
+			goto retry;
+		}
+	} else {
+		tmp = mas_prev(&mas, 0);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			high_limit = tmp->vm_start;
+			mas_reset(&mas);
+			goto retry;
+		}
+	}
+
 	return gap;
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


