Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9D367E1E7
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 11:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbjA0Kkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 05:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjA0Kkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 05:40:39 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B649B2CC68
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:28 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id j17so3157047wms.0
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQA8ie8gDGnN9i1Gkqhn40XBHeOG+J3va8u+Gl+XlVM=;
        b=xUyNMLLS9r+SAEJJHrAvAUjeGlDUCS0MsFCqN8jBJQOEBAteMPkiFOvkPkEtNggLbw
         g+IPrcJBOAaUPy/h+Bq87sYMPJcbBFWP/LTBijYpoovlnqmU/cXdZvpfPatgEamol52Q
         HULZRCbRz+Z2kfplRBjEsMa0HTvF0fB2w/qPA6w+Qth57PZ+4fQ11JKVqw2vAl9/6JqE
         B03LXZpbRoEkQScZKjgFvKdWQr6kBgDxosUNl3xO4OTy6PsfW7tSmpkmU2ULkFg5Ui9h
         r+qMtxDVGeQX2fB8/ywWsqKvrAHk2QzGVwwsZs/VJQqHgM1S+mjbecMkcIkXWdWqLqy8
         4mSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GQA8ie8gDGnN9i1Gkqhn40XBHeOG+J3va8u+Gl+XlVM=;
        b=pK681ydRfNdCrSs02r8vP2F8s+zJGwwoTbExQd8xATuxT//VqhASWE3VE4CeuASPb7
         LcwrNUQN4jKHHxJsmiTnvI6q/3HXBdFcWGvGLezvpC/xGexySgxwmS1jjEHC0kQMg2NC
         H+U81MyQZJqPLPXKpmBHPzlvCjbR1tMP0O0hP0u1JZVKhO51tyNcsk7zjQtobS3MicTf
         KrKN1hM8reswGFPdjv81/a8CO8Yi123wvgw67/+PLgq5YmG5nnaq0U9AGG7vBtmpJ0hb
         ehrAvaJ38DepPlkgftVrO553kCEvNDeSz+kkVVvjCUDNIWyTspKYsKd1g5eaxl6gLr8S
         msvg==
X-Gm-Message-State: AFqh2krQMHc1iFyBR1elaARoHPQKxdxK51PAmlk0/0N4U0L++QoPbEwt
        V+L2A5jlxzHoOZ7w999ydN/Snw==
X-Google-Smtp-Source: AMrXdXsvHJxiuNWojgCPjR8TCJ+EfBZUNvV59SyJ1A9XHpIJpl0+uq8rgDMQpwcrRRrT5XOqZBzasQ==
X-Received: by 2002:a05:600c:434b:b0:3d9:cc40:a8dc with SMTP id r11-20020a05600c434b00b003d9cc40a8dcmr37194425wme.27.1674816027291;
        Fri, 27 Jan 2023 02:40:27 -0800 (PST)
Received: from localhost.localdomain ([5.133.47.210])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003dc34edacf8sm1619787wmc.31.2023.01.27.02.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:40:26 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 04/10] nvmem: core: remove nvmem_config wp_gpio
Date:   Fri, 27 Jan 2023 10:40:09 +0000
Message-Id: <20230127104015.23839-5-srinivas.kandagatla@linaro.org>
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

No one provides wp_gpio, so let's remove it to avoid issues with
the nvmem core putting this gpio.

Cc: stable@vger.kernel.org
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/core.c           | 4 +---
 include/linux/nvmem-provider.h | 2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 7394a7598efa..608f3ad2e2e4 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -772,9 +772,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	nvmem->id = rval;
 
-	if (config->wp_gpio)
-		nvmem->wp_gpio = config->wp_gpio;
-	else if (!config->ignore_wp)
+	if (!config->ignore_wp)
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 50caa117cb62..bb15c9234e21 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -70,7 +70,6 @@ struct nvmem_keepout {
  * @word_size:	Minimum read/write access granularity.
  * @stride:	Minimum read/write access stride.
  * @priv:	User context passed to read/write callbacks.
- * @wp-gpio:	Write protect pin
  * @ignore_wp:  Write Protect pin is managed by the provider.
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
@@ -85,7 +84,6 @@ struct nvmem_config {
 	const char		*name;
 	int			id;
 	struct module		*owner;
-	struct gpio_desc	*wp_gpio;
 	const struct nvmem_cell_info	*cells;
 	int			ncells;
 	const struct nvmem_keepout *keepout;
-- 
2.25.1

