Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B478E406307
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242292AbhIJAqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231563AbhIJAWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0FD1604DC;
        Fri, 10 Sep 2021 00:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233300;
        bh=dp4wSqm3sfSb+t/V4j7I6BKE9+blk1saDdAg4tgNn8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSu/hrg1JDh6HyW2SCZbEp2yUivX34j73KmKBsLs8K2BtBO2uXm4PeDBhGJPOFjVw
         A3/jNP8IOTaD3kI2aLefUdhmG3/+1hmD7OJOQFPzr9OUZYyhiaMSS+B/WjumVakxEX
         +LC9Sn4Mvvx5GA61sdtLigH0Amcsowjt51gbG9zmwD0+7BpriFKQ4n6dlzVpstpcE2
         fxnnhGkyPQjeQRpAzRbyl2lzu48YRMqXmaBHIskc+L9POns3gzuo15xrLrr0p3saPS
         UtHagFr0CIQqjrccegm+qF6K0HywHv510kY+zoNE+X0XW/9dDwj/Miwi/Kp8hMLqKc
         g/RxXPA2ujS7g==
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
Subject: [PATCH AUTOSEL 5.10 52/53] ocfs2: ocfs2_downconvert_lock failure results in deadlock
Date:   Thu,  9 Sep 2021 20:20:27 -0400
Message-Id: <20210910002028.175174-52-sashal@kernel.org>
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
index 8e3a369086db..01cf5211b5c8 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -18,6 +18,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/delay.h>
 #include <linux/quotaops.h>
 #include <linux/sched/signal.h>
 
@@ -3906,6 +3907,17 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
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

