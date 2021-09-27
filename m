Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E01419B71
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhI0RTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235820AbhI0RQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:16:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D8F060238;
        Mon, 27 Sep 2021 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762695;
        bh=CGvZ5TLO5rzIwhIAS4yIEYmpZjvloeNZ3UQ6m4E23Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nukpeE0e0Wx/T5UID7Tt9Pi75dID6MWcj98wuagdI3Kkckezb0xdYpnTqj5h1ESx6
         O6MqtiQhQF1TF3KaZy4voPTK57ZRzLT4fwTmXGqtU1R4L13xiv2UY7F4hEeAWtRh+l
         Fe2ZVy5UOGJm/d/qR1dVtaM7tE+jCaYUwRoShAHE=
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
Subject: [PATCH 5.14 002/162] ocfs2: drop acl cache for directories too
Date:   Mon, 27 Sep 2021 19:00:48 +0200
Message-Id: <20210927170233.543958175@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
@@ -3939,7 +3939,7 @@ static int ocfs2_data_convert_worker(str
 		oi = OCFS2_I(inode);
 		oi->ip_dir_lock_gen++;
 		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
-		goto out;
+		goto out_forget;
 	}
 
 	if (!S_ISREG(inode->i_mode))
@@ -3970,6 +3970,7 @@ static int ocfs2_data_convert_worker(str
 		filemap_fdatawait(mapping);
 	}
 
+out_forget:
 	forget_all_cached_acls(inode);
 
 out:


