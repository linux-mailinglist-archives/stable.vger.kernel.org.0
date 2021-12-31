Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A504825DF
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 22:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhLaVHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Dec 2021 16:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhLaVHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Dec 2021 16:07:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29229C061574;
        Fri, 31 Dec 2021 13:07:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8BD7B81D7A;
        Fri, 31 Dec 2021 21:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3FAC36AEA;
        Fri, 31 Dec 2021 21:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640984836;
        bh=mJXkXmQh7Z31S7wp/KP12QJqyiu5jIOEL3u8nIvKtVM=;
        h=Date:From:To:Subject:From;
        b=Nw6VkiJEkpRhTcqJolIlhfSlDJdmaxACfAM/PUk4PfgDLazkSXDb4jYgIrxrRQW3i
         iX68X7fLt1fB9FbCDs/L4eGOA3IFfNQILdeWNkJLtpniqBFFLurlMnS6bmtUdBe/Cz
         Um+WQtmZ4By8uRPdrDqBCfroZtQ0m0ecz/v/QuWA=
Date:   Fri, 31 Dec 2021 13:07:16 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, stable@vger.kernel.org
Subject:  [merged]
 mm-damon-dbgfs-fix-struct-pid-leaks-in-dbgfs_target_ids_write.patch removed
 from -mm tree
Message-ID: <20211231210716.4k505Z5z3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: fix 'struct pid' leaks in 'dbgfs_target_ids_write()'
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-fix-struct-pid-leaks-in-dbgfs_target_ids_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: fix 'struct pid' leaks in 'dbgfs_target_ids_write()'

DAMON debugfs interface increases the reference counts of 'struct pid's
for targets from the 'target_ids' file write callback
('dbgfs_target_ids_write()'), but decreases the counts only in DAMON
monitoring termination callback ('dbgfs_before_terminate()').

Therefore, when 'target_ids' file is repeatedly written without DAMON
monitoring start/termination, the reference count is not decreased and
therefore memory for the 'struct pid' cannot be freed.  This commit fixes
this issue by decreasing the reference counts when 'target_ids' is
written.

Link: https://lkml.kernel.org/r/20211229124029.23348-1-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-fix-struct-pid-leaks-in-dbgfs_target_ids_write
+++ a/mm/damon/dbgfs.c
@@ -353,6 +353,7 @@ static ssize_t dbgfs_target_ids_write(st
 		const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct damon_ctx *ctx = file->private_data;
+	struct damon_target *t, *next_t;
 	bool id_is_pid = true;
 	char *kbuf, *nrs;
 	unsigned long *targets;
@@ -397,8 +398,12 @@ static ssize_t dbgfs_target_ids_write(st
 		goto unlock_out;
 	}
 
-	/* remove targets with previously-set primitive */
-	damon_set_targets(ctx, NULL, 0);
+	/* remove previously set targets */
+	damon_for_each_target_safe(t, next_t, ctx) {
+		if (targetid_is_pid(ctx))
+			put_pid((struct pid *)t->id);
+		damon_destroy_target(t);
+	}
 
 	/* Configure the context for the address space type */
 	if (id_is_pid)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch
mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch
mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
mm-damon-reclaim-provide-reclamation-statistics.patch
docs-admin-guide-mm-damon-reclaim-document-statistics-parameters.patch
mm-damon-dbgfs-support-all-damos-stats.patch
docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch
mm-damon-dbgfs-remove-a-unnecessary-variable.patch
mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch
mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log.patch
mm-damon-hide-kernel-pointer-from-tracepoint-event.patch

