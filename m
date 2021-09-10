Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FB64063BE
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhIJAsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234897AbhIJAZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 695446103E;
        Fri, 10 Sep 2021 00:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233442;
        bh=A4ygMTv36b98wldtBwApoKAYxRYDZNFvNyYpbkHB6MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVkkJrFk316QgYvgABHT8KCfFW+JUHZyucJ7CeQckwyI2cq2ILSbrUscYpOOudt9t
         OdhbN6Hn6HdEWvwNZrOXdkyNHCFBXTLlaVV8/x3sGbwcyACd8GSmIX8M70FWypb2US
         B2KDuSbvVFmEiqSFTxYMZZQkL1GSUIOD3HHgbjrokQiv2xB1gQrNq+rvA1KojKX/tt
         g7BPOfftVlKvm9xieG62tJUqkCgSftnpGysIi09/jUR01vqbi2AyXFRuD06bP+ZfAZ
         HGsjwjQcG++Y2PxLKNMp+D6KcSp9iFJ9+6Ib2ma1N8UU0u4d4taTchnavblSQTxWav
         AhC4CbZIBty1A==
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
Subject: [PATCH AUTOSEL 4.9 17/17] ocfs2: ocfs2_downconvert_lock failure results in deadlock
Date:   Thu,  9 Sep 2021 20:23:38 -0400
Message-Id: <20210910002338.176677-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002338.176677-1-sashal@kernel.org>
References: <20210910002338.176677-1-sashal@kernel.org>
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
index 2c3e975126b3..2e6aee19e536 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -32,6 +32,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/delay.h>
 #include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_DLM_GLUE
@@ -3677,6 +3678,17 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
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

