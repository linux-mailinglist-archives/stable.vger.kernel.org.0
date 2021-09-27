Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67613419AA1
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbhI0RKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236487AbhI0RJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D1E06101A;
        Mon, 27 Sep 2021 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762431;
        bh=gnVceWG5Ho92c4gKzaRn0O46ws7FP8BK2OI+dr3qgJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=np2WwQvGO4fjdG8DYVzFoLeeQuR9z7SvKlRyBf1yeHA6PxSlNDcAHfCl2iG10DCbP
         cUg79Yl+bNG5PE7CEvqVFAVNm/Alapb5tAJJwc9rzx/IlGGWgwHlTRbmV1NjKC01l0
         xTQlFJkJaONaqIv7n76WZPHkH+FGkgWeBCPQVQ0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wengang Wang <wen.gang.wang@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 002/103] ocfs2: drop acl cache for directories too
Date:   Mon, 27 Sep 2021 19:01:34 +0200
Message-Id: <20210927170225.785643829@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wengang Wang <wen.gang.wang@oracle.com>

commit 9c0f0a03e386f4e1df33db676401547e1b7800c6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlmglue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3933,7 +3933,7 @@ static int ocfs2_data_convert_worker(str
 		oi = OCFS2_I(inode);
 		oi->ip_dir_lock_gen++;
 		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
-		goto out;
+		goto out_forget;
 	}
 
 	if (!S_ISREG(inode->i_mode))
@@ -3964,6 +3964,7 @@ static int ocfs2_data_convert_worker(str
 		filemap_fdatawait(mapping);
 	}
 
+out_forget:
 	forget_all_cached_acls(inode);
 
 out:


