Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9DB6DD375
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732854AbfJRWH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732801AbfJRWH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:07:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B412822473;
        Fri, 18 Oct 2019 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436447;
        bh=lP1MIHb9S8XFejf9Q1cRvqIZFJYfESq5ykS7JZi3GQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ciZqMCHwZ1jUmaAHFljPojbf+QSu9LI8jwy0vjfCjqvymGPmdKgvEzRuIqKZ6IPmH
         KuqDWRlAaXY332W2kge9Q5Ai9cNPrwFp8NnG0DoArr/kcluV4IrDN0jxiGRyQV7Si4
         0NShxZ93pkaREyFRE4f7qLDG1aAGVvUGqD3D2r+I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 082/100] fs: ocfs2: fix a possible null-pointer dereference in ocfs2_write_end_nolock()
Date:   Fri, 18 Oct 2019 18:05:07 -0400
Message-Id: <20191018220525.9042-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index dc773e163132c..543efa3e5655f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2056,7 +2056,8 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
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

