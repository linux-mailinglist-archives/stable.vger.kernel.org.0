Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9543370CF
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhCKLGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232461AbhCKLGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:06:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C7864F2D;
        Thu, 11 Mar 2021 11:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615460762;
        bh=cyhRmiXv5k47ECRCfIL5lHCW87E4NQGgeaFIfdFjPyk=;
        h=From:To:Cc:Subject:Date:From;
        b=vmCVT/wWfijArX9Q0V5zen6LvPlmGHTn8eDIJYOTn10Ave/cdZuYQU2MZ8C1CmlcP
         vufVPg+fMKOBXG8n03GNKg5/63p/xsMDrLHJvd/u2mgDAT4xPoHVNust4PuhLQXvJd
         4wcJI35+WnoyWZAmBM9XZF7nAdxXlXw1/gXbEOKM=
From:   gregkh@linuxfoundation.org
To:     Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>
Cc:     linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] configfs: Fix config_item refcnt error in __configfs_open_file()
Date:   Thu, 11 Mar 2021 12:05:50 +0100
Message-Id: <20210311110550.981100-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Rosenberg <drosen@google.com>

__configfs_open_file() used to use configfs_get_config_item, but changed
in commit b0841eefd969 ("configfs: provide exclusion between IO and
removals") to just call to_item. The error path still tries to clean up
the reference, incorrectly decrementing the ref count.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Cc: stable@vger.kernel.org
Fixes: b0841eefd969 ("configfs: provide exclusion between IO and removals")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/configfs/file.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 1f0270229d7b..8b7c8a8a09f3 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -378,7 +378,7 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
 
 	attr = to_attr(dentry);
 	if (!attr)
-		goto out_put_item;
+		goto out_put_module;
 
 	if (type & CONFIGFS_ITEM_BIN_ATTR) {
 		buffer->bin_attr = to_bin_attr(dentry);
@@ -391,7 +391,7 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
 	/* Grab the module reference for this attribute if we have one */
 	error = -ENODEV;
 	if (!try_module_get(buffer->owner))
-		goto out_put_item;
+		goto out_put_module;
 
 	error = -EACCES;
 	if (!buffer->item->ci_type)
@@ -435,8 +435,6 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
 
 out_put_module:
 	module_put(buffer->owner);
-out_put_item:
-	config_item_put(buffer->item);
 out_free_buffer:
 	up_read(&frag->frag_sem);
 	kfree(buffer);
-- 
2.30.2

