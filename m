Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27FC6AA216
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjCCVpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjCCVoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:44:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B559637FA;
        Fri,  3 Mar 2023 13:43:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5175861921;
        Fri,  3 Mar 2023 21:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3445C433EF;
        Fri,  3 Mar 2023 21:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879733;
        bh=mdXaVsMHHRpVXUk+uZ9EYwJv98Vwf3VmgKDN7QRilxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8NgfZpAHuEJg8Y82lT5T5gBRT/4OHgI3sMdx7RNF5lvYGeEssYUKETlK6YOQwQK8
         SThQyV5IkluqOv3eRHYu+KQx4uhtFzbI9h5DUHfZSA5bJNTSBArRt3WuaC5PZJujQm
         j+BCB/VFuiQRf8cZg92l/hh65AyjjgLwXBhRgJH2fCugM57qJtR60x0umXRRfN5AgV
         PtT1rm8UtBs1lu/gAz+3B1OGn6CtpQQwU3xoTiFHyxxLOlVFjNbZoOSTbKokJV2i2D
         Gin2OzxHjl5Qa5ogB724evperzj+8ihs+AZ75re49CfVttoVeW0xQA8eHaPdWIP6BC
         SXwOBP2SySNvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Sidong Yang <realwakka@gmail.com>,
        Liu Shixin <liushixin2@huawei.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 6.2 29/64] staging: pi433: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:40:31 -0500
Message-Id: <20230303214106.1446460-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 2f36e789e540df6a9fbf471b3a2ba62a8b361586 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.  This requires saving off the root directory dentry to make
creation of individual device subdirectories easier.

Cc: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Sidong Yang <realwakka@gmail.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230202141138.2291946-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/pi433/pi433_if.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/pi433/pi433_if.c b/drivers/staging/pi433/pi433_if.c
index d4e06a3929f3d..b59f6a4cb611a 100644
--- a/drivers/staging/pi433/pi433_if.c
+++ b/drivers/staging/pi433/pi433_if.c
@@ -55,6 +55,7 @@
 static dev_t pi433_dev;
 static DEFINE_IDR(pi433_idr);
 static DEFINE_MUTEX(minor_lock); /* Protect idr accesses */
+static struct dentry *root_dir;	/* debugfs root directory for the driver */
 
 static struct class *pi433_class; /* mainly for udev to create /dev/pi433 */
 
@@ -1306,8 +1307,7 @@ static int pi433_probe(struct spi_device *spi)
 	/* spi setup */
 	spi_set_drvdata(spi, device);
 
-	entry = debugfs_create_dir(dev_name(device->dev),
-				   debugfs_lookup(KBUILD_MODNAME, NULL));
+	entry = debugfs_create_dir(dev_name(device->dev), root_dir);
 	debugfs_create_file("regs", 0400, entry, device, &pi433_debugfs_regs_fops);
 
 	return 0;
@@ -1333,9 +1333,8 @@ static int pi433_probe(struct spi_device *spi)
 static void pi433_remove(struct spi_device *spi)
 {
 	struct pi433_device	*device = spi_get_drvdata(spi);
-	struct dentry *mod_entry = debugfs_lookup(KBUILD_MODNAME, NULL);
 
-	debugfs_remove(debugfs_lookup(dev_name(device->dev), mod_entry));
+	debugfs_lookup_and_remove(dev_name(device->dev), root_dir);
 
 	/* free GPIOs */
 	free_gpio(device);
@@ -1408,7 +1407,7 @@ static int __init pi433_init(void)
 		return PTR_ERR(pi433_class);
 	}
 
-	debugfs_create_dir(KBUILD_MODNAME, NULL);
+	root_dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
 
 	status = spi_register_driver(&pi433_spi_driver);
 	if (status < 0) {
@@ -1427,7 +1426,7 @@ static void __exit pi433_exit(void)
 	spi_unregister_driver(&pi433_spi_driver);
 	class_destroy(pi433_class);
 	unregister_chrdev(MAJOR(pi433_dev), pi433_spi_driver.driver.name);
-	debugfs_remove_recursive(debugfs_lookup(KBUILD_MODNAME, NULL));
+	debugfs_remove(root_dir);
 }
 module_exit(pi433_exit);
 
-- 
2.39.2

