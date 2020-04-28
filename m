Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D8A1BC84E
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgD1Sb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729104AbgD1SbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D91F121775;
        Tue, 28 Apr 2020 18:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098685;
        bh=GAiPwIVVBydPgilToYpHU2FaUBilWjF37l3+JT7AkEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ima9zCME9gbvodkFu2/tz4IyQwZNzYgH2QRp9k4EYTyXYn/WcSHvKIr40hGOCnMyv
         RszfZ3rrpcl4l2OcFlOUF74yPdzKGXYaIkMadyJPAvmCI6jhFR4DJHO+Ob8tg704a5
         UuD3/o0v+w2fUaeuTJUYi7qGJ8ytFJ/6aq7ybeYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randall Huang <huangrandall@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/131] f2fs: fix to avoid memory leakage in f2fs_listxattr
Date:   Tue, 28 Apr 2020 20:24:13 +0200
Message-Id: <20200428182230.231555676@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
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
[bwh: Backported to 4.19: Use f2fs_msg() instead of f2fs_err()]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/xattr.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 1dae74f7cccac..201e9da1692a4 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -538,8 +538,9 @@ out:
 ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 {
 	struct inode *inode = d_inode(dentry);
+	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 	struct f2fs_xattr_entry *entry;
-	void *base_addr;
+	void *base_addr, *last_base_addr;
 	int error = 0;
 	size_t rest = buffer_size;
 
@@ -549,6 +550,8 @@ ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 	if (error)
 		return error;
 
+	last_base_addr = (void *)base_addr + XATTR_SIZE(xnid, inode);
+
 	list_for_each_xattr(entry, base_addr) {
 		const struct xattr_handler *handler =
 			f2fs_xattr_handler(entry->e_name_index);
@@ -556,6 +559,16 @@ ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
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
 
-- 
2.20.1



