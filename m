Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115BA60EEA5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 05:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbiJ0Ddq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 23:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiJ0Dda (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 23:33:30 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BCD15627C;
        Wed, 26 Oct 2022 20:32:23 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j12so127966plj.5;
        Wed, 26 Oct 2022 20:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7yF1dXBnJEVhGGTIzHbHbpBrHmE7RRuUtKfNdRHcto=;
        b=gu6eTOkZtN4JP0DfX2VwONvMw+YB9vTjBp2U/9eEjpWrIdTvvb/NT8IBB/HSfr77T/
         KVU109xPoqhChnO4jEJJeNoR4PxuEiH/nAXSGrDwiBwAXDYj5CYtkIuQ1KlG5Q4jPy2a
         /mw69vD27HVRoam4QlHY4I8x6oJdbrxeOUjLEnJsyCgctGEqkezSz0C/2pICsRoGWGW1
         KKDcghoA6uiFfa96jQd/mQ8IQ/ySUBgXYphkyeiQYOdMfa2rNBeOauCMLxN1f6kzy/FU
         OPiSipbCxduZWTiG2SbeVpLYiA2gE90MJeOgKT9NtDNr4li1Lki+e+3JtuJxOzvZha/K
         eiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h7yF1dXBnJEVhGGTIzHbHbpBrHmE7RRuUtKfNdRHcto=;
        b=tnP/pArVfmE4pCpknxqnHw2CLn7uAcr9aQLetUA12GeiUd00Z3rwlRu9jDvPOJKkFC
         1Yr7pRvDwCcE67t3gZNBz1PMLcBMIjKlp4PPtIxLAFinTOeeLd+WQAw2Uh5NRnTySurv
         +oTWspNeVNGDnqWJfi1woZGUlXs5Ik5DTz411i1B/mojHGQOvJXT0DBWrS5YO66OAod2
         huTKq+OQiaC6q6MlAnXNmZif3Eos7lFyOrPc5D/JFUtHicH8LwlINb7cxSMgF124NpNv
         SXNMG9j+Vg+pwDy6QW2O0t96QOzDmRFHCcwPLGoeGL0yudo+NZNwC3/gwBQBKiRn9Jjw
         bfmg==
X-Gm-Message-State: ACrzQf1jNDQG1wk/9EM6bQmaYZ9Um2W8nf8xBDWLLuA1BsCterZvYShA
        wwNXyu6o+ai1H3KPUeyfXrQ=
X-Google-Smtp-Source: AMsMyM6oUvd42J9Qm3Kf9To8fT2/SccEZj3w8kvldWdNKTSEoPdsjH8KiGX20Bc8aBzrrQHNBi1Tbw==
X-Received: by 2002:a17:902:a60d:b0:186:61f6:d7f4 with SMTP id u13-20020a170902a60d00b0018661f6d7f4mr37042665plq.75.1666841542726;
        Wed, 26 Oct 2022 20:32:22 -0700 (PDT)
Received: from localhost.localdomain ([2402:7500:47a:8591:f9eb:aa62:7d76:f953])
        by smtp.gmail.com with ESMTPSA id o11-20020a65458b000000b0043c732e1536sm65921pgq.45.2022.10.26.20.32.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Oct 2022 20:32:21 -0700 (PDT)
From:   cy_huang <u0084500@gmail.com>
To:     lee@kernel.org
Cc:     matthias.bgg@gmail.com, gene_chen@richtek.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Subject: [PATCH v3] mfd: mt6360: add boundary check in in mt6360 regmap read/write
Date:   Thu, 27 Oct 2022 11:32:09 +0800
Message-Id: <1666841529-12781-1-git-send-email-u0084500@gmail.com>
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

Fix the potential risk if virtual bank index is over the maximum.

Refer to the discussion list on mt6370.
https://lore.kernel.org/all/20220914013345.GA5802@cyhuang-hp-elitebook-840-g3.rt/
If not to check the boundary, there is also the same issue on mt6360.

For mt6360 register virtual mapping, the normal range is 0 to 0x3FF.
Below's the backtrace in my experiment to access mt6360 0x400 register
with regmap_raw_read() and regmap_raw_write() function.

1) regmap_raw_read()
Unable to handle kernel execute from non-executable memory at virtual
address ffffffd4940c4c20
pc : platform_bus+0x8/0x2e8
lr : i2c_smbus_xfer+0x60/0x120
Call trace:
 platform_bus+0x8/0x2e8
 i2c_smbus_read_i2c_block_data+0x74/0xc0
 mt6360_regmap_read+0x9c/0x180 [mt6360_core]
 _regmap_raw_read+0xe4/0x278
 regmap_raw_read+0xec/0x240

2) regmap_raw_write()
Unable to handle kernel execute from non-executable memory at virtual
address ffffffe4a0ac4c20
pc : platform_bus+0x8/0x2e8
lr : i2c_smbus_xfer+0x60/0x120
Call trace:
 platform_bus+0x8/0x2e8
 i2c_smbus_write_i2c_block_data+0x84/0xd0
 mt6360_regmap_write+0xa8/0x150 [mt6360_core]
 _regmap_raw_write_impl+0x6e8/0x828
 _regmap_raw_write+0xb4/0x130
 regmap_raw_write+0x74/0xb0

After adding the boundary check, the above two cases can be solved.

Fixes: 3b0850440a06c (mfd: mt6360: Merge different sub-devices I2C read/write)
Cc: stable@vger.kernel.org
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
---
Since v3:
- Add backtrace log to help understanding what the potential risk is.

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

