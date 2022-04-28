Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EAA5138E3
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347971AbiD1PqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349432AbiD1PqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:46:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C937AB3DCB;
        Thu, 28 Apr 2022 08:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78605B82E5E;
        Thu, 28 Apr 2022 15:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796F1C385AE;
        Thu, 28 Apr 2022 15:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160572;
        bh=FigP1rKu5Y706yYbX73vbKh4dLtC3zR1Bbs8LKoNESA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBgp7CDHDBsvGPmxf48mgvcPTrEKpp/9bsSeDh2RNuSe4Jl7Aje5Su/+kdCxUracj
         XEpcTr509prF175AmINfaAoIn+uFlPQX7U6p8a/Ts0gIz0noYMl16ZJLu2g2j5VA5j
         LJEGSqwpNGjD/aXx9OCtWiQKOZP+1twuLtmApyvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Rientjes <rientjes@google.com>,
        Fam Zheng <fam.zheng@bytedance.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Lars Persson <lars.persson@axis.com>,
        Peter Xu <peterx@redhat.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 04/14] mm: hugetlb: fix missing cache flush in hugetlb_mcopy_atomic_pte()
Date:   Thu, 28 Apr 2022 17:42:12 +0200
Message-Id: <20220428154222.1230793-4-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1942; i=gregkh@linuxfoundation.org; h=from:subject; bh=Bx716YFt3zvnDbB2iimMq8Rzl+VGbS5K+OqBTq22op8=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW+/8f37obMjhjuuxE7+eOxbQLHV3U5QhU8jWTDGbtK5k 0bM9HbEsDIJMDLJiiixftvEc3V9xSNHL0PY0zBxWJpAhDFycAjCRj0sY5sq4fmbQK5I9arnhlSKTcf W0vyytLxjmmekePSB2Zvnu+LBFLN2Xuf+aiWbzAAA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 348923665a0e50ad9fc0b3bb8127d3cb976691cc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a1da8757cc9c..e2dc190c6725 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5820,7 +5820,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 			*pagep = NULL;
 			goto out;
 		}
-		folio_copy(page_folio(page), page_folio(*pagep));
+		copy_user_huge_page(page, *pagep, dst_addr, dst_vma,
+				    pages_per_huge_page(h));
 		put_page(*pagep);
 		*pagep = NULL;
 	}
-- 
2.36.0

