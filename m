Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7062E666778
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbjALAPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbjALAPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9104F15F12;
        Wed, 11 Jan 2023 16:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CF5A61F0F;
        Thu, 12 Jan 2023 00:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D024C433EF;
        Thu, 12 Jan 2023 00:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482506;
        bh=uBRcwDcbhBztp/7dqAtIBBmVoMa+y9qiXx9dY0lbIzs=;
        h=Date:To:From:Subject:From;
        b=o6lvs9YPKeK8koho24WVSScZeBY8+JnhkyEStAhGnF2I/kOB7NmjU+/xYXCUQohmn
         IjpPXZX+pawv3YHrI5WowaUxVruS4oLvf00HKJpVA6x3WoVHFucZgKh9y+1H6uAqD9
         YBEMTm/3hB2d0Qo+RpR2S7M4N1bO3o8SqndL0lyw=
Date:   Wed, 11 Jan 2023 16:15:05 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, hughd@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-madv_collapse-dont-expand-collapse-when-vm_end-is-past-requested-end.patch removed from -mm tree
Message-Id: <20230112001506.7D024C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/MADV_COLLAPSE: don't expand collapse when vm_end is past requested end
has been removed from the -mm tree.  Its filename was
     mm-madv_collapse-dont-expand-collapse-when-vm_end-is-past-requested-end.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/MADV_COLLAPSE: don't expand collapse when vm_end is past requested end
Date: Sat, 24 Dec 2022 00:20:34 -0800

MADV_COLLAPSE acts on one hugepage-aligned/sized region at a time, until
it has collapsed all eligible memory contained within the bounds supplied
by the user.

At the top of each hugepage iteration we (re)lock mmap_lock and
(re)validate the VMA for eligibility and update variables that might have
changed while mmap_lock was dropped.  One thing that might occur is that
the VMA could be resized, and as such, we refetch vma->vm_end to make sure
we don't collapse past the end of the VMA's new end.

However, it's possible that when refetching vma->vm_end that we expand the
region acted on by MADV_COLLAPSE if vma->vm_end is greater than size+len
supplied by the user.

The consequence here is that we may attempt to collapse more memory than
requested, possibly yielding either "too much success" or "false failure"
user-visible results.  An example of the former is if we MADV_COLLAPSE the
first 4MiB of a 2TiB mmap()'d file, the incorrect refetch would cause the
operation to block for much longer than anticipated as we attempt to
collapse the entire TiB region.  An example of the latter is that applying
MADV_COLLPSE to a 4MiB file mapped to the start of a 6MiB VMA will
successfully collapse the first 4MiB, then incorrectly attempt to collapse
the last hugepage-aligned/sized region -- fail (since readahead/page cache
lookup will fail) -- and report a failure to the user.

I don't believe there is a kernel stability concern here as we always
(re)validate the VMA / region accordingly.  Also as Hugh mentions, the
user-visible effects are: we try to collapse more memory than requested
by the user, and/or failing an operation that should have otherwise
succeeded.  An example is trying to collapse a 4MiB file contained
within a 12MiB VMA.

Don't expand the acted-on region when refetching vma->vm_end.

Link: https://lkml.kernel.org/r/20221224082035.3197140-1-zokeefe@google.com
Fixes: 4d24de9425f7 ("mm: MADV_COLLAPSE: refetch vm_end after reacquiring mmap_lock")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-madv_collapse-dont-expand-collapse-when-vm_end-is-past-requested-end
+++ a/mm/khugepaged.c
@@ -2647,7 +2647,7 @@ int madvise_collapse(struct vm_area_stru
 				goto out_nolock;
 			}
 
-			hend = vma->vm_end & HPAGE_PMD_MASK;
+			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
_

Patches currently in -mm which might be from zokeefe@google.com are


