Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B3E68D2DD
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjBGJdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjBGJdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:33:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0686419F2E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:33:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95A8E61259
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DB8C433EF;
        Tue,  7 Feb 2023 09:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675762395;
        bh=BwHOoi1fXhcWa8hFu63lnqr+jYZ54adJ7OauIga+elY=;
        h=Subject:To:Cc:From:Date:From;
        b=Bq9Swzg+ZAVz3QjAmoDmqESLYxN05OH22LKlqwwpLYMGYKwsYgGq+MIGoPnVmNaN1
         QRSfi1itJDzYAZxyotn+JQqW0l5gZLIvi5TLFIyGjuxvR/JVIHj4I84m8v92zcOsLl
         tUle877TqcKZzH3H/kyBEAw+NCLh5U5ML9BF7MnU=
Subject: FAILED: patch "[PATCH] nvmem: core: fix registration vs use race" failed to apply to 5.10-stable tree
To:     rmk+kernel@armlinux.org.uk, gregkh@linuxfoundation.org,
        srinivas.kandagatla@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 10:33:09 +0100
Message-ID: <16757623891585@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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
de0534df9347 ("nvmem: core: fix error handling while validating keepout regions")
1333a6779501 ("nvmem: core: allow specifying of_node")
fd3bb8f54a88 ("nvmem: core: Add support for keepout regions")

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
 

