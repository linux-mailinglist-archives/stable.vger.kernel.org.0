Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5471E15AFF
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfEGFun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbfEGFkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60267206A3;
        Tue,  7 May 2019 05:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207603;
        bh=oltf7s8yWvOf91gejP7+tfmQ/hNH4o0McIR8F6hT8ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpG6C3IESQwcZyRQnBt7tALx1bais1M0nsL8oJScyW3aPlnRKcJsmhTyYxbbHBpu6
         r/5Tj8+Dd9Kkj0t8oYCwoeTKTrvIxo3P7krH8P+e10JnT3zPh+dyTB6qIfbOPCAAKJ
         dmQR4WZ30mHLRNLIwx0nKP4y3ijUck5502AKQOCM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 50/95] fsnotify: generalize handling of extra event flags
Date:   Tue,  7 May 2019 01:37:39 -0400
Message-Id: <20190507053826.31622-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 007d1e8395eaa59b0e7ad9eb2b53a40859446a88 ]

FS_EVENT_ON_CHILD gets a special treatment in fsnotify() because it is
not a flag specifying an event type, but rather an extra flags that may
be reported along with another event and control the handling of the
event by the backend.

FS_ISDIR is also an "extra flag" and not an "event type" and therefore
desrves the same treatment. With inotify/dnotify backends it was never
possible to set FS_ISDIR in mark masks, so it did not matter.
With fanotify backend, mark adding code jumps through hoops to avoid
setting the FS_ISDIR in the commulative object mask.

Separate the constant ALL_FSNOTIFY_EVENTS to ALL_FSNOTIFY_FLAGS and
ALL_FSNOTIFY_EVENTS, so the latter can be used to test for specific
event types.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 fs/notify/fsnotify.c             | 7 +++----
 include/linux/fsnotify_backend.h | 9 +++++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 506da82ff3f1..dc080c642dd0 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -192,7 +192,7 @@ static int send_to_group(struct inode *to_tell,
 			 struct fsnotify_iter_info *iter_info)
 {
 	struct fsnotify_group *group = NULL;
-	__u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
+	__u32 test_mask = (mask & ALL_FSNOTIFY_EVENTS);
 	__u32 marks_mask = 0;
 	__u32 marks_ignored_mask = 0;
 
@@ -256,8 +256,7 @@ int fsnotify(struct inode *to_tell, __u32 mask, const void *data, int data_is,
 	struct fsnotify_iter_info iter_info;
 	struct mount *mnt;
 	int ret = 0;
-	/* global tests shouldn't care about events on child only the specific event */
-	__u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
+	__u32 test_mask = (mask & ALL_FSNOTIFY_EVENTS);
 
 	if (data_is == FSNOTIFY_EVENT_PATH)
 		mnt = real_mount(((const struct path *)data)->mnt);
@@ -380,7 +379,7 @@ static __init int fsnotify_init(void)
 {
 	int ret;
 
-	BUG_ON(hweight32(ALL_FSNOTIFY_EVENTS) != 23);
+	BUG_ON(hweight32(ALL_FSNOTIFY_BITS) != 23);
 
 	ret = init_srcu_struct(&fsnotify_mark_srcu);
 	if (ret)
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index ce74278a454a..81052313adeb 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -67,15 +67,20 @@
 
 #define ALL_FSNOTIFY_PERM_EVENTS (FS_OPEN_PERM | FS_ACCESS_PERM)
 
+/* Events that can be reported to backends */
 #define ALL_FSNOTIFY_EVENTS (FS_ACCESS | FS_MODIFY | FS_ATTRIB | \
 			     FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN | \
 			     FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE | \
 			     FS_DELETE | FS_DELETE_SELF | FS_MOVE_SELF | \
 			     FS_UNMOUNT | FS_Q_OVERFLOW | FS_IN_IGNORED | \
-			     FS_OPEN_PERM | FS_ACCESS_PERM | FS_EXCL_UNLINK | \
-			     FS_ISDIR | FS_IN_ONESHOT | FS_DN_RENAME | \
+			     FS_OPEN_PERM | FS_ACCESS_PERM | FS_DN_RENAME)
+
+/* Extra flags that may be reported with event or control handling of events */
+#define ALL_FSNOTIFY_FLAGS  (FS_EXCL_UNLINK | FS_ISDIR | FS_IN_ONESHOT | \
 			     FS_DN_MULTISHOT | FS_EVENT_ON_CHILD)
 
+#define ALL_FSNOTIFY_BITS   (ALL_FSNOTIFY_EVENTS | ALL_FSNOTIFY_FLAGS)
+
 struct fsnotify_group;
 struct fsnotify_event;
 struct fsnotify_mark;
-- 
2.20.1

