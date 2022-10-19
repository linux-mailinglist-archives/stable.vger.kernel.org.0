Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65D4603C2A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiJSIoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJSIn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:43:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2134F7FFA8;
        Wed, 19 Oct 2022 01:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B548617F2;
        Wed, 19 Oct 2022 08:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEEAC433D7;
        Wed, 19 Oct 2022 08:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168876;
        bh=I6MFGlUEj5EUaxpuOQQn/MHXXgwh2qEtqurcxmSeeuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ns9Yfy95osqnpTJttDjdi8pzcy12KIxreYWwK/VmvpYVejM82T/5gALnjiEAUlxM/
         GN8BNdMLMCJmiCz+zUogL9MNBz/2JwomZ+4Uj++d5FseuVSG5ISazFihs03XF0zr4f
         QflzDPXWlaUIx4woFdRX7HRI1gOXbEkvD0ZMC8ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        SeongJae Park <sj@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 084/862] mm/damon: validate if the pmd entry is present before accessing
Date:   Wed, 19 Oct 2022 10:22:51 +0200
Message-Id: <20221019083253.646689056@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -304,6 +304,11 @@ static int damon_mkold_pmd_entry(pmd_t *
 
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
@@ -431,6 +436,11 @@ static int damon_young_pmd_entry(pmd_t *
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


