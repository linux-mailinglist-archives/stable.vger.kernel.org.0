Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32464F351F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiDEJfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343533AbiDEI45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:56:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8144C21E09;
        Tue,  5 Apr 2022 01:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D64066117A;
        Tue,  5 Apr 2022 08:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35E3C385A0;
        Tue,  5 Apr 2022 08:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148779;
        bh=F7l6cRDIskjsaex4YVqyUiGZjsX8weyvVrGPsY41MgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWIm5NdLqJh3tUPDBi1w6vW68nrxwPA2JcREKDrUY2cJy0f2+SUYgl3wY6Md/Aw20
         2h2jy/zE7zpwPLKPfWks3E90OOOmcuzm6jB0DIawLC1l1VcuV6scAjc2DnnOHy5LtL
         XWEEaRJAbJ0/WG4JU1vDWYuxnVVK0j8JMkUfqR9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0479/1017] mtd: mchp48l640: Add SPI ID table
Date:   Tue,  5 Apr 2022 09:23:12 +0200
Message-Id: <20220405070408.517000412@linuxfoundation.org>
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

[ Upstream commit 69a6d06878f05d63673b0dcdc3c3ef1af2996d46 ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding an id_table listing the
SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Michael Walle <michael@walle.cc>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220202143404.16070-4-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/mchp48l640.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mtd/devices/mchp48l640.c b/drivers/mtd/devices/mchp48l640.c
index 99400d0fb8c1..fbd6b6bf908e 100644
--- a/drivers/mtd/devices/mchp48l640.c
+++ b/drivers/mtd/devices/mchp48l640.c
@@ -357,6 +357,15 @@ static const struct of_device_id mchp48l640_of_table[] = {
 };
 MODULE_DEVICE_TABLE(of, mchp48l640_of_table);
 
+static const struct spi_device_id mchp48l640_spi_ids[] = {
+	{
+		.name = "48l640",
+		.driver_data = (kernel_ulong_t)&mchp48l640_caps,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(spi, mchp48l640_spi_ids);
+
 static struct spi_driver mchp48l640_driver = {
 	.driver = {
 		.name	= "mchp48l640",
@@ -364,6 +373,7 @@ static struct spi_driver mchp48l640_driver = {
 	},
 	.probe		= mchp48l640_probe,
 	.remove		= mchp48l640_remove,
+	.id_table	= mchp48l640_spi_ids,
 };
 
 module_spi_driver(mchp48l640_driver);
-- 
2.34.1



