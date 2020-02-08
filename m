Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B74C15664E
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgBHSdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:33:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34320 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727910AbgBHS3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrL-0003g4-9v; Sat, 08 Feb 2020 18:29:39 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-000CQR-TL; Sat, 08 Feb 2020 18:29:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arijit Banerjee" <arijit@rubrik.com>,
        "Miklos Szeredi" <mszeredi@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sat, 08 Feb 2020 18:20:26 +0000
Message-ID: <lsq.1581185940.39176846@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 087/148] fuse: verify attributes
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit eb59bd17d2fa6e5e84fba61a5ebdea984222e6d5 upstream.

If a filesystem returns negative inode sizes, future reads on the file were
causing the cpu to spin on truncate_pagecache.

Create a helper to validate the attributes.  This now does two things:

 - check the file mode
 - check if the file size fits in i_size without overflowing

Reported-by: Arijit Banerjee <arijit@rubrik.com>
Fixes: d8a5ba45457e ("[PATCH] FUSE - core")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/dir.c    | 24 +++++++++++++++++-------
 fs/fuse/fuse_i.h |  2 ++
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -250,7 +250,8 @@ static int fuse_dentry_revalidate(struct
 			spin_unlock(&fc->lock);
 		}
 		kfree(forget);
-		if (err || (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
+		if (err || fuse_invalid_attr(&outarg.attr) ||
+		    (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
 			goto invalid;
 
 		fuse_change_attributes(inode, &outarg.attr,
@@ -295,6 +296,12 @@ int fuse_valid_type(int m)
 		S_ISBLK(m) || S_ISFIFO(m) || S_ISSOCK(m);
 }
 
+bool fuse_invalid_attr(struct fuse_attr *attr)
+{
+	return !fuse_valid_type(attr->mode) ||
+		attr->size > LLONG_MAX;
+}
+
 int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
 		     struct fuse_entry_out *outarg, struct inode **inode)
 {
@@ -334,7 +341,7 @@ int fuse_lookup_name(struct super_block
 	err = -EIO;
 	if (!outarg->nodeid)
 		goto out_put_forget;
-	if (!fuse_valid_type(outarg->attr.mode))
+	if (fuse_invalid_attr(&outarg->attr))
 		goto out_put_forget;
 
 	*inode = fuse_iget(sb, outarg->nodeid, outarg->generation,
@@ -464,7 +471,8 @@ static int fuse_create_open(struct inode
 		goto out_free_ff;
 
 	err = -EIO;
-	if (!S_ISREG(outentry.attr.mode) || invalid_nodeid(outentry.nodeid))
+	if (!S_ISREG(outentry.attr.mode) || invalid_nodeid(outentry.nodeid) ||
+	    fuse_invalid_attr(&outentry.attr))
 		goto out_free_ff;
 
 	fuse_put_request(fc, req);
@@ -580,7 +588,7 @@ static int create_new_entry(struct fuse_
 		goto out_put_forget_req;
 
 	err = -EIO;
-	if (invalid_nodeid(outarg.nodeid))
+	if (invalid_nodeid(outarg.nodeid) || fuse_invalid_attr(&outarg.attr))
 		goto out_put_forget_req;
 
 	if ((outarg.attr.mode ^ mode) & S_IFMT)
@@ -971,7 +979,8 @@ static int fuse_do_getattr(struct inode
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
-		if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+		if (fuse_invalid_attr(&outarg.attr) ||
+		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
 			make_bad_inode(inode);
 			err = -EIO;
 		} else {
@@ -1282,7 +1291,7 @@ static int fuse_direntplus_link(struct f
 
 	if (invalid_nodeid(o->nodeid))
 		return -EIO;
-	if (!fuse_valid_type(o->attr.mode))
+	if (fuse_invalid_attr(&o->attr))
 		return -EIO;
 
 	fc = get_fuse_conn(dir);
@@ -1794,7 +1803,8 @@ int fuse_do_setattr(struct dentry *dentr
 		goto error;
 	}
 
-	if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+	if (fuse_invalid_attr(&outarg.attr) ||
+	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
 		make_bad_inode(inode);
 		err = -EIO;
 		goto error;
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -828,6 +828,8 @@ void fuse_ctl_remove_conn(struct fuse_co
  */
 int fuse_valid_type(int m);
 
+bool fuse_invalid_attr(struct fuse_attr *attr);
+
 /**
  * Is current process allowed to perform filesystem operation?
  */

