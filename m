Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A907268D2DB
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjBGJdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjBGJdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:33:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9BA10407
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:33:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FA7CB8171C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A4FC4339B;
        Tue,  7 Feb 2023 09:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675762391;
        bh=SWAwSSJgWJN7RWGiJ1JM+KNwOsvPKzL1WS6O6A14I38=;
        h=Subject:To:Cc:From:Date:From;
        b=JRLchAMLMBdfJEplU5XqpYlSpOBZ8X2D0EmYfR/Kj2HQdDewJ/kTfgssKpyj2+9TY
         l4Q6d+zTPSLoomBWEjlNKCMzIzCMwsWLhP23hbBQvy/wMD3sAX1Xeu6735O5JLQJ0T
         bhRGM6QgwRjM6Va67YfAIQiUaTv/1KUvcsFubFjc=
Subject: FAILED: patch "[PATCH] nvmem: core: fix registration vs use race" failed to apply to 5.15-stable tree
To:     rmk+kernel@armlinux.org.uk, gregkh@linuxfoundation.org,
        srinivas.kandagatla@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 10:33:03 +0100
Message-ID: <1675762383106141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ab3428cfd9aa ("nvmem: core: fix registration vs use race")
560181d3ace6 ("nvmem: core: fix cleanup after dev_set_name()")
569653f022a2 ("nvmem: core: remove nvmem_config wp_gpio")
3bd747c7ea13 ("nvmem: core: initialise nvmem->id early")
5544e90c8126 ("nvmem: core: add error handling for dev_set_name")
bd1244561fa2 ("nvmem: core: Fix memleak in nvmem_register()")
f6c052afe6f8 ("nvmem: core: Fix a conflict between MTD and NVMEM on wp-gpios property")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ab3428cfd9aa2f3463ee4b2909b5bb2193bd0c4a Mon Sep 17 00:00:00 2001
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Date: Fri, 27 Jan 2023 10:40:11 +0000
Subject: [PATCH] nvmem: core: fix registration vs use race

The i.MX6 CPU frequency driver sometimes fails to register at boot time
due to nvmem_cell_read_u32() sporadically returning -ENOENT.

This happens because there is a window where __nvmem_device_get() in
of_nvmem_cell_get() is able to return the nvmem device, but as cells
have been setup, nvmem_find_cell_entry_by_node() returns NULL.

The occurs because the nvmem core registration code violates one of the
fundamental principles of kernel programming: do not publish data
structures before their setup is complete.

Fix this by making nvmem core code conform with this principle.

Fixes: eace75cfdcf7 ("nvmem: Add a simple NVMEM framework for nvmem providers")
Cc: stable@vger.kernel.org
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-7-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index ac77a019aed7..e92c6f1aadbb 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -832,22 +832,16 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	nvmem->dev.groups = nvmem_dev_groups;
 #endif
 
-	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
-
-	rval = device_add(&nvmem->dev);
-	if (rval)
-		goto err_put_device;
-
 	if (nvmem->nkeepout) {
 		rval = nvmem_validate_keepouts(nvmem);
 		if (rval)
-			goto err_device_del;
+			goto err_put_device;
 	}
 
 	if (config->compat) {
 		rval = nvmem_sysfs_setup_compat(nvmem, config);
 		if (rval)
-			goto err_device_del;
+			goto err_put_device;
 	}
 
 	if (config->cells) {
@@ -864,6 +858,12 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	if (rval)
 		goto err_remove_cells;
 
+	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
+
+	rval = device_add(&nvmem->dev);
+	if (rval)
+		goto err_remove_cells;
+
 	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_ADD, nvmem);
 
 	return nvmem;
@@ -873,8 +873,6 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 err_teardown_compat:
 	if (config->compat)
 		nvmem_sysfs_remove_compat(nvmem, config);
-err_device_del:
-	device_del(&nvmem->dev);
 err_put_device:
 	put_device(&nvmem->dev);
 

