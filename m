Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B0F4F2B1E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240982AbiDEJfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343532AbiDEI45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:56:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2591CFFA;
        Tue,  5 Apr 2022 01:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2480961003;
        Tue,  5 Apr 2022 08:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D608C385A0;
        Tue,  5 Apr 2022 08:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148776;
        bh=iYsyppak5X0PQkSwIxgTeVWMzlqbLKhGuR4Pvhdsn3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgzD7JVq2gk/+9zQ7Qiyj4f2C1pMC0gA6yZj5owfRXgwPWfrlfOwbutVBsdA9IB8d
         GEDHKZfLoZnV+j7Kp4XIkNTJ2zIArGLhQJXpO9VMKoWZPz4pwMbvuN95cHKRV4GTAn
         R84RZDVORPvfdoRL5cOUwoC3AwmVTqDeN7H2kY5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0478/1017] mtd: mchp23k256: Add SPI ID table
Date:   Tue,  5 Apr 2022 09:23:11 +0200
Message-Id: <20220405070408.487381655@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit bc7ee2e34b219da6813c17a1680dd20766648883 ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding an id_table listing the
SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Michael Walle <michael@walle.cc>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220202143404.16070-3-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/mchp23k256.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/mtd/devices/mchp23k256.c b/drivers/mtd/devices/mchp23k256.c
index 77c872fd3d83..7d188cdff6a2 100644
--- a/drivers/mtd/devices/mchp23k256.c
+++ b/drivers/mtd/devices/mchp23k256.c
@@ -229,6 +229,19 @@ static const struct of_device_id mchp23k256_of_table[] = {
 };
 MODULE_DEVICE_TABLE(of, mchp23k256_of_table);
 
+static const struct spi_device_id mchp23k256_spi_ids[] = {
+	{
+		.name = "mchp23k256",
+		.driver_data = (kernel_ulong_t)&mchp23k256_caps,
+	},
+	{
+		.name = "mchp23lcv1024",
+		.driver_data = (kernel_ulong_t)&mchp23lcv1024_caps,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(spi, mchp23k256_spi_ids);
+
 static struct spi_driver mchp23k256_driver = {
 	.driver = {
 		.name	= "mchp23k256",
@@ -236,6 +249,7 @@ static struct spi_driver mchp23k256_driver = {
 	},
 	.probe		= mchp23k256_probe,
 	.remove		= mchp23k256_remove,
+	.id_table	= mchp23k256_spi_ids,
 };
 
 module_spi_driver(mchp23k256_driver);
-- 
2.34.1



