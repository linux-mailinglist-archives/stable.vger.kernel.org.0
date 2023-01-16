Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A8766CA1A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbjAPQ7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbjAPQ6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:58:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6622DE59
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:41:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBDCE61089
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBB1C433D2;
        Mon, 16 Jan 2023 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887303;
        bh=k9XD1RGkiNKjB4ImWJzV4xDbHKBCUZ9EuqSw2aZxvww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8/deAXfO2x3OmK2ZVdFZbvX8VKx7BjnvJnSUEu9wEYshvzc9sxEDXGPCTgiKWQau
         VBi9qGJJPdXxoqZJBBOg+xTAUXxtnEQGafslVoGEjhkWli1KUDSScx+pFqhtvM8fiq
         jJep12qob6/9cS/nxf+Y+mhG93YBvRPL/VrxvSe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/521] mtd: Fix device name leak when register device failed in add_mtd_device()
Date:   Mon, 16 Jan 2023 16:45:59 +0100
Message-Id: <20230116154851.569657794@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 895d68a39481a75c680aa421546931fb11942fa6 ]

There is a kmemleak when register device failed:
  unreferenced object 0xffff888101aab550 (size 8):
    comm "insmod", pid 3922, jiffies 4295277753 (age 925.408s)
    hex dump (first 8 bytes):
      6d 74 64 30 00 88 ff ff                          mtd0....
    backtrace:
      [<00000000bde26724>] __kmalloc_node_track_caller+0x4e/0x150
      [<000000003c32b416>] kvasprintf+0xb0/0x130
      [<000000001f7a8f15>] kobject_set_name_vargs+0x2f/0xb0
      [<000000006e781163>] dev_set_name+0xab/0xe0
      [<00000000e30d0c78>] add_mtd_device+0x4bb/0x700
      [<00000000f3d34de7>] mtd_device_parse_register+0x2ac/0x3f0
      [<00000000c0d88488>] 0xffffffffa0238457
      [<00000000b40d0922>] 0xffffffffa02a008f
      [<0000000023d17b9d>] do_one_initcall+0x87/0x2a0
      [<00000000770f6ca6>] do_init_module+0xdf/0x320
      [<000000007b6768fe>] load_module+0x2f98/0x3330
      [<00000000346bed5a>] __do_sys_finit_module+0x113/0x1b0
      [<00000000674c2290>] do_syscall_64+0x35/0x80
      [<000000004c6a8d97>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

If register device failed, should call put_device() to give up the
reference.

Fixes: 1f24b5a8ecbb ("[MTD] driver model updates")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221022121352.2534682-1-zhangxiaoxu5@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index a0b1a7814e2e..90d9c0e93157 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -567,8 +567,10 @@ int add_mtd_device(struct mtd_info *mtd)
 	dev_set_drvdata(&mtd->dev, mtd);
 	of_node_get(mtd_get_of_node(mtd));
 	error = device_register(&mtd->dev);
-	if (error)
+	if (error) {
+		put_device(&mtd->dev);
 		goto fail_added;
+	}
 
 	if (!IS_ERR_OR_NULL(dfs_dir_mtd)) {
 		mtd->dbg.dfs_dir = debugfs_create_dir(dev_name(&mtd->dev), dfs_dir_mtd);
-- 
2.35.1



