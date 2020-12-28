Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE7A2E3F65
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503585AbgL1O3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503557AbgL1O3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C14CB2063A;
        Mon, 28 Dec 2020 14:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165722;
        bh=36WiMtRDyTVJcJ5PLAxaQpO1NLh2xLL159iUgPBuEd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBaBrbj/dE0rG8LOY7qQzWAnkpPLoL8ScJReiiSkxnx/g+WnLVB3cWYkW9/ANDZgx
         5XHzVxmYGsyoX7b7sQoPS22WDyjOAq+/TzcAzydRcpjxdh+1HSZf7jk5GekV5sREg3
         b2qbzonX9QggORUVfbKeShmOk+F36ybGYbnAUawU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 631/717] fsnotify: fix events reported to watching parent and child
Date:   Mon, 28 Dec 2020 13:50:29 +0100
Message-Id: <20201228125051.147530651@linuxfoundation.org>
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

commit fecc4559780d52d174ea05e3bf543669165389c3 upstream.

fsnotify_parent() used to send two separate events to backends when a
parent inode is watching children and the child inode is also watching.
In an attempt to avoid duplicate events in fanotify, we unified the two
backend callbacks to a single callback and handled the reporting of the
two separate events for the relevant backends (inotify and dnotify).
However the handling is buggy and can result in inotify and dnotify
listeners receiving events of the type they never asked for or spurious
events.

The problem is the unified event callback with two inode marks (parent and
child) is called when any of the parent and child inodes are watched and
interested in the event, but the parent inode's mark that is interested
in the event on the child is not necessarily the one we are currently
reporting to (it could belong to a different group).

So before reporting the parent or child event flavor to backend we need
to check that the mark is really interested in that event flavor.

The semantics of INODE and CHILD marks were hard to follow and made the
logic more complicated than it should have been.  Replace it with INODE
and PARENT marks semantics to hopefully make the logic more clear.

Thanks to Hugh Dickins for spotting a bug in the earlier version of this
patch.

