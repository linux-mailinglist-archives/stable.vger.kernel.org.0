Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A43A8A0B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbfIDP6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731812AbfIDP6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89EF22341C;
        Wed,  4 Sep 2019 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612693;
        bh=h2IhLcindbILDhqXojQbO6MMiUWRO4pjB7tV4EHYZ90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6B0JrN1rekJ9wgrzlyoGi0m03QXMbUEGygDkFsOimY215OoYMFcL+/XOvS9BwSj7
         gE9vfNvibQhUIQ1qQg7tAMfBy6Xc6n3SOAmInCY7sDl+1GZ6Y6naMDvm8xS9uQ56Fg
         QarWhggB4I3I/1A7I/tP0VFLJCb5bJbRb01y4TkM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phil Reid <preid@electromag.com.au>,
        Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fpga@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 21/94] fpga: altera-ps-spi: Fix getting of optional confd gpio
Date:   Wed,  4 Sep 2019 11:56:26 -0400
Message-Id: <20190904155739.2816-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
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
index a13f224303c69..0221dee8dd4c6 100644
--- a/drivers/fpga/altera-ps-spi.c
+++ b/drivers/fpga/altera-ps-spi.c
@@ -210,7 +210,7 @@ static int altera_ps_write_complete(struct fpga_manager *mgr,
 		return -EIO;
 	}
 
-	if (!IS_ERR(conf->confd)) {
+	if (conf->confd) {
 		if (!gpiod_get_raw_value_cansleep(conf->confd)) {
 			dev_err(&mgr->dev, "CONF_DONE is inactive!\n");
 			return -EIO;
@@ -289,10 +289,13 @@ static int altera_ps_probe(struct spi_device *spi)
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

