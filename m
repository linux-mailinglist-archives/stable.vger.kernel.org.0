Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763EA6AA246
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjCCVqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbjCCVqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:46:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41F16EB4;
        Fri,  3 Mar 2023 13:44:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1418761912;
        Fri,  3 Mar 2023 21:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314CAC433A1;
        Fri,  3 Mar 2023 21:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879853;
        bh=jBO+9yF13EmApSE0R4KjaJE9woEJGEqHfkyOh+W2jNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTgr6azp6cF0dCyq3FXJYVYv2NB+57PxUOkNKtETIYjWvXrw3y3b3makN+BErBw/6
         IUxB2j0kF+HkSfdssSG9O6Ud2huA5c+EipbYclOj8YB0HABCdFgZyvfM1JPI31sLzL
         q2NHweTUfvzR4rJJ0Ztpypmczd4IBZsXp9lSmr+dTkWRaW/JYN6FspYlpugKdn5TOG
         RHyO4H2FHRlzGwFQPk7wGSW11UDBFNUSpQn8xeipMo1G3JSPepOg5FLY/yu1QV2ae6
         2Ks6yRyDFkFQ0BHWtI2lrwde5MRnIqNR3N8TtV5sv4sY/fROyYA8e5m79QCHQo95MT
         a3xWGw7hCWuoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 28/60] USB: ULPI: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:42:42 -0500
Message-Id: <20230303214315.1447666-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
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

[ Upstream commit 8f4d25eba599c4bd4b5ea8ae8752cda480a9d563 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230202153235.2412790-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/ulpi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index d7c8461976ce0..38703781ee2d1 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -271,7 +271,7 @@ static int ulpi_regs_show(struct seq_file *seq, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(ulpi_regs);
 
-#define ULPI_ROOT debugfs_lookup(KBUILD_MODNAME, NULL)
+static struct dentry *ulpi_root;
 
 static int ulpi_register(struct device *dev, struct ulpi *ulpi)
 {
@@ -301,7 +301,7 @@ static int ulpi_register(struct device *dev, struct ulpi *ulpi)
 		return ret;
 	}
 
-	root = debugfs_create_dir(dev_name(dev), ULPI_ROOT);
+	root = debugfs_create_dir(dev_name(dev), ulpi_root);
 	debugfs_create_file("regs", 0444, root, ulpi, &ulpi_regs_fops);
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",
@@ -349,8 +349,7 @@ EXPORT_SYMBOL_GPL(ulpi_register_interface);
  */
 void ulpi_unregister_interface(struct ulpi *ulpi)
 {
-	debugfs_remove_recursive(debugfs_lookup(dev_name(&ulpi->dev),
-						ULPI_ROOT));
+	debugfs_lookup_and_remove(dev_name(&ulpi->dev), ulpi_root);
 	device_unregister(&ulpi->dev);
 }
 EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
@@ -360,12 +359,11 @@ EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
 static int __init ulpi_init(void)
 {
 	int ret;
-	struct dentry *root;
 
-	root = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	ulpi_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
 	ret = bus_register(&ulpi_bus);
 	if (ret)
-		debugfs_remove(root);
+		debugfs_remove(ulpi_root);
 	return ret;
 }
 subsys_initcall(ulpi_init);
@@ -373,7 +371,7 @@ subsys_initcall(ulpi_init);
 static void __exit ulpi_exit(void)
 {
 	bus_unregister(&ulpi_bus);
-	debugfs_remove_recursive(ULPI_ROOT);
+	debugfs_remove(ulpi_root);
 }
 module_exit(ulpi_exit);
 
-- 
2.39.2

