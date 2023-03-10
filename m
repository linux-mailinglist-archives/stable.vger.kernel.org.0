Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE086B4986
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbjCJPNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbjCJPNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:13:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5528123CF5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:04:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 114DFB8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816C9C4339C;
        Fri, 10 Mar 2023 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460144;
        bh=G7h5UZufLDv0qv+XgIFeT0avy8rEXVYUeuXLcSUBq/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llqcJkf8YJ/lRgjpOuFCwHgAScij7jMK9TBa3Eo/5D4KjATnOfiOX+B2w+U9zCeVu
         Y8WTj1oedwqadOP45/XCBsUj8hnarwH7yKYvHUudllX+H53V2iUh7trRqBqnE+6vZf
         e0wHhBV+H86nAZ1hnlya5pd4e5MZ3tSkW7NK/oI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/529] Input: iqs269a - configure device with a single block write
Date:   Fri, 10 Mar 2023 14:36:20 +0100
Message-Id: <20230310133815.967248172@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 3689abfc4e369a643d758a02fb9ad0b2403d6d6d ]

Unless it is being done as part of servicing a soft reset interrupt,
configuring channels on-the-fly (as is the case when writing to the
ati_trigger attribute) may cause GPIO3 (which reflects the state of
touch for a selected channel) to be inadvertently asserted.

To solve this problem, follow the vendor's recommendation and write
all channel configuration as well as the REDO_ATI register field as
part of a single block write. This ensures the device has been told
to re-calibrate itself following an I2C stop condition, after which
sensing resumes and GPIO3 may be asserted.

Fixes: 04e49867fad1 ("Input: add support for Azoteq IQS269A")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/Y7Rs8GyV7g0nF5Yy@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs269a.c | 98 ++++++++++++++----------------------
 1 file changed, 39 insertions(+), 59 deletions(-)

diff --git a/drivers/input/misc/iqs269a.c b/drivers/input/misc/iqs269a.c
index ea3401a1000f0..1530efd301c24 100644
--- a/drivers/input/misc/iqs269a.c
+++ b/drivers/input/misc/iqs269a.c
@@ -96,8 +96,6 @@
 #define IQS269_MISC_B_TRACKING_UI_ENABLE	BIT(4)
 #define IQS269_MISC_B_FILT_STR_SLIDER		GENMASK(1, 0)
 
-#define IQS269_CHx_SETTINGS			0x8C
-
 #define IQS269_CHx_ENG_A_MEAS_CAP_SIZE		BIT(15)
 #define IQS269_CHx_ENG_A_RX_GND_INACTIVE	BIT(13)
 #define IQS269_CHx_ENG_A_LOCAL_CAP_SIZE		BIT(12)
@@ -245,6 +243,18 @@ struct iqs269_ver_info {
 	u8 padding;
 } __packed;
 
