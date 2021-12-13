Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3134728C5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239154AbhLMKOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239694AbhLMKIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:08:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F49C08E851;
        Mon, 13 Dec 2021 01:53:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 101C3B80E0B;
        Mon, 13 Dec 2021 09:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C119C00446;
        Mon, 13 Dec 2021 09:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389180;
        bh=CAfw3KUSjKuV/DirhW631ijwevUOhw/255korYoPg/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmB5IJUsxjQplqVuH5zODkj6iTv2rrRAHA1q0SFYqjWwhpfdRiZnTdZ60RCpbMhr4
         8+NFIuwo0JUdS7j0UHpQ9UNQSkvLD+E56Pga7YDobawUnrtgVQhQFVPcTj0QUSkoaj
         PnQHZK4vZLZPTt+fL0FG019Uz606wF0Bk8yFQ+70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 012/171] mtd: dataflash: Add device-tree SPI IDs
Date:   Mon, 13 Dec 2021 10:28:47 +0100
Message-Id: <20211213092945.503211076@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit 27a030e8729255b2068f35c1cd609b532b263311 upstream.

Commit 5fa6863ba692 ("spi: Check we have a spi_device_id for each DT
compatible") added a test to check that every SPI driver has a
spi_device_id for each DT compatiable string defined by the driver
and warns if the spi_device_id is missing. The spi_device_ids are
missing for the dataflash driver and the following warnings are now
seen.

 WARNING KERN SPI driver mtd_dataflash has no spi_device_id for atmel,at45
 WARNING KERN SPI driver mtd_dataflash has no spi_device_id for atmel,dataflash

Fix this by adding the necessary spi_device_ids.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211130112443.107730-1-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/mtd_dataflash.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -96,6 +96,13 @@ struct dataflash {
 	struct mtd_info		mtd;
 };
 
+static const struct spi_device_id dataflash_dev_ids[] = {
+	{ "at45" },
+	{ "dataflash" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, dataflash_dev_ids);
+
 #ifdef CONFIG_OF
 static const struct of_device_id dataflash_dt_ids[] = {
 	{ .compatible = "atmel,at45", },
@@ -927,6 +934,7 @@ static struct spi_driver dataflash_drive
 		.name		= "mtd_dataflash",
 		.of_match_table = of_match_ptr(dataflash_dt_ids),
 	},
+	.id_table = dataflash_dev_ids,
 
 	.probe		= dataflash_probe,
 	.remove		= dataflash_remove,


