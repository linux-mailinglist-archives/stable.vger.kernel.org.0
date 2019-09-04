Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D71EA8B07
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733020AbfIDQBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733013AbfIDQBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 452D123404;
        Wed,  4 Sep 2019 16:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612890;
        bh=xlj4YzSLybuhqRVuRFUgZO5wN1PoJ9k1JCxgoRxgs3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fc3kEbTZYisRGg6oMrZM7phQPlEP69zlCX3QoCV9Y2pddX+mAXnT7wW0UfSnpAzcx
         thDHSb9hwp7rwy7o4/w/ouHUig6uXzp8quFmNZfSiZBd1MBvEj1eWXb9QytdZanKMs
         JNZ8sSjqX1U1HSaPrYiFYsNStwFhIzcaZCoc0c/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phil Reid <preid@electromag.com.au>,
        Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fpga@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/36] fpga: altera-ps-spi: Fix getting of optional confd gpio
Date:   Wed,  4 Sep 2019 12:00:53 -0400
Message-Id: <20190904160122.4179-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Reid <preid@electromag.com.au>

[ Upstream commit dec43da46f63eb71f519d963ba6832838e4262a3 ]

Currently the driver does not handle EPROBE_DEFER for the confd gpio.
Use devm_gpiod_get_optional() instead of devm_gpiod_get() and return
error codes from altera_ps_probe().

Fixes: 5692fae0742d ("fpga manager: Add altera-ps-spi driver for Altera FPGAs")
Signed-off-by: Phil Reid <preid@electromag.com.au>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/altera-ps-spi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/fpga/altera-ps-spi.c b/drivers/fpga/altera-ps-spi.c
index 06d212a3d49dd..19b1cf8a82528 100644
--- a/drivers/fpga/altera-ps-spi.c
+++ b/drivers/fpga/altera-ps-spi.c
@@ -207,7 +207,7 @@ static int altera_ps_write_complete(struct fpga_manager *mgr,
 		return -EIO;
 	}
 
-	if (!IS_ERR(conf->confd)) {
+	if (conf->confd) {
 		if (!gpiod_get_raw_value_cansleep(conf->confd)) {
 			dev_err(&mgr->dev, "CONF_DONE is inactive!\n");
 			return -EIO;
@@ -263,10 +263,13 @@ static int altera_ps_probe(struct spi_device *spi)
 		return PTR_ERR(conf->status);
 	}
 
-	conf->confd = devm_gpiod_get(&spi->dev, "confd", GPIOD_IN);
+	conf->confd = devm_gpiod_get_optional(&spi->dev, "confd", GPIOD_IN);
 	if (IS_ERR(conf->confd)) {
-		dev_warn(&spi->dev, "Not using confd gpio: %ld\n",
-			 PTR_ERR(conf->confd));
+		dev_err(&spi->dev, "Failed to get confd gpio: %ld\n",
+			PTR_ERR(conf->confd));
+		return PTR_ERR(conf->confd);
+	} else if (!conf->confd) {
+		dev_warn(&spi->dev, "Not using confd gpio");
 	}
 
 	/* Register manager with unique name */
-- 
2.20.1

