Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A55936F8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343556AbiHOTKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343561AbiHOTIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:08:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C36D39BBF;
        Mon, 15 Aug 2022 11:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8883CB8105C;
        Mon, 15 Aug 2022 18:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24E6C433C1;
        Mon, 15 Aug 2022 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588547;
        bh=oN4SatVjTHyC2dGIr0dnQaeRRTBhraK/hcKFR13JZp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvUcyCd8nUKOSkQzLZSlsgYzXikv9/oXgiHHAAMo5c+FmV3/BPoahrzmQv9tH0vvu
         v0HPERDQmDHhKLq/KY3NW+fCRafTSn7yZ5GMb3zcBoxxCAkqdRUUmIWxyuhFem1mtQ
         yI0kpy0Q/xwFF0JYArWwsGtXQ2PsqirkjYvjlY/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/779] mtd: dataflash: Add SPI ID table
Date:   Mon, 15 Aug 2022 20:01:23 +0200
Message-Id: <20220815180356.039213941@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit ac4f83482afbfd927d0fe118151b747cf175e724 ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding an id_table listing the
SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220620152313.708768-1-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/mtd_dataflash.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 2b317ed6c103..9c714c982c6e 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -112,6 +112,13 @@ static const struct of_device_id dataflash_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, dataflash_dt_ids);
 #endif
 
+static const struct spi_device_id dataflash_spi_ids[] = {
+	{ .name = "at45", },
+	{ .name = "dataflash", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(spi, dataflash_spi_ids);
+
 /* ......................................................................... */
 
 /*
@@ -938,6 +945,7 @@ static struct spi_driver dataflash_driver = {
 
 	.probe		= dataflash_probe,
 	.remove		= dataflash_remove,
+	.id_table	= dataflash_spi_ids,
 
 	/* FIXME:  investigate suspend and resume... */
 };
-- 
2.35.1



