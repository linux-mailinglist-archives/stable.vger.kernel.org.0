Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D182B406302
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhIJAqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhIJAWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 041C160724;
        Fri, 10 Sep 2021 00:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233298;
        bh=FyZy43GHK7jIYNL7e0FXP+TeGrf6xbmOHOWhZy9F/FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bquBGQCgRteNEENRAngYzJU7hj6hSXJ0F/1viD+3BNaEa29ahEDULHzA5ttuaU+9m
         VoXkmpokmkPUZG22NcXhKr+2Oic9cmYfhrBHUQoY5AsTcIkbgbugYV0sEmbLv3lHW+
         kqOro45ghGBWkhIyif5WMTbtAGIxz6fzIOm5eE47LTE3nR6bG3SbkB4oW9ktBtjj2/
         nc42ELQOyCYoDRYUZj2kRS8jdLd53f19I93CamCK+em5HZ3IV2CmzgulTFf9QxjS7i
         uLdnPnuHWIxmrLq5uB7Y+9f9sVf0CfTXMFEzugUzz7HnGpFHrdhCrI3dj9Ss9gH9Fz
         +5Laz4Jc0663w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 5.10 51/53] ocfs2: quota_local: fix possible uninitialized-variable access in ocfs2_local_read_info()
Date:   Thu,  9 Sep 2021 20:20:26 -0400
Message-Id: <20210910002028.175174-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 6c85c2c728193d19d6a908ae9fb312d0325e65ca ]

A memory block is allocated through kmalloc(), and its return value is
assigned to the pointer oinfo. However, oinfo->dqi_gqinode is not
initialized but it is accessed in:
  iput(oinfo->dqi_gqinode);

To fix this possible uninitialized-variable access, assign NULL to
oinfo->dqi_gqinode, and add ocfs2_qinfo_lock_res_init() behind the
assignment in ocfs2_local_read_info().  Remove ocfs2_qinfo_lock_res_init()
in ocfs2_global_read_info().

Link: https://lkml.kernel.org/r/20210804031832.57154-1-islituo@gmail.com
Signed-off-by: Tuo Li <islituo@gmail.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
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
 fs/ocfs2/quota_global.c | 1 -
 fs/ocfs2/quota_local.c  | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index eda83487c9ec..f033de733adb 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -357,7 +357,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	}
 	oinfo->dqi_gi.dqi_sb = sb;
 	oinfo->dqi_gi.dqi_type = type;
-	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
 	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
 	oinfo->dqi_gqi_bh = NULL;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index b1a8b046f4c2..0e4b16d4c037 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -702,6 +702,8 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	info->dqi_priv = oinfo;
 	oinfo->dqi_type = type;
 	INIT_LIST_HEAD(&oinfo->dqi_chunk);
+	oinfo->dqi_gqinode = NULL;
+	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_rec = NULL;
 	oinfo->dqi_lqi_bh = NULL;
 	oinfo->dqi_libh = NULL;
-- 
2.30.2

