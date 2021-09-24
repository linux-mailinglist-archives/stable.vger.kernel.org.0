Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB892417DD8
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 00:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbhIXWpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 18:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239842AbhIXWpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4E85610C7;
        Fri, 24 Sep 2021 22:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523416;
        bh=rA37PYHONDIG3MvsoHAzveB2Egr+eik4Izw0/KSpGnE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AkZeVTDSqx95emlo020iXkENsJudK1Ke/nbogy/fmcyrtgUHV7GVrx7i2BKWnyHD/
         +h7lr/VHy3zEdtcc4+K1l/8GkkGf22jOVySWJVZtwOy110KBvdLEZ1n8TPf4vq/ahk
         BUTbK6005fWp2+fLwpsqBaSSpZ8nyiBqByzQS3VU=
Date:   Fri, 24 Sep 2021 15:43:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        wen.gang.wang@oracle.com
Subject:  [patch 06/16] ocfs2: drop acl cache for directories too
Message-ID: <20210924224335.qEoBbK0p3%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: drop acl cache for directories too

ocfs2_data_convert_worker() is currently dropping any cached acl info for
FILE before down-converting meta lock.  It should also drop for DIRECTORY.
Otherwise the second acl lookup returns the cached one (from VFS layer)
which could be already stale.

The problem we are seeing is that the acl changes on one node doesn't get
refreshed on other nodes in the following case:

  Node 1                    Node 2
--------------            ----------------
getfacl dir1

			  getfacl dir1    <-- this is OK

setfacl -m u:user1:rwX dir1
getfacl dir1   <-- see the change for user1

			  getfacl dir1    <-- can't see change for user1

Link: https://lkml.kernel.org/r/20210903012631.6099-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-drop-acl-cache-for-directories-too
+++ a/fs/ocfs2/dlmglue.c
@@ -3951,7 +3951,7 @@ static int ocfs2_data_convert_worker(str
 		oi = OCFS2_I(inode);
 		oi->ip_dir_lock_gen++;
 		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
-		goto out;
+		goto out_forget;
 	}
 
 	if (!S_ISREG(inode->i_mode))
@@ -3982,6 +3982,7 @@ static int ocfs2_data_convert_worker(str
 		filemap_fdatawait(mapping);
 	}
 
+out_forget:
 	forget_all_cached_acls(inode);
 
 out:
_
