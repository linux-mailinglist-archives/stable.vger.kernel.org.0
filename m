Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C5BEED6C
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389539AbfKDWGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:06:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388994AbfKDWGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:06:30 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F1C214D8;
        Mon,  4 Nov 2019 22:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905189;
        bh=CU+Jwbn70AzlpxNRKMIooxKiYLzL3JFn5/kueyOSaTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2SYs+LB5Q5G7Pr9mKR7PafQTeHLNKg0QlYaH6V2lwKnzwkzEstuBd3NGCKb8VXEki
         FLqbPQkPMcJByxEEU/DOv+QW4s2UZ334VAXeS7n47t1Gh0yqJjNBPrzD1U4L2UpsNj
         xzOz+ixaJEgqweJ1AX8kljyXYsAjXdOLNUbFQC44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 060/163] fs: ocfs2: fix a possible null-pointer dereference in ocfs2_write_end_nolock()
Date:   Mon,  4 Nov 2019 22:44:10 +0100
Message-Id: <20191104212144.415251652@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 583fee3e12df0e6f1f66f063b989d8e7fed0e65a ]

In ocfs2_write_end_nolock(), there are an if statement on lines 1976,
2047 and 2058, to check whether handle is NULL:

    if (handle)

When handle is NULL, it is used on line 2045:

	ocfs2_update_inode_fsync_trans(handle, inode, 1);
        oi->i_sync_tid = handle->h_transaction->t_tid;

Thus, a possible null-pointer dereference may occur.

To fix this bug, handle is checked before calling
ocfs2_update_inode_fsync_trans().

This bug is found by a static analysis tool STCheck written by us.

Link: http://lkml.kernel.org/r/20190726033705.32307-1-baijiaju1990@gmail.com
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/aops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 3e0a93e799ea1..9b827143a3504 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2042,7 +2042,8 @@ out_write_size:
 		inode->i_mtime = inode->i_ctime = current_time(inode);
 		di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
 		di->i_mtime_nsec = di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
-		ocfs2_update_inode_fsync_trans(handle, inode, 1);
+		if (handle)
+			ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	}
 	if (handle)
 		ocfs2_journal_dirty(handle, wc->w_di_bh);
-- 
2.20.1



