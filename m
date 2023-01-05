Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA1D65E28B
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 02:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjAEBjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 20:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjAEBjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 20:39:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6B12011;
        Wed,  4 Jan 2023 17:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD074618BB;
        Thu,  5 Jan 2023 01:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3183EC433D2;
        Thu,  5 Jan 2023 01:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672882746;
        bh=BSTAnrWPIkm/Pe5UI9idcxx0FoqY/+2cqEy5WZiN3B4=;
        h=Date:To:From:Subject:From;
        b=M4R34xrTH9oUApyb9hit4JgYy8zgxKBRwAgQ30a7OCjXOGnpS3a69mpPMo6Bmj2WI
         mcfSAqsQ4EebBfmReW+XOoLkiu+ZfWxLBZhLgpYQg+2i5GVa+6qym5MqiDVD/L5WeB
         pJwEatD+ympBfZzjFNfdgSaNVcg0PtZ0FKDMiZQY=
Date:   Wed, 04 Jan 2023 17:39:05 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        pasha.tatashin@soleen.com, hughd@google.com, david@redhat.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20230105013906.3183EC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix vma->anon_name memory leak for anonymous shmem VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix vma->anon_name memory leak for anonymous shmem VMAs
Date: Wed, 4 Jan 2023 16:02:40 -0800

free_anon_vma_name() is missing a check for anonymous shmem VMA which
leads to a memory leak due to refcount not being dropped.  Fix this by
calling anon_vma_name_put() unconditionally.  It will free vma->anon_name
whenever it's non-NULL.

Link: https://lkml.kernel.org/r/20230105000241.1450843-1-surenb@google.com
Fixes: d09e8ca6cb93 ("mm: anonymous shared memory naming")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+91edf9178386a07d06a7@syzkaller.appspotmail.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm_inline.h~mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas
+++ a/include/linux/mm_inline.h
@@ -413,8 +413,7 @@ static inline void free_anon_vma_name(st
 	 * Not using anon_vma_name because it generates a warning if mmap_lock
 	 * is not held, which might be the case here.
 	 */
-	if (!vma->vm_file)
-		anon_vma_name_put(vma->anon_name);
+	anon_vma_name_put(vma->anon_name);
 }
 
 static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch

