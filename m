Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBB74812BE
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 13:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhL2Mkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 07:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbhL2Mkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 07:40:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBB9C061574;
        Wed, 29 Dec 2021 04:40:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55A40614B0;
        Wed, 29 Dec 2021 12:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEF0C36AE7;
        Wed, 29 Dec 2021 12:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640781632;
        bh=JNtJWhL8T6Yw6jb+V2HcqwNvBrLooLiUovJs7iJkiJE=;
        h=From:To:Cc:Subject:Date:From;
        b=fm86xMaC9MeOy4RjPSKTCxE3SgGMcOoQNmpgxjPMOXctMo8C2UfsN4uSB1Zlc7TE4
         m6V3OeyWA3p2n2IleCTbSQKsX4v8sURjbDFpqUqaaOzmis/yZyhZFG6TMBq7/bPHWa
         s4siX7GZL43RcGB+N02rVzQ3DkyIMP6XCdjx8yVMwHiKWVc/f2uqxxGzelXrfyMhS+
         sPiel3BGwnrEqxNMNxbY8yPOvO1o59gRuQyv1fD2bM9yvn4s6SOoc2I/Tjhulr9Lgy
         r+s27M3t/SfBtfnkcpE+W+PQ0ZVi3bosNScBPLJayH1xFXFLS4x5RSFYUkPEHcPTbs
         5yqfpardqsr7w==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] mm/damon/dbgfs: Fix 'struct pid' leaks in 'dbgfs_target_ids_write()'
Date:   Wed, 29 Dec 2021 12:40:29 +0000
Message-Id: <20211229124029.23348-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DAMON debugfs interface increases the reference counts of 'struct pid's
for targets from the 'target_ids' file write callback
('dbgfs_target_ids_write()'), but decreases the counts only in DAMON
monitoring termination callback ('dbgfs_before_terminate()').
Therefore, when 'target_ids' file is repeatedly written without DAMON
monitoring start/termination, the reference count is not decreased and
therefore memory for the 'struct pid' cannot be freed.  This commit
fixes this issue by decreasing the reference counts when 'target_ids' is
written.

Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
---
 mm/damon/dbgfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index 489be9c830c4..751c7b835684 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -362,6 +362,7 @@ static ssize_t dbgfs_target_ids_write(struct file *file,
 		const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct damon_ctx *ctx = file->private_data;
+	struct damon_target *t, *next_t;
 	bool id_is_pid = true;
 	char *kbuf, *nrs;
 	unsigned long *targets;
@@ -406,8 +407,12 @@ static ssize_t dbgfs_target_ids_write(struct file *file,
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
-- 
2.17.1

