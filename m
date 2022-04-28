Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E625138DE
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349529AbiD1Pq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349506AbiD1PqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:46:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B9EB715C;
        Thu, 28 Apr 2022 08:43:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB08EB82DAA;
        Thu, 28 Apr 2022 15:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D529FC385AF;
        Thu, 28 Apr 2022 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160578;
        bh=cUTeQdSbuKp1C1IB6s6cp2R4rK9jLAPr9VFjKwq5OVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVbN9lEcnOc/+Jxc3KuGDhg6Dr8dnI5JqV5nzay/g7SJqVoLqShtoT6oewTEOLYwD
         flLEKLx58kSL9hiOdWdGzg23ZYE1TfoW1gPGUCsbpTcgy2HWR66hQLfLqNuQoFf7my
         sW0RXQzWXELykHKHBoXm5bo5DKucM8/ujbgHuW0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Rientjes <rientjes@google.com>,
        Fam Zheng <fam.zheng@bytedance.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Lars Persson <lars.persson@axis.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 06/14] mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()
Date:   Thu, 28 Apr 2022 17:42:14 +0200
Message-Id: <20220428154222.1230793-6-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1990; i=gregkh@linuxfoundation.org; h=from:subject; bh=w/4yshSSx6bYlycE+CXvFti1EqgLl8fqTCv8PDJp7+o=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW+8emM35cFrCfpYrsaulchb4ctgd5eWKLZG7/95q8YWr nNd3dcSyMAgyMciKKbJ82cZzdH/FIUUvQ9vTMHNYmUCGMHBxCsBErtQyLJh7/oDIuZBg9RvHvypanU rzKWsu+8swP+T74rvTtdWWGBqf3uH1JJPj3tWP0gA=
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

commit 7c25a0b89a487878b0691e6524fb5a8827322194 upstream.

userfaultfd calls mcopy_atomic_pte() and __mcopy_atomic() which do not
do any cache flushing for the target page.  Then the target page will be
mapped to the user space with a different address (user address), which
might have an alias issue with the kernel address used to copy the data
from the user to.  Fix this by insert flush_dcache_page() after
copy_from_user() succeeds.

Link: https://lkml.kernel.org/r/20220210123058.79206-7-songmuchun@bytedance.com
Fixes: b6ebaedb4cb1 ("userfaultfd: avoid mmap_sem read recursion in mcopy_atomic")
Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 885e5adb0168..7259f96faaa0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -153,6 +153,8 @@ static int mcopy_atomic_pte(struct mm_struct *dst_mm,
 			/* don't free the page */
 			goto out;
 		}
+
+		flush_dcache_page(page);
 	} else {
 		page = *pagep;
 		*pagep = NULL;
@@ -628,6 +630,7 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 				err = -EFAULT;
 				goto out;
 			}
+			flush_dcache_page(page);
 			goto retry;
 		} else
 			BUG_ON(page);
-- 
2.36.0

