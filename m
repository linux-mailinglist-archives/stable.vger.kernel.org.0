Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E236657E49
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiL1Pwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiL1PwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:52:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E05186F6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:52:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47173B817B0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928C5C433D2;
        Wed, 28 Dec 2022 15:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242729;
        bh=qS3sQKPxUY+CWKSVE4dLqFIwyaZ2m2NE5iWvu3ZYrf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npLkahThC5Sv88lbkfvw2hm4gJwYKkq29O9xvx6ZBUcAKkfKdzv0W92Fb/AMGBxWt
         rJlVHOvm4H4XVVSmZxB7BBdtdmUVfn/AvCc2L7zB+ZLiQJ5dxYCx87+/3K36gsnJZG
         OUz+/5SHE9uniATol79bgZIIKblXxVMr+RQgYssk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0386/1146] mtd: core: Fix refcount error in del_mtd_device()
Date:   Wed, 28 Dec 2022 15:32:05 +0100
Message-Id: <20221228144340.649044052@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 56570bdad5e31c5c538cd6efff5c4510256e1bb4 ]

del_mtd_device() will call of_node_put() to mtd_get_of_node(mtd), which
is mtd->dev.of_node. However, memset(&mtd->dev, 0) is called before
of_node_put(). As the result, of_node_put() won't do anything in
del_mtd_device(), and causes the refcount leak.

del_mtd_device()
    memset(&mtd->dev, 0, sizeof(mtd->dev) # clear mtd->dev
    of_node_put()
        mtd_get_of_node(mtd) # mtd->dev is cleared, can't locate of_node
                             # of_node_put(NULL) won't do anything

Fix the error by caching the pointer of the device_node.

OF: ERROR: memory leak, expected refcount 1 instead of 2,
of_node_get()/of_node_put() unbalanced - destroy cset entry: attach
overlay node /spi/spi-sram@0
CPU: 3 PID: 275 Comm: python3 Tainted: G N 6.1.0-rc3+ #54
    0d8a1edddf51f172ff5226989a7565c6313b08e2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
Call Trace:
<TASK>
    dump_stack_lvl+0x67/0x83
    kobject_get+0x155/0x160
    of_node_get+0x1f/0x30
    of_fwnode_get+0x43/0x70
    fwnode_handle_get+0x54/0x80
    fwnode_get_nth_parent+0xc9/0xe0
    fwnode_full_name_string+0x3f/0xa0
    device_node_string+0x30f/0x750
    pointer+0x598/0x7a0
    vsnprintf+0x62d/0x9b0
    ...
    cfs_overlay_release+0x30/0x90
    config_item_release+0xbe/0x1a0
    config_item_put+0x5e/0x80
    configfs_rmdir+0x3bd/0x540
    vfs_rmdir+0x18c/0x320
    do_rmdir+0x198/0x330
    __x64_sys_rmdir+0x2c/0x40
    do_syscall_64+0x37/0x90
    entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 00596576a051 ("mtd: core: clear out unregistered devices a bit more")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
[<miquel.raynal@bootlin.com>: Light reword of the commit log]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221119063915.11108-1-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 675305139a54..686ada1a63e9 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -776,6 +776,7 @@ int del_mtd_device(struct mtd_info *mtd)
 {
 	int ret;
 	struct mtd_notifier *not;
+	struct device_node *mtd_of_node;
 
 	mutex_lock(&mtd_table_mutex);
 
@@ -794,6 +795,7 @@ int del_mtd_device(struct mtd_info *mtd)
 		       mtd->index, mtd->name, mtd->usecount);
 		ret = -EBUSY;
 	} else {
+		mtd_of_node = mtd_get_of_node(mtd);
 		debugfs_remove_recursive(mtd->dbg.dfs_dir);
 
 		/* Try to remove the NVMEM provider */
@@ -805,7 +807,7 @@ int del_mtd_device(struct mtd_info *mtd)
 		memset(&mtd->dev, 0, sizeof(mtd->dev));
 
 		idr_remove(&mtd_idr, mtd->index);
-		of_node_put(mtd_get_of_node(mtd));
+		of_node_put(mtd_of_node);
 
 		module_put(THIS_MODULE);
 		ret = 0;
-- 
2.35.1



