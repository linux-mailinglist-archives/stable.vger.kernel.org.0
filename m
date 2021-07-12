Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D0E3C4567
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhGLGZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235192AbhGLGYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70101611B0;
        Mon, 12 Jul 2021 06:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070884;
        bh=xnWYHfObpQ+5Ip/l/lNmui/q8vAGzemHgguL1UMezNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSNuKw7edjApF9zyhE/bh1LCwngAwxsh5IT4kawMKLnwEoZq8uXkxdzf5/40gTbhF
         AmTko0ydEhbNHbWYFA4ZxK1DGqnyBDQ0oWZK9Da2t9ldYVQf0hR1/tWhn56TvjVDu/
         h6C7vlLIWOOKMOHf+Ta/0Tuqk8fKJw7ixmysxGIc=
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
Subject: [PATCH 5.4 182/348] ocfs2: fix snprintf() checking
Date:   Mon, 12 Jul 2021 08:09:26 +0200
Message-Id: <20210712060725.071516538@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 50f11bfdc8c2..82a3edc4aea4 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -328,11 +328,7 @@ static ssize_t ocfs2_filecheck_attr_show(struct kobject *kobj,
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
index 8aa6a667860c..188038760136 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -502,11 +502,7 @@ static ssize_t ocfs2_loaded_cluster_plugins_show(struct kobject *kobj,
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
@@ -533,7 +529,7 @@ static ssize_t ocfs2_active_cluster_plugin_show(struct kobject *kobj,
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



