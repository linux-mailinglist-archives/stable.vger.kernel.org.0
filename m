Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5698440FC
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390657AbfFMQK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731243AbfFMIng (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:43:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3034321743;
        Thu, 13 Jun 2019 08:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415415;
        bh=Y1WnJruasGRm3U9AQ0OHPrzS3NNHvnFoLXqzcfF6xUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkjH+IubBh9ctBlt0I9eYgoUO5stz5jKwN9idzd6n9JkOJn+xca6P+u+OOs4y8PlY
         VIvEWQ6g/XcEgoHFhajD+8AajwI8aHH7IB9W5IQpJCWptgkVhf1JBj+2us0T9vJIiV
         EE7110csV9G40ye2jgtSrvn9VIi3a0SEDds+Iz6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie Horng <eddiehorng.tw@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 117/118] ovl: support stacked SEEK_HOLE/SEEK_DATA
Date:   Thu, 13 Jun 2019 10:34:15 +0200
Message-Id: <20190613075651.140948053@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 9e46b840c7053b5f7a245e98cd239b60d189a96c upstream.

Overlay file f_pos is the master copy that is preserved
through copy up and modified on read/write, but only real
fs knows how to SEEK_HOLE/SEEK_DATA and real fs may impose
limitations that are more strict than ->s_maxbytes for specific
files, so we use the real file to perform seeks.

We do not call real fs for SEEK_CUR:0 query and for SEEK_SET:0
requests.

Fixes: d1d04ef8572b ("ovl: stack file ops")
Reported-by: Eddie Horng <eddiehorng.tw@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/file.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -146,11 +146,47 @@ static int ovl_release(struct inode *ino
 
 static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
 {
-	struct inode *realinode = ovl_inode_real(file_inode(file));
+	struct inode *inode = file_inode(file);
+	struct fd real;
+	const struct cred *old_cred;
+	ssize_t ret;
 
-	return generic_file_llseek_size(file, offset, whence,
-					realinode->i_sb->s_maxbytes,
-					i_size_read(realinode));
+	/*
+	 * The two special cases below do not need to involve real fs,
+	 * so we can optimizing concurrent callers.
+	 */
+	if (offset == 0) {
+		if (whence == SEEK_CUR)
+			return file->f_pos;
+
+		if (whence == SEEK_SET)
+			return vfs_setpos(file, 0, 0);
+	}
+
+	ret = ovl_real_fdget(file, &real);
+	if (ret)
+		return ret;
+
+	/*
+	 * Overlay file f_pos is the master copy that is preserved
+	 * through copy up and modified on read/write, but only real
+	 * fs knows how to SEEK_HOLE/SEEK_DATA and real fs may impose
+	 * limitations that are more strict than ->s_maxbytes for specific
+	 * files, so we use the real file to perform seeks.
+	 */
+	inode_lock(inode);
+	real.file->f_pos = file->f_pos;
+
+	old_cred = ovl_override_creds(inode->i_sb);
+	ret = vfs_llseek(real.file, offset, whence);
+	revert_creds(old_cred);
+
+	file->f_pos = real.file->f_pos;
+	inode_unlock(inode);
+
+	fdput(real);
+
+	return ret;
 }
 
 static void ovl_file_accessed(struct file *file)


