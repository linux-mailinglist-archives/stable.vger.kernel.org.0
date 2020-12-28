Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993842E3F82
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505808AbgL1Okd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:40:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502591AbgL1O2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B821A2245C;
        Mon, 28 Dec 2020 14:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165716;
        bh=XswwtGKOe2JQHg1tS7WNcVglwH6+zp5gLbM0SpqK8uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/GCkAapS8c0c8hWAnoQhT1kd8HzsEii8Jj3oErUyyD1eIh/9tvv42/bfTDvcdArv
         In3QNLYnHamG8FTGw952oEgrM0k51U8LbgES1GVMc31aUOaOmosEiOrvj/PLU69quR
         t/vLnQFamsIcGUZM1LDxrb+jFyb0DeX6bBxVsbOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 629/717] fsnotify: generalize handle_inode_event()
Date:   Mon, 28 Dec 2020 13:50:27 +0100
Message-Id: <20201228125051.059907069@linuxfoundation.org>
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

commit 950cc0d2bef078e1f6459900ca4d4b2a2e0e3c37 upstream.

The handle_inode_event() interface was added as (quoting comment):
"a simple variant of handle_event() for groups that only have inode
marks and don't have ignore mask".

In other words, all backends except fanotify.  The inotify backend
also falls under this category, but because it required extra arguments
it was left out of the initial pass of backends conversion to the
simple interface.

This results in code duplication between the generic helper
fsnotify_handle_event() and the inotify_handle_event() callback
which also happen to be buggy code.

Generalize the handle_inode_event() arguments and add the check for
FS_EXCL_UNLINK flag to the generic helper, so inotify backend could
be converted to use the simple interface.

