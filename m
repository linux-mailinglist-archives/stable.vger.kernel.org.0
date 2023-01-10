Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBDB664A00
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbjAJS3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjAJS2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:28:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6824AF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 730A661865
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6649BC433D2;
        Tue, 10 Jan 2023 18:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374995;
        bh=28HnGYvLUBH0VcEp2wUB5MgJsMx54LSkc1ou7ocB4qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rr4m8DkjC+HvJHnFfVlFKLxJGYMBIghAUtHAtcQnWoe/2VOUHdvh6Qi80yvYbHvjr
         jAELhaV/sr+DkECtZLO7o3PDzallWUaxvhJm6vm3numgAa41+LtR3IKnMSDZfZxZtY
         zFkrHMvpyBo/O1YVWkRt1TWp856XbR0MGVaFVNIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ChiYuan Huang <cy_huang@richtek.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 044/290] mfd: mt6360: Add bounds checking in Regmap read/write call-backs
Date:   Tue, 10 Jan 2023 19:02:16 +0100
Message-Id: <20230110180033.115199871@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

commit 5f4f94e9f26cca6514474b307b59348b8485e711 upstream.

Fix the potential risk of OOB read if bank index is over the maximum.

Refer to the discussion list for the experiment result on mt6370.
https://lore.kernel.org/all/20220914013345.GA5802@cyhuang-hp-elitebook-840-g3.rt/
If not to check the bound, there is the same issue on mt6360.

Cc: stable@vger.kernel.org
Fixes: 3b0850440a06c (mfd: mt6360: Merge different sub-devices I2C read/write)
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/1664416817-31590-1-git-send-email-u0084500@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/mt6360-core.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/mfd/mt6360-core.c
+++ b/drivers/mfd/mt6360-core.c
@@ -402,7 +402,7 @@ static int mt6360_regmap_read(void *cont
 	struct mt6360_ddata *ddata = context;
 	u8 bank = *(u8 *)reg;
 	u8 reg_addr = *(u8 *)(reg + 1);
-	struct i2c_client *i2c = ddata->i2c[bank];
+	struct i2c_client *i2c;
 	bool crc_needed = false;
 	u8 *buf;
 	int buf_len = MT6360_ALLOC_READ_SIZE(val_size);
@@ -410,6 +410,11 @@ static int mt6360_regmap_read(void *cont
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
@@ -453,13 +458,18 @@ static int mt6360_regmap_write(void *con
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


