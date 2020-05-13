Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD31D0DD1
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388370AbgEMJ4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388364AbgEMJ4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:56:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1683120575;
        Wed, 13 May 2020 09:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363763;
        bh=4iIVcTifZvL8nu1DaxM0FGI8SpGg4kPPmBLvdLJ7DP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSl1i5PiJoE03uaPtkRXSH4ddskwgDnTju1VzKEx92wPaBbO/xCgyYgF5pTK/hQnY
         CFG4jsgPmATBaenvJilZ+/2ZLPRDew3kaC7bDwiPvOtrUG73DgnNWYlIZ6xmG67WaK
         qC4F5ghsGgVERltGhc0alxyaZX8p8ebLWWiyT1io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 117/118] fsnotify: replace inode pointer with an object id
Date:   Wed, 13 May 2020 11:45:36 +0200
Message-Id: <20200513094428.087814857@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit dfc2d2594e4a79204a3967585245f00644b8f838 ]

The event inode field is used only for comparison in queue merges and
cannot be dereferenced after handle_event(), because it does not hold a
refcount on the inode.

Replace it with an abstract id to do the same thing.

Link: https://lore.kernel.org/r/20200319151022.31456-8-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c        | 4 ++--
 fs/notify/inotify/inotify_fsnotify.c | 4 ++--
 fs/notify/inotify/inotify_user.c     | 2 +-
 include/linux/fsnotify_backend.h     | 7 +++----
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 5778d1347b351..14d0ac4664595 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -26,7 +26,7 @@ static bool should_merge(struct fsnotify_event *old_fsn,
 	old = FANOTIFY_E(old_fsn);
 	new = FANOTIFY_E(new_fsn);
 
-	if (old_fsn->inode != new_fsn->inode || old->pid != new->pid ||
+	if (old_fsn->objectid != new_fsn->objectid || old->pid != new->pid ||
 	    old->fh_type != new->fh_type || old->fh_len != new->fh_len)
 		return false;
 
@@ -314,7 +314,7 @@ struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 	if (!event)
 		goto out;
 init: __maybe_unused
-	fsnotify_init_event(&event->fse, inode);
+	fsnotify_init_event(&event->fse, (unsigned long)inode);
 	event->mask = mask;
 	if (FAN_GROUP_FLAG(group, FAN_REPORT_TID))
 		event->pid = get_pid(task_pid(current));
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index d510223d302ca..589dee9629938 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -39,7 +39,7 @@ static bool event_compare(struct fsnotify_event *old_fsn,
 	if (old->mask & FS_IN_IGNORED)
 		return false;
 	if ((old->mask == new->mask) &&
-	    (old_fsn->inode == new_fsn->inode) &&
+	    (old_fsn->objectid == new_fsn->objectid) &&
 	    (old->name_len == new->name_len) &&
 	    (!old->name_len || !strcmp(old->name, new->name)))
 		return true;
@@ -118,7 +118,7 @@ int inotify_handle_event(struct fsnotify_group *group,
 		mask &= ~IN_ISDIR;
 
 	fsn_event = &event->fse;
-	fsnotify_init_event(fsn_event, inode);
+	fsnotify_init_event(fsn_event, (unsigned long)inode);
 	event->mask = mask;
 	event->wd = i_mark->wd;
 	event->sync_cookie = cookie;
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 107537a543fd8..81ffc8629fc4b 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -635,7 +635,7 @@ static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 		return ERR_PTR(-ENOMEM);
 	}
 	group->overflow_event = &oevent->fse;
-	fsnotify_init_event(group->overflow_event, NULL);
+	fsnotify_init_event(group->overflow_event, 0);
 	oevent->mask = FS_Q_OVERFLOW;
 	oevent->wd = -1;
 	oevent->sync_cookie = 0;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 1915bdba2fad9..64cfb5446f4d4 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -133,8 +133,7 @@ struct fsnotify_ops {
  */
 struct fsnotify_event {
 	struct list_head list;
-	/* inode may ONLY be dereferenced during handle_event(). */
-	struct inode *inode;	/* either the inode the event happened to or its parent */
+	unsigned long objectid;	/* identifier for queue merges */
 };
 
 /*
@@ -500,10 +499,10 @@ extern void fsnotify_finish_user_wait(struct fsnotify_iter_info *iter_info);
 extern bool fsnotify_prepare_user_wait(struct fsnotify_iter_info *iter_info);
 
 static inline void fsnotify_init_event(struct fsnotify_event *event,
-				       struct inode *inode)
+				       unsigned long objectid)
 {
 	INIT_LIST_HEAD(&event->list);
-	event->inode = inode;
+	event->objectid = objectid;
 }
 
 #else
-- 
2.20.1



