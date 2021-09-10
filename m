Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F89A4061BA
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241072AbhIJAnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232902AbhIJATP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F08D610A3;
        Fri, 10 Sep 2021 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233085;
        bh=ZfP09m5w4LGh1ZGZG+EzEbW+bLxlL9P5Fvsc5CaZiW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kB4bOSfKo9PTT38PHk8+cezf+8Aepsme1plMp6IHn9OWZoXVzR8jl1aQm0zpjOrgD
         qqCZO3b1kffXERGtnjbZJo5YVifiGnwR/bFKOvP6ZMXWLWhXO1xXQrJ1TO02H541s7
         V6GOa+7P2QM6xUyUkgvrq3alTSdzGauyuxFNF+fWYrET/Q8a3ag8AxuJF5PR4kvM+j
         3vZoLUvj6DPwn9WjyhXJbwezfp+dohnob08cf9nZ1ARoxGm9gmY43snF5SoiGT5Pdo
         uE3pskvOULDzSs+yur3DktjGH86skV2rwqhoGSaz4BTtdQDx/2DKvI8CsUcMsqVvSw
         3McRuOjJuGvEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gang He <ghe@suse.com>, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 5.14 91/99] ocfs2: ocfs2_downconvert_lock failure results in deadlock
Date:   Thu,  9 Sep 2021 20:15:50 -0400
Message-Id: <20210910001558.173296-91-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gang He <ghe@suse.com>

[ Upstream commit 9673e0050c39b0534d0e2ca431223f52089f4959 ]

Usually, ocfs2_downconvert_lock() function always downconverts dlm lock to
the expected level for satisfy dlm bast requests from the other nodes.

But there is a rare situation.  When dlm lock conversion is being
canceled, ocfs2_downconvert_lock() function will return -EBUSY.  You need
to be aware that ocfs2_cancel_convert() function is asynchronous in fsdlm
implementation.

If we does not requeue this lockres entry, ocfs2 downconvert thread no
longer handles this dlm lock bast request.  Then, the other nodes will not
get the dlm lock again, the current node's process will be blocked when
acquire this dlm lock again.

Link: https://lkml.kernel.org/r/20210830044621.12544-1-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
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
 fs/ocfs2/dlmglue.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 48fd369c29a4..f8f561850470 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -16,6 +16,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/delay.h>
 #include <linux/quotaops.h>
 #include <linux/sched/signal.h>
 
@@ -3912,6 +3913,17 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 	ret = ocfs2_downconvert_lock(osb, lockres, new_level, set_lvb,
 				     gen);
+	/* The dlm lock convert is being cancelled in background,
+	 * ocfs2_cancel_convert() is asynchronous in fs/dlm,
+	 * requeue it, try again later.
+	 */
+	if (ret == -EBUSY) {
+		ctl->requeue = 1;
+		mlog(ML_BASTS, "lockres %s, ReQ: Downconvert busy\n",
+		     lockres->l_name);
+		ret = 0;
+		msleep(20);
+	}
 
 leave:
 	if (ret)
-- 
2.30.2

