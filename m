Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F044B3108BF
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 11:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhBEKMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 05:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhBEKJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 05:09:53 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48457C061793
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 02:09:08 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u14so7033086wri.3
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 02:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nJ1w5c/RrMimr7BCaOj2WL8JgUYIM2DtTX9HaqhWiMg=;
        b=ylwqKq1LgP9nIdabrg5licnGPNXBHbCP3H0BUEAVzVjJ/2cz1HAinKX6NTwpB05888
         ZE2KJT4UiQ5eAl8boRKQl9oRn21VcUuFb+P1ZgtslilHj+9FIdBYFWFVTcvCAzbQjZBc
         vu7iz9LmOKR1HEoZsdc8wsp/qg9YtH2OgE7y0UG+zFOlEJ0TA7wJuf1/8Uz1myGWmtxX
         2LFEXbJes2HOq5F9u8AuzH7p/sLmGDYbni3UIg4JJWtt80ObYEZaAkyhJFc2d0RMo7Oh
         AKp1Qljc94euDgtBPn3AHYJR0/uPqn2RKOUgAK+9TXeq9iatcxIBWDeGBrXvwKqohEnW
         a2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nJ1w5c/RrMimr7BCaOj2WL8JgUYIM2DtTX9HaqhWiMg=;
        b=n69zV16qJZlW4FwObPHvV0YTurUER+AQlMoTwE02SZLOoIjOEcS4sIYydWmkj3HB/b
         FPXvhKSYpI7uwnBiYWVum2/ax1T4VVs1+8BqqWWrKTZzSLz0/brQ0T6DNOKGNt2FWFod
         vnUrs1OfwLnpszD3lA4Th2LK77oZqhZAhHzRgGzlNf8/q7VFjpFw+MAu7vOQtnxSpMDF
         ZiswLcorak4yPhZc0I0xfMOyVeSbQN626LoFhpHKIYquPeeDna+Zk0RJU+9ETFwYWlA6
         aHWf7EAM25YFmMD+1gfucHKt5vOhYYjBlGrXR2sPk/0IN/DCnjq7sEEhGo0vMobSdPkS
         ZV7A==
X-Gm-Message-State: AOAM530WSmuWdhakL+PsFOeoSlsRAchWXfBrcUm6opJ28ZJl+mfg2Srz
        Ssus6f/SNPehO7TfdGh9eg18n1f9WcLhOw==
X-Google-Smtp-Source: ABdhPJwQtMX0+tbhvpTGKBui1lTpBZ91wTj9ZJ18zmZrJ6T9uozsUchZJtLUoSE4D8xmkgHlMIIZeQ==
X-Received: by 2002:a5d:4a4e:: with SMTP id v14mr4189572wrs.80.1612519747073;
        Fri, 05 Feb 2021 02:09:07 -0800 (PST)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id g16sm8067738wmi.30.2021.02.05.02.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 02:09:06 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 2/2] nvmem: qcom-spmi-sdam: Fix uninitialized pdev pointer
Date:   Fri,  5 Feb 2021 10:08:53 +0000
Message-Id: <20210205100853.32372-3-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210205100853.32372-1-srinivas.kandagatla@linaro.org>
References: <20210205100853.32372-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraman Narayanamurthy <subbaram@codeaurora.org>

"sdam->pdev" is uninitialized and it is used to print error logs.
Fix it. Since device pointer can be used from sdam_config, use it
directly thereby removing pdev pointer.

Fixes: 40ce9798794f ("nvmem: add QTI SDAM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/qcom-spmi-sdam.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvmem/qcom-spmi-sdam.c b/drivers/nvmem/qcom-spmi-sdam.c
index a72704cd0468..f6e9f96933ca 100644
--- a/drivers/nvmem/qcom-spmi-sdam.c
+++ b/drivers/nvmem/qcom-spmi-sdam.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2017, 2020 The Linux Foundation. All rights reserved.
+ * Copyright (c) 2017, 2020-2021, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/device.h>
@@ -18,7 +18,6 @@
 #define SDAM_PBS_TRIG_CLR		0xE6
 
 struct sdam_chip {
-	struct platform_device		*pdev;
 	struct regmap			*regmap;
 	struct nvmem_config		sdam_config;
 	unsigned int			base;
@@ -65,7 +64,7 @@ static int sdam_read(void *priv, unsigned int offset, void *val,
 				size_t bytes)
 {
 	struct sdam_chip *sdam = priv;
-	struct device *dev = &sdam->pdev->dev;
+	struct device *dev = sdam->sdam_config.dev;
 	int rc;
 
 	if (!sdam_is_valid(sdam, offset, bytes)) {
@@ -86,7 +85,7 @@ static int sdam_write(void *priv, unsigned int offset, void *val,
 				size_t bytes)
 {
 	struct sdam_chip *sdam = priv;
-	struct device *dev = &sdam->pdev->dev;
+	struct device *dev = sdam->sdam_config.dev;
 	int rc;
 
 	if (!sdam_is_valid(sdam, offset, bytes)) {
-- 
2.21.0

