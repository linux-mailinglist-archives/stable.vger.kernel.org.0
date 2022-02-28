Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8334B4C72B3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiB1R2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbiB1R2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:28:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2061E5B;
        Mon, 28 Feb 2022 09:27:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E2BAB815B3;
        Mon, 28 Feb 2022 17:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D79C340F1;
        Mon, 28 Feb 2022 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069239;
        bh=CidzmvAFVi43hMNxzqnk5tG9HKIHJRZgVsRGz6ocuw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co6JB92vrzGgpBSnV/1W1F6NLD+e+lQPiDQ0i2PiD4cN2gYs0elC1jxyHkY+jUPJu
         0ySLr5b+7R/kbW4R1MB6n+y2Oqxw5FTvXkVD7raeE8END+fHulVyXl2ZHowfUXpqhB
         3OC+DwqpAlr8jHG5QijfcI54Vl6LpQPmIVcNuN9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChenXiaoSong <chenxiaosong2@huawei.com>,
        Laibin Qiu <qiulaibin@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/31] configfs: fix a race in configfs_{,un}register_subsystem()
Date:   Mon, 28 Feb 2022 18:24:10 +0100
Message-Id: <20220228172201.258455438@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
References: <20220228172159.515152296@linuxfoundation.org>
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



