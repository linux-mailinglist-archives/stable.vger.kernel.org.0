Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B85167E1E9
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 11:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjA0Kkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 05:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjA0Kkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 05:40:40 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC35823301
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:29 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id q8so3121557wmo.5
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ee8M/Zfl0pOs8Tnpp0ye8rZhC7jbLJshdfxfwBd8N4=;
        b=N554l+a4UV+5pp3GziZ82E2uFpGyeuI2jtL1QNcQGYgpzh5aSUxjUvIIiLbjIrld4C
         REZvNGQ2vU/7eosArZXgOoNYv3RBWM+XOdggo3BbrRjJJ9sDNVwv2Q2xd68Pi2hztqel
         tdT+A0vNpZyBZ8WsL5idXJQygTTSusA2UER5+8TJdregZCPUA88rcHaBTPiGATUKC/1g
         EkSoPO1TzRgpNJyc2YTqTpE8RHCAhm/BFGX2QDtSNLqwQbEaQUNkD6o6DQsG/5nk5sBu
         FwQmlldnm7sPp79qOrrsdMMrCZW95X3k82j/wbiUeV/YNJP1wxwLMtrQUf69+vLUeg1Y
         7Qqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ee8M/Zfl0pOs8Tnpp0ye8rZhC7jbLJshdfxfwBd8N4=;
        b=pA4ChU63N9IxQXzWRl5vTafxHqcpzcSPbvut7rIK0BYBcxkUdl637yR4dSw6EwYDpA
         8cxPkrVhYNLYw7Jnro7ozncN2jz2Wz3lays+0NDhd8yAMz13Ioq/CEvdVMUavtDbXgUV
         gtijwr0yuFarEdwCgZvhDaraVeGLFhRCPKGyRkmFTmlygVk59k4wJ5K5fiwFh9ZstK1U
         02rRc51cMNwZafsnnitTGHHVZMRtp0Ba124zNzVeMbTe3ZIthNujFir6YzqB7CddY5NP
         YbmaB+sB07U9vaNITsop4EctlyBCjVr6vIG7VnlgyAN8Lu7WiPMZxe5RAZXC2Pm+cadn
         RzVw==
X-Gm-Message-State: AFqh2ko7iSxvFS/Z2jb64Jx+eUWKHLz5mdzbM8oLNEzJ7UQwtg8q1O4D
        d1e16Q5SheutWzLUYRuS9Jt+gg==
X-Google-Smtp-Source: AMrXdXv8r1WlZJ6abS3W4jl0IXaMTirvycwLOdaiLvCf+FE0El2w8WwrvDeu0IQx1yRWvhtGHId1Kg==
X-Received: by 2002:a05:600c:4395:b0:3c6:f7ff:6f87 with SMTP id e21-20020a05600c439500b003c6f7ff6f87mr37673436wmn.11.1674816028506;
        Fri, 27 Jan 2023 02:40:28 -0800 (PST)
Received: from localhost.localdomain ([5.133.47.210])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003dc34edacf8sm1619787wmc.31.2023.01.27.02.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:40:27 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 05/10] nvmem: core: fix cleanup after dev_set_name()
Date:   Fri, 27 Jan 2023 10:40:10 +0000
Message-Id: <20230127104015.23839-6-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
References: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

If dev_set_name() fails, we leak nvmem->wp_gpio as the cleanup does not
put this. While a minimal fix for this would be to add the gpiod_put()
call, we can do better if we split device_register(), and use the
tested nvmem_release() cleanup code by initialising the device early,
and putting the device.

This results in a slightly larger fix, but results in clear code.

Note: this patch depends on "nvmem: core: initialise nvmem->id early"
and "nvmem: core: remove nvmem_config wp_gpio".

Cc: stable@vger.kernel.org
Fixes: 5544e90c8126 ("nvmem: core: add error handling for dev_set_name")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
[Srini: Fixed subject line and error code handing with wp_gpio while applying.]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
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
2.25.1

