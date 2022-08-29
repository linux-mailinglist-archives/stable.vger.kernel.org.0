Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196BD5A4A93
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiH2LnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiH2Lmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:42:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7386A857CB;
        Mon, 29 Aug 2022 04:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18F4761128;
        Mon, 29 Aug 2022 11:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2031BC433D6;
        Mon, 29 Aug 2022 11:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771930;
        bh=kqkVxhuCaRG2+GSbJDbaLUZwPMnCwLQMfdS0t1ErPWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKQyOA3v/warpGV3X7Y4d/ht/r/3QA/9r+s8JOpo67s28lX1lNKCCVSHUievqg5P4
         QM68ZtGzZMdkA42NGVhfMqNhmdM02g7MYzxGahBIilQ47xcq2LAjjloayLH+o4T7n4
         QluEFZw4oon+wFHYzPrql6A0HCPwWky27xYbjBvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 117/158] mm/hugetlb: avoid corrupting page->mapping in hugetlb_mcopy_atomic_pte
Date:   Mon, 29 Aug 2022 12:59:27 +0200
Message-Id: <20220829105814.014988421@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit ab74ef708dc51df7cf2b8a890b9c6990fac5c0c6 upstream.

In MCOPY_ATOMIC_CONTINUE case with a non-shared VMA, pages in the page
cache are installed in the ptes.  But hugepage_add_new_anon_rmap is called
for them mistakenly because they're not vm_shared.  This will corrupt the
page->mapping used by page cache code.

Link: https://lkml.kernel.org/r/20220712130542.18836-1-linmiaohe@huawei.com
Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6026,7 +6026,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	if (!huge_pte_none_mostly(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
-	if (vm_shared) {
+	if (page_in_pagecache) {
 		page_dup_file_rmap(page, true);
 	} else {
 		ClearHPageRestoreReserve(page);


