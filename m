Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7BE457A49
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 01:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhKTAq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 19:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236574AbhKTAqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 19:46:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB5D161A07;
        Sat, 20 Nov 2021 00:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637369033;
        bh=qf3iadlSg2k12B5DqrvmmY/Fm1Ggd5KqM/KQJdUpLzw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PbZQT7Y/EtGMxQw3xtK/0Kvu4xX7Tqoj7QvAiPGW/tvLrhsw/z/isp1G0n41BxMax
         lu52qvQt1oJqYFJoG1cuv0VY0RF+hf4ACfAxHMQbIOKPa9K8vmgywkGeX+jSOmwbqU
         dmXQSODTrahU/ufLLCZ7jTo7ZEDpGpGEr1WrvhxI=
Date:   Fri, 19 Nov 2021 16:43:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 13/15] mm/damon/dbgfs: fix missed use of
 damon_dbgfs_lock
Message-ID: <20211120004352.cP--sDA9q%akpm@linux-foundation.org>
In-Reply-To: <20211119164248.50feee07c5d2cc6cc4addf97@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
