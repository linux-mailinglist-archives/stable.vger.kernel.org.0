Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B04D6633CE
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 23:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbjAIWSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 17:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235561AbjAIWSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 17:18:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E8B1117A;
        Mon,  9 Jan 2023 14:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B930461460;
        Mon,  9 Jan 2023 22:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3166C433EF;
        Mon,  9 Jan 2023 22:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673302682;
        bh=ymZsekTDAc1VEVPFAqfV7G208VuP2rx57skrvug03Tk=;
        h=Date:To:From:Subject:From;
        b=PVGvHKffNamh58XVFvHigKwehXt5EeT1TDh6KHWdAGxfK8ZBIiJSoHnrkhm7aRqJl
         jK521+rQLUWFqy5Ji6F5k4v+eYfhRzMOvkwzIwZ7esAw9/RFEkLGQbwbqfpqtyBdt5
         ElXxFsIxj2za4iGbKTk1CXj9Ton0z2CuX4mRDu9w=
Date:   Mon, 09 Jan 2023 14:18:02 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, stable@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nommu-fix-do_munmap-error-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20230109221802.D3166C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nommu: fix do_munmap() error path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nommu-fix-do_munmap-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nommu-fix-do_munmap-error-path.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: nommu: fix do_munmap() error path
Date: Mon, 9 Jan 2023 20:57:21 +0000

When removing a VMA from the tree fails due to no memory, do not free the
VMA since a reference still exists.

Link: https://lkml.kernel.org/r/20230109205708.956103-1-Liam.Howlett@oracle.com
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/nommu.c~nommu-fix-do_munmap-error-path
+++ a/mm/nommu.c
@@ -1509,7 +1509,8 @@ int do_munmap(struct mm_struct *mm, unsi
 erase_whole_vma:
 	if (delete_vma_from_mm(vma))
 		ret = -ENOMEM;
-	delete_vma(mm, vma);
+	else
+		delete_vma(mm, vma);
 	return ret;
 }
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

nommu-fix-memory-leak-in-do_mmap-error-path.patch
nommu-fix-do_munmap-error-path.patch
nommu-fix-split_vma-map_count-error.patch
maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

