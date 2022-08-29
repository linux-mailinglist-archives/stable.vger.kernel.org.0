Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3973A5A43D8
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiH2HiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH2HiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:38:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1894A4E639
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A90816112E
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8524C433C1;
        Mon, 29 Aug 2022 07:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661758692;
        bh=lDxf3ofkbN63R3jFC6iwDii2DotY2XqdYPt3P8wJ/og=;
        h=Subject:To:Cc:From:Date:From;
        b=0L1J1WU8NafGnVidj8IFaeHgKUa06eOisbN5QPC95sNkvjK0nvuZUL5SZntJ+c1rc
         h4cPaAzp8LRC4WwOcK3gRuaupdr6eeheYg46K9V5YxejVI3mqn2K59CEwHzF1gkSLd
         eSrpWIrlnwvqv7C+fr1LUlJRYGPs7BKWbxFCOArw=
Subject: FAILED: patch "[PATCH] mm/hugetlb: avoid corrupting page->mapping in" failed to apply to 5.15-stable tree
To:     linmiaohe@huawei.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        peterx@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:38:09 +0200
Message-ID: <166175868922875@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ab74ef708dc51df7cf2b8a890b9c6990fac5c0c6 Mon Sep 17 00:00:00 2001
From: Miaohe Lin <linmiaohe@huawei.com>
Date: Tue, 12 Jul 2022 21:05:42 +0800
Subject: [PATCH] mm/hugetlb: avoid corrupting page->mapping in
 hugetlb_mcopy_atomic_pte

In MCOPY_ATOMIC_CONTINUE case with a non-shared VMA, pages in the page
cache are installed in the ptes.  But hugepage_add_new_anon_rmap is called
for them mistakenly because they're not vm_shared.  This will corrupt the
page->mapping used by page cache code.

Link: https://lkml.kernel.org/r/20220712130542.18836-1-linmiaohe@huawei.com
Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2480ba627aa5..e070b8593b37 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6041,7 +6041,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	if (!huge_pte_none_mostly(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
-	if (vm_shared) {
+	if (page_in_pagecache) {
 		page_dup_file_rmap(page, true);
 	} else {
 		ClearHPageRestoreReserve(page);

