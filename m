Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA95525E0E
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 11:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378737AbiEMI4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378665AbiEMI4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:56:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0135EDCA
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:56:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EE30B82CD3
        for <stable@vger.kernel.org>; Fri, 13 May 2022 08:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7194C34113;
        Fri, 13 May 2022 08:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652432194;
        bh=J3cBFEgxyN4dv86vcQIES/w0QcMslcz3WvVFvEjh67o=;
        h=Subject:To:Cc:From:Date:From;
        b=d2UrWPouuKxVzraxvPbCGYKoVQlPDnBMRbhzWHCBXPgQ+HZYqznekC+x0sajhS8e/
         d9jz7Jepw2jyijcX2Me8aBsd7YRlm77D+j5gNN+eMFK3E9kT/KoONRfM3xuE/P+/rG
         W2HL7Bo6bn2QVRGxgaWjjzsBVnY7ZDqa2pn3G8yQ=
Subject: FAILED: patch "[PATCH] mm: shmem: fix missing cache flush in" failed to apply to 5.10-stable tree
To:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, duanxiongchun@bytedance.com,
        fam.zheng@bytedance.com, kirill.shutemov@linux.intel.com,
        lars.persson@axis.com, mike.kravetz@oracle.com, peterx@redhat.com,
        rientjes@google.com, torvalds@linux-foundation.org, ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 May 2022 10:56:31 +0200
Message-ID: <1652432191198225@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 19b482c29b6f3805f1d8e93015847b89e2f7f3b1 Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 22 Mar 2022 14:42:05 -0700
Subject: [PATCH] mm: shmem: fix missing cache flush in
 shmem_mfill_atomic_pte()

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

diff --git a/mm/shmem.c b/mm/shmem.c
index f21eb0ef8ae0..01fd227b6947 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2364,8 +2364,10 @@ int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
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

