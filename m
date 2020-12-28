Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792AA2E3E88
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503554AbgL1O3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:29:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503531AbgL1O3U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:29:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9C1F20739;
        Mon, 28 Dec 2020 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165719;
        bh=bQlWG8m/y2SOdLhkDyeJvXTFSbLfUE+ifkv4i+gjYMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmKBpxz8mK97cbtmNbs5D3oQqQ9kJn+hIjrjUCJaL+OSMNQ2Uc4yy2NShTEbE22mi
         PwDlwd1JcerB/5YlPMCDptCvgsVCZSuOSRA1UPSthRO7dJ4GtwA7NMBDOsbpS/X5u6
         Iw81tKn8gZnuBeY7Wkz0Bg+2G/59Jg7POxBdORbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 630/717] inotify: convert to handle_inode_event() interface
Date:   Mon, 28 Dec 2020 13:50:28 +0100
Message-Id: <20201228125051.099405971@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 1a2620a99803ad660edc5d22fd9c66cce91ceb1c upstream.

Convert inotify to use the simple handle_inode_event() interface to
get rid of the code duplication between the generic helper
fsnotify_handle_event() and the inotify_handle_event() callback, which
also happen to be buggy code.

The bug will be fixed in the generic helper.

Link: https://lore.kernel.org/r/20201202120713.702387-3-amir73il@gmail.com
CC: stable@vger.kernel.org
Fixes: b9a1b9772509 ("fsnotify: create method handle_inode_event() in fsnotify_operations")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/inotify/inotify.h          |    9 ++----
 fs/notify/inotify/inotify_fsnotify.c |   51 +++++------------------------------
 fs/notify/inotify/inotify_user.c     |    8 +----
 3 files changed, 14 insertions(+), 54 deletions(-)

--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -24,11 +24,10 @@ static inline struct inotify_event_info
 
 extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 					   struct fsnotify_group *group);
-extern int inotify_handle_event(struct fsnotify_group *group, u32 mask,
-				const void *data, int data_type,
-				struct inode *dir,
-				const struct qstr *file_name, u32 cookie,
-				struct fsnotify_iter_info *iter_info);
+extern int inotify_handle_inode_event(struct fsnotify_mark *inode_mark,
+				      u32 mask, struct inode *inode,
+				      struct inode *dir,
+				      const struct qstr *name, u32 cookie);
 
 extern const struct fsnotify_ops inotify_fsnotify_ops;
 extern struct kmem_cache *inotify_inode_mark_cachep;
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -55,25 +55,21 @@ static int inotify_merge(struct list_hea
 	return event_compare(last_event, event);
 }
 
-static int inotify_one_event(struct fsnotify_group *group, u32 mask,
-			     struct fsnotify_mark *inode_mark,
-			     const struct path *path,
-			     const struct qstr *file_name, u32 cookie)
+int inotify_handle_inode_event(struct fsnotify_mark *inode_mark, u32 mask,
+			       struct inode *inode, struct inode *dir,
+			       const struct qstr *name, u32 cookie)
 {
 	struct inotify_inode_mark *i_mark;
 	struct inotify_event_info *event;
 	struct fsnotify_event *fsn_event;
+	struct fsnotify_group *group = inode_mark->group;
 	int ret;
 	int len = 0;
 	int alloc_len = sizeof(struct inotify_event_info);
 	struct mem_cgroup *old_memcg;
 
-	if ((inode_mark->mask & FS_EXCL_UNLINK) &&
-	    path && d_unlinked(path->dentry))
-		return 0;
-
-	if (file_name) {
-		len = file_name->len;
+	if (name) {
+		len = name->len;
 		alloc_len += len + 1;
 	}
 
@@ -117,7 +113,7 @@ static int inotify_one_event(struct fsno
 	event->sync_cookie = cookie;
 	event->name_len = len;
 	if (len)
-		strcpy(event->name, file_name->name);
+		strcpy(event->name, name->name);
 
 	ret = fsnotify_add_event(group, fsn_event, inotify_merge);
 	if (ret) {
@@ -131,37 +127,6 @@ static int inotify_one_event(struct fsno
 	return 0;
 }
 
-int inotify_handle_event(struct fsnotify_group *group, u32 mask,
-			 const void *data, int data_type, struct inode *dir,
-			 const struct qstr *file_name, u32 cookie,
-			 struct fsnotify_iter_info *iter_info)
-{
-	const struct path *path = fsnotify_data_path(data, data_type);
-	struct fsnotify_mark *inode_mark = fsnotify_iter_inode_mark(iter_info);
-	struct fsnotify_mark *child_mark = fsnotify_iter_child_mark(iter_info);
-	int ret = 0;
-
-	if (WARN_ON(fsnotify_iter_vfsmount_mark(iter_info)))
-		return 0;
-
-	/*
-	 * Some events cannot be sent on both parent and child marks
-	 * (e.g. IN_CREATE).  Those events are always sent on inode_mark.
-	 * For events that are possible on both parent and child (e.g. IN_OPEN),
-	 * event is sent on inode_mark with name if the parent is watching and
-	 * is sent on child_mark without name if child is watching.
-	 * If both parent and child are watching, report the event with child's
-	 * name here and report another event without child's name below.
-	 */
-	if (inode_mark)
-		ret = inotify_one_event(group, mask, inode_mark, path,
-					file_name, cookie);
-	if (ret || !child_mark)
-		return ret;
-
-	return inotify_one_event(group, mask, child_mark, path, NULL, 0);
-}
-
 static void inotify_freeing_mark(struct fsnotify_mark *fsn_mark, struct fsnotify_group *group)
 {
 	inotify_ignored_and_remove_idr(fsn_mark, group);
@@ -227,7 +192,7 @@ static void inotify_free_mark(struct fsn
 }
 
 const struct fsnotify_ops inotify_fsnotify_ops = {
-	.handle_event = inotify_handle_event,
+	.handle_inode_event = inotify_handle_inode_event,
 	.free_group_priv = inotify_free_group_priv,
 	.free_event = inotify_free_event,
 	.freeing_mark = inotify_freeing_mark,
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -486,14 +486,10 @@ void inotify_ignored_and_remove_idr(stru
 				    struct fsnotify_group *group)
 {
 	struct inotify_inode_mark *i_mark;
-	struct fsnotify_iter_info iter_info = { };
-
-	fsnotify_iter_set_report_type_mark(&iter_info, FSNOTIFY_OBJ_TYPE_INODE,
-					   fsn_mark);
 
 	/* Queue ignore event for the watch */
-	inotify_handle_event(group, FS_IN_IGNORED, NULL, FSNOTIFY_EVENT_NONE,
-			     NULL, NULL, 0, &iter_info);
+	inotify_handle_inode_event(fsn_mark, FS_IN_IGNORED, NULL, NULL, NULL,
+				   0);
 
 	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 	/* remove this mark from the idr */


