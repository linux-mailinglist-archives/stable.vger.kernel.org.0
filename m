Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1208345AF5C
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 23:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbhKWWtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 17:49:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239113AbhKWWtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 17:49:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C3ED60E08;
        Tue, 23 Nov 2021 22:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707564;
        bh=4LvFDitmV4HoCGXKzQY4dSbnRF2wkH+WkA2sKy0XNiw=;
        h=Date:From:To:Subject:From;
        b=DfK0Ks39l0QgRJC2ZWS0iXkzyyYs596rBDpXj9DOTBJIt8cMmVic/gEv9rUIZ6uPA
         ds2GIlfbSM33tWJibbv7Ohm67cp0uEtvc/1l4p7ka3xRQwJLDeonAs/MGQqMLLs73o
         bJWP2gPGv+Dt3EcMfxzJgHPzcEtcfjpwnpbHvEZw=
Date:   Tue, 23 Nov 2021 14:46:04 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, stable@vger.kernel.org
Subject:  [merged]
 mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock.patch removed from -mm
 tree
Message-ID: <20211123224604.77Gx2r8RM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: fix missed use of damon_dbgfs_lock
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: fix missed use of damon_dbgfs_lock

DAMON debugfs is supposed to protect dbgfs_ctxs, dbgfs_nr_ctxs, and
dbgfs_dirs using damon_dbgfs_lock.  However, some of the code is accessing
the variables without the protection.  This commit fixes it by protecting
all such accesses.

Link: https://lkml.kernel.org/r/20211110145758.16558-3-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock
+++ a/mm/damon/dbgfs.c
@@ -877,12 +877,14 @@ static ssize_t dbgfs_monitor_on_write(st
 		return -EINVAL;
 	}
 
+	mutex_lock(&damon_dbgfs_lock);
 	if (!strncmp(kbuf, "on", count)) {
 		int i;
 
 		for (i = 0; i < dbgfs_nr_ctxs; i++) {
 			if (damon_targets_empty(dbgfs_ctxs[i])) {
 				kfree(kbuf);
+				mutex_unlock(&damon_dbgfs_lock);
 				return -EINVAL;
 			}
 		}
@@ -892,6 +894,7 @@ static ssize_t dbgfs_monitor_on_write(st
 	} else {
 		ret = -EINVAL;
 	}
+	mutex_unlock(&damon_dbgfs_lock);
 
 	if (!ret)
 		ret = count;
@@ -944,15 +947,16 @@ static int __init __damon_dbgfs_init(voi
 
 static int __init damon_dbgfs_init(void)
 {
-	int rc;
+	int rc = -ENOMEM;
 
+	mutex_lock(&damon_dbgfs_lock);
 	dbgfs_ctxs = kmalloc(sizeof(*dbgfs_ctxs), GFP_KERNEL);
 	if (!dbgfs_ctxs)
-		return -ENOMEM;
+		goto out;
 	dbgfs_ctxs[0] = dbgfs_new_ctx();
 	if (!dbgfs_ctxs[0]) {
 		kfree(dbgfs_ctxs);
-		return -ENOMEM;
+		goto out;
 	}
 	dbgfs_nr_ctxs = 1;
 
@@ -963,6 +967,8 @@ static int __init damon_dbgfs_init(void)
 		pr_err("%s: dbgfs init failed\n", __func__);
 	}
 
+out:
+	mutex_unlock(&damon_dbgfs_lock);
 	return rc;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch

