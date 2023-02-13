Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2A0694943
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjBMO6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjBMO56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:57:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0B71CAF0
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB3146111D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E128BC4339B;
        Mon, 13 Feb 2023 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300238;
        bh=3OpV0qJ/8dww7FlHopo6CyENW94HW2ZdZScYWzlrRxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yT+Yj0B1s+1BJWL79t8HmGx3MBODLMsRxGYFgp3xGZjogczBbBwm471ERwu+tNony
         iZCZS3WlxXusCFuZti/eylIprgaHh95M3KM4LKb6YthRoZ/1SPESrqiXzmYyiA68j7
         Ppmv8Hl8WOeO7uwd8ktk+aCx6ZBLTeQxgTUOnfeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/67] nvmem: core: fix cleanup after dev_set_name()
Date:   Mon, 13 Feb 2023 15:48:43 +0100
Message-Id: <20230213144732.453228453@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 560181d3ace61825f4ca9dd3481d6c0ee6709fa8 ]

If dev_set_name() fails, we leak nvmem->wp_gpio as the cleanup does not
put this. While a minimal fix for this would be to add the gpiod_put()
call, we can do better if we split device_register(), and use the
tested nvmem_release() cleanup code by initialising the device early,
and putting the device.

This results in a slightly larger fix, but results in clear code.

Note: this patch depends on "nvmem: core: initialise nvmem->id early"
and "nvmem: core: remove nvmem_config wp_gpio".

Fixes: 5544e90c8126 ("nvmem: core: add error handling for dev_set_name")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
[Srini: Fixed subject line and error code handing with wp_gpio while applying.]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-6-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ab3428cfd9aa ("nvmem: core: fix registration vs use race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 51bec9f8a3bf9..f06b65f0d410b 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -768,14 +768,18 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	nvmem->id = rval;
 
+	nvmem->dev.type = &nvmem_provider_type;
+	nvmem->dev.bus = &nvmem_bus_type;
+	nvmem->dev.parent = config->dev;
+
+	device_initialize(&nvmem->dev);
+
 	if (!config->ignore_wp)
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
-		ida_free(&nvmem_ida, nvmem->id);
 		rval = PTR_ERR(nvmem->wp_gpio);
-		kfree(nvmem);
-		return ERR_PTR(rval);
+		goto err_put_device;
 	}
 
 	kref_init(&nvmem->refcnt);
@@ -787,9 +791,6 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	nvmem->stride = config->stride ?: 1;
 	nvmem->word_size = config->word_size ?: 1;
 	nvmem->size = config->size;
-	nvmem->dev.type = &nvmem_provider_type;
-	nvmem->dev.bus = &nvmem_bus_type;
-	nvmem->dev.parent = config->dev;
 	nvmem->root_only = config->root_only;
 	nvmem->priv = config->priv;
 	nvmem->type = config->type;
@@ -816,11 +817,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 		break;
 	}
 
-	if (rval) {
-		ida_free(&nvmem_ida, nvmem->id);
-		kfree(nvmem);
-		return ERR_PTR(rval);
-	}
+	if (rval)
+		goto err_put_device;
 
 	nvmem->read_only = device_property_present(config->dev, "read-only") ||
 			   config->read_only || !nvmem->reg_write;
@@ -831,7 +829,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
 
-	rval = device_register(&nvmem->dev);
+	rval = device_add(&nvmem->dev);
 	if (rval)
 		goto err_put_device;
 
-- 
2.39.0



