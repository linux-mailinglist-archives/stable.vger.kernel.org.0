Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DC8226858
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgGTQSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731285AbgGTQNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:13:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94362065E;
        Mon, 20 Jul 2020 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261622;
        bh=Z3WwYEHD7u+9ctkPGM3yimUz4PDsga+PbGgh/DhZiqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuRpgGVgJ8V8Wp6X78OXoy/DYOGX6WKIhAzmUdZlZcXgbRb1M55XZssn/o6Ef4w+l
         4Ux9OasQFW5LlG1NFy1aBTdy3P3NmRIL0jhM5opVCEVR9/asCuTtYtSg3TFwDngWe9
         pNOLJiMC9RNNzwHnt+dttL8ZdrgEJ/JdtrvY/RVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.7 183/244] fuse: use ->reconfigure() instead of ->remount_fs()
Date:   Mon, 20 Jul 2020 17:37:34 +0200
Message-Id: <20200720152834.544659224@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit 0189a2d367f49729622fdafaef5da73161591859 upstream.

s_op->remount_fs() is only called from legacy_reconfigure(), which is not
used after being converted to the new API.

Convert to using ->reconfigure().  This restores the previous behavior of
syncing the filesystem and rejecting MS_MANDLOCK on remount.

Fixes: c30da2e981a7 ("fuse: convert to use the new mount API")
Cc: <stable@vger.kernel.org> # v5.4
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/inode.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -121,10 +121,12 @@ static void fuse_evict_inode(struct inod
 	}
 }
 
-static int fuse_remount_fs(struct super_block *sb, int *flags, char *data)
+static int fuse_reconfigure(struct fs_context *fc)
 {
+	struct super_block *sb = fc->root->d_sb;
+
 	sync_filesystem(sb);
-	if (*flags & SB_MANDLOCK)
+	if (fc->sb_flags & SB_MANDLOCK)
 		return -EINVAL;
 
 	return 0;
@@ -817,7 +819,6 @@ static const struct super_operations fus
 	.evict_inode	= fuse_evict_inode,
 	.write_inode	= fuse_write_inode,
 	.drop_inode	= generic_delete_inode,
-	.remount_fs	= fuse_remount_fs,
 	.put_super	= fuse_put_super,
 	.umount_begin	= fuse_umount_begin,
 	.statfs		= fuse_statfs,
@@ -1291,6 +1292,7 @@ static int fuse_get_tree(struct fs_conte
 static const struct fs_context_operations fuse_context_ops = {
 	.free		= fuse_free_fc,
 	.parse_param	= fuse_parse_param,
+	.reconfigure	= fuse_reconfigure,
 	.get_tree	= fuse_get_tree,
 };
 


