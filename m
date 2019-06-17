Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58AEF49396
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbfFQV11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbfFQV10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:27:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E46B3204FD;
        Mon, 17 Jun 2019 21:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806845;
        bh=DkQ4+3eXZuqP2wd/INZMDQrJBw4VOOOrip6+Xw6VTSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPc6nlhf4JuruuJckvX1QGFFn7p+qyyX50jjR8QMHuo4NSv/WmbbSOTltKH5/iu+g
         7r8CAhmNFVOwONSdzXX1mwQzE9cWoL5hJXCf4M0mIlPDJj0UvadjZX160iVyuGjR4c
         MIRS0PSiqFwyKmFypnLJmt2G+u9c5FvBNcbDu1bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randall Huang <huangrandall@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/75] f2fs: fix to avoid accessing xattr across the boundary
Date:   Mon, 17 Jun 2019 23:09:44 +0200
Message-Id: <20190617210754.076823433@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2777e654371dd4207a3a7f4fb5fa39550053a080 ]

When we traverse xattr entries via __find_xattr(),
if the raw filesystem content is faked or any hardware failure occurs,
out-of-bound error can be detected by KASAN.
Fix the issue by introducing boundary check.

[   38.402878] c7   1827 BUG: KASAN: slab-out-of-bounds in f2fs_getxattr+0x518/0x68c
[   38.402891] c7   1827 Read of size 4 at addr ffffffc0b6fb35dc by task
[   38.402935] c7   1827 Call trace:
[   38.402952] c7   1827 [<ffffff900809003c>] dump_backtrace+0x0/0x6bc
[   38.402966] c7   1827 [<ffffff9008090030>] show_stack+0x20/0x2c
[   38.402981] c7   1827 [<ffffff900871ab10>] dump_stack+0xfc/0x140
[   38.402995] c7   1827 [<ffffff9008325c40>] print_address_description+0x80/0x2d8
[   38.403009] c7   1827 [<ffffff900832629c>] kasan_report_error+0x198/0x1fc
[   38.403022] c7   1827 [<ffffff9008326104>] kasan_report_error+0x0/0x1fc
[   38.403037] c7   1827 [<ffffff9008325000>] __asan_load4+0x1b0/0x1b8
[   38.403051] c7   1827 [<ffffff90085fcc44>] f2fs_getxattr+0x518/0x68c
[   38.403066] c7   1827 [<ffffff90085fc508>] f2fs_xattr_generic_get+0xb0/0xd0
[   38.403080] c7   1827 [<ffffff9008395708>] __vfs_getxattr+0x1f4/0x1fc
[   38.403096] c7   1827 [<ffffff9008621bd0>] inode_doinit_with_dentry+0x360/0x938
[   38.403109] c7   1827 [<ffffff900862d6cc>] selinux_d_instantiate+0x2c/0x38
[   38.403123] c7   1827 [<ffffff900861b018>] security_d_instantiate+0x68/0x98
[   38.403136] c7   1827 [<ffffff9008377db8>] d_splice_alias+0x58/0x348
[   38.403149] c7   1827 [<ffffff900858d16c>] f2fs_lookup+0x608/0x774
[   38.403163] c7   1827 [<ffffff900835eacc>] lookup_slow+0x1e0/0x2cc
[   38.403177] c7   1827 [<ffffff9008367fe0>] walk_component+0x160/0x520
[   38.403190] c7   1827 [<ffffff9008369ef4>] path_lookupat+0x110/0x2b4
[   38.403203] c7   1827 [<ffffff900835dd38>] filename_lookup+0x1d8/0x3a8
[   38.403216] c7   1827 [<ffffff900835eeb0>] user_path_at_empty+0x54/0x68
[   38.403229] c7   1827 [<ffffff9008395f44>] SyS_getxattr+0xb4/0x18c
[   38.403241] c7   1827 [<ffffff9008084200>] el0_svc_naked+0x34/0x38

Signed-off-by: Randall Huang <huangrandall@google.com>
[Jaegeuk Kim: Fix wrong ending boundary]
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/xattr.c | 36 +++++++++++++++++++++++++++---------
 fs/f2fs/xattr.h |  2 ++
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 409a637f7a92..88e30f7cf9e1 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -205,12 +205,17 @@ static inline const struct xattr_handler *f2fs_xattr_handler(int index)
 	return handler;
 }
 
