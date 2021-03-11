Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF759337172
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhCKLfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhCKLfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:35:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC0E764F35;
        Thu, 11 Mar 2021 11:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615462516;
        bh=QAJISEQfEvhTRZwuVwqrfN6snvt2kOJhPwWipRjOkBM=;
        h=From:To:Cc:Subject:Date:From;
        b=fZY10M1Kte2mrHHvaNPVcEhdncP+N42qk14pZyszqvN2i6TrGYlXh2Alqc0m2sjMo
         eB/znL5P7nbulg0CwfJsO1//joNT5tWKZM/FAnjC3EPCtM/5RMpa81YN95dbjtNMPK
         CGbQZZEb2rcIMcbU2AhIAy9hrOTWuGvv0Mu7dXDU=
From:   gregkh@linuxfoundation.org
To:     Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>
Cc:     linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2] configfs: Fix config_item refcnt error in __configfs_open_file()
Date:   Thu, 11 Mar 2021 12:35:10 +0100
Message-Id: <20210311113510.1031406-1-gregkh@linuxfoundation.org>
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
v2: goto the correct out_ label as pointed out by Christoph

 fs/configfs/file.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 1f0270229d7b..da8351d1e455 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -378,7 +378,7 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
 
 	attr = to_attr(dentry);
 	if (!attr)
-		goto out_put_item;
+		goto out_free_buffer;
 
 	if (type & CONFIGFS_ITEM_BIN_ATTR) {
 		buffer->bin_attr = to_bin_attr(dentry);
@@ -391,7 +391,7 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
 	/* Grab the module reference for this attribute if we have one */
 	error = -ENODEV;
 	if (!try_module_get(buffer->owner))
-		goto out_put_item;
+		goto out_free_buffer;
 
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

