Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4977333BA74
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhCOOJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234493AbhCOODo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A46C64F09;
        Mon, 15 Mar 2021 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817022;
        bh=Pm30020gGrM5qI3951SiRp7jWHodZbfmbKsDx1La4hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLi0G7t3Moo9BxSreYqmvhgu3D0umATt1ZQJHJS5WQOobrreio43RxL/WBU7vg3Ql
         QfYz7zZSpHoWgoJpiAhwGsU/VA2i+tnKdJX1cweb9QBPy5qa0/5b03uZ6nICVFW4Fq
         O9YVYxyi6ET8ZSCiJ3uo+hi9SBiN6nUY1SWi3GYA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daiyue Zhang <zhangdaiyue1@huawei.com>,
        Yi Chen <chenyi77@huawei.com>, Ge Qiu <qiuge@huawei.com>,
        Chao Yu <yuchao0@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/290] configfs: fix a use-after-free in __configfs_open_file
Date:   Mon, 15 Mar 2021 14:55:44 +0100
Message-Id: <20210315135550.500767191@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
2.30.1



