Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16066582B1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiL1QkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbiL1Qjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:39:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0931E3D3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:34:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D2D61577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969C5C433D2;
        Wed, 28 Dec 2022 16:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245286;
        bh=0+toHmPPNYZQb2J6HMgYF0ISCazdIc2rtA3/MMKR5Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRyJXP6iVyOJjFrlYSdOtxYJz9t8Tykl8L7aB2Y89bly6bPGZpPf2mCCY7QPQuBIy
         9DUH/O3gOZ5n+oac4FPvN0U1lkDIc1k8WIv6C3fVyGgsaQwXBvMk3mnTJPzKwyqixp
         PZH7J61AgFeFzCAjICfIdo1qTB2kkzXuPGPo6W+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0833/1146] rtc: pcf2127: Convert to .probe_new()
Date:   Wed, 28 Dec 2022 15:39:32 +0100
Message-Id: <20221228144352.783228795@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 5418e595f30bf4fde83ebb0121417c0c95cff98e ]

.probe_new() doesn't get the i2c_device_id * parameter, so determine
that explicitly in .probe(). The device_id array has to move up for that
to work.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20221021130706.178687-7-u.kleine-koenig@pengutronix.de
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf2127.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2127.c b/drivers/rtc/rtc-pcf2127.c
index 63b275b014bd..87f4fc9df68b 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -885,9 +885,17 @@ static const struct regmap_bus pcf2127_i2c_regmap = {
 
 static struct i2c_driver pcf2127_i2c_driver;
 
-static int pcf2127_i2c_probe(struct i2c_client *client,
-				const struct i2c_device_id *id)
+static const struct i2c_device_id pcf2127_i2c_id[] = {
+	{ "pcf2127", 1 },
+	{ "pcf2129", 0 },
+	{ "pca2129", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pcf2127_i2c_id);
+
+static int pcf2127_i2c_probe(struct i2c_client *client)
 {
+	const struct i2c_device_id *id = i2c_match_id(pcf2127_i2c_id, client);
 	struct regmap *regmap;
 	static const struct regmap_config config = {
 		.reg_bits = 8,
@@ -910,20 +918,12 @@ static int pcf2127_i2c_probe(struct i2c_client *client,
 			     pcf2127_i2c_driver.driver.name, id->driver_data);
 }
 
-static const struct i2c_device_id pcf2127_i2c_id[] = {
-	{ "pcf2127", 1 },
-	{ "pcf2129", 0 },
-	{ "pca2129", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, pcf2127_i2c_id);
-
 static struct i2c_driver pcf2127_i2c_driver = {
 	.driver		= {
 		.name	= "rtc-pcf2127-i2c",
 		.of_match_table = of_match_ptr(pcf2127_of_match),
 	},
-	.probe		= pcf2127_i2c_probe,
+	.probe_new	= pcf2127_i2c_probe,
 	.id_table	= pcf2127_i2c_id,
 };
 
-- 
2.35.1



