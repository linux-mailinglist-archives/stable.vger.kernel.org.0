Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFAB406392
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241955AbhIJAsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234796AbhIJAYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2051B6103E;
        Fri, 10 Sep 2021 00:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233388;
        bh=eNoERcqlwCN9kgjrVWZd4Q2Bfh3fgrljFvP8FgbdA+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayJaYxupXvx/avQKrAYTTjHITHT5MjWWivyXoEtwH49UuJ/PkoxDxfoVH+s6swPcK
         0IKMqlbtxgFX7wRci6AoBZ0nOOpPxNopgQi+kJHNTekxr8AMOTi6/hvpI8CUJxgpND
         RrGNtgU29Ue3w5UwMxlKxVusLvA/D2g+FCgDMOWipjusnyGCr7oO/750BDoZNcjVXr
         s4OJfv5s+O8d79bJQaxbtCLJ9gpm7MX3eTznXTx3qUFd1TSKLLO4Y749WVIZ6Xqz7Q
         2GjnM6GgrtUzYXNfU+fdXR3y+64TfIlV1liafSeOOcSAAICfUX9jS/Nl/EpDbm8lzP
         xD1UWbObS9ajQ==
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
Subject: [PATCH AUTOSEL 4.19 25/25] ocfs2: ocfs2_downconvert_lock failure results in deadlock
Date:   Thu,  9 Sep 2021 20:22:33 -0400
Message-Id: <20210910002234.176125-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002234.176125-1-sashal@kernel.org>
References: <20210910002234.176125-1-sashal@kernel.org>
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
index 8149fb6f1f0d..496d16376764 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -32,6 +32,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/delay.h>
 #include <linux/quotaops.h>
 #include <linux/sched/signal.h>
 
@@ -3880,6 +3881,17 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
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

