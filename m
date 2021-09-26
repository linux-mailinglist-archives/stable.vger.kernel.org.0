Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4569E41889D
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhIZMaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhIZM37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:29:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E9660F6D;
        Sun, 26 Sep 2021 12:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632659303;
        bh=L9vYftrkLuhhDKvZFQudLBWxlsYBHs2a5NXVMGnikKo=;
        h=Subject:To:Cc:From:Date:From;
        b=k8mJsM5qoSmJ1UHvGKBB2dtSeFeJ1jEEJTdJBzEJ0H+BIT46N6EscIS7V7DOSZKO8
         T88qE99ts3oTXgnz5Xvfr1KIUFO0h09R0enH+W4sp/qBKMBMTYfNAsRGR/bU9eFFrA
         fr9f+Qo9d2mRbC2n1Pe8koUeenO3k1b8z/mgDC6c=
Subject: FAILED: patch "[PATCH] ocfs2: drop acl cache for directories too" failed to apply to 4.4-stable tree
To:     wen.gang.wang@oracle.com, akpm@linux-foundation.org,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, piaojun@huawei.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 14:28:20 +0200
Message-ID: <16326593004839@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9c0f0a03e386f4e1df33db676401547e1b7800c6 Mon Sep 17 00:00:00 2001
From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 24 Sep 2021 15:43:35 -0700
Subject: [PATCH] ocfs2: drop acl cache for directories too

ocfs2_data_convert_worker() is currently dropping any cached acl info
for FILE before down-converting meta lock.  It should also drop for
DIRECTORY.  Otherwise the second acl lookup returns the cached one (from
VFS layer) which could be already stale.

The problem we are seeing is that the acl changes on one node doesn't
get refreshed on other nodes in the following case:

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 359524b7341f..801e60bab955 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3951,7 +3951,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		oi = OCFS2_I(inode);
 		oi->ip_dir_lock_gen++;
 		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
-		goto out;
+		goto out_forget;
 	}
 
 	if (!S_ISREG(inode->i_mode))
@@ -3982,6 +3982,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		filemap_fdatawait(mapping);
 	}
 
+out_forget:
 	forget_all_cached_acls(inode);
 
 out:

