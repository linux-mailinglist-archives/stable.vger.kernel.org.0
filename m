Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF135CBB9
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfGBIPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfGBIEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:04:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 413C621479;
        Tue,  2 Jul 2019 08:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054682;
        bh=3sGDtnNNHkSBzik1GPgm8oBEsV9m204Seh2XVrY2XE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeuacoxgCnQfJ+TNVl+hujKREOyRANyQ+J+hfwTIueNKHEf3kuuUsF+4vdH1MXiTI
         IDmrfDTsB/bqnlKkxWhMCb7qQUby7eJGKg5urOJV8rIm+vIE9qccPsLPTCYMEDvHsk
         w9MrxbrhZ0ln5zuDG3pTUuiuUkOVC5ivmPoKIW2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>,
        syzbot+c277e8e2f46414645508@syzkaller.appspotmail.com
Subject: [PATCH 5.1 54/55] fanotify: update connector fsid cache on add mark
Date:   Tue,  2 Jul 2019 10:02:02 +0200
Message-Id: <20190702080126.858780989@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit c285a2f01d692ef48d7243cf1072897bbd237407 upstream.

When implementing connector fsid cache, we only initialized the cache
when the first mark added to object was added by FAN_REPORT_FID group.
We forgot to update conn->fsid when the second mark is added by
FAN_REPORT_FID group to an already attached connector without fsid
cache.

Reported-and-tested-by: syzbot+c277e8e2f46414645508@syzkaller.appspotmail.com
Fixes: 77115225acc6 ("fanotify: cache fsid in fsnotify_mark_connector")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fanotify/fanotify.c    |    4 ++++
 fs/notify/mark.c                 |   14 +++++++++++---
 include/linux/fsnotify_backend.h |    4 +++-
 3 files changed, 18 insertions(+), 4 deletions(-)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -355,6 +355,10 @@ static __kernel_fsid_t fanotify_get_fsid
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
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -495,10 +495,13 @@ static int fsnotify_attach_connector_to_
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
@@ -573,7 +576,12 @@ restart:
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
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -292,7 +292,9 @@ typedef struct fsnotify_mark_connector _
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


