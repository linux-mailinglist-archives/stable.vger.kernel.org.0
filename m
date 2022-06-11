Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3105477B0
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 23:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiFKVWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 17:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiFKVWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 17:22:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E7018E15;
        Sat, 11 Jun 2022 14:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B799B80B48;
        Sat, 11 Jun 2022 21:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAA3C34116;
        Sat, 11 Jun 2022 21:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654982535;
        bh=qjrcib6KILgbnGmzm34HkLZtopOWPii/Vu4Htwb9x8I=;
        h=Date:To:From:Subject:From;
        b=LlzhhAMLKhwq54y1cvg9qxGaYKiORnZTfS9glqBJPitaef6OhmcZfzvPNQBw9fDmn
         dXaQUfg9IhdLCPlw21HyhFnYshs6RET9OtY8k9/lj1idU2yqiIup8YEwtBeSqsr4mg
         YpbYA6Vx8abrBM4uy/TNr3wSnHgnvlJcT/uST9+U=
Date:   Sat, 11 Jun 2022 14:22:14 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, hughd@google.com, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-userfaultfd-fix-uffdio_continue-on-fallocated-shmem-pages.patch removed from -mm tree
Message-Id: <20220611212215.3BAA3C34116@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-uffdio_continue-on-fallocated-shmem-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages
Date: Fri, 3 Jun 2022 13:57:41 -0700

When fallocate() is used on a shmem file, the pages we allocate can end up
with !PageUptodate.

Since UFFDIO_CONTINUE tries to find the existing page the user wants to
map with SGP_READ, we would fail to find such a page, since
shmem_getpage_gfp returns with a "NULL" pagep for SGP_READ if it discovers
!PageUptodate.  As a result, UFFDIO_CONTINUE returns -EFAULT, as it would
do if the page wasn't found in the page cache at all.

This isn't the intended behavior.  UFFDIO_CONTINUE is just trying to find
if a page exists, and doesn't care whether it still needs to be cleared or
not.  So, instead of SGP_READ, pass in SGP_NOALLOC.  This is the same,
except for one critical difference: in the !PageUptodate case, SGP_NOALLOC
will clear the page and then return it.  With this change, UFFDIO_CONTINUE
works properly (succeeds) on a shmem file which has been fallocated, but
otherwise not modified.

Link: https://lkml.kernel.org/r/20220603205741.12888-1-axelrasmussen@google.com
Fixes: 153132571f02 ("userfaultfd/shmem: support UFFDIO_CONTINUE for shmem")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-fix-uffdio_continue-on-fallocated-shmem-pages
+++ a/mm/userfaultfd.c
@@ -246,7 +246,7 @@ static int mcontinue_atomic_pte(struct m
 	struct page *page;
 	int ret;
 
-	ret = shmem_getpage(inode, pgoff, &page, SGP_READ);
+	ret = shmem_getpage(inode, pgoff, &page, SGP_NOALLOC);
 	if (ret)
 		goto out;
 	if (!page) {
_

Patches currently in -mm which might be from axelrasmussen@google.com are