Link: https://lore.kernel.org/r/20201202120713.702387-2-amir73il@gmail.com
CC: stable@vger.kernel.org
Fixes: b9a1b9772509 ("fsnotify: create method handle_inode_event() in fsnotify_operations")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/filecache.c              |    2 +-
 fs/notify/dnotify/dnotify.c      |    2 +-
 fs/notify/fsnotify.c             |   31 ++++++++++++++++++++++++-------
 include/linux/fsnotify_backend.h |    3 ++-
 kernel/audit_fsnotify.c          |    2 +-
 kernel/audit_tree.c              |    2 +-
 kernel/audit_watch.c             |    2 +-
 7 files changed, 31 insertions(+), 13 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -600,7 +600,7 @@ static struct notifier_block nfsd_file_l
 static int
 nfsd_file_fsnotify_handle_event(struct fsnotify_mark *mark, u32 mask,
 				struct inode *inode, struct inode *dir,
-				const struct qstr *name)
+				const struct qstr *name, u32 cookie)
 {
 	trace_nfsd_file_fsnotify_handle_event(inode, mask);
 
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -72,7 +72,7 @@ static void dnotify_recalc_inode_mask(st
  */
 static int dnotify_handle_event(struct fsnotify_mark *inode_mark, u32 mask,
 				struct inode *inode, struct inode *dir,
-				const struct qstr *name)
+				const struct qstr *name, u32 cookie)
 {
 	struct dnotify_mark *dn_mark;
 	struct dnotify_struct *dn;
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -232,6 +232,26 @@ notify:
 }
 EXPORT_SYMBOL_GPL(__fsnotify_parent);
 
+static int fsnotify_handle_inode_event(struct fsnotify_group *group,
+				       struct fsnotify_mark *inode_mark,
+				       u32 mask, const void *data, int data_type,
+				       struct inode *dir, const struct qstr *name,
+				       u32 cookie)
+{
+	const struct path *path = fsnotify_data_path(data, data_type);
+	struct inode *inode = fsnotify_data_inode(data, data_type);
+	const struct fsnotify_ops *ops = group->ops;
+
+	if (WARN_ON_ONCE(!ops->handle_inode_event))
+		return 0;
+
+	if ((inode_mark->mask & FS_EXCL_UNLINK) &&
+	    path && d_unlinked(path->dentry))
+		return 0;
+
+	return ops->handle_inode_event(inode_mark, mask, inode, dir, name, cookie);
+}
+
 static int fsnotify_handle_event(struct fsnotify_group *group, __u32 mask,
 				 const void *data, int data_type,
 				 struct inode *dir, const struct qstr *name,
@@ -239,13 +259,8 @@ static int fsnotify_handle_event(struct
 {
 	struct fsnotify_mark *inode_mark = fsnotify_iter_inode_mark(iter_info);
 	struct fsnotify_mark *child_mark = fsnotify_iter_child_mark(iter_info);
-	struct inode *inode = fsnotify_data_inode(data, data_type);
-	const struct fsnotify_ops *ops = group->ops;
 	int ret;
 
-	if (WARN_ON_ONCE(!ops->handle_inode_event))
-		return 0;
-
 	if (WARN_ON_ONCE(fsnotify_iter_sb_mark(iter_info)) ||
 	    WARN_ON_ONCE(fsnotify_iter_vfsmount_mark(iter_info)))
 		return 0;
@@ -262,7 +277,8 @@ static int fsnotify_handle_event(struct
 		name = NULL;
 	}
 
-	ret = ops->handle_inode_event(inode_mark, mask, inode, dir, name);
+	ret = fsnotify_handle_inode_event(group, inode_mark, mask, data, data_type,
+					  dir, name, cookie);
 	if (ret || !child_mark)
 		return ret;
 
@@ -272,7 +288,8 @@ static int fsnotify_handle_event(struct
 	 * report the event once to parent dir with name and once to child
 	 * without name.
 	 */
-	return ops->handle_inode_event(child_mark, mask, inode, NULL, NULL);
+	return fsnotify_handle_inode_event(group, child_mark, mask, data, data_type,
+					   NULL, NULL, 0);
 }
 
 static int send_to_group(__u32 mask, const void *data, int data_type,
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -137,6 +137,7 @@ struct mem_cgroup;
  *		if @file_name is not NULL, this is the directory that
  *		@file_name is relative to.
  * @file_name:	optional file name associated with event
+ * @cookie:	inotify rename cookie
  *
  * free_group_priv - called when a group refcnt hits 0 to clean up the private union
  * freeing_mark - called when a mark is being destroyed for some reason.  The group
@@ -151,7 +152,7 @@ struct fsnotify_ops {
 			    struct fsnotify_iter_info *iter_info);
 	int (*handle_inode_event)(struct fsnotify_mark *mark, u32 mask,
 			    struct inode *inode, struct inode *dir,
-			    const struct qstr *file_name);
+			    const struct qstr *file_name, u32 cookie);
 	void (*free_group_priv)(struct fsnotify_group *group);
 	void (*freeing_mark)(struct fsnotify_mark *mark, struct fsnotify_group *group);
 	void (*free_event)(struct fsnotify_event *event);
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -154,7 +154,7 @@ static void audit_autoremove_mark_rule(s
 /* Update mark data in audit rules based on fsnotify events. */
 static int audit_mark_handle_event(struct fsnotify_mark *inode_mark, u32 mask,
 				   struct inode *inode, struct inode *dir,
-				   const struct qstr *dname)
+				   const struct qstr *dname, u32 cookie)
 {
 	struct audit_fsnotify_mark *audit_mark;
 
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -1037,7 +1037,7 @@ static void evict_chunk(struct audit_chu
 
 static int audit_tree_handle_event(struct fsnotify_mark *mark, u32 mask,
 				   struct inode *inode, struct inode *dir,
-				   const struct qstr *file_name)
+				   const struct qstr *file_name, u32 cookie)
 {
 	return 0;
 }
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -466,7 +466,7 @@ void audit_remove_watch_rule(struct audi
 /* Update watch data in audit rules based on fsnotify events. */
 static int audit_watch_handle_event(struct fsnotify_mark *inode_mark, u32 mask,
 				    struct inode *inode, struct inode *dir,
-				    const struct qstr *dname)
+				    const struct qstr *dname, u32 cookie)
 {
 	struct audit_parent *parent;
 


