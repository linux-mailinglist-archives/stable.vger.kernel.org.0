Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DC347F942
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 23:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbhLZWUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 17:20:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52130 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbhLZWUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 17:20:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F241AB80DE2;
        Sun, 26 Dec 2021 22:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3098C36AE8;
        Sun, 26 Dec 2021 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640557213;
        bh=wAro1RTIpVx3ZtlJEAmaOTx+QMCzboCfkAntAiFvs/g=;
        h=Date:From:To:Subject:From;
        b=nd81tpK7uKNdgtx0eDICplABBG3GxhuxuRLB2aWOZKvhFlN3ndsjmEvhTCfQiK/Qs
         +d3kGwVtxDqwUb4z91RpejVH/h1Vy4qlyKbY4XKrPHHzUrBLrmXYMpwAcuzSnRncts
         DPtGSBcLTiyP4lMrxxZbr9AIkanNVvrNDQLjWXLM=
Date:   Sun, 26 Dec 2021 14:20:13 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sangwoob@amazon.com, sj@kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 mm-damon-dbgfs-protect-targets-destructions-with-kdamond_lock.patch removed
 from -mm tree
Message-ID: <20211226222013.04LcQPcL1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: protect targets destructions with kdamond_lock
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-protect-targets-destructions-with-kdamond_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: protect targets destructions with kdamond_lock

DAMON debugfs interface iterates current monitoring targets in
'dbgfs_target_ids_read()' while holding the corresponding 'kdamond_lock'. 
However, it also destructs the monitoring targets in
'dbgfs_before_terminate()' without holding the lock.  This can result in a
use_after_free bug.  This commit avoids the race by protecting the
destruction with the corresponding 'kdamond_lock'.

Link: https://lkml.kernel.org/r/20211221094447.2241-1-sj@kernel.org
Reported-by: Sangwoo Bae <sangwoob@amazon.com>
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-protect-targets-destructions-with-kdamond_lock
+++ a/mm/damon/dbgfs.c
@@ -650,10 +650,12 @@ static void dbgfs_before_terminate(struc
 	if (!targetid_is_pid(ctx))
 		return;
 
+	mutex_lock(&ctx->kdamond_lock);
 	damon_for_each_target_safe(t, next, ctx) {
 		put_pid((struct pid *)t->id);
 		damon_destroy_target(t);
 	}
+	mutex_unlock(&ctx->kdamond_lock);
 }
 
 static struct damon_ctx *dbgfs_new_ctx(void)
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

