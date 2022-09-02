Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374845AAFCE
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiIBMoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237420AbiIBMng (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25B2EB855;
        Fri,  2 Sep 2022 05:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 349D7B82AA5;
        Fri,  2 Sep 2022 12:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D9CC433D7;
        Fri,  2 Sep 2022 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121928;
        bh=FyeLDq2PH9S41l9QFfUpiWJFrh1e22Akt8LbPtNul28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUwz6PpKP7WvVuIH2EjddkUu0kcLi3XTYNUIH4SZI5HPkR8gay5X5m1Qhw1334YXe
         qFmGdSf8G68sREdIOE8E63l+rN/c7W41qG6vw4PSfW2mSvrg2AvMgkxb6ZgCN4iN35
         M2osU0QqF6h9C1hBhOU2tOi4N/2udbsB70/5R1bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 09/73] mm/hugetlb: avoid corrupting page->mapping in hugetlb_mcopy_atomic_pte
Date:   Fri,  2 Sep 2022 14:18:33 +0200
Message-Id: <20220902121404.745542492@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5371,7 +5371,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	if (!huge_pte_none(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
-	if (vm_shared) {
+	if (page_in_pagecache) {
 		page_dup_rmap(page, true);
 	} else {
 		ClearHPageRestoreReserve(page);


