Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916621D8634
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgERRso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730416AbgERRsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:48:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A6AE20671;
        Mon, 18 May 2020 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824122;
        bh=1fHF5grwxTgTWwfq9Mfn5XKvs5M5XYY8AvnqEOnJuws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XT5M0lJhQYywbkP8kfyU7IWlSLur5ZMQPLax6dPFnE0HHiRVqtROrolYAGHlFqdgX
         whjJkg0rrWVh9AF7L6UK/3swWusDC93xMNxT/YsEwx/CKrJCcRqlu6g7MQxTPGdVYe
         sO6BeO/DrG8Hv9+YoY1c9fxZLw/0o/ec9JlSxNMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randall Huang <huangrandall@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 047/114] f2fs: fix to avoid memory leakage in f2fs_listxattr
Date:   Mon, 18 May 2020 19:36:19 +0200
Message-Id: <20200518173511.830041124@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randall Huang <huangrandall@google.com>

commit 688078e7f36c293dae25b338ddc9e0a2790f6e06 upstream.

In f2fs_listxattr, there is no boundary check before
memcpy e_name to buffer.
If the e_name_len is corrupted,
unexpected memory contents may be returned to the buffer.

Signed-off-by: Randall Huang <huangrandall@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[bwh: Backported to 4.14: Use f2fs_msg() instead of f2fs_err()]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -516,8 +516,9 @@ out:
 ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 {
 	struct inode *inode = d_inode(dentry);
+	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 	struct f2fs_xattr_entry *entry;
-	void *base_addr;
+	void *base_addr, *last_base_addr;
 	int error = 0;
 	size_t rest = buffer_size;
 
@@ -527,6 +528,8 @@ ssize_t f2fs_listxattr(struct dentry *de
 	if (error)
 		return error;
 
+	last_base_addr = (void *)base_addr + XATTR_SIZE(xnid, inode);
+
 	list_for_each_xattr(entry, base_addr) {
 		const struct xattr_handler *handler =
 			f2fs_xattr_handler(entry->e_name_index);
@@ -534,6 +537,16 @@ ssize_t f2fs_listxattr(struct dentry *de
 		size_t prefix_len;
 		size_t size;
 
+		if ((void *)(entry) + sizeof(__u32) > last_base_addr ||
+			(void *)XATTR_NEXT_ENTRY(entry) > last_base_addr) {
+			f2fs_msg(dentry->d_sb, KERN_ERR,
+				 "inode (%lu) has corrupted xattr",
+				 inode->i_ino);
+			set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
+			error = -EFSCORRUPTED;
+			goto cleanup;
+		}
+
 		if (!handler || (handler->list && !handler->list(dentry)))
 			continue;
 


