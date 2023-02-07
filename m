Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C98B68D841
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjBGNH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjBGNH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E92E15CAA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:07:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC953B8198B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034B7C433D2;
        Tue,  7 Feb 2023 13:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775246;
        bh=lWk98joLJ8pjO2SQV6lMG3Eehe34U0kURP3Epsw8tOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCOI97rG3UIXojJHbbejQRYQFRxnVhZoZTp90DCG/zSqNzyJGe2WQsQArbjLpMCeK
         RIYcRvEAHoxCzcAFg24zh/A4rFtpTvlL2JT17SteLMFCTM23TggVAxEz13R3F3h5nI
         gDmlHIeN4tkqIYAIfdt+LMG3t8BwLuORhiKiUUBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 186/208] nvmem: core: fix cleanup after dev_set_name()
Date:   Tue,  7 Feb 2023 13:57:20 +0100
Message-Id: <20230207125642.897899987@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

commit 560181d3ace61825f4ca9dd3481d6c0ee6709fa8 upstream.

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
---
 drivers/nvmem/core.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 608f3ad2e2e4..ac77a019aed7 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -772,14 +772,18 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
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
@@ -791,9 +795,6 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	nvmem->stride = config->stride ?: 1;
 	nvmem->word_size = config->word_size ?: 1;
 	nvmem->size = config->size;
-	nvmem->dev.type = &nvmem_provider_type;
-	nvmem->dev.bus = &nvmem_bus_type;
-	nvmem->dev.parent = config->dev;
 	nvmem->root_only = config->root_only;
 	nvmem->priv = config->priv;
 	nvmem->type = config->type;
@@ -821,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
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
@@ -836,7 +834,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
 
-	rval = device_register(&nvmem->dev);
+	rval = device_add(&nvmem->dev);
 	if (rval)
 		goto err_put_device;
 
-- 
2.39.1



