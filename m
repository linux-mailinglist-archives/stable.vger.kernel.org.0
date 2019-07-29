Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972A3794AD
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388283AbfG2TeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388245AbfG2TeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F2D217D4;
        Mon, 29 Jul 2019 19:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428857;
        bh=tFnnW8KSo4byF6W82hamKfZ7QGeCOL5vKLL2w2xncR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsIDyKXViktF/5QW9UntCbE4DVX9jdWYkNvnYbilOQ+6lvKRSALT8RgNU6s45BZsI
         9EJI51st6oAdn8WibgI9OQNEQMnqYoc+6+Kza9kz3oELo6AfxCrDT04GPPHicehWLx
         iClz0Hv+z+gulIcH27PjCHT8Hh5nmITZnCrk2SmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 208/293] ext4: dont allow any modifications to an immutable file
Date:   Mon, 29 Jul 2019 21:21:39 +0200
Message-Id: <20190729190840.393859042@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

commit 2e53840362771c73eb0a5ff71611507e64e8eecd upstream.

Don't allow any modifications to a file that's marked immutable, which
means that we have to flush all the writable pages to make the readonly
and we have to check the setattr/setflags parameters more closely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ioctl.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -210,6 +210,29 @@ static int uuid_is_zero(__u8 u[16])
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
@@ -263,6 +286,20 @@ static int ext4_ioctl_setflags(struct in
 			goto flags_out;
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
@@ -653,7 +690,11 @@ long ext4_ioctl(struct file *filp, unsig
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
@@ -1061,6 +1102,9 @@ resizefs_out:
 			goto out;
 		flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
 			 (flags & EXT4_FL_XFLAG_VISIBLE);
+		err = ext4_ioctl_check_immutable(inode, fa.fsx_projid, flags);
+		if (err)
+			goto out;
 		err = ext4_ioctl_setflags(inode, flags);
 		if (err)
 			goto out;


