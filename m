Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9432579D38
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbiGSMss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241488AbiGSMsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6EE8C761;
        Tue, 19 Jul 2022 05:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94936B81B1C;
        Tue, 19 Jul 2022 12:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABCDC341C6;
        Tue, 19 Jul 2022 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233131;
        bh=Xqwg7JtPMDLqWkar0qZiMQvS5epYSo4zrSmrUigssec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFcrKzzyYaDawnJqi1q2TSp9je9MH2/fqQu4H+leNj79Ew7Rr8FXoCI79cjUvrmmz
         DhuDUaim3z2RaRCswP6jc8kyXoHnVIWuiEZC6pLUQqPVJO4he74cTFq0ouU9kedpYq
         JSAQb9doM/3o4U105/hz/ToDzD1THYtHNvLQ8DlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 017/231] mm: sparsemem: fix missing higher order allocation splitting
Date:   Tue, 19 Jul 2022 13:51:42 +0200
Message-Id: <20220719114715.473649310@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 39d35edee4537487e5178f258e23518272a66413 upstream.

Higher order allocations for vmemmap pages from buddy allocator must be
able to be treated as indepdenent small pages as they can be freed
individually by the caller.  There is no problem for higher order vmemmap
pages allocated at boot time since each individual small page will be
initialized at boot time.  However, it will be an issue for memory hotplug
case since those higher order vmemmap pages are allocated from buddy
allocator without initializing each individual small page's refcount.  The
system will panic in put_page_testzero() when CONFIG_DEBUG_VM is enabled
if the vmemmap page is freed.

Link: https://lkml.kernel.org/r/20220620023019.94257-1-songmuchun@bytedance.com
Fixes: d8d55f5616cf ("mm: sparsemem: use page table lock to protect kernel pmd operations")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/sparse-vmemmap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f4fa61dbbee3..dbbd1a7e65f3 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -78,6 +78,14 @@ static int __split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
 
 	spin_lock(&init_mm.page_table_lock);
 	if (likely(pmd_leaf(*pmd))) {
+		/*
+		 * Higher order allocations from buddy allocator must be able to
+		 * be treated as indepdenent small pages (as they can be freed
+		 * individually).
+		 */
+		if (!PageReserved(page))
+			split_page(page, get_order(PMD_SIZE));
+
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
-- 
2.37.1



