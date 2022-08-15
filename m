Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AA3594595
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345211AbiHOWAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347213AbiHOV73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:59:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A5910DCE9;
        Mon, 15 Aug 2022 12:35:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29B1561184;
        Mon, 15 Aug 2022 19:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7FCC433C1;
        Mon, 15 Aug 2022 19:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592081;
        bh=bOmIgRM4vNz3Df9Jf/OuuxejBYT6qZkU/b0bYL8I7/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmJ/Hn0Y7VPD1ZxOrbMhfJDQjYmWXa5IoMSUPbZmoOi/ZmjSVRVzyNhvQ+J3dwQAj
         5oOXTHPMoZVADEZLI4KIlo9f5QnR7Cxo/Dkie/Ir4JBdhZ8Z5Vgq3My7CWsUVbv/Tm
         Kfjh70JGEUCbYmCKvU1OU/cU5c8P3NJ4uyIpyJ3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0692/1095] mtd: dataflash: Add SPI ID table
Date:   Mon, 15 Aug 2022 20:01:31 +0200
Message-Id: <20220815180458.001073972@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 134e27328597..25bad4318305 100644
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
@@ -936,6 +943,7 @@ static struct spi_driver dataflash_driver = {
 
 	.probe		= dataflash_probe,
 	.remove		= dataflash_remove,
+	.id_table	= dataflash_spi_ids,
 
 	/* FIXME:  investigate suspend and resume... */
 };
-- 
2.35.1



