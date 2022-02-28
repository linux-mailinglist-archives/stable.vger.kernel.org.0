Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AEB4C728A
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiB1R0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiB1R0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:26:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AC486E33;
        Mon, 28 Feb 2022 09:26:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D38A7B815AB;
        Mon, 28 Feb 2022 17:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAEEC340E7;
        Mon, 28 Feb 2022 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069157;
        bh=CidzmvAFVi43hMNxzqnk5tG9HKIHJRZgVsRGz6ocuw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXMPntDm6y+8w4hcinH7mvD2/2bDfECiLO6dOm7waJSovU6OuXvNZByPAUbenM8xM
         YXliMkBP0hM7d0zINBiLm8uf3/Cnw37AFtMGH8JsK6f2kEU96BBupvzgmn+9L9Mv47
         ct94YUWJHKiJHJOBt/+4C3ddCXExRY+dXpeWs5dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChenXiaoSong <chenxiaosong2@huawei.com>,
        Laibin Qiu <qiulaibin@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/29] configfs: fix a race in configfs_{,un}register_subsystem()
Date:   Mon, 28 Feb 2022 18:23:41 +0100
Message-Id: <20220228172143.262489847@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
References: <20220228172141.744228435@linuxfoundation.org>
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
index c875f246cb0e9..ccb49caed502c 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -50,6 +50,14 @@ DECLARE_RWSEM(configfs_rename_sem);
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
@@ -1937,7 +1945,9 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 		group->cg_item.ci_name = group->cg_item.ci_namebuf;
 
 	sd = root->d_fsdata;
+	mutex_lock(&configfs_subsystem_mutex);
 	link_group(to_config_group(sd->s_element), group);
+	mutex_unlock(&configfs_subsystem_mutex);
 
 	inode_lock_nested(d_inode(root), I_MUTEX_PARENT);
 
@@ -1962,7 +1972,9 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 	inode_unlock(d_inode(root));
 
 	if (err) {
+		mutex_lock(&configfs_subsystem_mutex);
 		unlink_group(group);
+		mutex_unlock(&configfs_subsystem_mutex);
 		configfs_release_fs();
 	}
 	put_fragment(frag);
@@ -2008,7 +2020,9 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 
 	dput(dentry);
 
+	mutex_lock(&configfs_subsystem_mutex);
 	unlink_group(group);
+	mutex_unlock(&configfs_subsystem_mutex);
 	configfs_release_fs();
 }
 
-- 
2.34.1



