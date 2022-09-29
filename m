Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661D85EEB64
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 04:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbiI2CA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 22:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiI2CA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 22:00:26 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2625F13F;
        Wed, 28 Sep 2022 19:00:24 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b21so11976plz.7;
        Wed, 28 Sep 2022 19:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=C5vB9AdNpMbk+2uUPlTv1wvt0hrX4ZZuVlJ7vkkQRH8=;
        b=hPDZmGiqxB9XD3Z6wxo4PZNRWs3oY/Iz5OeU+JgazAdaRNCYb0hY+XBfMT5h9LpDuK
         sCGI7yR8/B5SquXIbmemuUwjvIDSrPu4q0TQj4VgxJpWiQUjdojJRHZNtrxDqXrzln0J
         SC2HI4obfGuU+uLyFgsG6Jz52S87DuPUi+3oTAYb331UHYMDQuKvHA2vT1QADuBgiLVe
         7VSIb6tXofr7qFnhoUnL5WuTwLGNHphva9ycidtoa1lkJdflmrIUQCf9iwfFzPojQGuX
         dzg1bswH2ufICBvvHb6SrbK5MKAhZ6SJjKefrLNz0CNT44/RBeJw5+BJ9/93nNc0aH6Y
         FW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=C5vB9AdNpMbk+2uUPlTv1wvt0hrX4ZZuVlJ7vkkQRH8=;
        b=ERZchNlRsbSdg8yM9YOz9lo2AjD7M0rU8vOpJSWyFw0l5zShYWzsmrhg+U4oHc9P2m
         Hf7GGJGcpbMCD01+q7yRlOWhCzRu9aD+NA2zEtt1NGU4dclZ2yLZDxUiud/YvkBlGVwS
         2vqd4rBHpjhzAEe2lxaATRCBleOWr7pKXRzVDvMDktWXEcG+qvV0EeFuz3v6bRtygAgO
         8udTAD3fm9mT6GfC/QL+6QFipYegtoHHSevPVNWgEAActBXPE9l3gxCaxH7lfw4Zr9zW
         7HhYS17+J7Y78eCt995LCN35jWZUk70+JxdFCwU6QSc1GZ9IRPBtey76tLhwENGZfZlA
         SnAw==
X-Gm-Message-State: ACrzQf2+ufi4VhYWf2BW8IgDOPX1kk1WOQsMruy9Bc9e4scxTVqrmSow
        C3uTvolw2fsZL5ebCEnSUwZsHeAVVb63mg==
X-Google-Smtp-Source: AMsMyM7ZzV1vVGJNs6nTmd5yrCePl3Paqmk+hVgLyyR8mFNJpaQU8/eOM+EA2rjQyhlE3+Pt5NXgtg==
X-Received: by 2002:a17:903:11cc:b0:178:aec1:18c3 with SMTP id q12-20020a17090311cc00b00178aec118c3mr994449plh.91.1664416823981;
        Wed, 28 Sep 2022 19:00:23 -0700 (PDT)
Received: from localhost.localdomain ([2402:7500:579:1b3a:f99f:1552:d82e:aa5a])
        by smtp.gmail.com with ESMTPSA id o6-20020a170902d4c600b00178bd916c64sm4512864plg.265.2022.09.28.19.00.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Sep 2022 19:00:23 -0700 (PDT)
From:   cy_huang <u0084500@gmail.com>
To:     lee@kernel.org
Cc:     matthias.bgg@gmail.com, gene_chen@richtek.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Subject: [PATCH v2] mfd: mt6360: add bound check in regmap read/write function
Date:   Thu, 29 Sep 2022 10:00:17 +0800
Message-Id: <1664416817-31590-1-git-send-email-u0084500@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

Fix the potential risk for null pointer if bank index is over the maximum.

Refer to the discussion list for the experiment result on mt6370.
https://lore.kernel.org/all/20220914013345.GA5802@cyhuang-hp-elitebook-840-g3.rt/
If not to check the bound, there is the same issue on mt6360.

Fixes: 3b0850440a06c (mfd: mt6360: Merge different sub-devices I2C read/write)
Cc: stable@vger.kernel.org
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
---
Since v2:
- Assign i2c bank variable after bank index is already checked.

---
 drivers/mfd/mt6360-core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mt6360-core.c b/drivers/mfd/mt6360-core.c
index 6eaa677..d3b32eb 100644
--- a/drivers/mfd/mt6360-core.c
+++ b/drivers/mfd/mt6360-core.c
@@ -402,7 +402,7 @@ static int mt6360_regmap_read(void *context, const void *reg, size_t reg_size,
 	struct mt6360_ddata *ddata = context;
 	u8 bank = *(u8 *)reg;
 	u8 reg_addr = *(u8 *)(reg + 1);
-	struct i2c_client *i2c = ddata->i2c[bank];
+	struct i2c_client *i2c;
 	bool crc_needed = false;
 	u8 *buf;
 	int buf_len = MT6360_ALLOC_READ_SIZE(val_size);
@@ -410,6 +410,11 @@ static int mt6360_regmap_read(void *context, const void *reg, size_t reg_size,
 	u8 crc;
 	int ret;
 
+	if (bank >= MT6360_SLAVE_MAX)
+		return -EINVAL;
+
+	i2c = ddata->i2c[bank];
+
 	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
 		crc_needed = true;
 		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size);
@@ -453,13 +458,18 @@ static int mt6360_regmap_write(void *context, const void *val, size_t val_size)
 	struct mt6360_ddata *ddata = context;
 	u8 bank = *(u8 *)val;
 	u8 reg_addr = *(u8 *)(val + 1);
-	struct i2c_client *i2c = ddata->i2c[bank];
+	struct i2c_client *i2c;
 	bool crc_needed = false;
 	u8 *buf;
 	int buf_len = MT6360_ALLOC_WRITE_SIZE(val_size);
 	int write_size = val_size - MT6360_REGMAP_REG_BYTE_SIZE;
 	int ret;
 
+	if (bank >= MT6360_SLAVE_MAX)
+		return -EINVAL;
+
+	i2c = ddata->i2c[bank];
+
 	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
 		crc_needed = true;
 		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size - MT6360_REGMAP_REG_BYTE_SIZE);
-- 
2.7.4

