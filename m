Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78811BCB41
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbgD1Sbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729717AbgD1Sbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 716A02176D;
        Tue, 28 Apr 2020 18:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098704;
        bh=Q8sCDerqS6rityV7Avt0cCY55uZMs6aiOFcpfWnyRCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijajdxOdp6e+H11XRIplquHmtNB3qVGX75xXuqMLNR6D5D69paVJlHGdvW89nO8bn
         OckfklLw0gZ21nEjeqaiflZcZFfRx2Rc5YXTJhRKL3oLaT/VxrD9Bmc9/7chftyiPI
         /22+9TDbjJFdkWTIpkokQB7kP+zBLlmPC7wHYDk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randall Huang <huangrandall@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 5.4 002/168] f2fs: fix to avoid memory leakage in f2fs_listxattr
Date:   Tue, 28 Apr 2020 20:22:56 +0200
Message-Id: <20200428182232.025314631@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
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
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/xattr.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -539,8 +539,9 @@ out:
 ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 {
 	struct inode *inode = d_inode(dentry);
+	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 	struct f2fs_xattr_entry *entry;
-	void *base_addr;
+	void *base_addr, *last_base_addr;
 	int error = 0;
 	size_t rest = buffer_size;
 
@@ -550,6 +551,8 @@ ssize_t f2fs_listxattr(struct dentry *de
 	if (error)
 		return error;
 
+	last_base_addr = (void *)base_addr + XATTR_SIZE(xnid, inode);
+
 	list_for_each_xattr(entry, base_addr) {
 		const struct xattr_handler *handler =
 			f2fs_xattr_handler(entry->e_name_index);
@@ -557,6 +560,15 @@ ssize_t f2fs_listxattr(struct dentry *de
 		size_t prefix_len;
 		size_t size;
 
+		if ((void *)(entry) + sizeof(__u32) > last_base_addr ||
+			(void *)XATTR_NEXT_ENTRY(entry) > last_base_addr) {
+			f2fs_err(F2FS_I_SB(inode), "inode (%lu) has corrupted xattr",
+						inode->i_ino);
+			set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
+			error = -EFSCORRUPTED;
+			goto cleanup;
+		}
+
 		if (!handler || (handler->list && !handler->list(dentry)))
 			continue;
 


