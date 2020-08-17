Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529C1246F09
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbgHQRlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731079AbgHQQQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:16:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8331820748;
        Mon, 17 Aug 2020 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680959;
        bh=/Zg3SNKr8mCaJ1cJBZAHpHQDtg5B/8uF8qGbcJ2YRhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRtKbDKbCSqdP+SK9eVZAV/djfu89+5b9/1zXvrvmcCAzMi66DSdoGeKher1OkEuf
         LeEZMjLq7bel5ecIh526GgfiZMm9wSBnTF8zurxArcSWFHXPd5LqiON2TmX6u3iVbf
         ZFsun0ls3NnTOHaH5RoM51scyH6gt3DH9qLQ2N/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 126/168] ocfs2: fix unbalanced locking
Date:   Mon, 17 Aug 2020 17:17:37 +0200
Message-Id: <20200817143739.979067917@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

[ Upstream commit 57c720d4144a9c2b88105c3e8f7b0e97e4b5cc93 ]

Based on what fails, function can return with nfs_sync_rwlock either
locked or unlocked. That can not be right.

Always return with lock unlocked on error.

Fixes: 4cd9973f9ff6 ("ocfs2: avoid inode removal while nfsd is accessing it")
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Link: http://lkml.kernel.org/r/20200724124443.GA28164@duo.ucw.cz
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlmglue.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index c141b06811a6c..8149fb6f1f0d2 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2867,9 +2867,15 @@ int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex)
 
 	status = ocfs2_cluster_lock(osb, lockres, ex ? LKM_EXMODE : LKM_PRMODE,
 				    0, 0);
-	if (status < 0)
+	if (status < 0) {
 		mlog(ML_ERROR, "lock on nfs sync lock failed %d\n", status);
 
+		if (ex)
+			up_write(&osb->nfs_sync_rwlock);
+		else
+			up_read(&osb->nfs_sync_rwlock);
+	}
+
 	return status;
 }
 
-- 
2.25.1



