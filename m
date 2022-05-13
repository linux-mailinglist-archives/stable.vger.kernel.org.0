Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6BC526425
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356414AbiEMO1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381121AbiEMO0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000182D8;
        Fri, 13 May 2022 07:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA096B8306E;
        Fri, 13 May 2022 14:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD1AC34100;
        Fri, 13 May 2022 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452003;
        bh=12YI1UGBZzsNCwc7wOpvDIuco1N5jvXCN9y084M/eS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TF49NBISrw454SlKH7LUFx3eAsJgEkHlhjHS9BsxZlJt7MxCdE3ctQyuyhgM7KSRb
         ZlD9o85gQ+0wOrCwp6m0R/9cJuFOB028EPZsJBFxFoqMA7bKkcS4Ust09XkMbJ+Xcx
         u7J3e0CJQXl1Qz9c8ODLfKuI5XRiSJglxpfUt5Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Zi Yan <ziy@nvidia.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Rientjes <rientjes@google.com>,
        Fam Zheng <fam.zheng@bytedance.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lars Persson <lars.persson@axis.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 16/18] mm: fix missing cache flush for all tail pages of compound page
Date:   Fri, 13 May 2022 16:23:42 +0200
Message-Id: <20220513142229.625666491@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
References: <20220513142229.153291230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Muchun Song <songmuchun@bytedance.com>

commit 2771739a7162782c0aa6424b2e3dd874e884a15d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -994,9 +994,12 @@ static int move_to_new_page(struct page
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


