Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A32C106513
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbfKVFwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbfKVFwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A2BE2070A;
        Fri, 22 Nov 2019 05:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401923;
        bh=JD+nfwlfA6FTDIx8CSLBblnhU8b9zxdQYj7UMBcMqL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrRptPQADb2LBdWt24/YRC4VdycjVBV3FlpmotxvAxgrtd1+K+EG9nFD459UHAD02
         LqdEBdD/PYgdCglMgFIZ9/gYkmJkRPQTF/di0azAE6iZ2kUo2JOOmW/8gmm81JHgkd
         s6aJ7gm4gADUnSOVRiYkWq+k3UDbJMGW8xKD0uO8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Junxiao Bi <junxiao.bi@oracle.com>,
        Yiwen Jiang <jiangyiwen@huawei.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Jun Piao <piaojun@huawei.com>,
        Changwei Ge <ge.changwei@h3c.com>,
        Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@versity.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 4.19 152/219] ocfs2: clear journal dirty flag after shutdown journal
Date:   Fri, 22 Nov 2019 00:48:04 -0500
Message-Id: <20191122054911.1750-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>

[ Upstream commit d85400af790dba2aa294f0a77e712f166681f977 ]

Dirty flag of the journal should be cleared at the last stage of umount,
if do it before jbd2_journal_destroy(), then some metadata in uncommitted
transaction could be lost due to io error, but as dirty flag of journal
was already cleared, we can't find that until run a full fsck.  This may
cause system panic or other corruption.

Link: http://lkml.kernel.org/r/20181121020023.3034-3-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@versity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/journal.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index c492cbb2410f6..4c7e9b8dca316 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1018,7 +1018,8 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 			mlog_errno(status);
 	}
 
-	if (status == 0) {
+	/* Shutdown the kernel journal system */
+	if (!jbd2_journal_destroy(journal->j_journal) && !status) {
 		/*
 		 * Do not toggle if flush was unsuccessful otherwise
 		 * will leave dirty metadata in a "clean" journal
@@ -1027,9 +1028,6 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		if (status < 0)
 			mlog_errno(status);
 	}
-
-	/* Shutdown the kernel journal system */
-	jbd2_journal_destroy(journal->j_journal);
 	journal->j_journal = NULL;
 
 	OCFS2_I(inode)->ip_open_count--;
-- 
2.20.1

