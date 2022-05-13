Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960C8525E4D
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 11:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378646AbiEMIyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378635AbiEMIyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:54:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BBA2B24C6
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:54:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ACE2B82CCE
        for <stable@vger.kernel.org>; Fri, 13 May 2022 08:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D925C34100;
        Fri, 13 May 2022 08:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652432073;
        bh=9NDHXkYrQDIX7BWEYEVc7vqJoSMKKDN2dVhXPtY8TE0=;
        h=Subject:To:Cc:From:Date:From;
        b=fVf8W5kULool8gDYU0QK7VVdoeSzE2gYYO8hOGCWYetXb3DP/mWWD+Dzf3gd9VX5h
         JxYFuYsHDJ9SdmiMSPPTuEGx3DQyN8tIqX+kk5ygTOlYMkl8ABT0ZPmN51dbE1HeCv
         LObWhRmAYD/1Vjxeyw/YF0sifugJZqlYVXdDuwLE=
Subject: FAILED: patch "[PATCH] mm: fix missing cache flush for all tail pages of compound" failed to apply to 4.9-stable tree
To:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, duanxiongchun@bytedance.com,
        fam.zheng@bytedance.com, kirill.shutemov@linux.intel.com,
        lars.persson@axis.com, mike.kravetz@oracle.com, peterx@redhat.com,
        rientjes@google.com, torvalds@linux-foundation.org, ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 May 2022 10:54:30 +0200
Message-ID: <1652432070139102@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2771739a7162782c0aa6424b2e3dd874e884a15d Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 22 Mar 2022 14:41:56 -0700
Subject: [PATCH] mm: fix missing cache flush for all tail pages of compound
 page

The D-cache maintenance inside move_to_new_page() only consider one
page, there is still D-cache maintenance issue for tail pages of
compound page (e.g. THP or HugeTLB).

THP migration is only enabled on x86_64, ARM64 and powerpc, while
powerpc and arm64 need to maintain the consistency between I-Cache and
D-Cache, which depends on flush_dcache_page() to maintain the
consistency between I-Cache and D-Cache.

But there is no issues on arm64 and powerpc since they already considers
the compound page cache flushing in their icache flush function.
HugeTLB migration is enabled on arm, arm64, mips, parisc, powerpc,
riscv, s390 and sh, while arm has handled the compound page cache flush
in flush_dcache_page(), but most others do not.

In theory, the issue exists on many architectures.  Fix this by not
using flush_dcache_folio() since it is not backportable.

Link: https://lkml.kernel.org/r/20220210123058.79206-3-songmuchun@bytedance.com
Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/migrate.c b/mm/migrate.c
index be0d5ae36dc1..996c0e386734 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -916,9 +916,12 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 		if (!PageMappingFlags(page))
 			page->mapping = NULL;
 
-		if (likely(!is_zone_device_page(newpage)))
-			flush_dcache_page(newpage);
+		if (likely(!is_zone_device_page(newpage))) {
+			int i, nr = compound_nr(newpage);
 
+			for (i = 0; i < nr; i++)
+				flush_dcache_page(newpage + i);
+		}
 	}
 out:
 	return rc;

