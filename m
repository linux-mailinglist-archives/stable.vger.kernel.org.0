Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574584821EE
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 05:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbhLaEMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 23:12:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32822 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhLaEMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 23:12:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 048E4B81D4B;
        Fri, 31 Dec 2021 04:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACFEC36AE9;
        Fri, 31 Dec 2021 04:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640923955;
        bh=qAa71we+OzH5frizipYFiM2+rzEExaMHymKmGW3O0VY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YD+OR0pTQXCDeCTH0vi2rQScST1fUXVhUHIAxKRL+SiVcc5hI3KWx2aAJ7Efmhnmf
         wfFw3503EbJDxDS1icFXf41aZpU8CehX7LvyIXzBQpYYG8XXFc4Gwe0U3lwDzqZfB0
         8x5Hp1vNfYl9I1t5UGD0iFX9QhkSjmEUKZDJ5IyA=
Date:   Thu, 30 Dec 2021 20:12:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 2/2] mm/damon/dbgfs: fix 'struct pid' leaks in
 'dbgfs_target_ids_write()'
Message-ID: <20211231041234.50dCet98O%akpm@linux-foundation.org>
In-Reply-To: <20211230201202.d9bcb24678cc3d9d503579a0@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
