Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273CE541559
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356420AbiFGUfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376822AbiFGU2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBAD1D92E7;
        Tue,  7 Jun 2022 11:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4188E612F2;
        Tue,  7 Jun 2022 18:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D63C385A2;
        Tue,  7 Jun 2022 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626796;
        bh=qV2DruYLPwyZRDN9vck8Ib0tA9uqVGuc67Tk42gUhNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fl8g7sEGGtOG/u/ftXW9ipOoqA8vTi5cHfxxEXLQfWP3kKbxUhDEZNxi5NUlzXj1G
         M/k9fbGe+PmfrxSnfVJGD2divbTJ6nzp4TMU7K2rE5dCdrR7OSYwhA0o5OqdC8WBZY
         yucfGVnPEn0BUvhwvXTyz+DMfzJ0l2Db6jJp4a/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Alistair Popple <apopple@nvidia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Ross Zwisler <zwisler@kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 506/772] dax: fix cache flush on PMD-mapped pages
Date:   Tue,  7 Jun 2022 19:01:38 +0200
Message-Id: <20220607165003.889379506@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit e583b5c472bd23d450e06f148dc1f37be74f7666 ]

The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
However, it does not cover the full pages in a THP except a head page.
Replace it with flush_cache_range() to fix this issue.  This is just a
documentation issue with the respect to properly documenting the expected
usage of cache flushing before modifying the pmd.  However, in practice
this is not a problem due to the fact that DAX is not available on
architectures with virtually indexed caches per:

  commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")

Link: https://lkml.kernel.org/r/20220403053957.10770-3-songmuchun@bytedance.com
Fixes: f729c8c9b24f ("dax: wrprotect pmd_t in dax_mapping_entry_mkclean")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index cd03485867a7..411ea6a0fe57 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -846,7 +846,8 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 			if (!pmd_dirty(*pmdp) && !pmd_write(*pmdp))
 				goto unlock_pmd;
 
-			flush_cache_page(vma, address, pfn);
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			pmd = pmdp_invalidate(vma, address, pmdp);
 			pmd = pmd_wrprotect(pmd);
 			pmd = pmd_mkclean(pmd);
-- 
2.35.1