-static struct f2fs_xattr_entry *__find_xattr(void *base_addr, int index,
-					size_t len, const char *name)
+static struct f2fs_xattr_entry *__find_xattr(void *base_addr,
+				void *last_base_addr, int index,
+				size_t len, const char *name)
 {
 	struct f2fs_xattr_entry *entry;
 
 	list_for_each_xattr(entry, base_addr) {
+		if ((void *)(entry) + sizeof(__u32) > last_base_addr ||
+			(void *)XATTR_NEXT_ENTRY(entry) > last_base_addr)
+			return NULL;
+
 		if (entry->e_name_index != index)
 			continue;
 		if (entry->e_name_len != len)
@@ -300,20 +305,22 @@ static int lookup_all_xattrs(struct inode *inode, struct page *ipage,
 				const char *name, struct f2fs_xattr_entry **xe,
 				void **base_addr, int *base_size)
 {
-	void *cur_addr, *txattr_addr, *last_addr = NULL;
+	void *cur_addr, *txattr_addr, *last_txattr_addr;
+	void *last_addr = NULL;
 	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
-	unsigned int size = xnid ? VALID_XATTR_BLOCK_SIZE : 0;
 	unsigned int inline_size = inline_xattr_size(inode);
 	int err = 0;
 
-	if (!size && !inline_size)
+	if (!xnid && !inline_size)
 		return -ENODATA;
 
-	*base_size = inline_size + size + XATTR_PADDING_SIZE;
+	*base_size = XATTR_SIZE(xnid, inode) + XATTR_PADDING_SIZE;
 	txattr_addr = f2fs_kzalloc(F2FS_I_SB(inode), *base_size, GFP_NOFS);
 	if (!txattr_addr)
 		return -ENOMEM;
 
+	last_txattr_addr = (void *)txattr_addr + XATTR_SIZE(xnid, inode);
+
 	/* read from inline xattr */
 	if (inline_size) {
 		err = read_inline_xattr(inode, ipage, txattr_addr);
@@ -340,7 +347,11 @@ static int lookup_all_xattrs(struct inode *inode, struct page *ipage,
 	else
 		cur_addr = txattr_addr;
 
-	*xe = __find_xattr(cur_addr, index, len, name);
+	*xe = __find_xattr(cur_addr, last_txattr_addr, index, len, name);
+	if (!*xe) {
+		err = -EFAULT;
+		goto out;
+	}
 check:
 	if (IS_XATTR_LAST_ENTRY(*xe)) {
 		err = -ENODATA;
@@ -584,7 +595,8 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 			struct page *ipage, int flags)
 {
 	struct f2fs_xattr_entry *here, *last;
-	void *base_addr;
+	void *base_addr, *last_base_addr;
+	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 	int found, newsize;
 	size_t len;
 	__u32 new_hsize;
@@ -608,8 +620,14 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	if (error)
 		return error;
 
+	last_base_addr = (void *)base_addr + XATTR_SIZE(xnid, inode);
+
 	/* find entry with wanted name. */
-	here = __find_xattr(base_addr, index, len, name);
+	here = __find_xattr(base_addr, last_base_addr, index, len, name);
+	if (!here) {
+		error = -EFAULT;
+		goto exit;
+	}
 
 	found = IS_XATTR_LAST_ENTRY(here) ? 0 : 1;
 
diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
index dbcd1d16e669..2a4ecaf338ea 100644
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -74,6 +74,8 @@ struct f2fs_xattr_entry {
 				entry = XATTR_NEXT_ENTRY(entry))
 #define VALID_XATTR_BLOCK_SIZE	(PAGE_SIZE - sizeof(struct node_footer))
 #define XATTR_PADDING_SIZE	(sizeof(__u32))
+#define XATTR_SIZE(x,i)		(((x) ? VALID_XATTR_BLOCK_SIZE : 0) +	\
+						(inline_xattr_size(i)))
 #define MIN_OFFSET(i)		XATTR_ALIGN(inline_xattr_size(i) +	\
 						VALID_XATTR_BLOCK_SIZE)
 
-- 
2.20.1



