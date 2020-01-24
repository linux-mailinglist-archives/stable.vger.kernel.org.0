Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48049147F2F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbgAXLAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732904AbgAXLAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:00:18 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9252A2075D;
        Fri, 24 Jan 2020 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863617;
        bh=pbCrjAdgWcpudYwH/bllTG0VuAZarbturEuo4z94yZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6YwlqZHYk0M204mAa0iDYMSoeNuURpgstKWBYPRltOxMfbfru6wZnYfGtSI742cD
         7MD2VgEzuE39Ghwq8sFwPJS/0SNxOk66Y88JxRaKxIkWqoR1XsOUPtRhcPqD9ZL/MH
         g6dytoWdCpfJ329dL2ogN74xyMCdd4VtXgsV8qT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei-Ning Huang <wnhuang@chromium.org>,
        Julius Werner <jwerner@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Samuel Holland <samuel@sholland.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/639] firmware: coreboot: Let OF core populate platform device
Date:   Fri, 24 Jan 2020 10:23:18 +0100
Message-Id: <20200124093050.862596047@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 09ed061a4f56d50758851ca3997510f27115f81b ]

Now that the /firmware/coreboot node in DT is populated by the core DT
platform code with commit 3aa0582fdb82 ("of: platform: populate
/firmware/ node from of_platform_default_populate_init()") we should and
can remove the platform device creation here. Otherwise, the
of_platform_device_create() call will fail, the coreboot of driver won't
be registered, and this driver will never bind. At the same time, we
should move this driver to use MODULE_DEVICE_TABLE so that module
auto-load works properly when the coreboot device is auto-populated and
we should drop the of_node handling that was presumably placed here to
hold a reference to the DT node created during module init that no
longer happens.

Cc: Wei-Ning Huang <wnhuang@chromium.org>
Cc: Julius Werner <jwerner@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Cc: Samuel Holland <samuel@sholland.org>
Reviewed-by: Sudeep Holla <Sudeep.Holla@arm.com>
Fixes: 3aa0582fdb82 ("of: platform: populate /firmware/ node from of_platform_default_populate_init()")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/coreboot_table-of.c | 28 +++------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/firmware/google/coreboot_table-of.c b/drivers/firmware/google/coreboot_table-of.c
index f15bf404c579b..9b90c0fa4a0b4 100644
--- a/drivers/firmware/google/coreboot_table-of.c
+++ b/drivers/firmware/google/coreboot_table-of.c
@@ -19,7 +19,6 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
-#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 
 #include "coreboot_table.h"
@@ -30,7 +29,6 @@ static int coreboot_table_of_probe(struct platform_device *pdev)
 	void __iomem *ptr;
 
 	ptr = of_iomap(fw_dn, 0);
-	of_node_put(fw_dn);
 	if (!ptr)
 		return -ENOMEM;
 
@@ -44,8 +42,9 @@ static int coreboot_table_of_remove(struct platform_device *pdev)
 
 static const struct of_device_id coreboot_of_match[] = {
 	{ .compatible = "coreboot" },
-	{},
+	{}
 };
+MODULE_DEVICE_TABLE(of, coreboot_of_match);
 
 static struct platform_driver coreboot_table_of_driver = {
 	.probe = coreboot_table_of_probe,
@@ -55,28 +54,7 @@ static struct platform_driver coreboot_table_of_driver = {
 		.of_match_table = coreboot_of_match,
 	},
 };
-
-static int __init platform_coreboot_table_of_init(void)
-{
-	struct platform_device *pdev;
-	struct device_node *of_node;
-
-	/* Limit device creation to the presence of /firmware/coreboot node */
-	of_node = of_find_node_by_path("/firmware/coreboot");
-	if (!of_node)
-		return -ENODEV;
-
-	if (!of_match_node(coreboot_of_match, of_node))
-		return -ENODEV;
-
-	pdev = of_platform_device_create(of_node, "coreboot_table_of", NULL);
-	if (!pdev)
-		return -ENODEV;
-
-	return platform_driver_register(&coreboot_table_of_driver);
-}
-
-module_init(platform_coreboot_table_of_init);
+module_platform_driver(coreboot_table_of_driver);
 
 MODULE_AUTHOR("Google, Inc.");
 MODULE_LICENSE("GPL");
-- 
2.20.1



