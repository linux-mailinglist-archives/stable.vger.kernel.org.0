Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985AF60BDE4
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 00:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiJXWxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 18:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiJXWwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 18:52:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B6025C57;
        Mon, 24 Oct 2022 14:14:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44B5B615B8;
        Mon, 24 Oct 2022 21:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918EFC433D6;
        Mon, 24 Oct 2022 21:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666646023;
        bh=OhEoXwuGCqDCOVYZzRgnB5p5PlO8SCM4mT745q/Id2E=;
        h=Date:To:From:Subject:From;
        b=ZgNGAtLsPEwk3Etq5OpIr1LsUj81JuNeRznD1lBNQ+KgShj2AZENNRpZtYD9vmVBO
         xAZCsEypivvYTnZh2RJ7MHN6Yiafglbmzj7GbogwkrNnstU5RVUPmhLyKjIJ5eDxb1
         LwGWbcvrnz7zVJYdsaRqupl9spJ/GjeGLx+rEwVg=
Date:   Mon, 24 Oct 2022 14:13:42 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        stable@vger.kernel.org, shy828301@gmail.com, david@redhat.com,
        apopple@nvidia.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch added to mm-hotfixes-unstable branch
Message-Id: <20221024211343.918EFC433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix return value if all subpages of THPs are migrated successfully
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: fix return value if all subpages of THPs are migrated successfully
Date: Mon, 24 Oct 2022 16:34:21 +0800

During THP migration, if THPs are not migrated but they are split and all
subpages are migrated successfully, migrate_pages() will still return the
number of THP pages that were not migrated.  This will confuse the callers
of migrate_pages().  For example, the longterm pinning will failed though
all pages are migrated successfully.

Thus we should return 0 to indicate that all pages are migrated in this
case

Link: https://lkml.kernel.org/r/de386aa864be9158d2f3b344091419ea7c38b2f7.1666599848.git.baolin.wang@linux.alibaba.com
Fixes: b5bade978e9b ("mm: migrate: fix the return value of migrate_pages()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/migrate.c~mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully
+++ a/mm/migrate.c
@@ -1582,6 +1582,13 @@ out:
 	 */
 	list_splice(&ret_pages, from);
 
+	/*
+	 * Return 0 in case all subpages of fail-to-migrate THPs are
+	 * migrated successfully.
+	 */
+	if (list_empty(from))
+		rc = 0;
+
 	count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
 	count_vm_events(PGMIGRATE_FAIL, nr_failed_pages);
 	count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch
mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt.patch

