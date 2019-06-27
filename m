Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37BD5761F
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfF0AfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbfF0AfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:35:21 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 776BA21851;
        Thu, 27 Jun 2019 00:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595720;
        bh=ozNMpS8bpFGjzEslo1XHCm1rR2P1bHb1+IRkhfR11mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7/IyaCxj/M+h7ePrpk0Fqp/5KMgcVZ4Gm1tytz6jzq2TuxAOOx0f4cSw84L8sdsO
         /d8YwcbURuGJtYg+8If6cNZ67tBkvB5F08Y6QRRDtHEYVNFczCnyFfgg67jVGoaaEd
         kmtTMSuHyuGTViz/EETtCTJ8qsiuuhWArVoef6Co=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        syzbot+c277e8e2f46414645508@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 91/95] fanotify: update connector fsid cache on add mark
Date:   Wed, 26 Jun 2019 20:30:16 -0400
Message-Id: <20190627003021.19867-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit c285a2f01d692ef48d7243cf1072897bbd237407 ]

When implementing connector fsid cache, we only initialized the cache
when the first mark added to object was added by FAN_REPORT_FID group.
We forgot to update conn->fsid when the second mark is added by
FAN_REPORT_FID group to an already attached connector without fsid
cache.

Reported-and-tested-by: syzbot+c277e8e2f46414645508@syzkaller.appspotmail.com
Fixes: 77115225acc6 ("fanotify: cache fsid in fsnotify_mark_connector")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c    |  4 ++++
 fs/notify/mark.c                 | 14 +++++++++++---
 include/linux/fsnotify_backend.h |  4 +++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 63c6bb1f8c4d..8c286f8228e5 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -355,6 +355,10 @@ static __kernel_fsid_t fanotify_get_fsid(struct fsnotify_iter_info *iter_info)
 		/* Mark is just getting destroyed or created? */
 		if (!conn)
 			continue;
+		if (!(conn->flags & FSNOTIFY_CONN_FLAG_HAS_FSID))
+			continue;
+		/* Pairs with smp_wmb() in fsnotify_add_mark_list() */
+		smp_rmb();
 		fsid = conn->fsid;
 		if (WARN_ON_ONCE(!fsid.val[0] && !fsid.val[1]))
 			continue;
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 22acb0a79b53..e9d49191d39e 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -495,10 +495,13 @@ static int fsnotify_attach_connector_to_object(fsnotify_connp_t *connp,
 	conn->type = type;
 	conn->obj = connp;
 	/* Cache fsid of filesystem containing the object */
-	if (fsid)
+	if (fsid) {
 		conn->fsid = *fsid;
-	else
+		conn->flags = FSNOTIFY_CONN_FLAG_HAS_FSID;
+	} else {
 		conn->fsid.val[0] = conn->fsid.val[1] = 0;
+		conn->flags = 0;
+	}
 	if (conn->type == FSNOTIFY_OBJ_TYPE_INODE)
 		inode = igrab(fsnotify_conn_inode(conn));
 	/*
@@ -573,7 +576,12 @@ static int fsnotify_add_mark_list(struct fsnotify_mark *mark,
 		if (err)
 			return err;
 		goto restart;
-	} else if (fsid && (conn->fsid.val[0] || conn->fsid.val[1]) &&
+	} else if (fsid && !(conn->flags & FSNOTIFY_CONN_FLAG_HAS_FSID)) {
+		conn->fsid = *fsid;
+		/* Pairs with smp_rmb() in fanotify_get_fsid() */
+		smp_wmb();
+		conn->flags |= FSNOTIFY_CONN_FLAG_HAS_FSID;
+	} else if (fsid && (conn->flags & FSNOTIFY_CONN_FLAG_HAS_FSID) &&
 		   (fsid->val[0] != conn->fsid.val[0] ||
 		    fsid->val[1] != conn->fsid.val[1])) {
 		/*
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 094b38f2d9a1..0f67cabbbec8 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -292,7 +292,9 @@ typedef struct fsnotify_mark_connector __rcu *fsnotify_connp_t;
  */
 struct fsnotify_mark_connector {
 	spinlock_t lock;
-	unsigned int type;	/* Type of object [lock] */
+	unsigned short type;	/* Type of object [lock] */
+#define FSNOTIFY_CONN_FLAG_HAS_FSID	0x01
+	unsigned short flags;	/* flags [lock] */
 	__kernel_fsid_t fsid;	/* fsid of filesystem containing object */
 	union {
 		/* Object pointer [lock] */
-- 
2.20.1

