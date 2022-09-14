Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1665B82DF
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 10:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiINI0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 04:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiINI0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 04:26:21 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B371C6525D;
        Wed, 14 Sep 2022 01:26:20 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id jm11so14355115plb.13;
        Wed, 14 Sep 2022 01:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=i4WqWGFN996ypu86FTXwvXB/hikI0wOqqPyZaEJtfSY=;
        b=Pk9I7QN+hJasEV+ylLAnn7dJqAYMe00n+0NJAPi7Arcl49+qWU46huTRyJ/6g1miDI
         UHLfAT7GiwUwnBVezIgkd+Und4q9abZujU5mCdq0k/Frqkbm9jBJIAZUsIX6EaJpqapv
         AMgy7bF3S+AiAC8n3cG5najvxtQRY1YDrpYs+IaTqk3DRpikS9g6LgIDqiR7bPGQJZDU
         0rqRThk1bGGSL0sqTqtXi9dSIDuya/lwoGjO9ryAb/h7OfVn6VmuUcr2Lyj35y4nlfea
         HcHWGWF67tVLL09vn4vCcWjWfnjqKyxUsl5p+uneutQTOHX5mQJW3XqiuWTV2o+HAXx6
         dNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=i4WqWGFN996ypu86FTXwvXB/hikI0wOqqPyZaEJtfSY=;
        b=qSvqO61kK1myVmblZqqVwy6IdZPeyv85Jo+dlacdWOicoWXQR6KerGNxYgoj4aq10K
         kXDXYorfTO5oHLMx5XP8dHSS9bMxf0pxFiZn314ffGQjfptzcbM6t5jrJVS5+rYg0V/P
         LBbxREYDbv0h9WHKhpZM5Zo6jHPwkDl707LOzLh95wfbUVgbZSJiWmuvTCagAdw4twvt
         3mT5O4Za/a+mWDff0H/kuFwI2CXQeg61VpUAq3GQq1fuN+lcsDecQpCRrnYwjBx0h4Dm
         Oa8rv/uzVdSsl1ATVElOX5X3MsAGrWW9EE2aLM8Mv2seY+wPJx30NO4Wl2v0y2UW/PKH
         wCHg==
X-Gm-Message-State: ACrzQf017U0LwiNEjaHzgYV2IBpVa1eorR2dIwnGZElnt0DlWiku5tQ3
        0bAtARmmt4/Oi8yI/srxDw9mXfXtZxc=
X-Google-Smtp-Source: AMsMyM4BtmnroQBdF3hqgGthCFmpDRy5iBoH9QAgv1iUdP9UBTEJ0P4IYfv9E74Ot1tFYqSPlcgrqg==
X-Received: by 2002:a17:90a:4607:b0:202:e22d:489c with SMTP id w7-20020a17090a460700b00202e22d489cmr3603534pjg.80.1663143980150;
        Wed, 14 Sep 2022 01:26:20 -0700 (PDT)
Received: from localhost.localdomain ([2402:7500:486:362c:d94f:b1bb:6842:3424])
        by smtp.gmail.com with ESMTPSA id s8-20020a17090a880800b0020036e008bcsm8683195pjn.4.2022.09.14.01.26.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Sep 2022 01:26:19 -0700 (PDT)
From:   cy_huang <u0084500@gmail.com>
To:     lee@kernel.org
Cc:     matthias.bgg@gmail.com, gene_chen@richtek.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Subject: [PATCH] mfd: mt6360: add bound check in regmap read/write function
Date:   Wed, 14 Sep 2022 16:26:13 +0800
Message-Id: <1663143973-29254-1-git-send-email-u0084500@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

Fix the potential risk for null pointer if bank index is over the maximimum.

Refer to the discussion list for the experiment result on mt6370.
https://lore.kernel.org/all/20220914013345.GA5802@cyhuang-hp-elitebook-840-g3.rt/
If not to check the bound, there is the same issue on mt6360.

Fixes: 3b0850440a06c (mfd: mt6360: Merge different sub-devices I2C read/write)
Cc: stable@vger.kernel.org
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
---
 drivers/mfd/mt6360-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/mt6360-core.c b/drivers/mfd/mt6360-core.c
index 6eaa677..d375333 100644
--- a/drivers/mfd/mt6360-core.c
+++ b/drivers/mfd/mt6360-core.c
@@ -410,6 +410,9 @@ static int mt6360_regmap_read(void *context, const void *reg, size_t reg_size,
 	u8 crc;
 	int ret;
 
+	if (bank >= MT6360_SLAVE_MAX)
+		return -EINVAL;
+
 	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
 		crc_needed = true;
 		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size);
@@ -460,6 +463,9 @@ static int mt6360_regmap_write(void *context, const void *val, size_t val_size)
 	int write_size = val_size - MT6360_REGMAP_REG_BYTE_SIZE;
 	int ret;
 
+	if (bank >= MT6360_SLAVE_MAX)
+		return -EINVAL;
+
 	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
 		crc_needed = true;
 		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size - MT6360_REGMAP_REG_BYTE_SIZE);
-- 
2.7.4

