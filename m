Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8532C088D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbgKWMxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387860AbgKWMxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:53:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 433052168B;
        Mon, 23 Nov 2020 12:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135953;
        bh=x5Cq1URUMwzZhi777AdAVQz03lxHFAXQcXWhhs8r99I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XkcCWRPKEYRjpJbNNEWzktrqMzGykfyYTpc/yTCra+HwnzpyQ87njsPro1qMo3Vu
         ENp3JDKZ7TzlFdDvI3Tvtq5bq8gg9un/Zy2t7RhvcvU72MYWmE3HhnZNtO1C1rXZQp
         2CZ4YlK7QP3xQ5vefjDmVEmmqrE6mmFrE5SEecp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.9 247/252] fanotify: fix logic of reporting name info with watched parent
Date:   Mon, 23 Nov 2020 13:23:17 +0100
Message-Id: <20201123121847.506028944@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 7372e79c9eb9d7034e498721eb2861ae4fdbc618 upstream.

The victim inode's parent and name info is required when an event
needs to be delivered to a group interested in filename info OR
when the inode's parent is interested in an event on its children.

Let us call the first condition 'parent_needed' and the second
condition 'parent_interested'.

In fsnotify_parent(), the condition where the inode's parent is
interested in some events on its children, but not necessarily
interested the specific event is called 'parent_watched'.

fsnotify_parent() tests the condition (!parent_watched && !parent_needed)
for sending the event without parent and name info, which is correct.

It then wrongly assumes that parent_watched implies !parent_needed
and tests the condition (parent_watched && !parent_interested)
for sending the event without parent and name info, which is wrong,
because parent may still be needed by some group.

For example, after initializing a group with FAN_REPORT_DFID_NAME and
adding a FAN_MARK_MOUNT with FAN_OPEN mask, open events on non-directory
children of "testdir" are delivered with file name info.

After adding another mark to the same group on the parent "testdir"
with FAN_CLOSE|FAN_EVENT_ON_CHILD mask, open events on non-directory
children of "testdir" are no longer delivered with file name info.

Fix the logic and use auxiliary variables to clarify the conditions.

Fixes: 9b93f33105f5 ("fsnotify: send event with parent/name info to sb/mount/non-dir marks")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201108105906.8493-1-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fsnotify.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -178,6 +178,7 @@ int __fsnotify_parent(struct dentry *den
 	struct inode *inode = d_inode(dentry);
 	struct dentry *parent;
 	bool parent_watched = dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED;
+	bool parent_needed, parent_interested;
 	__u32 p_mask;
 	struct inode *p_inode = NULL;
 	struct name_snapshot name;
@@ -193,7 +194,8 @@ int __fsnotify_parent(struct dentry *den
 		return 0;
 
 	parent = NULL;
-	if (!parent_watched && !fsnotify_event_needs_parent(inode, mnt, mask))
+	parent_needed = fsnotify_event_needs_parent(inode, mnt, mask);
+	if (!parent_watched && !parent_needed)
 		goto notify;
 
 	/* Does parent inode care about events on children? */
@@ -205,17 +207,17 @@ int __fsnotify_parent(struct dentry *den
 
 	/*
 	 * Include parent/name in notification either if some notification
-	 * groups require parent info (!parent_watched case) or the parent is
-	 * interested in this event.
+	 * groups require parent info or the parent is interested in this event.
 	 */
-	if (!parent_watched || (mask & p_mask & ALL_FSNOTIFY_EVENTS)) {
+	parent_interested = mask & p_mask & ALL_FSNOTIFY_EVENTS;
+	if (parent_needed || parent_interested) {
 		/* When notifying parent, child should be passed as data */
 		WARN_ON_ONCE(inode != fsnotify_data_inode(data, data_type));
 
 		/* Notify both parent and child with child name info */
 		take_dentry_name_snapshot(&name, dentry);
 		file_name = &name.name;
-		if (parent_watched)
+		if (parent_interested)
 			mask |= FS_EVENT_ON_CHILD;
 	}
 


