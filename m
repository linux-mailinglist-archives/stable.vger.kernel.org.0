Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A2F3CDD0B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242754AbhGSOzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237775AbhGSOxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE8196121F;
        Mon, 19 Jul 2021 15:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708756;
        bh=e7evNLBmicdBJh4K885RFfO6iqvSUE3XI9fnyV014oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPHtyCS/I2bmFnPcjZj+j5B412+QdcL3WeGgfw10N4/VD7HZeOT6R3TwLEJzhkl+7
         H7g2RWlADyu8gJaPUTpqH/da8AQGbwHRnjAiF+Y0mRSzdBeUD+PwyXhXr5nLuTfXta
         2ubwCPomws4RzJe8CD/KE1Dq3UjjsbWcobakll1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/421] ocfs2: fix snprintf() checking
Date:   Mon, 19 Jul 2021 16:48:50 +0200
Message-Id: <20210719144950.677660827@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 54e948c60cc843b6e84dc44496edc91f51d2a28e ]

The snprintf() function returns the number of bytes which would have been
printed if the buffer was large enough.  In other words it can return ">=
remain" but this code assumes it returns "== remain".

The run time impact of this bug is not very severe.  The next iteration
through the loop would trigger a WARN() when we pass a negative limit to
snprintf().  We would then return success instead of -E2BIG.

The kernel implementation of snprintf() will never return negatives so
there is no need to check and I have deleted that dead code.

Link: https://lkml.kernel.org/r/20210511135350.GV1955@kadam
Fixes: a860f6eb4c6a ("ocfs2: sysfile interfaces for online file check")
Fixes: 74ae4e104dfc ("ocfs2: Create stack glue sysfs files.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
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
 fs/ocfs2/filecheck.c | 6 +-----
 fs/ocfs2/stackglue.c | 8 ++------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 1906cc962c4d..345ca9e14028 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -336,11 +336,7 @@ static ssize_t ocfs2_filecheck_attr_show(struct kobject *kobj,
 		ret = snprintf(buf + total, remain, "%lu\t\t%u\t%s\n",
 			       p->fe_ino, p->fe_done,
 			       ocfs2_filecheck_error(p->fe_status));
-		if (ret < 0) {
-			total = ret;
-			break;
-		}
-		if (ret == remain) {
+		if (ret >= remain) {
 			/* snprintf() didn't fit */
 			total = -E2BIG;
 			break;
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index c4b029c43464..e7eb08ac4215 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -510,11 +510,7 @@ static ssize_t ocfs2_loaded_cluster_plugins_show(struct kobject *kobj,
 	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
 		ret = snprintf(buf, remain, "%s\n",
 			       p->sp_name);
-		if (ret < 0) {
-			total = ret;
-			break;
-		}
-		if (ret == remain) {
+		if (ret >= remain) {
 			/* snprintf() didn't fit */
 			total = -E2BIG;
 			break;
@@ -541,7 +537,7 @@ static ssize_t ocfs2_active_cluster_plugin_show(struct kobject *kobj,
 	if (active_stack) {
 		ret = snprintf(buf, PAGE_SIZE, "%s\n",
 			       active_stack->sp_name);
-		if (ret == PAGE_SIZE)
+		if (ret >= PAGE_SIZE)
 			ret = -E2BIG;
 	}
 	spin_unlock(&ocfs2_stack_lock);
-- 
2.30.2



