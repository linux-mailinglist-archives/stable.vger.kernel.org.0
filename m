Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C336666780
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbjALAPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbjALAPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC8737536;
        Wed, 11 Jan 2023 16:15:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BD6261EFC;
        Thu, 12 Jan 2023 00:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96FFC433EF;
        Thu, 12 Jan 2023 00:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482528;
        bh=r7rWJHIb7WZZ9kmEdcYLhQqBp5BbDV4ag9v1yEPvMF4=;
        h=Date:To:From:Subject:From;
        b=O+PO3z3KJFqHBtt0OaQLT24sA+K/AApPEUhALPpqy95hbW1GL0VlcRK+gQSGTHss2
         FTUGu/0zqqd53CFeCzpJ45+6DhYwvEpMHHePyddmlZN3Of5siY9vkAZVcoi09fzRDk
         sO/CVeMaVqhMX7O5/T9d9LqBoD/V2+ei0ABtCbKg=
Date:   Wed, 11 Jan 2023 16:15:27 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, stable@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nommu-fix-memory-leak-in-do_mmap-error-path.patch removed from -mm tree
Message-Id: <20230112001528.C96FFC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nommu: fix memory leak in do_mmap() error path
has been removed from the -mm tree.  Its filename was
     nommu-fix-memory-leak-in-do_mmap-error-path.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: nommu: fix memory leak in do_mmap() error path
Date: Mon, 9 Jan 2023 20:55:21 +0000

The preallocation of the maple tree nodes may leak if the error path to
"error_just_free" is taken.  Fix this by moving the freeing of the maple
tree nodes to a shared location for all error paths.

Link: https://lkml.kernel.org/r/20230109205507.955577-1-Liam.Howlett@oracle.com
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~nommu-fix-memory-leak-in-do_mmap-error-path
+++ a/mm/nommu.c
@@ -1240,6 +1240,7 @@ share:
 error_just_free:
 	up_write(&nommu_region_sem);
 error:
+	mas_destroy(&mas);
 	if (region->vm_file)
 		fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
@@ -1250,7 +1251,6 @@ error:
 
 sharing_violation:
 	up_write(&nommu_region_sem);
-	mas_destroy(&mas);
 	pr_warn("Attempt to share mismatched mappings\n");
 	ret = -EINVAL;
 	goto error;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_empty_area_rev-lower-bound-validation.patch
maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

