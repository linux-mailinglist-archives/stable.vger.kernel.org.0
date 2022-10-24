Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144CE60B8A5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiJXTwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiJXTvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:51:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5381B7AB;
        Mon, 24 Oct 2022 11:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44E19B81147;
        Mon, 24 Oct 2022 12:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A125DC433C1;
        Mon, 24 Oct 2022 12:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614931;
        bh=eG772EymcZ2/cocaXc0a5fNVtPwx5zmLGY63ykM1Z74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5rcD71hxY3wZhxt78nnD5E1vt8iGgikFTHOaJUGRsn2r3NILwcmgjkZ+AEkD0+cz
         qOyJGoh5di4mnmhqoBOa+Xnrv+iRWig9Kmp84qu1wTKduSLlxVZfLSGyTsjvY5arhM
         Zxp1A245tC8RqSC3bUMrFwN0HUJVVXrOKrKLBe6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        SeongJae Park <sj@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 057/530] mm/damon: validate if the pmd entry is present before accessing
Date:   Mon, 24 Oct 2022 13:26:41 +0200
Message-Id: <20221024113047.621856529@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit c8b9aff419303e4d4219b5ff64b1c7e062dee48e upstream.

pmd_huge() is used to validate if the pmd entry is mapped by a huge page,
also including the case of non-present (migration or hwpoisoned) pmd entry
on arm64 or x86 architectures.  This means that pmd_pfn() can not get the
correct pfn number for a non-present pmd entry, which will cause
damon_get_page() to get an incorrect page struct (also may be NULL by
pfn_to_online_page()), making the access statistics incorrect.

This means that the DAMON may make incorrect decision according to the
incorrect statistics, for example, DAMON may can not reclaim cold page
in time due to this cold page was regarded as accessed mistakenly if
DAMOS_PAGEOUT operation is specified.

Moreover it does not make sense that we still waste time to get the page
of the non-present entry.  Just treat it as not-accessed and skip it,
which maintains consistency with non-present pte level entries.

So add pmd entry present validation to fix the above issues.

Link: https://lkml.kernel.org/r/58b1d1f5fbda7db49ca886d9ef6783e3dcbbbc98.1660805030.git.baolin.wang@linux.alibaba.com
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -456,6 +456,11 @@ static int damon_mkold_pmd_entry(pmd_t *
 
 	if (pmd_huge(*pmd)) {
 		ptl = pmd_lock(walk->mm, pmd);
+		if (!pmd_present(*pmd)) {
+			spin_unlock(ptl);
+			return 0;
+		}
+
 		if (pmd_huge(*pmd)) {
 			damon_pmdp_mkold(pmd, walk->mm, addr);
 			spin_unlock(ptl);
@@ -530,6 +535,11 @@ static int damon_young_pmd_entry(pmd_t *
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_huge(*pmd)) {
 		ptl = pmd_lock(walk->mm, pmd);
+		if (!pmd_present(*pmd)) {
+			spin_unlock(ptl);
+			return 0;
+		}
+
 		if (!pmd_huge(*pmd)) {
 			spin_unlock(ptl);
 			goto regular_page;


