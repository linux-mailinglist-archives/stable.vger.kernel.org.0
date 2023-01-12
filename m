Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C8866677F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbjALAPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbjALAPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECABD11F;
        Wed, 11 Jan 2023 16:15:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AFC161781;
        Thu, 12 Jan 2023 00:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C99C433EF;
        Thu, 12 Jan 2023 00:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482530;
        bh=7nWoV/7wgBo2A6supU5tvBTgMYX8nCrmSps4LKH1rNE=;
        h=Date:To:From:Subject:From;
        b=FWX5mrv1Bozb2fOwmCXKKS5P/tWc/ZeHWwPNDlqti2pnQudwJy3OipSmMxZDNdocm
         VFvJ7m68UD0uNUaxiEc4BMMjOmo4Pz6DguLsCvyp8O4aH1kSuYt9fIsxFV94JYtWxr
         6n5jKb9ZjCtUpc4+54SL4yScAbQ8THtIm0G9WxWg=
Date:   Wed, 11 Jan 2023 16:15:29 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, stable@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nommu-fix-do_munmap-error-path.patch removed from -mm tree
Message-Id: <20230112001530.69C99C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nommu: fix do_munmap() error path
has been removed from the -mm tree.  Its filename was
     nommu-fix-do_munmap-error-path.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maple_tree-fix-mas_empty_area_rev-lower-bound-validation.patch
maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

