Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABDE6ECDCB
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjDXN0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjDXN0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:26:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02C9619A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88DA4622D0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1FDC4339C;
        Mon, 24 Apr 2023 13:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342809;
        bh=lSOBpUnFu9VK1D1fFEX3s0tqrCknH4atbNI6skVNVjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbV9sC8tVtSg/qUFpAFNZnwLix9B5q82iOUYBoHIdPal4iNy9OXTZnuObLDj6ottR
         iGKsybOR4pwBhHBqMGocPNRjCdfDvM8k/UoYoe1v3cU3l3v3R6XdDhmnbl+NLO9PoM
         9mVEOpPjCjrw/C4u50w5Pp8nmBbngea5tnYHsspI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <pratyush@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 48/98] mtd: spi-nor: fix memory leak when using debugfs_lookup()
Date:   Mon, 24 Apr 2023 15:17:11 +0200
Message-Id: <20230424131135.738833650@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ec738ca127d07ecac6afae36e2880341ec89150e ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To solve this, remove the
lookup and create the directory on the first device found, and then
remove it when the module is unloaded.

Cc: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-mtd@lists.infradead.org
Reviewed-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20230208160230.2179905-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c    | 14 +++++++++++++-
 drivers/mtd/spi-nor/core.h    |  2 ++
 drivers/mtd/spi-nor/debugfs.c | 11 ++++++++---
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index cda57cb863089..75e694791d8d9 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3272,7 +3272,19 @@ static struct spi_mem_driver spi_nor_driver = {
 	.remove = spi_nor_remove,
 	.shutdown = spi_nor_shutdown,
 };
-module_spi_mem_driver(spi_nor_driver);
+
+static int __init spi_nor_module_init(void)
+{
+	return spi_mem_driver_register(&spi_nor_driver);
+}
+module_init(spi_nor_module_init);
+
+static void __exit spi_nor_module_exit(void)
+{
+	spi_mem_driver_unregister(&spi_nor_driver);
+	spi_nor_debugfs_shutdown();
+}
+module_exit(spi_nor_module_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Huang Shijie <shijie8@gmail.com>");
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index d18dafeb020ab..00bf0d0e955a0 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -709,8 +709,10 @@ static inline struct spi_nor *mtd_to_spi_nor(struct mtd_info *mtd)
 
 #ifdef CONFIG_DEBUG_FS
 void spi_nor_debugfs_register(struct spi_nor *nor);
+void spi_nor_debugfs_shutdown(void);
 #else
 static inline void spi_nor_debugfs_register(struct spi_nor *nor) {}
+static inline void spi_nor_debugfs_shutdown(void) {}
 #endif
 
 #endif /* __LINUX_MTD_SPI_NOR_INTERNAL_H */
diff --git a/drivers/mtd/spi-nor/debugfs.c b/drivers/mtd/spi-nor/debugfs.c
index df76cb5de3f93..5f56b23205d8b 100644
--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -226,13 +226,13 @@ static void spi_nor_debugfs_unregister(void *data)
 	nor->debugfs_root = NULL;
 }
 
+static struct dentry *rootdir;
+
 void spi_nor_debugfs_register(struct spi_nor *nor)
 {
-	struct dentry *rootdir, *d;
+	struct dentry *d;
 	int ret;
 
-	/* Create rootdir once. Will never be deleted again. */
-	rootdir = debugfs_lookup(SPI_NOR_DEBUGFS_ROOT, NULL);
 	if (!rootdir)
 		rootdir = debugfs_create_dir(SPI_NOR_DEBUGFS_ROOT, NULL);
 
@@ -247,3 +247,8 @@ void spi_nor_debugfs_register(struct spi_nor *nor)
 	debugfs_create_file("capabilities", 0444, d, nor,
 			    &spi_nor_capabilities_fops);
 }
+
+void spi_nor_debugfs_shutdown(void)
+{
+	debugfs_remove(rootdir);
+}
-- 
2.39.2



