Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959FD33B928
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhCOOFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233231AbhCOOBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F239F64F7B;
        Mon, 15 Mar 2021 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816846;
        bh=GB1vwIdOfNR8qRP591rTAIh/r2c1exIUQDAPyVAgDEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OiNotfqIC/xoicSyosM7LOT7dDODH88YEBzVyug/ULu1BaSBP7bHA583scfLYIZ9K
         5F5zxypemOJVGubpD7gHp9rHzhxIs+fTyuAbOkvjgnwx40HAL9Mo958QwM92geKmY0
         pVrPzurULaiOwut8hQEaq5N1S/feX7wEREwiXpcc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daiyue Zhang <zhangdaiyue1@huawei.com>,
        Yi Chen <chenyi77@huawei.com>, Ge Qiu <qiuge@huawei.com>,
        Chao Yu <yuchao0@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/120] configfs: fix a use-after-free in __configfs_open_file
Date:   Mon, 15 Mar 2021 14:57:39 +0100
Message-Id: <20210315135723.514714220@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Daiyue Zhang <zhangdaiyue1@huawei.com>

[ Upstream commit 14fbbc8297728e880070f7b077b3301a8c698ef9 ]

Commit b0841eefd969 ("configfs: provide exclusion between IO and removals")
uses ->frag_dead to mark the fragment state, thus no bothering with extra
refcount on config_item when opening a file. The configfs_get_config_item
was removed in __configfs_open_file, but not with config_item_put. So the
refcount on config_item will lost its balance, causing use-after-free
issues in some occasions like this:

Test:
1. Mount configfs on /config with read-only items:
drwxrwx--- 289 root   root            0 2021-04-01 11:55 /config
drwxr-xr-x   2 root   root            0 2021-04-01 11:54 /config/a
--w--w--w-   1 root   root         4096 2021-04-01 11:53 /config/a/1.txt
......

2. Then run:
for file in /config
do
echo $file
grep -R 'key' $file
done

3. __configfs_open_file will be called in parallel, the first one
got called will do:
if (file->f_mode & FMODE_READ) {
	if (!(inode->i_mode & S_IRUGO))
		goto out_put_module;
			config_item_put(buffer->item);
				kref_put()
					package_details_release()
						kfree()

the other one will run into use-after-free issues like this:
BUG: KASAN: use-after-free in __configfs_open_file+0x1bc/0x3b0
Read of size 8 at addr fffffff155f02480 by task grep/13096
CPU: 0 PID: 13096 Comm: grep VIP: 00 Tainted: G        W       4.14.116-kasan #1
TGID: 13096 Comm: grep
Call trace:
dump_stack+0x118/0x160
kasan_report+0x22c/0x294
__asan_load8+0x80/0x88
__configfs_open_file+0x1bc/0x3b0
configfs_open_file+0x28/0x34
do_dentry_open+0x2cc/0x5c0
vfs_open+0x80/0xe0
path_openat+0xd8c/0x2988
do_filp_open+0x1c4/0x2fc
do_sys_open+0x23c/0x404
SyS_openat+0x38/0x48

Allocated by task 2138:
kasan_kmalloc+0xe0/0x1ac
kmem_cache_alloc_trace+0x334/0x394
packages_make_item+0x4c/0x180
configfs_mkdir+0x358/0x740
vfs_mkdir2+0x1bc/0x2e8
SyS_mkdirat+0x154/0x23c
el0_svc_naked+0x34/0x38

Freed by task 13096:
kasan_slab_free+0xb8/0x194
kfree+0x13c/0x910
package_details_release+0x524/0x56c
kref_put+0xc4/0x104
config_item_put+0x24/0x34
__configfs_open_file+0x35c/0x3b0
configfs_open_file+0x28/0x34
do_dentry_open+0x2cc/0x5c0
vfs_open+0x80/0xe0
path_openat+0xd8c/0x2988
do_filp_open+0x1c4/0x2fc
do_sys_open+0x23c/0x404
SyS_openat+0x38/0x48
el0_svc_naked+0x34/0x38

To fix this issue, remove the config_item_put in
__configfs_open_file to balance the refcount of config_item.

Fixes: b0841eefd969 ("configfs: provide exclusion between IO and removals")
Signed-off-by: Daiyue Zhang <zhangdaiyue1@huawei.com>
Signed-off-by: Yi Chen <chenyi77@huawei.com>
Signed-off-by: Ge Qiu <qiuge@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/file.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index bb0a427517e9..50b7c4c4310e 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -392,7 +392,7 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
 
 	attr = to_attr(dentry);
 	if (!attr)
-		goto out_put_item;
+		goto out_free_buffer;
 
 	if (type & CONFIGFS_ITEM_BIN_ATTR) {
 		buffer->bin_attr = to_bin_attr(dentry);
@@ -405,7 +405,7 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
 	/* Grab the module reference for this attribute if we have one */
 	error = -ENODEV;
 	if (!try_module_get(buffer->owner))
-		goto out_put_item;
+		goto out_free_buffer;
 
 	error = -EACCES;
 	if (!buffer->item->ci_type)
@@ -449,8 +449,6 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
 
 out_put_module:
 	module_put(buffer->owner);
-out_put_item:
-	config_item_put(buffer->item);
 out_free_buffer:
 	up_read(&frag->frag_sem);
 	kfree(buffer);
-- 
2.30.1



