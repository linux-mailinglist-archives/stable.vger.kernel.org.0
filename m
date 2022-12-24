Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E91655B6D
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 23:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiLXWSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 17:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLXWSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 17:18:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC2B9FC7;
        Sat, 24 Dec 2022 14:18:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11D0D60AB8;
        Sat, 24 Dec 2022 22:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4840AC433EF;
        Sat, 24 Dec 2022 22:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671920329;
        bh=Hvrz4jXubPSc7sFeWlFDGBLv96lD5lBhXyUNQeKy7zw=;
        h=Date:To:From:Subject:From;
        b=VKt2YdEz7cU9Gtx1QtN+Qpgdh99MAq0Khi72EbVYJTyannr9LfLsS4l9ZJ5OlJnoM
         Ics/XO5DNJTeq2c4GoPoEPp7tDdyJiWAzEKsKa0eZtVntwDovZWnursU5aRBrWj5Gp
         yrKvhBN8XeoZ+Xli/nPaeNwQsmSM10+sXNQMXV4c=
Date:   Sat, 24 Dec 2022 14:18:46 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, hughd@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madv_collapse-dont-expand-collapse-when-vm_end-is-past-requested-end.patch added to mm-hotfixes-unstable branch
Message-Id: <20221224221849.4840AC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/MADV_COLLAPSE: don't expand collapse when vm_end is past requested end
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-madv_collapse-dont-expand-collapse-when-vm_end-is-past-requested-end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madv_collapse-dont-expand-collapse-when-vm_end-is-past-requested-end.patch

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

Don't expand the acted-on region when refetching vma->vm_end.

Link: https://lkml.kernel.org/r/20221224082035.3197140-1-zokeefe@google.com
Fixes: 4d24de9425f7 ("mm: MADV_COLLAPSE: refetch vm_end after reacquiring mmap_lock")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

mm-madv_collapse-dont-expand-collapse-when-vm_end-is-past-requested-end.patch
mm-shmem-restore-shmem_huge_deny-precedence-over-madv_collapse.patch

