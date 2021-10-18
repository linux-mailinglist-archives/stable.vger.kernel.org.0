Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1662F431E87
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhJROB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234206AbhJRN76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F1B261A70;
        Mon, 18 Oct 2021 13:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564529;
        bh=qRlZ3O2fCZAUNFvO+4h5GtexXDjDgVaufbLgT+qB8JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYkZ64VGxDkf1cF1Scp8tjKCnZtiwMMKdWbuZ2WVg3xH0kIMAUKinj3t+lRFRQbs4
         QvaIcIH9YJpqGX1AQOeCcvF2C8OH6eyN4FtxiPcKmPuorwGRH0enHgkC8CpOL3qcJo
         QgPuv0yX/mc1ktaEHrEpM1JH9iLQbaWYBSUqj/1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.14 123/151] spi: spidev: Add SPI ID table
Date:   Mon, 18 Oct 2021 15:25:02 +0200
Message-Id: <20211018132344.669365810@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit 6840615f85f6046039ebc4989870ddb12892b7fc upstream.

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding an id_table listing the
SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210923170023.1683-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spidev.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -673,6 +673,19 @@ static const struct file_operations spid
 
 static struct class *spidev_class;
 
+static const struct spi_device_id spidev_spi_ids[] = {
+	{ .name = "dh2228fv" },
+	{ .name = "ltc2488" },
+	{ .name = "sx1301" },
+	{ .name = "bk4" },
+	{ .name = "dhcom-board" },
+	{ .name = "m53cpld" },
+	{ .name = "spi-petra" },
+	{ .name = "spi-authenta" },
+	{},
+};
+MODULE_DEVICE_TABLE(spi, spidev_spi_ids);
+
 #ifdef CONFIG_OF
 static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "rohm,dh2228fv" },
@@ -819,6 +832,7 @@ static struct spi_driver spidev_spi_driv
 	},
 	.probe =	spidev_probe,
 	.remove =	spidev_remove,
+	.id_table =	spidev_spi_ids,
 
 	/* NOTE:  suspend/resume methods are not necessary here.
 	 * We don't do anything except pass the requests to/from


