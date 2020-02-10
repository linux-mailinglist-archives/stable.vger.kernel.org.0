Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4663015786F
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgBJNHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:07:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbgBJMjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:39 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B08A20733;
        Mon, 10 Feb 2020 12:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338379;
        bh=DFJPCdROt0qntKgqeVYtKo/8XNbjrfGdpMW3OmgeaXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwIaIaoZl7FS7y0AsTmGowCT2ujLPW6FVY1JJXq7BkSiaGlEG7xpGaqCaQAWr5rjL
         x4V0VlFn1bTSvWVVb44goJNHhhPd1lJPhO9+nYTAb2NQM92H2SuMzUGRu+ZEsJdZGq
         /zhTnCqCURuzCFZ43jps1pyV3bGM4THaJoawdTpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.5 056/367] utimes: Clamp the timestamps in notify_change()
Date:   Mon, 10 Feb 2020 04:29:29 -0800
Message-Id: <20200210122429.221280725@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit eb31e2f63d85d1bec4f7b136f317e03c03db5503 upstream.

Push clamping timestamps into notify_change(), so in-kernel
callers like nfsd and overlayfs will get similar timestamp
set behavior as utimes.

AV: get rid of clamping in ->setattr() instances; we don't need
to bother with that there, with notify_change() doing normalization
in all cases now (it already did for implicit case, since current_time()
clamps).

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: 42e729b9ddbb ("utimes: Clamp the timestamps before update")
Cc: stable@vger.kernel.org # v5.4
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/attr.c           |   23 +++++++++++------------
 fs/configfs/inode.c |    9 +++------
 fs/f2fs/file.c      |   18 ++++++------------
 fs/ntfs/inode.c     |   18 ++++++------------
 fs/ubifs/file.c     |   18 ++++++------------
 fs/utimes.c         |    4 ++--
 6 files changed, 34 insertions(+), 56 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -183,18 +183,12 @@ void setattr_copy(struct inode *inode, c
 		inode->i_uid = attr->ia_uid;
 	if (ia_valid & ATTR_GID)
 		inode->i_gid = attr->ia_gid;
-	if (ia_valid & ATTR_ATIME) {
-		inode->i_atime = timestamp_truncate(attr->ia_atime,
-						  inode);
-	}
-	if (ia_valid & ATTR_MTIME) {
-		inode->i_mtime = timestamp_truncate(attr->ia_mtime,
-						  inode);
-	}
-	if (ia_valid & ATTR_CTIME) {
-		inode->i_ctime = timestamp_truncate(attr->ia_ctime,
-						  inode);
-	}
+	if (ia_valid & ATTR_ATIME)
+		inode->i_atime = attr->ia_atime;
+	if (ia_valid & ATTR_MTIME)
+		inode->i_mtime = attr->ia_mtime;
+	if (ia_valid & ATTR_CTIME)
+		inode->i_ctime = attr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 
@@ -268,8 +262,13 @@ int notify_change(struct dentry * dentry
 	attr->ia_ctime = now;
 	if (!(ia_valid & ATTR_ATIME_SET))
 		attr->ia_atime = now;
+	else
+		attr->ia_atime = timestamp_truncate(attr->ia_atime, inode);
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
+	else
+		attr->ia_mtime = timestamp_truncate(attr->ia_mtime, inode);
+
 	if (ia_valid & ATTR_KILL_PRIV) {
 		error = security_inode_need_killpriv(dentry);
 		if (error < 0)
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -76,14 +76,11 @@ int configfs_setattr(struct dentry * den
 	if (ia_valid & ATTR_GID)
 		sd_iattr->ia_gid = iattr->ia_gid;
 	if (ia_valid & ATTR_ATIME)
-		sd_iattr->ia_atime = timestamp_truncate(iattr->ia_atime,
-						      inode);
+		sd_iattr->ia_atime = iattr->ia_atime;
 	if (ia_valid & ATTR_MTIME)
-		sd_iattr->ia_mtime = timestamp_truncate(iattr->ia_mtime,
-						      inode);
+		sd_iattr->ia_mtime = iattr->ia_mtime;
 	if (ia_valid & ATTR_CTIME)
-		sd_iattr->ia_ctime = timestamp_truncate(iattr->ia_ctime,
-						      inode);
+		sd_iattr->ia_ctime = iattr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = iattr->ia_mode;
 
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -754,18 +754,12 @@ static void __setattr_copy(struct inode
 		inode->i_uid = attr->ia_uid;
 	if (ia_valid & ATTR_GID)
 		inode->i_gid = attr->ia_gid;
-	if (ia_valid & ATTR_ATIME) {
-		inode->i_atime = timestamp_truncate(attr->ia_atime,
-						  inode);
-	}
-	if (ia_valid & ATTR_MTIME) {
-		inode->i_mtime = timestamp_truncate(attr->ia_mtime,
-						  inode);
-	}
-	if (ia_valid & ATTR_CTIME) {
-		inode->i_ctime = timestamp_truncate(attr->ia_ctime,
-						  inode);
-	}
+	if (ia_valid & ATTR_ATIME)
+		inode->i_atime = attr->ia_atime;
+	if (ia_valid & ATTR_MTIME)
+		inode->i_mtime = attr->ia_mtime;
+	if (ia_valid & ATTR_CTIME)
+		inode->i_ctime = attr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2899,18 +2899,12 @@ int ntfs_setattr(struct dentry *dentry,
 			ia_valid |= ATTR_MTIME | ATTR_CTIME;
 		}
 	}
-	if (ia_valid & ATTR_ATIME) {
-		vi->i_atime = timestamp_truncate(attr->ia_atime,
-					       vi);
-	}
-	if (ia_valid & ATTR_MTIME) {
-		vi->i_mtime = timestamp_truncate(attr->ia_mtime,
-					       vi);
-	}
-	if (ia_valid & ATTR_CTIME) {
-		vi->i_ctime = timestamp_truncate(attr->ia_ctime,
-					       vi);
-	}
+	if (ia_valid & ATTR_ATIME)
+		vi->i_atime = attr->ia_atime;
+	if (ia_valid & ATTR_MTIME)
+		vi->i_mtime = attr->ia_mtime;
+	if (ia_valid & ATTR_CTIME)
+		vi->i_ctime = attr->ia_ctime;
 	mark_inode_dirty(vi);
 out:
 	return err;
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1078,18 +1078,12 @@ static void do_attr_changes(struct inode
 		inode->i_uid = attr->ia_uid;
 	if (attr->ia_valid & ATTR_GID)
 		inode->i_gid = attr->ia_gid;
-	if (attr->ia_valid & ATTR_ATIME) {
-		inode->i_atime = timestamp_truncate(attr->ia_atime,
-						  inode);
-	}
-	if (attr->ia_valid & ATTR_MTIME) {
-		inode->i_mtime = timestamp_truncate(attr->ia_mtime,
-						  inode);
-	}
-	if (attr->ia_valid & ATTR_CTIME) {
-		inode->i_ctime = timestamp_truncate(attr->ia_ctime,
-						  inode);
-	}
+	if (attr->ia_valid & ATTR_ATIME)
+		inode->i_atime = attr->ia_atime;
+	if (attr->ia_valid & ATTR_MTIME)
+		inode->i_mtime = attr->ia_mtime;
+	if (attr->ia_valid & ATTR_CTIME)
+		inode->i_ctime = attr->ia_ctime;
 	if (attr->ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -36,14 +36,14 @@ static int utimes_common(const struct pa
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
 		else if (times[0].tv_nsec != UTIME_NOW) {
-			newattrs.ia_atime = timestamp_truncate(times[0], inode);
+			newattrs.ia_atime = times[0];
 			newattrs.ia_valid |= ATTR_ATIME_SET;
 		}
 
 		if (times[1].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_MTIME;
 		else if (times[1].tv_nsec != UTIME_NOW) {
-			newattrs.ia_mtime = timestamp_truncate(times[1], inode);
+			newattrs.ia_mtime = times[1];
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
 		/*


