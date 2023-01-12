Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1BE66754D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbjALOUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbjALOTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987D6532AA
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:11:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD0361F4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8A8C433D2;
        Thu, 12 Jan 2023 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532683;
        bh=9g3w6FqGG5dKfjDgxqMNoBNcBj3pFG2i7rm2kfMKH0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BX2WOiPhko+7C7ucZKLQwL6pwwxsCbx7Kr24anmY//ZqQR323iSSCO/G2SNX3PF85
         usUt5cJSqXPx8wHiBarrjR7w7VecV/4bcXyS2FOq8RPJ/mCdzJouYFcA16b3KDsIM7
         462lk4yUecxrHicBcmwniwXXfx5tAYMDn/hASAFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Sverdlin <alexander.sverdlin@siemens.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/783] spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE
Date:   Thu, 12 Jan 2023 14:48:37 +0100
Message-Id: <20230112135533.657723768@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 7dbfa445ff7393d1c4c066c1727c9e0af1251958 ]

Commit f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
has changed the user-space interface so that bogus SPI_CS_HIGH started
to appear in the mask returned by SPI_IOC_RD_MODE even for active-low CS
pins. Commit 138c9c32f090
("spi: spidev: Fix CS polarity if GPIO descriptors are used") fixed only
SPI_IOC_WR_MODE part of the problem. Let's fix SPI_IOC_RD_MODE
symmetrically.

Test case:

	#include <sys/ioctl.h>
	#include <fcntl.h>
	#include <linux/spi/spidev.h>

	int main(int argc, char **argv)
	{
		char modew = SPI_CPHA;
		char moder;
		int f = open("/dev/spidev0.0", O_RDWR);

		if (f < 0)
			return 1;

		ioctl(f, SPI_IOC_WR_MODE, &modew);
		ioctl(f, SPI_IOC_RD_MODE, &moder);

		return moder == modew ? 0 : 2;
	}

Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20221130162927.539512-1-alexander.sverdlin@siemens.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 859910ec8d9f..9c5ec99431d2 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -376,12 +376,23 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	/* read requests */
 	case SPI_IOC_RD_MODE:
-		retval = put_user(spi->mode & SPI_MODE_MASK,
-					(__u8 __user *)arg);
-		break;
 	case SPI_IOC_RD_MODE32:
-		retval = put_user(spi->mode & SPI_MODE_MASK,
-					(__u32 __user *)arg);
+		tmp = spi->mode;
+
+		{
+			struct spi_controller *ctlr = spi->controller;
+
+			if (ctlr->use_gpio_descriptors && ctlr->cs_gpiods &&
+			    ctlr->cs_gpiods[spi->chip_select])
+				tmp &= ~SPI_CS_HIGH;
+		}
+
+		if (cmd == SPI_IOC_RD_MODE)
+			retval = put_user(tmp & SPI_MODE_MASK,
+					  (__u8 __user *)arg);
+		else
+			retval = put_user(tmp & SPI_MODE_MASK,
+					  (__u32 __user *)arg);
 		break;
 	case SPI_IOC_RD_LSB_FIRST:
 		retval = put_user((spi->mode & SPI_LSB_FIRST) ?  1 : 0,
-- 
2.35.1