Fixes: 497b0c5a7c06 ("fsnotify: send event to parent and child with single callback")
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201202120713.702387-4-amir73il@gmail.com
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fanotify/fanotify.c    |    7 +--
 fs/notify/fsnotify.c             |   84 +++++++++++++++++++++++----------------
 include/linux/fsnotify_backend.h |    6 +-
 3 files changed, 57 insertions(+), 40 deletions(-)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -268,12 +268,11 @@ static u32 fanotify_group_event_mask(str
 			continue;
 
 		/*
-		 * If the event is for a child and this mark is on a parent not
+		 * If the event is on a child and this mark is on a parent not
 		 * watching children, don't send it!
 		 */
-		if (event_mask & FS_EVENT_ON_CHILD &&
-		    type == FSNOTIFY_OBJ_TYPE_INODE &&
-		     !(mark->mask & FS_EVENT_ON_CHILD))
+		if (type == FSNOTIFY_OBJ_TYPE_PARENT &&
+		    !(mark->mask & FS_EVENT_ON_CHILD))
 			continue;
 
 		marks_mask |= mark->mask;
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -152,6 +152,13 @@ static bool fsnotify_event_needs_parent(
 	if (mask & FS_ISDIR)
 		return false;
 
+	/*
+	 * All events that are possible on child can also may be reported with
+	 * parent/name info to inode/sb/mount.  Otherwise, a watching parent
+	 * could result in events reported with unexpected name info to sb/mount.
+	 */
+	BUILD_BUG_ON(FS_EVENTS_POSS_ON_CHILD & ~FS_EVENTS_POSS_TO_PARENT);
+
 	/* Did either inode/sb/mount subscribe for events with parent/name? */
 	marks_mask |= fsnotify_parent_needed_mask(inode->i_fsnotify_mask);
 	marks_mask |= fsnotify_parent_needed_mask(inode->i_sb->s_fsnotify_mask);
@@ -249,6 +256,10 @@ static int fsnotify_handle_inode_event(s
 	    path && d_unlinked(path->dentry))
 		return 0;
 
+	/* Check interest of this mark in case event was sent with two marks */
+	if (!(mask & inode_mark->mask & ALL_FSNOTIFY_EVENTS))
+		return 0;
+
 	return ops->handle_inode_event(inode_mark, mask, inode, dir, name, cookie);
 }
 
@@ -258,38 +269,46 @@ static int fsnotify_handle_event(struct
 				 u32 cookie, struct fsnotify_iter_info *iter_info)
 {
 	struct fsnotify_mark *inode_mark = fsnotify_iter_inode_mark(iter_info);
-	struct fsnotify_mark *child_mark = fsnotify_iter_child_mark(iter_info);
+	struct fsnotify_mark *parent_mark = fsnotify_iter_parent_mark(iter_info);
 	int ret;
 
 	if (WARN_ON_ONCE(fsnotify_iter_sb_mark(iter_info)) ||
 	    WARN_ON_ONCE(fsnotify_iter_vfsmount_mark(iter_info)))
 		return 0;
 
-	/*
-	 * An event can be sent on child mark iterator instead of inode mark
-	 * iterator because of other groups that have interest of this inode
-	 * and have marks on both parent and child.  We can simplify this case.
-	 */
-	if (!inode_mark) {
-		inode_mark = child_mark;
-		child_mark = NULL;
+	if (parent_mark) {
+		/*
+		 * parent_mark indicates that the parent inode is watching
+		 * children and interested in this event, which is an event
+		 * possible on child. But is *this mark* watching children and
+		 * interested in this event?
+		 */
+		if (parent_mark->mask & FS_EVENT_ON_CHILD) {
+			ret = fsnotify_handle_inode_event(group, parent_mark, mask,
+							  data, data_type, dir, name, 0);
+			if (ret)
+				return ret;
+		}
+		if (!inode_mark)
+			return 0;
+	}
+
+	if (mask & FS_EVENT_ON_CHILD) {
+		/*
+		 * Some events can be sent on both parent dir and child marks
+		 * (e.g. FS_ATTRIB).  If both parent dir and child are
+		 * watching, report the event once to parent dir with name (if
+		 * interested) and once to child without name (if interested).
+		 * The child watcher is expecting an event without a file name
+		 * and without the FS_EVENT_ON_CHILD flag.
+		 */
+		mask &= ~FS_EVENT_ON_CHILD;
 		dir = NULL;
 		name = NULL;
 	}
 
-	ret = fsnotify_handle_inode_event(group, inode_mark, mask, data, data_type,
-					  dir, name, cookie);
-	if (ret || !child_mark)
-		return ret;
-
-	/*
-	 * Some events can be sent on both parent dir and child marks
-	 * (e.g. FS_ATTRIB).  If both parent dir and child are watching,
-	 * report the event once to parent dir with name and once to child
-	 * without name.
-	 */
-	return fsnotify_handle_inode_event(group, child_mark, mask, data, data_type,
-					   NULL, NULL, 0);
+	return fsnotify_handle_inode_event(group, inode_mark, mask, data, data_type,
+					   dir, name, cookie);
 }
 
 static int send_to_group(__u32 mask, const void *data, int data_type,
@@ -447,7 +466,7 @@ int fsnotify(__u32 mask, const void *dat
 	struct fsnotify_iter_info iter_info = {};
 	struct super_block *sb;
 	struct mount *mnt = NULL;
-	struct inode *child = NULL;
+	struct inode *parent = NULL;
 	int ret = 0;
 	__u32 test_mask, marks_mask;
 
@@ -459,11 +478,10 @@ int fsnotify(__u32 mask, const void *dat
 		inode = dir;
 	} else if (mask & FS_EVENT_ON_CHILD) {
 		/*
-		 * Event on child - report on TYPE_INODE to dir if it is
-		 * watching children and on TYPE_CHILD to child.
+		 * Event on child - report on TYPE_PARENT to dir if it is
+		 * watching children and on TYPE_INODE to child.
 		 */
-		child = inode;
-		inode = dir;
+		parent = dir;
 	}
 	sb = inode->i_sb;
 
@@ -477,7 +495,7 @@ int fsnotify(__u32 mask, const void *dat
 	if (!sb->s_fsnotify_marks &&
 	    (!mnt || !mnt->mnt_fsnotify_marks) &&
 	    (!inode || !inode->i_fsnotify_marks) &&
-	    (!child || !child->i_fsnotify_marks))
+	    (!parent || !parent->i_fsnotify_marks))
 		return 0;
 
 	marks_mask = sb->s_fsnotify_mask;
@@ -485,8 +503,8 @@ int fsnotify(__u32 mask, const void *dat
 		marks_mask |= mnt->mnt_fsnotify_mask;
 	if (inode)
 		marks_mask |= inode->i_fsnotify_mask;
-	if (child)
-		marks_mask |= child->i_fsnotify_mask;
+	if (parent)
+		marks_mask |= parent->i_fsnotify_mask;
 
 
 	/*
@@ -509,9 +527,9 @@ int fsnotify(__u32 mask, const void *dat
 		iter_info.marks[FSNOTIFY_OBJ_TYPE_INODE] =
 			fsnotify_first_mark(&inode->i_fsnotify_marks);
 	}
-	if (child) {
-		iter_info.marks[FSNOTIFY_OBJ_TYPE_CHILD] =
-			fsnotify_first_mark(&child->i_fsnotify_marks);
+	if (parent) {
+		iter_info.marks[FSNOTIFY_OBJ_TYPE_PARENT] =
+			fsnotify_first_mark(&parent->i_fsnotify_marks);
 	}
 
 	/*
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -278,7 +278,7 @@ static inline const struct path *fsnotif
 
 enum fsnotify_obj_type {
 	FSNOTIFY_OBJ_TYPE_INODE,
-	FSNOTIFY_OBJ_TYPE_CHILD,
+	FSNOTIFY_OBJ_TYPE_PARENT,
 	FSNOTIFY_OBJ_TYPE_VFSMOUNT,
 	FSNOTIFY_OBJ_TYPE_SB,
 	FSNOTIFY_OBJ_TYPE_COUNT,
@@ -286,7 +286,7 @@ enum fsnotify_obj_type {
 };
 
 #define FSNOTIFY_OBJ_TYPE_INODE_FL	(1U << FSNOTIFY_OBJ_TYPE_INODE)
-#define FSNOTIFY_OBJ_TYPE_CHILD_FL	(1U << FSNOTIFY_OBJ_TYPE_CHILD)
+#define FSNOTIFY_OBJ_TYPE_PARENT_FL	(1U << FSNOTIFY_OBJ_TYPE_PARENT)
 #define FSNOTIFY_OBJ_TYPE_VFSMOUNT_FL	(1U << FSNOTIFY_OBJ_TYPE_VFSMOUNT)
 #define FSNOTIFY_OBJ_TYPE_SB_FL		(1U << FSNOTIFY_OBJ_TYPE_SB)
 #define FSNOTIFY_OBJ_ALL_TYPES_MASK	((1U << FSNOTIFY_OBJ_TYPE_COUNT) - 1)
@@ -331,7 +331,7 @@ static inline struct fsnotify_mark *fsno
 }
 
 FSNOTIFY_ITER_FUNCS(inode, INODE)
-FSNOTIFY_ITER_FUNCS(child, CHILD)
+FSNOTIFY_ITER_FUNCS(parent, PARENT)
 FSNOTIFY_ITER_FUNCS(vfsmount, VFSMOUNT)
 FSNOTIFY_ITER_FUNCS(sb, SB)
 


