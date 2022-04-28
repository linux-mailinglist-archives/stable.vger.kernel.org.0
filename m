Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED57F5138E2
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349403AbiD1Ppt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344055AbiD1Ppo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:45:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EFAAC04B;
        Thu, 28 Apr 2022 08:42:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F8A61F95;
        Thu, 28 Apr 2022 15:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E38AC385A0;
        Thu, 28 Apr 2022 15:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160548;
        bh=W6JZHURiD6S8sCBWTVgKCEUD2N8YrqtIi8H2lqDIUIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FTCNuEMytEk2OLSJR+am6TFPzLZzc9hAU1K91ZblJPHOU3wXQN8kU6njVxB8Py/l
         M36IPZ6KvEBBoep7xbkFbx5r+H3i9WqDDOrSesrxA394/eBd4mGWEqQoOCqjrRfn/Q
         QskWcYrWsaZI4jQM1mJ2aVtC2QaJznoMfzJqN8Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Muchun Song <songmuchun@bytedance.com>, Zi Yan <ziy@nvidia.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Rientjes <rientjes@google.com>,
        Fam Zheng <fam.zheng@bytedance.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Lars Persson <lars.persson@axis.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 02/14] mm: fix missing cache flush for all tail pages of compound page
Date:   Thu, 28 Apr 2022 17:42:10 +0200
Message-Id: <20220428154222.1230793-2-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2363; i=gregkh@linuxfoundation.org; h=from:subject; bh=tzQoyaSqlxtKRFY8pVM4ItgoSNdr8h3zMFKbCiWeB+o=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW++4TAoPCs68vr7igM3rJk+lvg4Rixv6869mVp2wv2Cx +2N3RywLgyATg6yYIsuXbTxH91ccUvQytD0NM4eVCWQIAxenAEzk/FeGBWdvSqqovPy9V3b1Oqf2r0 sqt79pk2SYHyd3/rzal4VSM3hYg4XL8hQ/L9jwCAA=
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
 mm/migrate.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 086a36637467..fc0e14ecd42a 100644
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
-- 
2.36.0

