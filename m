Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB57658495
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiL1Q63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbiL1Q5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8321FCEA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:54:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46C286156C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D30C433D2;
        Wed, 28 Dec 2022 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246448;
        bh=qqPHorUplOr6AKJmY8mB2/SxR0HyqLQIt0tKHgrzLZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3L35yMILLEiXzp2792DMNV3wXWKnvVXrKvliih1zvieucTLdRfzAiu52ET9t+Nw1
         dNFb7v/q/GdbVcYYrpGuoCSzBJg7laKikPFdoB9Kgj7rPfHkntMpUxuzthNcqtl+x+
         5prl1G/UkmxH5K0z7HS/PBpfBg1VnEbpPeLVbHjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ChenXiaoSong <chenxiaosong2@huawei.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 1073/1073] cifs: fix use-after-free on the link name
Date:   Wed, 28 Dec 2022 15:44:21 +0100
Message-Id: <20221228144357.386866755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChenXiaoSong <chenxiaosong2@huawei.com>

commit 542228db2f28fdf775b301f2843e1fe486e7c797 upstream.

xfstests generic/011 reported use-after-free bug as follows:

  BUG: KASAN: use-after-free in __d_alloc+0x269/0x859
  Read of size 15 at addr ffff8880078933a0 by task dirstress/952

  CPU: 1 PID: 952 Comm: dirstress Not tainted 6.1.0-rc3+ #77
  Call Trace:
   __dump_stack+0x23/0x29
   dump_stack_lvl+0x51/0x73
   print_address_description+0x67/0x27f
   print_report+0x3e/0x5c
   kasan_report+0x7b/0xa8
   kasan_check_range+0x1b2/0x1c1
   memcpy+0x22/0x5d
   __d_alloc+0x269/0x859
   d_alloc+0x45/0x20c
   d_alloc_parallel+0xb2/0x8b2
   lookup_open+0x3b8/0x9f9
   open_last_lookups+0x63d/0xc26
   path_openat+0x11a/0x261
   do_filp_open+0xcc/0x168
   do_sys_openat2+0x13b/0x3f7
   do_sys_open+0x10f/0x146
   __se_sys_creat+0x27/0x2e
   __x64_sys_creat+0x55/0x6a
   do_syscall_64+0x40/0x96
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

  Allocated by task 952:
   kasan_save_stack+0x1f/0x42
   kasan_set_track+0x21/0x2a
   kasan_save_alloc_info+0x17/0x1d
   __kasan_kmalloc+0x7e/0x87
   __kmalloc_node_track_caller+0x59/0x155
   kstrndup+0x60/0xe6
   parse_mf_symlink+0x215/0x30b
   check_mf_symlink+0x260/0x36a
   cifs_get_inode_info+0x14e1/0x1690
   cifs_revalidate_dentry_attr+0x70d/0x964
   cifs_revalidate_dentry+0x36/0x62
   cifs_d_revalidate+0x162/0x446
   lookup_open+0x36f/0x9f9
   open_last_lookups+0x63d/0xc26
   path_openat+0x11a/0x261
   do_filp_open+0xcc/0x168
   do_sys_openat2+0x13b/0x3f7
   do_sys_open+0x10f/0x146
   __se_sys_creat+0x27/0x2e
   __x64_sys_creat+0x55/0x6a
   do_syscall_64+0x40/0x96
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

  Freed by task 950:
   kasan_save_stack+0x1f/0x42
   kasan_set_track+0x21/0x2a
   kasan_save_free_info+0x1c/0x34
   ____kasan_slab_free+0x1c1/0x1d5
   __kasan_slab_free+0xe/0x13
   __kmem_cache_free+0x29a/0x387
   kfree+0xd3/0x10e
   cifs_fattr_to_inode+0xb6a/0xc8c
   cifs_get_inode_info+0x3cb/0x1690
   cifs_revalidate_dentry_attr+0x70d/0x964
   cifs_revalidate_dentry+0x36/0x62
   cifs_d_revalidate+0x162/0x446
   lookup_open+0x36f/0x9f9
   open_last_lookups+0x63d/0xc26
   path_openat+0x11a/0x261
   do_filp_open+0xcc/0x168
   do_sys_openat2+0x13b/0x3f7
   do_sys_open+0x10f/0x146
   __se_sys_creat+0x27/0x2e
   __x64_sys_creat+0x55/0x6a
   do_syscall_64+0x40/0x96
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

When opened a symlink, link name is from 'inode->i_link', but it may be
reset to a new value when revalidate the dentry. If some processes get the
link name on the race scenario, then UAF will happen on link name.

Fix this by implementing 'get_link' interface to duplicate the link name.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |   26 +++++++++++++++++++++++++-
 fs/cifs/inode.c  |    5 -----
 2 files changed, 25 insertions(+), 6 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1143,8 +1143,32 @@ const struct inode_operations cifs_file_
 	.fiemap = cifs_fiemap,
 };
 
+const char *cifs_get_link(struct dentry *dentry, struct inode *inode,
+			    struct delayed_call *done)
+{
+	char *target_path;
+
+	target_path = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!target_path)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock(&inode->i_lock);
+	if (likely(CIFS_I(inode)->symlink_target)) {
+		strscpy(target_path, CIFS_I(inode)->symlink_target, PATH_MAX);
+	} else {
+		kfree(target_path);
+		target_path = ERR_PTR(-EOPNOTSUPP);
+	}
+	spin_unlock(&inode->i_lock);
+
+	if (!IS_ERR(target_path))
+		set_delayed_call(done, kfree_link, target_path);
+
+	return target_path;
+}
+
 const struct inode_operations cifs_symlink_inode_ops = {
-	.get_link = simple_get_link,
+	.get_link = cifs_get_link,
 	.permission = cifs_permission,
 	.listxattr = cifs_listxattr,
 };
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -215,11 +215,6 @@ cifs_fattr_to_inode(struct inode *inode,
 		kfree(cifs_i->symlink_target);
 		cifs_i->symlink_target = fattr->cf_symlink_target;
 		fattr->cf_symlink_target = NULL;
-
-		if (unlikely(!cifs_i->symlink_target))
-			inode->i_link = ERR_PTR(-EOPNOTSUPP);
-		else
-			inode->i_link = cifs_i->symlink_target;
 	}
 	spin_unlock(&inode->i_lock);
 


