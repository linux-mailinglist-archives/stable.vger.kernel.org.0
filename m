Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8C9604133
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiJSKkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiJSKjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:39:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8415F24946;
        Wed, 19 Oct 2022 03:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CDD7B823B5;
        Wed, 19 Oct 2022 08:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DDBC433D7;
        Wed, 19 Oct 2022 08:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169598;
        bh=HZaN/LuBXVRxq6KpjERBiJycbpJDZKdsXB0MQGoEFeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHnBJ4XVmLfjuadNsmOo7dBcQFhfu8yiY4ixhs1vdaIVZDYiY8+yvSao+bHcTLkYM
         Ybo5BOXaOuQargkneeUzsAav3qe40Kv3S+50bkUnCAFWfxofoIvNbSoabud6OzG24G
         j6JdS/p0fSOeKfJ17fQpYTIIYMaOKLUnEfc27piY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksandr Shamray <oleksandrs@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 335/862] hwmon: (pmbus/mp2888) Fix sensors readouts for MPS Multi-phase mp2888 controller
Date:   Wed, 19 Oct 2022 10:27:02 +0200
Message-Id: <20221019083304.853608171@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Shamray <oleksandrs@nvidia.com>

[ Upstream commit 525dd5aed67a2f4f7278116fb92a24e6a53e2622 ]

Fix scale factors for reading MPS Multi-phase mp2888 controller.
Fixed sensors:
    - PIN/POUT: based on vendor documentation, set bscale factor 0.5W/LSB
    - IOUT: based on vendor documentation, set scale factor 0.25 A/LSB

Fixes: e4db7719d037 ("hwmon: (pmbus) Add support for MPS Multi-phase mp2888 controller")
Signed-off-by: Oleksandr Shamray <oleksandrs@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20220929121642.63051-1-oleksandrs@nvidia.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/mp2888.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/pmbus/mp2888.c b/drivers/hwmon/pmbus/mp2888.c
index 8ecd4adfef40..24e5194706cf 100644
--- a/drivers/hwmon/pmbus/mp2888.c
+++ b/drivers/hwmon/pmbus/mp2888.c
@@ -34,7 +34,7 @@ struct mp2888_data {
 	int curr_sense_gain;
 };
 
-#define to_mp2888_data(x)  container_of(x, struct mp2888_data, info)
+#define to_mp2888_data(x)	container_of(x, struct mp2888_data, info)
 
 static int mp2888_read_byte_data(struct i2c_client *client, int page, int reg)
 {
@@ -109,7 +109,7 @@ mp2888_read_phase(struct i2c_client *client, struct mp2888_data *data, int page,
 	 * - Kcs is the DrMOS current sense gain of power stage, which is obtained from the
 	 *   register MP2888_MFR_VR_CONFIG1, bits 13-12 with the following selection of DrMOS
 	 *   (data->curr_sense_gain):
-	 *   00b - 5µA/A, 01b - 8.5µA/A, 10b - 9.7µA/A, 11b - 10µA/A.
+	 *   00b - 8.5µA/A, 01b - 9.7µA/A, 1b - 10µA/A, 11b - 5µA/A.
 	 * - Rcs is the internal phase current sense resistor. This parameter depends on hardware
 	 *   assembly. By default it is set to 1kΩ. In case of different assembly, user should
 	 *   scale this parameter by dividing it by Rcs.
@@ -118,10 +118,9 @@ mp2888_read_phase(struct i2c_client *client, struct mp2888_data *data, int page,
 	 * because sampling of current occurrence of bit weight has a big deviation, especially for
 	 * light load.
 	 */
-	ret = DIV_ROUND_CLOSEST(ret * 100 - 9800, data->curr_sense_gain);
-	ret = (data->phase_curr_resolution) ? ret * 2 : ret;
+	ret = DIV_ROUND_CLOSEST(ret * 200 - 19600, data->curr_sense_gain);
 	/* Scale according to total current resolution. */
-	ret = (data->total_curr_resolution) ? ret * 8 : ret * 4;
+	ret = (data->total_curr_resolution) ? ret * 2 : ret;
 	return ret;
 }
 
@@ -212,7 +211,7 @@ static int mp2888_read_word_data(struct i2c_client *client, int page, int phase,
 		ret = pmbus_read_word_data(client, page, phase, reg);
 		if (ret < 0)
 			return ret;
-		ret = data->total_curr_resolution ? ret * 2 : ret;
+		ret = data->total_curr_resolution ? ret : DIV_ROUND_CLOSEST(ret, 2);
 		break;
 	case PMBUS_POUT_OP_WARN_LIMIT:
 		ret = pmbus_read_word_data(client, page, phase, reg);
@@ -223,7 +222,7 @@ static int mp2888_read_word_data(struct i2c_client *client, int page, int phase,
 		 * set 1. Actual power is reported with 0.5W or 1W respectively resolution. Scaling
 		 * is needed to match both.
 		 */
-		ret = data->total_curr_resolution ? ret * 4 : ret * 2;
+		ret = data->total_curr_resolution ? ret * 2 : ret;
 		break;
 	/*
 	 * The below registers are not implemented by device or implemented not according to the
-- 
2.35.1



