Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88AF628BD6
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbiKNWKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237825AbiKNWKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:10:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04831A042;
        Mon, 14 Nov 2022 14:10:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D1CF61485;
        Mon, 14 Nov 2022 22:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2A7C433C1;
        Mon, 14 Nov 2022 22:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668463831;
        bh=zVbDNFCUsWvcTSqNt9X3CIW4vUTUSB02RVP/uZREMKs=;
        h=Date:To:From:Subject:From;
        b=dz3WRJBMd7wriMjT5ScV+SfvBifIjveUBrgTUPe0wJn+7ee60kKu8jDGV4lsp5B6d
         zFwtkKRb0td+vViCZGpqBkZGEqKfx82L8TqtKnU3ypRCYEDm4rJM/nAHW+2Xh2B9+C
         sOJ/gQQREkMBs/VbyMN6R4/KB/d03UaKS5sBBHbs=
Date:   Mon, 14 Nov 2022 14:10:30 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed.patch added to mm-hotfixes-unstable branch
Message-Id: <20221114221031.BE2A7C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: skip stats update if the scheme directory is removed
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed.patch

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
 
+		/* user could removed the scheme sysfs dir */
+		if (schemes_idx >= sysfs_schemes->nr)
+			break;
+
 		sysfs_stats = sysfs_schemes->schemes_arr[schemes_idx++]->stats;
 		sysfs_stats->nr_tried = scheme->stat.nr_tried;
 		sysfs_stats->sz_tried = scheme->stat.sz_tried;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed.patch
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

