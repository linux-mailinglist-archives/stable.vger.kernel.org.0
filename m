Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB18C611C2D
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJ1VHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJ1VH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:07:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239E8249D37;
        Fri, 28 Oct 2022 14:07:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4884B82CC0;
        Fri, 28 Oct 2022 21:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1BCC433C1;
        Fri, 28 Oct 2022 21:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991239;
        bh=LxBt0XZI/2TIxFritiR7o6Peu+bQkpS2Ct500WBR+0k=;
        h=Date:To:From:Subject:From;
        b=tyU05Tvi07JnwvO1e1dZBUV2iKolHXFmR8Z/6exsb54E1TG7Ulux5VT6t1DrG8AZM
         kqkNouMQL9ETrLF64SRzHJ6b1LQmZKOBUEe9oz/B6+Vi9mmYBKeSo1V8BRE1w0EkQs
         m78vYxnO/0+MX7sfjjhs74xtK7sFufv9cVqj8teI=
Date:   Fri, 28 Oct 2022 14:07:18 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        stable@vger.kernel.org, shy828301@gmail.com, david@redhat.com,
        apopple@nvidia.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch removed from -mm tree
Message-Id: <20221028210719.5E1BCC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: fix return value if all subpages of THPs are migrated successfully
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt.patch

