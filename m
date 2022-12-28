Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E22B657F5E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbiL1QEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbiL1QEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:04:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39BBF49
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:04:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67BB3B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE276C433D2;
        Wed, 28 Dec 2022 16:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243443;
        bh=ss+jQ5kl6mj6+G0f9dLPvAk08vCqGQW+r0073x108zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiCrQR6odznaBsiv8fEaYDG4NmblHTKAg9hkTcfLBXi8sPkmyuLAn3Dx1nmqMj6eU
         ARjv6/QPfhXEPiJhOgVS17dkh+ap0Xo1HR82UgyKps7zz8ZZUwn3ToHjk8Q9z7rWD9
         LRR5aXGuIKyIQDiMNdVcKj0d01RcP6iCvTsVv8wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0475/1146] configfs: fix possible memory leak in configfs_create_dir()
Date:   Wed, 28 Dec 2022 15:33:34 +0100
Message-Id: <20221228144343.085835030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index d1f9d2632202..ec6519e1ca3b 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -316,6 +316,7 @@ static int configfs_create_dir(struct config_item *item, struct dentry *dentry,
 	return 0;
 
 out_remove:
+	configfs_put(dentry->d_fsdata);
 	configfs_remove_dirent(dentry);
 	return PTR_ERR(inode);
 }
@@ -382,6 +383,7 @@ int configfs_create_link(struct configfs_dirent *target, struct dentry *parent,
 	return 0;
 
 out_remove:
+	configfs_put(dentry->d_fsdata);
 	configfs_remove_dirent(dentry);
 	return PTR_ERR(inode);
 }
-- 
2.35.1



