Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB13047C90C
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 23:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhLUWFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 17:05:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42028 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhLUWFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 17:05:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E653B819FE;
        Tue, 21 Dec 2021 22:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D298FC36AE8;
        Tue, 21 Dec 2021 22:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640124340;
        bh=bwOrAfqDd3fvIDaRDRks82wGpxaa7mYMQndjKZmCSus=;
        h=Date:From:To:Subject:From;
        b=g72V7yDHTdO2XoQVKJz4HMT8vlFQSC6QzJfESCXHaE1q3MdbY8ywI6B+huGYqnYzs
         iaxEIUsLihYXzAOGL4PffeR5twmDUXa/qj/5QqPypA2J9hKESpg78MG9mqgXTvZsF7
         4v+nWeZBXsoFH5HLNPKhywrbcJqJnRMQLCoGkJOw=
Date:   Tue, 21 Dec 2021 14:05:39 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sangwoob@amazon.com, sj@kernel.org
Subject:  +
 mm-damon-dbgfs-protect-targets-destructions-with-kdamond_lock.patch added to
 -mm tree
Message-ID: <20211221220539.x5Uvm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: protect targets destructions with kdamond_lock
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-protect-targets-destructions-with-kdamond_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-protect-targets-destructions-with-kdamond_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-protect-targets-destructions-with-kdamond_lock.patch

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

mm-damon-dbgfs-protect-targets-destructions-with-kdamond_lock.patch
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

