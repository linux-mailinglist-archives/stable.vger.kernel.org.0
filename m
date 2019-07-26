Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694C27673F
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfGZNWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:22:33 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60329 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726681AbfGZNWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 09:22:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9CD852B6;
        Fri, 26 Jul 2019 09:22:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 26 Jul 2019 09:22:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xZgcdb
        AVev8sHoQVylXppkQK8mxuTU3Y+ycpNSHebNM=; b=XFrikWn1HUGnVENBJi4rZX
        6WO9iD8NAbmttZfkTRwtUxR20KSJmYNy1wuCMUo6OV+V1RMwvwbg44Zc8SW0V8SP
        ZxfRGrpfMLuDoz5iVoQFCi1bG8exD54OFIZPjJ45TTSJlM09w/verURuIX1NKsK4
        RfhdDw/nFwY3r3yekm4S3e7Pb5l2cWenDTUigsO2wMwMFWYwvQrX7YiWOfK2jjLk
        2X9Uupb/xsORKQXJBSmt2bmdOc8mdAzpWX2RcLI7bFJBpMOxtfBB4nhwXoVr5x3i
        LPGw6LuQAdV0T6p6kWG3cFPhXR2wFoVkajJMIkYXFvzdo+iAz/rOb+cOkKymMZlw
        ==
X-ME-Sender: <xms:lv46XeD_F9dKfQhKKm0Tn8oh503RJ7FDREnzkLvsCOPQszeySsvQaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:lv46Xbe6g2O6p7bJFZ9awOfGHC3jJH4QrEHtZUUfGDKvoXZKMz4g7Q>
    <xmx:lv46XYUbqv4OyD-Tkg_jYYue8BlT1fowmqKK5iEphlbnzEHIZ2y1nQ>
    <xmx:lv46XW6ynedfNuIIl5kz-uk7isvDt44u5Od_Xw-u9EAxn5n0JNNu2Q>
    <xmx:l_46XXBy5NiATmuDMmnYDQVnqYwwmh5VGxm5qv4Kw-4NtsVucxoKjw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79C17380086;
        Fri, 26 Jul 2019 09:22:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: don't allow any modifications to an immutable file" failed to apply to 4.9-stable tree
To:     darrick.wong@oracle.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jul 2019 15:22:28 +0200
Message-ID: <156414734855241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e53840362771c73eb0a5ff71611507e64e8eecd Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 9 Jun 2019 21:41:41 -0400
Subject: [PATCH] ext4: don't allow any modifications to an immutable file

Don't allow any modifications to a file that's marked immutable, which
means that we have to flush all the writable pages to make the readonly
and we have to check the setattr/setflags parameters more closely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e486e49b31ed..7af835ac8d23 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -269,6 +269,29 @@ static int uuid_is_zero(__u8 u[16])
 }
 #endif
 
+/*
+ * If immutable is set and we are not clearing it, we're not allowed to change
+ * anything else in the inode.  Don't error out if we're only trying to set
+ * immutable on an immutable file.
+ */
+static int ext4_ioctl_check_immutable(struct inode *inode, __u32 new_projid,
+				      unsigned int flags)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int oldflags = ei->i_flags;
+
+	if (!(oldflags & EXT4_IMMUTABLE_FL) || !(flags & EXT4_IMMUTABLE_FL))
+		return 0;
+
+	if ((oldflags & ~EXT4_IMMUTABLE_FL) != (flags & ~EXT4_IMMUTABLE_FL))
+		return -EPERM;
+	if (ext4_has_feature_project(inode->i_sb) &&
+	    __kprojid_val(ei->i_projid) != new_projid)
+		return -EPERM;
+
+	return 0;
+}
+
 static int ext4_ioctl_setflags(struct inode *inode,
 			       unsigned int flags)
 {
@@ -340,6 +363,20 @@ static int ext4_ioctl_setflags(struct inode *inode,
 		}
 	}
 
+	/*
+	 * Wait for all pending directio and then flush all the dirty pages
+	 * for this file.  The flush marks all the pages readonly, so any
+	 * subsequent attempt to write to the file (particularly mmap pages)
+	 * will come through the filesystem and fail.
+	 */
+	if (S_ISREG(inode->i_mode) && !IS_IMMUTABLE(inode) &&
+	    (flags & EXT4_IMMUTABLE_FL)) {
+		inode_dio_wait(inode);
+		err = filemap_write_and_wait(inode->i_mapping);
+		if (err)
+			goto flags_out;
+	}
+
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
@@ -769,7 +806,11 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return err;
 
 		inode_lock(inode);
-		err = ext4_ioctl_setflags(inode, flags);
+		err = ext4_ioctl_check_immutable(inode,
+				from_kprojid(&init_user_ns, ei->i_projid),
+				flags);
+		if (!err)
+			err = ext4_ioctl_setflags(inode, flags);
 		inode_unlock(inode);
 		mnt_drop_write_file(filp);
 		return err;
@@ -1139,6 +1180,9 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto out;
 		flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
 			 (flags & EXT4_FL_XFLAG_VISIBLE);
+		err = ext4_ioctl_check_immutable(inode, fa.fsx_projid, flags);
+		if (err)
+			goto out;
 		err = ext4_ioctl_setflags(inode, flags);
 		if (err)
 			goto out;

