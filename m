Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C4F22682D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388357AbgGTQPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388353AbgGTQPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47AF822D2C;
        Mon, 20 Jul 2020 16:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261702;
        bh=Umw0qQZ9A4r2/DbuUka5YKnWlE1/51GOA2v+b7VIqYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOcDOvNAZi+NyCPo4xLkUnvYYG8gVq9czAzK9zvlrc3EBn8fjwdHfM84GJHduovyT
         gM1J8yjNOWUbfaHwHbr5E9uWoEbrKdsz2InFks6+wFWATvNky4/Mjxj9f2xQeBdhp4
         /XdBFAG2f2/Y/WXPSZSsO3P46hScQzReCATj7TjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.7 181/244] ovl: fix unneeded call to ovl_change_flags()
Date:   Mon, 20 Jul 2020 17:37:32 +0200
Message-Id: <20200720152834.455914160@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
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
@@ -32,13 +32,16 @@ static char ovl_whatisit(struct inode *i
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
@@ -59,8 +62,7 @@ static int ovl_change_flags(struct file
 	struct inode *inode = file_inode(file);
 	int err;
 
-	/* No atime modificaton on underlying */
-	flags |= O_NOATIME | FMODE_NONOTIFY;
+	flags |= OVL_OPEN_FLAGS;
 
 	/* If some flag changed that cannot be changed then something's amiss */
 	if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
@@ -113,7 +115,7 @@ static int ovl_real_fdget_meta(const str
 	}
 
 	/* Did the flags change since open? */
-	if (unlikely((file->f_flags ^ real->file->f_flags) & ~O_NOATIME))
+	if (unlikely((file->f_flags ^ real->file->f_flags) & ~OVL_OPEN_FLAGS))
 		return ovl_change_flags(real->file, file->f_flags);
 
 	return 0;


