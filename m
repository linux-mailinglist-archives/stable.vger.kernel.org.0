Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F6B525E95
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 11:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378653AbiEMI4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378747AbiEMI4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:56:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1968D27CCB
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8457B82CA1
        for <stable@vger.kernel.org>; Fri, 13 May 2022 08:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1DBC34100;
        Fri, 13 May 2022 08:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652432165;
        bh=GXl9Bpcd2mVu28UOFt/bdEZtjs9I9xWKinr9xV0yWUk=;
        h=Subject:To:Cc:From:Date:From;
        b=hxFB6zx2bOFP6Cdf2qeQEG760Bomjyo45YJIqbYGwJjL/bJUQyHFSXbXwShEmW4y/
         WudVZ8OtTkCXFhrRoABTi+XjYQ3YXzmaorpx2xtUHHPS1P3uly9uLo1gnU1dtadglz
         CPNJjewt9HVEQv1c+L3lv2+hGPR8UVQIK/R6oknc=
Subject: FAILED: patch "[PATCH] mm: hugetlb: fix missing cache flush in" failed to apply to 5.15-stable tree
To:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, duanxiongchun@bytedance.com,
        fam.zheng@bytedance.com, kirill.shutemov@linux.intel.com,
        lars.persson@axis.com, mike.kravetz@oracle.com, peterx@redhat.com,
        rientjes@google.com, torvalds@linux-foundation.org, ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 May 2022 10:56:02 +0200
Message-ID: <1652432162161131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

From 348923665a0e50ad9fc0b3bb8127d3cb976691cc Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 22 Mar 2022 14:42:02 -0700
Subject: [PATCH] mm: hugetlb: fix missing cache flush in
 hugetlb_mcopy_atomic_pte()

folio_copy() will copy the data from one page to the target page, then
the target page will be mapped to the user space address, which might
have an alias issue with the kernel address used to copy the data from
the page to.  There are 2 ways to fix this issue.

 1) insert flush_dcache_page() after folio_copy().

 2) replace folio_copy() with copy_user_huge_page() which already
    considers the cache maintenance.

We chose 2) way to fix the issue since architectures can optimize this
situation.  It is also make backports easier.

Link: https://lkml.kernel.org/r/20220210123058.79206-5-songmuchun@bytedance.com
Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a404af0b49a0..3d450f802823 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5816,7 +5816,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 			*pagep = NULL;
 			goto out;
 		}
-		folio_copy(page_folio(page), page_folio(*pagep));
+		copy_user_huge_page(page, *pagep, dst_addr, dst_vma,
+				    pages_per_huge_page(h));
 		put_page(*pagep);
 		*pagep = NULL;
 	}

