Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6C745C5C7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350527AbhKXOAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355726AbhKXN6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38D24633E8;
        Wed, 24 Nov 2021 13:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759312;
        bh=pFh54qme3lcq761ZJBOlSU3ubo7CiHWEsnmN+kg03L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gW3pL806nW3+89RMXktcjwG3KwkZckreYZFGIjvPFu0zMeKpf5pElTR2zSTMNOTOc
         YJwyNsRjqCrBiNGS3MUW7EpHYblKUWOU9WzfWaJtZKoXap61GCnKxK8aNWXJUWlR9H
         qBvettdJof2m/mA/wcZPQ3CoQGIL9QVMCpAp+GSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 200/279] mm/damon/dbgfs: fix missed use of damon_dbgfs_lock
Date:   Wed, 24 Nov 2021 12:58:07 +0100
Message-Id: <20211124115725.646670755@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

commit d78f3853f831eee46c6dbe726debf3be9e9c0d05 upstream.

DAMON debugfs is supposed to protect dbgfs_ctxs, dbgfs_nr_ctxs, and
dbgfs_dirs using damon_dbgfs_lock.  However, some of the code is
accessing the variables without the protection.  This fixes it by
protecting all such accesses.

Link: https://lkml.kernel.org/r/20211110145758.16558-3-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/dbgfs.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -538,12 +538,14 @@ static ssize_t dbgfs_monitor_on_write(st
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
@@ -596,15 +598,16 @@ static int __init __damon_dbgfs_init(voi
 
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
 


