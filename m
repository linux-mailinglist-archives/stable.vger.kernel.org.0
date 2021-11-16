Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBA04528AC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 04:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhKPDpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 22:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231592AbhKPDpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 22:45:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D68D761B50;
        Tue, 16 Nov 2021 03:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637034128;
        bh=MVsYQAyT6qszfdQPk0yAc+LmK0MFBGfv+mc90Rqf4zU=;
        h=Date:From:To:Subject:From;
        b=qGC/n6VDw1IUzg8wCq7TR2ga0+JI1tFlGcZ6oLXmVkWXAm1LDuskmfWBtVOCJngAi
         SO2h1Tn7tMV1pKDsAuMgjpchEc2H+3QdZacBgGPrvaL0xin2Vtiatz26nw3n7kAdNC
         Df/3MlUmWS/e0O8HGk/hXfW4kUwA9sRVWItj9jbI=
Date:   Mon, 15 Nov 2021 19:42:07 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, stable@vger.kernel.org
Subject:  + mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock.patch
 added to -mm tree
Message-ID: <20211116034207.w5ZFtig4R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: fix missed use of damon_dbgfs_lock
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock.patch

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

mm-damon-dbgfs-use-__gfp_nowarn-for-user-specified-size-buffer-allocation.patch
mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock.patch

