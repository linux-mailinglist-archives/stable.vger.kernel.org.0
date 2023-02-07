Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02D068D82D
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjBGNHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjBGNHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39143B0E8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA0DD61403
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B51C4339C;
        Tue,  7 Feb 2023 13:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775146;
        bh=9vkRVo911xuMNy+PWzxTzzANl7aShG2b2WHpcmtQFwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJWLUprfX4WpLNr7BLgfRlFYaFJoLdvR2r6adHW1tlrxq99MjMDY51RO2YgmDNrc/
         RqvgZ/HdLmmx9h87AbLUTNWsxPIb5f56SYSPEftTb89uTcQmfKkTyaxcfATNcHQVin
         O+dXZFBCi1oyFpgk48hq8sq+O08S2UJx4hJzUkBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Carlos Song <carlos.song@nxp.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 144/208] iio: imu: fxos8700: fix incorrect ODR mode readback
Date:   Tue,  7 Feb 2023 13:56:38 +0100
Message-Id: <20230207125640.952018934@linuxfoundation.org>
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

From: Carlos Song <carlos.song@nxp.com>

commit 78ad6864e9e012cdba7c353d044d21ffcfd5f34b upstream.

The absence of a correct offset leads an incorrect ODR mode
readback after use a hexadecimal number to mark the value from
FXOS8700_CTRL_REG1.

Get ODR mode by field mask and FIELD_GET clearly and conveniently.
And attach other additional fix for keeping the original code logic
and a good readability.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20230118074227.1665098-2-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -10,6 +10,7 @@
 #include <linux/regmap.h>
 #include <linux/acpi.h>
 #include <linux/bitops.h>
+#include <linux/bitfield.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
@@ -144,9 +145,9 @@
 #define FXOS8700_NVM_DATA_BNK0      0xa7
 
 /* Bit definitions for FXOS8700_CTRL_REG1 */
-#define FXOS8700_CTRL_ODR_MSK       0x38
 #define FXOS8700_CTRL_ODR_MAX       0x00
 #define FXOS8700_CTRL_ODR_MIN       GENMASK(4, 3)
+#define FXOS8700_CTRL_ODR_MSK       GENMASK(5, 3)
 
 /* Bit definitions for FXOS8700_M_CTRL_REG1 */
 #define FXOS8700_HMS_MASK           GENMASK(1, 0)
@@ -508,10 +509,9 @@ static int fxos8700_set_odr(struct fxos8
 	if (i >= odr_num)
 		return -EINVAL;
 
-	return regmap_update_bits(data->regmap,
-				  FXOS8700_CTRL_REG1,
-				  FXOS8700_CTRL_ODR_MSK + FXOS8700_ACTIVE,
-				  fxos8700_odr[i].bits << 3 | active_mode);
+	val &= ~FXOS8700_CTRL_ODR_MSK;
+	val |= FIELD_PREP(FXOS8700_CTRL_ODR_MSK, fxos8700_odr[i].bits) | FXOS8700_ACTIVE;
+	return regmap_write(data->regmap, FXOS8700_CTRL_REG1, val);
 }
 
 static int fxos8700_get_odr(struct fxos8700_data *data, enum fxos8700_sensor t,
@@ -524,7 +524,7 @@ static int fxos8700_get_odr(struct fxos8
 	if (ret)
 		return ret;
 
-	val &= FXOS8700_CTRL_ODR_MSK;
+	val = FIELD_GET(FXOS8700_CTRL_ODR_MSK, val);
 
 	for (i = 0; i < odr_num; i++)
 		if (val == fxos8700_odr[i].bits)


