Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCA54817B1
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 00:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhL2XXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 18:23:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47620 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbhL2XXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 18:23:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38C70B817AB;
        Wed, 29 Dec 2021 23:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB71FC36AEA;
        Wed, 29 Dec 2021 23:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640820181;
        bh=BXG18Sw1yVHCdB15AVt+Dqe/tked87k4pz322bxIyX0=;
        h=Date:From:To:Subject:From;
        b=on+fkySPLFbyRIZLhT3rFavU7yE8rMs6DnhD5N6/xhE/BuZw9rgmc3HMzCDGscL+i
         hHII2/L2KaHPfQ2F655/55E/qTQvU5NWvKrFLefUSxiiYpKRmx9Bu1SmEF7yKRyZbg
         Q0h5vfxJx/5zlnzXfdx24H+Q66OEIn8bG0rUs23E=
Date:   Wed, 29 Dec 2021 15:23:02 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org
Subject:  +
 mm-damon-dbgfs-fix-struct-pid-leaks-in-dbgfs_target_ids_write.patch added to
 -mm tree
Message-ID: <20211229232302.2rP0w%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: fix 'struct pid' leaks in 'dbgfs_target_ids_write()'
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-fix-struct-pid-leaks-in-dbgfs_target_ids_write.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-fix-struct-pid-leaks-in-dbgfs_target_ids_write.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-fix-struct-pid-leaks-in-dbgfs_target_ids_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-dbgfs-fix-struct-pid-leaks-in-dbgfs_target_ids_write.patch
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

