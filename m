Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F00113354
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbfLDSQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731389AbfLDSM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:12:57 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5A8620675;
        Wed,  4 Dec 2019 18:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483176;
        bh=bX5shF6z+hdjvDopTiIOMnMFS00lNoa2FlAure1pDjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAPkAvcjDAKW12dl9HvGwmTLhpF/n9A0kJeqodUby4WIuxafa7hPAJKFjGk8HxFTz
         SWp/n8QaHpqKtV5+C0GYiY5uihqPWcjmGzRZkVVFrJF2ELNoxahek3Rur+w2QRwu83
         5frGUcA1VmcWbjZkEDWFdXMgFNdbofitKovxBoIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
        Yiwen Jiang <jiangyiwen@huawei.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Jun Piao <piaojun@huawei.com>,
        Changwei Ge <ge.changwei@h3c.com>,
        Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@versity.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 081/125] ocfs2: clear journal dirty flag after shutdown journal
Date:   Wed,  4 Dec 2019 18:56:26 +0100
Message-Id: <20191204175323.967916703@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a30f63623db70..13cf69aa4cae8 100644
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



