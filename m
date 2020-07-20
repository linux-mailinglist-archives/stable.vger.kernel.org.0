Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098BC226672
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgGTQDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732729AbgGTQDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:03:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E032D2064B;
        Mon, 20 Jul 2020 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260996;
        bh=SxD1oQn/lgwmVRfk0IwFybvo8joUrX9xW8VgBvv2jiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=du87SHDVEk80wQoAvBc7XYM0hSx814fJGAkyVx2eoqZe0aKigl1g4yU0oaaYp9dZF
         pxqqVWUtY2usnkzfdTVtARcPfkG7XmF0Wl9OA3btezrTzedGj5e/1aQVGSbCR+jhe8
         pEFTEQHZ2qNOfkvyawqm8KJYuHlWHRoeX8B+34UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 172/215] ovl: fix unneeded call to ovl_change_flags()
Date:   Mon, 20 Jul 2020 17:37:34 +0200
Message-Id: <20200720152828.358690559@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 81a33c1ee941c3bb9ffc6bac8f676be13351344e upstream.

The check if user has changed the overlay file was wrong, causing unneeded
call to ovl_change_flags() including taking f_lock on every file access.

Fixes: d989903058a8 ("ovl: do not generate duplicate fsnotify events for "fake" path")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/file.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -21,13 +21,16 @@ static char ovl_whatisit(struct inode *i
 		return 'm';
 }
 
+/* No atime modificaton nor notify on underlying */
+#define OVL_OPEN_FLAGS (O_NOATIME | FMODE_NONOTIFY)
+
 static struct file *ovl_open_realfile(const struct file *file,
 				      struct inode *realinode)
 {
 	struct inode *inode = file_inode(file);
 	struct file *realfile;
 	const struct cred *old_cred;
-	int flags = file->f_flags | O_NOATIME | FMODE_NONOTIFY;
+	int flags = file->f_flags | OVL_OPEN_FLAGS;
 
 	old_cred = ovl_override_creds(inode->i_sb);
 	realfile = open_with_fake_path(&file->f_path, flags, realinode,
@@ -48,8 +51,7 @@ static int ovl_change_flags(struct file
 	struct inode *inode = file_inode(file);
 	int err;
 
-	/* No atime modificaton on underlying */
-	flags |= O_NOATIME | FMODE_NONOTIFY;
+	flags |= OVL_OPEN_FLAGS;
 
 	/* If some flag changed that cannot be changed then something's amiss */
 	if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
@@ -102,7 +104,7 @@ static int ovl_real_fdget_meta(const str
 	}
 
 	/* Did the flags change since open? */
-	if (unlikely((file->f_flags ^ real->file->f_flags) & ~O_NOATIME))
+	if (unlikely((file->f_flags ^ real->file->f_flags) & ~OVL_OPEN_FLAGS))
 		return ovl_change_flags(real->file, file->f_flags);
 
 	return 0;


