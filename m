Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DBB5138DF
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349519AbiD1PqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349466AbiD1PqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:46:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201BEB8207;
        Thu, 28 Apr 2022 08:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C12CAB82DAA;
        Thu, 28 Apr 2022 15:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C982EC385BF;
        Thu, 28 Apr 2022 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160575;
        bh=tmemQG01tDxaffG/Pfuw0hVRBBqMxYFA4QXgyJ9KyB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNVbFGWj4w+O8XJzSS3u5R9zNz+eNvMzluHnAROJ8PEHSppWkxC/Kb1EazourJU6V
         4Pf1K0SgnT2l+azMe/3RAD14dhoQshgKCeVlL0FfDqoA7B4tVNV8aLs7zAkN33q04u
         +154IftS0pcbXeIt6+h5JRXfRcpSHmYNhcPmr5JA=
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
Subject: [PATCH AUTOSEL 05/14] mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()
Date:   Thu, 28 Apr 2022 17:42:13 +0200
Message-Id: <20220428154222.1230793-5-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1949; i=gregkh@linuxfoundation.org; h=from:subject; bh=Zpdi/DUYbYcHJZrH6XatoKk6jiOZB35pe/zLcwmmE6k=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW+8I7V/+7fotz2mnl0RMZRSeptb7+8HX9sc9WQ8Dz9v+ 4Y/m6IhlYRBkYpAVU2T5so3n6P6KQ4pehranYeawMoEMYeDiFICJvH/GME/XkV/0Z52gvsadlwwHQk K/Z987IsIwT1X64LHvwY/O7N29c9sv8zo+sbrDrQA=
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

commit 19b482c29b6f3805f1d8e93015847b89e2f7f3b1 upstream.

userfaultfd calls shmem_mfill_atomic_pte() which does not do any cache
flushing for the target page.  Then the target page will be mapped to
the user space with a different address (user address), which might have
an alias issue with the kernel address used to copy the data from the
user to.  Insert flush_dcache_page() in non-zero-page case.  And replace
clear_highpage() with clear_user_highpage() which already considers the
cache maintenance.

Link: https://lkml.kernel.org/r/20220210123058.79206-6-songmuchun@bytedance.com
Fixes: 8d1039634206 ("userfaultfd: shmem: add shmem_mfill_zeropage_pte for userfaultfd support")
Fixes: 4c27fe4c4c84 ("userfaultfd: shmem: add shmem_mcopy_atomic_pte for userfaultfd support")
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
 mm/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a09b29ec2b45..7a46419d331d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2357,8 +2357,10 @@ int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 				/* don't free the page */
 				goto out_unacct_blocks;
 			}
+
+			flush_dcache_page(page);
 		} else {		/* ZEROPAGE */
-			clear_highpage(page);
+			clear_user_highpage(page, dst_addr);
 		}
 	} else {
 		page = *pagep;
-- 
2.36.0

