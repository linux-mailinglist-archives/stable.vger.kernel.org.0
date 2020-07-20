Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC0226676
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732440AbgGTQDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732732AbgGTQDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:03:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F682064B;
        Mon, 20 Jul 2020 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261002;
        bh=VKoFzrKDyz71P6U4CK6UWWX2yQOKa9pLdhf8lUigCG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZq9DaQQDkLZghCiqRrJvwrIR/KMJBEqpC66YF1Bn0kEuNjj9OkwAuytfu/96qwVA
         Duae9FaYgZwa8YwmZxUrk7tIGKnoFzc77xmYAr6Fx0MW83QsFVOBZQqYMnMfzP8UZI
         ElnczjnsdK3yPeTctCKqNHxTd3JJ+wF5uvL3wfzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 174/215] fuse: use ->reconfigure() instead of ->remount_fs()
Date:   Mon, 20 Jul 2020 17:37:36 +0200
Message-Id: <20200720152828.455017325@linuxfoundation.org>
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
@@ -822,7 +824,6 @@ static const struct super_operations fus
 	.evict_inode	= fuse_evict_inode,
 	.write_inode	= fuse_write_inode,
 	.drop_inode	= generic_delete_inode,
-	.remount_fs	= fuse_remount_fs,
 	.put_super	= fuse_put_super,
 	.umount_begin	= fuse_umount_begin,
 	.statfs		= fuse_statfs,
@@ -1296,6 +1297,7 @@ static int fuse_get_tree(struct fs_conte
 static const struct fs_context_operations fuse_context_ops = {
 	.free		= fuse_free_fc,
 	.parse_param	= fuse_parse_param,
+	.reconfigure	= fuse_reconfigure,
 	.get_tree	= fuse_get_tree,
 };
 


