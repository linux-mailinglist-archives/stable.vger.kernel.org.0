Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A354063A8
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhIJAsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhIJAYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD9E860FDA;
        Fri, 10 Sep 2021 00:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233415;
        bh=dYKpBXFovWyb/4JfCMqonsHdtO/XhImVOZAFLuml4L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+L2hXeChkf7fU6yao6h/yGprcYGtfYkjsRh7ZQjBOuxuwwTEs/Cmtai6fjV4tacN
         995lH5IiRH7F2W5RzF5g5ArmX992u8dRWKJI+Vq8P2i0AFr54/bNig8w647DOo9CwL
         bhWUdLXcCYL8pP29nM2IZT29xynRgBEmx4nOgmwgcBUpPxkOM24lTJbXZVkzs+7Aju
         /F5cRbWi40vvaygswiXnyLWkVRGTvu+GZTn+wfKv9xIxghkUM/WOXiqou+oEqnSGp2
         DySRlUTz3kHZ5Shn6JOMmwGkN5hqGEsNnAcIUcd1bDl5L4L2KYqAPFCKg1gyjrZdQK
         oP3NxwhJwadVQ==
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
Subject: [PATCH AUTOSEL 4.14 18/19] ocfs2: quota_local: fix possible uninitialized-variable access in ocfs2_local_read_info()
Date:   Thu,  9 Sep 2021 20:23:08 -0400
Message-Id: <20210910002309.176412-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002309.176412-1-sashal@kernel.org>
References: <20210910002309.176412-1-sashal@kernel.org>
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
index d212d09c00b1..f78e5294f5d2 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -356,7 +356,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	}
 	oinfo->dqi_gi.dqi_sb = sb;
 	oinfo->dqi_gi.dqi_type = type;
-	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
 	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
 	oinfo->dqi_gqi_bh = NULL;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 16c42ed0dca8..b5216ed38e8d 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -703,6 +703,8 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
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

