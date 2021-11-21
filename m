Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BE6458307
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 12:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbhKULFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 06:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238054AbhKULFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 06:05:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B67AD608FB;
        Sun, 21 Nov 2021 11:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637492549;
        bh=Ufdx8ARO4THgjUCgnF+gxz8aDr/YgOiNmfXPT9ZpqNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBF83KaobljbaaJHUuggWujZFm3neyoLpPN16qo3IUNGlLYGLYtmBB/l6Mko3JQEY
         qfRHQbd0pnJpTKrTHsaEWFxkFnCeGL3disH4QTConTzOfDroNBhIbV5868l6TOYEux
         tdzZRbAk/PPtkBv7RFRY5kK+UgLKT24sRlUSSqkBCueWwn4IFl2oq7/3yEgQwkU69O
         g5blPr7aZhJ088ee+TAVwMjQzzaQNpzPPeHTpC4iYV0m+FbCGdMfKvV9kpcHJoQibq
         mll/nT7nliW+YpMVBsdbzEbRXV/p/p+wsPpXNjGo9XgQvMWno2lR1piAPa8HTcde2Z
         frViPCtFB7Ygw==
From:   SeongJae Park <sj@kernel.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for-5.15.x 2/2] mm/damon/dbgfs: fix missed use of damon_dbgfs_lock
Date:   Sun, 21 Nov 2021 11:02:11 +0000
Message-Id: <20211121110211.17032-3-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211121110211.17032-1-sj@kernel.org>
References: <20211121110211.17032-1-sj@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d78f3853f831eee46c6dbe726debf3be9e9c0d05 upstream.

DAMON debugfs is supposed to protect dbgfs_ctxs, dbgfs_nr_ctxs, and
dbgfs_dirs using damon_dbgfs_lock.  However, some of the code is
accessing the variables without the protection.  This fixes it by
protecting all such accesses.

Link: https://lkml.kernel.org/r/20211110145758.16558-3-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/damon/dbgfs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index 2741ff79e8e8..f94d19a690df 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -538,12 +538,14 @@ static ssize_t dbgfs_monitor_on_write(struct file *file,
 		return -EINVAL;
 	}
 
+	mutex_lock(&damon_dbgfs_lock);
 	if (!strncmp(kbuf, "on", count))
 		err = damon_start(dbgfs_ctxs, dbgfs_nr_ctxs);
 	else if (!strncmp(kbuf, "off", count))
 		err = damon_stop(dbgfs_ctxs, dbgfs_nr_ctxs);
 	else
 		err = -EINVAL;
+	mutex_unlock(&damon_dbgfs_lock);
 
 	if (err)
 		ret = err;
@@ -596,15 +598,16 @@ static int __init __damon_dbgfs_init(void)
 
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
 
@@ -615,6 +618,8 @@ static int __init damon_dbgfs_init(void)
 		pr_err("%s: dbgfs init failed\n", __func__);
 	}
 
+out:
+	mutex_unlock(&damon_dbgfs_lock);
 	return rc;
 }
 
-- 
2.17.1

