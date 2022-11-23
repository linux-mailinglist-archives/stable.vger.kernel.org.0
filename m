Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E2C634E0C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 03:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbiKWCxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 21:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235594AbiKWCxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 21:53:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB5E8DA41;
        Tue, 22 Nov 2022 18:53:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AA3161A05;
        Wed, 23 Nov 2022 02:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721C2C433D6;
        Wed, 23 Nov 2022 02:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171994;
        bh=kldJ5OS7elwHMefD+Wx4q3drM1aCX8OiY/uvVrvh1KA=;
        h=Date:To:From:Subject:From;
        b=oz2BpGs7Sz3vAEddGHe3bm9kqM0VY6kaDsWnukz0wt4qF48Y3CgMR4Qz/13MThbvu
         hFbsX8N97UVpu5qdFM3YeRDAUW0nHH4SuJLyyAPVefMeFz7KpjFsO9mZ6J8Qf0cz3d
         A0wyLgEPGGBARz20QjCs+gsL2fdcwBmgGTK9F6Yk=
Date:   Tue, 22 Nov 2022 18:53:13 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed.patch removed from -mm tree
Message-Id: <20221123025314.721C2C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: skip stats update if the scheme directory is removed
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: skip stats update if the scheme directory is removed
Date: Mon, 14 Nov 2022 17:55:52 +0000

A DAMON sysfs interface user can start DAMON with a scheme, remove the
sysfs directory for the scheme, and then ask update of the scheme's stats.
Because the schemes stats update logic isn't aware of the situation, it
results in an invalid memory access.  Fix the bug by checking if the
scheme sysfs directory exists.

Link: https://lkml.kernel.org/r/20221114175552.1951-1-sj@kernel.org
Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[v5.18]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed
+++ a/mm/damon/sysfs.c
@@ -2339,6 +2339,10 @@ static int damon_sysfs_upd_schemes_stats
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_stats *sysfs_stats;
 
+		/* user could have removed the scheme sysfs dir */
+		if (schemes_idx >= sysfs_schemes->nr)
+			break;
+
 		sysfs_stats = sysfs_schemes->schemes_arr[schemes_idx++]->stats;
 		sysfs_stats->nr_tried = scheme->stat.nr_tried;
 		sysfs_stats->sz_tried = scheme->stat.sz_tried;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-fix-wrong-empty-schemes-assumption-under-online-tuning-in-damon_sysfs_set_schemes.patch
mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch
docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

