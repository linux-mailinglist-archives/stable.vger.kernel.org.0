Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE095667528
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjALOTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbjALOR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:17:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BBF5793F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:09:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04EA361F74
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0771CC433EF;
        Thu, 12 Jan 2023 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532589;
        bh=F7rQJqs9lnoIXtTM4+2FUd2+85c5WYh38YDURi7koTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/4h9QKqDLmLId1gvUrILREA6JvVERIE3Z9Fz3hvip8WY8DrPQOgDdE98uNsin2k5
         2vLMY3V0Nor4D8isAU1rLwMWwaGgSeDgq2ceTsZe52UDehdNdmmxx4u7o45+i8jElg
         qb3OqvhUp8qs/wLgr3LE47o4MpS1t2AMkJFTjR6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/783] configfs: fix possible memory leak in configfs_create_dir()
Date:   Thu, 12 Jan 2023 14:48:48 +0100
Message-Id: <20230112135534.176117713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit c65234b283a65cfbfc94619655e820a5e55199eb ]

kmemleak reported memory leaks in configfs_create_dir():

unreferenced object 0xffff888009f6af00 (size 192):
  comm "modprobe", pid 3777, jiffies 4295537735 (age 233.784s)
  backtrace:
    kmem_cache_alloc (mm/slub.c:3250 mm/slub.c:3256 mm/slub.c:3263 mm/slub.c:3273)
    new_fragment (./include/linux/slab.h:600 fs/configfs/dir.c:163)
    configfs_register_subsystem (fs/configfs/dir.c:1857)
    basic_write (drivers/hwtracing/stm/p_basic.c:14) stm_p_basic
    do_one_initcall (init/main.c:1296)
    do_init_module (kernel/module/main.c:2455)
    ...

unreferenced object 0xffff888003ba7180 (size 96):
  comm "modprobe", pid 3777, jiffies 4295537735 (age 233.784s)
  backtrace:
    kmem_cache_alloc (mm/slub.c:3250 mm/slub.c:3256 mm/slub.c:3263 mm/slub.c:3273)
    configfs_new_dirent (./include/linux/slab.h:723 fs/configfs/dir.c:194)
    configfs_make_dirent (fs/configfs/dir.c:248)
    configfs_create_dir (fs/configfs/dir.c:296)
    configfs_attach_group.isra.28 (fs/configfs/dir.c:816 fs/configfs/dir.c:852)
    configfs_register_subsystem (fs/configfs/dir.c:1881)
    basic_write (drivers/hwtracing/stm/p_basic.c:14) stm_p_basic
    do_one_initcall (init/main.c:1296)
    do_init_module (kernel/module/main.c:2455)
    ...

This is because the refcount is not correct in configfs_make_dirent().
For normal stage, the refcount is changing as:

configfs_register_subsystem()
  configfs_create_dir()
    configfs_make_dirent()
      configfs_new_dirent() # set s_count = 1
      dentry->d_fsdata = configfs_get(sd); # s_count = 2
...
configfs_unregister_subsystem()
  configfs_remove_dir()
    remove_dir()
      configfs_remove_dirent() # s_count = 1
    dput() ...
      *dentry_unlink_inode()*
        configfs_d_iput() # s_count = 0, release

However, if we failed in configfs_create():

configfs_register_subsystem()
  configfs_create_dir()
    configfs_make_dirent() # s_count = 2
    ...
    configfs_create() # fail
    ->out_remove:
    configfs_remove_dirent(dentry)
      configfs_put(sd) # s_count = 1
      return PTR_ERR(inode);

There is no inode in the error path, so the configfs_d_iput() is lost
and makes sd and fragment memory leaked.

To fix this, when we failed in configfs_create(), manually call
configfs_put(sd) to keep the refcount correct.

Fixes: 7063fbf22611 ("[PATCH] configfs: User-driven configuration filesystem")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 5ad27e484014..12388ed4faa5 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -317,6 +317,7 @@ static int configfs_create_dir(struct config_item *item, struct dentry *dentry,
 	return 0;
 
 out_remove:
+	configfs_put(dentry->d_fsdata);
 	configfs_remove_dirent(dentry);
 	return PTR_ERR(inode);
 }
@@ -383,6 +384,7 @@ int configfs_create_link(struct configfs_dirent *target, struct dentry *parent,
 	return 0;
 
 out_remove:
+	configfs_put(dentry->d_fsdata);
 	configfs_remove_dirent(dentry);
 	return PTR_ERR(inode);
 }
-- 
2.35.1