+struct iqs269_ch_reg {
+	u8 rx_enable;
+	u8 tx_enable;
+	__be16 engine_a;
+	__be16 engine_b;
+	__be16 ati_comp;
+	u8 thresh[3];
+	u8 hyst;
+	u8 assoc_select;
+	u8 assoc_weight;
+} __packed;
+
 struct iqs269_sys_reg {
 	__be16 general;
 	u8 active;
@@ -266,18 +276,7 @@ struct iqs269_sys_reg {
 	u8 timeout_swipe;
 	u8 thresh_swipe;
 	u8 redo_ati;
-} __packed;
-
-struct iqs269_ch_reg {
-	u8 rx_enable;
-	u8 tx_enable;
-	__be16 engine_a;
-	__be16 engine_b;
-	__be16 ati_comp;
-	u8 thresh[3];
-	u8 hyst;
-	u8 assoc_select;
-	u8 assoc_weight;
+	struct iqs269_ch_reg ch_reg[IQS269_NUM_CH];
 } __packed;
 
 struct iqs269_flags {
@@ -292,7 +291,6 @@ struct iqs269_private {
 	struct regmap *regmap;
 	struct mutex lock;
 	struct iqs269_switch_desc switches[ARRAY_SIZE(iqs269_events)];
-	struct iqs269_ch_reg ch_reg[IQS269_NUM_CH];
 	struct iqs269_sys_reg sys_reg;
 	struct input_dev *keypad;
 	struct input_dev *slider[IQS269_NUM_SL];
@@ -307,6 +305,7 @@ struct iqs269_private {
 static int iqs269_ati_mode_set(struct iqs269_private *iqs269,
 			       unsigned int ch_num, unsigned int mode)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_a;
 
 	if (ch_num >= IQS269_NUM_CH)
@@ -317,12 +316,12 @@ static int iqs269_ati_mode_set(struct iqs269_private *iqs269,
 
 	mutex_lock(&iqs269->lock);
 
-	engine_a = be16_to_cpu(iqs269->ch_reg[ch_num].engine_a);
+	engine_a = be16_to_cpu(ch_reg[ch_num].engine_a);
 
 	engine_a &= ~IQS269_CHx_ENG_A_ATI_MODE_MASK;
 	engine_a |= (mode << IQS269_CHx_ENG_A_ATI_MODE_SHIFT);
 
-	iqs269->ch_reg[ch_num].engine_a = cpu_to_be16(engine_a);
+	ch_reg[ch_num].engine_a = cpu_to_be16(engine_a);
 	iqs269->ati_current = false;
 
 	mutex_unlock(&iqs269->lock);
@@ -333,13 +332,14 @@ static int iqs269_ati_mode_set(struct iqs269_private *iqs269,
 static int iqs269_ati_mode_get(struct iqs269_private *iqs269,
 			       unsigned int ch_num, unsigned int *mode)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_a;
 
 	if (ch_num >= IQS269_NUM_CH)
 		return -EINVAL;
 
 	mutex_lock(&iqs269->lock);
-	engine_a = be16_to_cpu(iqs269->ch_reg[ch_num].engine_a);
+	engine_a = be16_to_cpu(ch_reg[ch_num].engine_a);
 	mutex_unlock(&iqs269->lock);
 
 	engine_a &= IQS269_CHx_ENG_A_ATI_MODE_MASK;
@@ -351,6 +351,7 @@ static int iqs269_ati_mode_get(struct iqs269_private *iqs269,
 static int iqs269_ati_base_set(struct iqs269_private *iqs269,
 			       unsigned int ch_num, unsigned int base)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_b;
 
 	if (ch_num >= IQS269_NUM_CH)
@@ -379,12 +380,12 @@ static int iqs269_ati_base_set(struct iqs269_private *iqs269,
 
 	mutex_lock(&iqs269->lock);
 
-	engine_b = be16_to_cpu(iqs269->ch_reg[ch_num].engine_b);
+	engine_b = be16_to_cpu(ch_reg[ch_num].engine_b);
 
 	engine_b &= ~IQS269_CHx_ENG_B_ATI_BASE_MASK;
 	engine_b |= base;
 
-	iqs269->ch_reg[ch_num].engine_b = cpu_to_be16(engine_b);
+	ch_reg[ch_num].engine_b = cpu_to_be16(engine_b);
 	iqs269->ati_current = false;
 
 	mutex_unlock(&iqs269->lock);
@@ -395,13 +396,14 @@ static int iqs269_ati_base_set(struct iqs269_private *iqs269,
 static int iqs269_ati_base_get(struct iqs269_private *iqs269,
 			       unsigned int ch_num, unsigned int *base)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_b;
 
 	if (ch_num >= IQS269_NUM_CH)
 		return -EINVAL;
 
 	mutex_lock(&iqs269->lock);
-	engine_b = be16_to_cpu(iqs269->ch_reg[ch_num].engine_b);
+	engine_b = be16_to_cpu(ch_reg[ch_num].engine_b);
 	mutex_unlock(&iqs269->lock);
 
 	switch (engine_b & IQS269_CHx_ENG_B_ATI_BASE_MASK) {
@@ -429,6 +431,7 @@ static int iqs269_ati_base_get(struct iqs269_private *iqs269,
 static int iqs269_ati_target_set(struct iqs269_private *iqs269,
 				 unsigned int ch_num, unsigned int target)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_b;
 
 	if (ch_num >= IQS269_NUM_CH)
@@ -439,12 +442,12 @@ static int iqs269_ati_target_set(struct iqs269_private *iqs269,
 
 	mutex_lock(&iqs269->lock);
 
-	engine_b = be16_to_cpu(iqs269->ch_reg[ch_num].engine_b);
+	engine_b = be16_to_cpu(ch_reg[ch_num].engine_b);
 
 	engine_b &= ~IQS269_CHx_ENG_B_ATI_TARGET_MASK;
 	engine_b |= target / 32;
 
-	iqs269->ch_reg[ch_num].engine_b = cpu_to_be16(engine_b);
+	ch_reg[ch_num].engine_b = cpu_to_be16(engine_b);
 	iqs269->ati_current = false;
 
 	mutex_unlock(&iqs269->lock);
@@ -455,13 +458,14 @@ static int iqs269_ati_target_set(struct iqs269_private *iqs269,
 static int iqs269_ati_target_get(struct iqs269_private *iqs269,
 				 unsigned int ch_num, unsigned int *target)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_b;
 
 	if (ch_num >= IQS269_NUM_CH)
 		return -EINVAL;
 
 	mutex_lock(&iqs269->lock);
-	engine_b = be16_to_cpu(iqs269->ch_reg[ch_num].engine_b);
+	engine_b = be16_to_cpu(ch_reg[ch_num].engine_b);
 	mutex_unlock(&iqs269->lock);
 
 	*target = (engine_b & IQS269_CHx_ENG_B_ATI_TARGET_MASK) * 32;
@@ -531,13 +535,7 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 	if (fwnode_property_present(ch_node, "azoteq,slider1-select"))
 		iqs269->sys_reg.slider_select[1] |= BIT(reg);
 
-	ch_reg = &iqs269->ch_reg[reg];
-
-	error = regmap_raw_read(iqs269->regmap,
-				IQS269_CHx_SETTINGS + reg * sizeof(*ch_reg) / 2,
-				ch_reg, sizeof(*ch_reg));
-	if (error)
-		return error;
+	ch_reg = &iqs269->sys_reg.ch_reg[reg];
 
 	error = iqs269_parse_mask(ch_node, "azoteq,rx-enable",
 				  &ch_reg->rx_enable);
@@ -1042,10 +1040,8 @@ static int iqs269_parse_prop(struct iqs269_private *iqs269)
 
 static int iqs269_dev_init(struct iqs269_private *iqs269)
 {
-	struct iqs269_sys_reg *sys_reg = &iqs269->sys_reg;
-	struct iqs269_ch_reg *ch_reg;
 	unsigned int val;
-	int error, i;
+	int error;
 
 	mutex_lock(&iqs269->lock);
 
@@ -1055,27 +1051,8 @@ static int iqs269_dev_init(struct iqs269_private *iqs269)
 	if (error)
 		goto err_mutex;
 
-	for (i = 0; i < IQS269_NUM_CH; i++) {
-		if (!(sys_reg->active & BIT(i)))
-			continue;
-
-		ch_reg = &iqs269->ch_reg[i];
-
-		error = regmap_raw_write(iqs269->regmap,
-					 IQS269_CHx_SETTINGS + i *
-					 sizeof(*ch_reg) / 2, ch_reg,
-					 sizeof(*ch_reg));
-		if (error)
-			goto err_mutex;
-	}
-
-	/*
-	 * The REDO-ATI and ATI channel selection fields must be written in the
-	 * same block write, so every field between registers 0x80 through 0x8B
-	 * (inclusive) must be written as well.
-	 */
-	error = regmap_raw_write(iqs269->regmap, IQS269_SYS_SETTINGS, sys_reg,
-				 sizeof(*sys_reg));
+	error = regmap_raw_write(iqs269->regmap, IQS269_SYS_SETTINGS,
+				 &iqs269->sys_reg, sizeof(iqs269->sys_reg));
 	if (error)
 		goto err_mutex;
 
@@ -1349,6 +1326,7 @@ static ssize_t hall_bin_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	struct i2c_client *client = iqs269->client;
 	unsigned int val;
 	int error;
@@ -1363,8 +1341,8 @@ static ssize_t hall_bin_show(struct device *dev,
 	if (error)
 		return error;
 
-	switch (iqs269->ch_reg[IQS269_CHx_HALL_ACTIVE].rx_enable &
-		iqs269->ch_reg[IQS269_CHx_HALL_INACTIVE].rx_enable) {
+	switch (ch_reg[IQS269_CHx_HALL_ACTIVE].rx_enable &
+		ch_reg[IQS269_CHx_HALL_INACTIVE].rx_enable) {
 	case IQS269_HALL_PAD_R:
 		val &= IQS269_CAL_DATA_A_HALL_BIN_R_MASK;
 		val >>= IQS269_CAL_DATA_A_HALL_BIN_R_SHIFT;
@@ -1444,9 +1422,10 @@ static ssize_t rx_enable_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 
 	return scnprintf(buf, PAGE_SIZE, "%u\n",
-			 iqs269->ch_reg[iqs269->ch_num].rx_enable);
+			 ch_reg[iqs269->ch_num].rx_enable);
 }
 
 static ssize_t rx_enable_store(struct device *dev,
@@ -1454,6 +1433,7 @@ static ssize_t rx_enable_store(struct device *dev,
 			       size_t count)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	unsigned int val;
 	int error;
 
@@ -1466,7 +1446,7 @@ static ssize_t rx_enable_store(struct device *dev,
 
 	mutex_lock(&iqs269->lock);
 
-	iqs269->ch_reg[iqs269->ch_num].rx_enable = val;
+	ch_reg[iqs269->ch_num].rx_enable = val;
 	iqs269->ati_current = false;
 
 	mutex_unlock(&iqs269->lock);
-- 
2.39.2



