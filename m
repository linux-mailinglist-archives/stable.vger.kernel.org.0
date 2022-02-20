Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953134BCF46
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 16:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238761AbiBTPPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 10:15:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbiBTPPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 10:15:00 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EB734B99
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 07:14:38 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id az26-20020a05600c601a00b0037c078db59cso9650369wmb.4
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 07:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wotUyCfca8/zG519U5/af89Me2Zg5VHivde488B+0/k=;
        b=kSIafJLo1kafBS98UX2zOOmFNXbp+gOAaMPuWX6B30F/0hHFxHx+b6mirLbuWdyPlH
         trcwVN8Z3gMmNmVFUzBPKfU5dWuJdZblIph9vV4xJPOoDTE3Y3wKmZGCsOk0wXEFe2P4
         Ivsu9vqCY1/LvdAjI6vcRirHUMP0PQ01K0tWgyHBb6uGLoXg3FDPuLB39VT5jqgxnJ+r
         98/iPJq51Ec4kmj3ifyljDIP8HfTjnIxL6sRv8MlHoIrxjC4KY5Z0JekZOMshFWmX+HM
         DP8iM/kIOakA5k/dor02gPX6VMvJXy9mk2/44Mpo96ctVORDKBZOtfRiV23f3/XXVA+a
         FqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wotUyCfca8/zG519U5/af89Me2Zg5VHivde488B+0/k=;
        b=I+E8MjUGE3rzNBGMiP8Kv+0/sNrqkH40X1h+N+POBTNVChBAXvAse95yurJ3MzC3a8
         8YQ36sYLE0fYi99zY/mNEOQpkfVHJt2o83PaHWedUi+ct8etS1ei50y7byXLznsnh4RJ
         a5/3t/hWH7+auAgOfo62BThW8aW3xBStV8aQn8LCq896XEt2zofdCA7+IYlUt2qeYV+W
         DEdJWQhqpHQYA4/wAet9Zt2Z9nG9ZilokLZGW3Ttb+JD5z1ZFgh2Y4uXrsRVNf3eQA5C
         DZTy7nCnp2X+8SDzdbccpghyMqakl5ncnna83C2ItSgomnG7SJC2DuF3eo0ufIsQt/lj
         aTGw==
X-Gm-Message-State: AOAM5339DqSI0D08ZczZueePaZviDDZZIqHdpK+4OMit36xeEQ3joAgR
        /q0YmVpBq7J91WWZ0IXlOI8f7w==
X-Google-Smtp-Source: ABdhPJz3XibEQYrsDmXIkvjitdL5RVZsTy7QaoAA+NYJQ1et19WIrkgJjyTtw9bxRpJxOJugiR6DvA==
X-Received: by 2002:a7b:cb44:0:b0:37c:4e2d:3bb2 with SMTP id v4-20020a7bcb44000000b0037c4e2d3bb2mr17926595wmj.96.1645370076845;
        Sun, 20 Feb 2022 07:14:36 -0800 (PST)
Received: from srini-hackbox.lan (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.gmail.com with ESMTPSA id d6sm46703322wrs.85.2022.02.20.07.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 07:14:36 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 1/2] nvmem: core: Fix a conflict between MTD and NVMEM on wp-gpios property
Date:   Sun, 20 Feb 2022 15:14:31 +0000
Message-Id: <20220220151432.16605-2-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220151432.16605-1-srinivas.kandagatla@linaro.org>
References: <20220220151432.16605-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Kerello <christophe.kerello@foss.st.com>

Wp-gpios property can be used on NVMEM nodes and the same property can
be also used on MTD NAND nodes. In case of the wp-gpios property is
defined at NAND level node, the GPIO management is done at NAND driver
level. Write protect is disabled when the driver is probed or resumed
and is enabled when the driver is released or suspended.

When no partitions are defined in the NAND DT node, then the NAND DT node
will be passed to NVMEM framework. If wp-gpios property is defined in
this node, the GPIO resource is taken twice and the NAND controller
driver fails to probe.

It would be possible to set config->wp_gpio at MTD level before calling
nvmem_register function but NVMEM framework will toggle this GPIO on
each write when this GPIO should only be controlled at NAND level driver
to ensure that the Write Protect has not been enabled.

A way to fix this conflict is to add a new boolean flag in nvmem_config
named ignore_wp. In case ignore_wp is set, the GPIO resource will
be managed by the provider.

Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/core.c           | 2 +-
 include/linux/nvmem-provider.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 23a38dcf0fc4..9fd1602b539d 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -771,7 +771,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	if (config->wp_gpio)
 		nvmem->wp_gpio = config->wp_gpio;
-	else
+	else if (!config->ignore_wp)
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 98efb7b5660d..c9a3ac9efeaa 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -70,7 +70,8 @@ struct nvmem_keepout {
  * @word_size:	Minimum read/write access granularity.
  * @stride:	Minimum read/write access stride.
  * @priv:	User context passed to read/write callbacks.
- * @wp-gpio:   Write protect pin
+ * @wp-gpio:	Write protect pin
+ * @ignore_wp:  Write Protect pin is managed by the provider.
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
  * no name is specified in its configuration. In such case "<id>" is
@@ -92,6 +93,7 @@ struct nvmem_config {
 	enum nvmem_type		type;
 	bool			read_only;
 	bool			root_only;
+	bool			ignore_wp;
 	struct device_node	*of_node;
 	bool			no_of_node;
 	nvmem_reg_read_t	reg_read;
-- 
2.21.0

