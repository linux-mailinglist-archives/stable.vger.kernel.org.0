Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97314C744F
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236480AbiB1RmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236769AbiB1Rkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:40:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BBA986DE;
        Mon, 28 Feb 2022 09:34:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7536614AC;
        Mon, 28 Feb 2022 17:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC80DC340E7;
        Mon, 28 Feb 2022 17:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069674;
        bh=XFprmJuZOhsQUKyrrUZXt41mOVKvj1+Gs65IZBSSPBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aab0QNVRVhhgQbnqGfF/AF+TfWconvb7TXxhwB/ZLxyPw7jDqEs2G67oCbVOdLbg5
         z0oP31OX53gM0hEFUG75VUnbnpJMDWEKXoaQ7/f5QDK3RezqGs/RNBRB/YgPpxTvah
         lVVKBwBxX93MdGMoCO5pz/5AohdOfy4+cTDWiJ4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChenXiaoSong <chenxiaosong2@huawei.com>,
        Laibin Qiu <qiulaibin@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/80] configfs: fix a race in configfs_{,un}register_subsystem()
Date:   Mon, 28 Feb 2022 18:24:31 +0100
Message-Id: <20220228172317.705510418@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit 84ec758fb2daa236026506868c8796b0500c047d ]

When configfs_register_subsystem() or configfs_unregister_subsystem()
is executing link_group() or unlink_group(),
it is possible that two processes add or delete list concurrently.
Some unfortunate interleavings of them can cause kernel panic.

One of cases is:
A --> B --> C --> D
A <-- B <-- C <-- D

     delete list_head *B        |      delete list_head *C
--------------------------------|-----------------------------------
configfs_unregister_subsystem   |   configfs_unregister_subsystem
  unlink_group                  |     unlink_group
    unlink_obj                  |       unlink_obj
      list_del_init             |         list_del_init
        __list_del_entry        |           __list_del_entry
          __list_del            |             __list_del
            // next == C        |
            next->prev = prev   |
                                |               next->prev = prev
            prev->next = next   |
                                |                 // prev == B
                                |                 prev->next = next

Fix this by adding mutex when calling link_group() or unlink_group(),
but parent configfs_subsystem is NULL when config_item is root.
So I create a mutex configfs_subsystem_mutex.

Fixes: 7063fbf22611 ("[PATCH] configfs: User-driven configuration filesystem")
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Laibin Qiu <qiulaibin@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 32ddad3ec5d53..5ad27e484014f 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -36,6 +36,14 @@
  */
 DEFINE_SPINLOCK(configfs_dirent_lock);
 
+/*
+ * All of link_obj/unlink_obj/link_group/unlink_group require that
+ * subsys->su_mutex is held.
+ * But parent configfs_subsystem is NULL when config_item is root.
+ * Use this mutex when config_item is root.
+ */
+static DEFINE_MUTEX(configfs_subsystem_mutex);
+
 static void configfs_d_iput(struct dentry * dentry,
 			    struct inode * inode)
 {
@@ -1884,7 +1892,9 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 		group->cg_item.ci_name = group->cg_item.ci_namebuf;
 
 	sd = root->d_fsdata;
+	mutex_lock(&configfs_subsystem_mutex);
 	link_group(to_config_group(sd->s_element), group);
+	mutex_unlock(&configfs_subsystem_mutex);
 
 	inode_lock_nested(d_inode(root), I_MUTEX_PARENT);
 
@@ -1909,7 +1919,9 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 	inode_unlock(d_inode(root));
 
 	if (err) {
+		mutex_lock(&configfs_subsystem_mutex);
 		unlink_group(group);
+		mutex_unlock(&configfs_subsystem_mutex);
 		configfs_release_fs();
 	}
 	put_fragment(frag);
@@ -1956,7 +1968,9 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 
 	dput(dentry);
 
+	mutex_lock(&configfs_subsystem_mutex);
 	unlink_group(group);
+	mutex_unlock(&configfs_subsystem_mutex);
 	configfs_release_fs();
 }
 
-- 
2.34.1



