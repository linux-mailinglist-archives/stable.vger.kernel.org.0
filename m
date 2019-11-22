Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8751070B6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbfKVKiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:38:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfKVKiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:38:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF1922072D;
        Fri, 22 Nov 2019 10:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419091;
        bh=W+ZYmJ3tALheWbUv4P01KUCmLl9oUrjKMEXFXL+OArg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHQRpoCRyF6PUxKoFfemk3TO1QD6GQmstxhpyXtVdtJsydeKmgPrW5gZw8pF66eJe
         0mor3rg1yTekbRg4ds7ldZyDDMrWfqvyeVrnrYkaO6wgg9PEDgQTwTSgdEiSgQAxMa
         5Ma7drQhAq5w4hSUODl0xNWpQPzVTawJvW0atKXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trent Piepho <tpiepho@impinj.com>,
        =?UTF-8?q?Jan=20Kundr=C3=83=C2=A1t?= <jan.kundrat@cesnet.cz>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 153/159] spi: spidev: Fix OF tree warning logic
Date:   Fri, 22 Nov 2019 11:29:04 +0100
Message-Id: <20191122100846.710231917@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trent Piepho <tpiepho@impinj.com>

[ Upstream commit 605b3bec73cbd74b4ac937b580cd0b47d1300484 ]

spidev will make a big fuss if a device tree node binds a device by
using "spidev" as the node's compatible property.

However, the logic for this isn't looking for "spidev" in the
compatible, but rather checking that the device is NOT compatible with
spidev's list of devices.

This causes a false positive if a device not named "rohm,dh2228fv", etc.
binds to spidev, even if a means other than putting "spidev" in the
device tree was used.  E.g., the sysfs driver_override attribute.

Signed-off-by: Trent Piepho <tpiepho@impinj.com>
Reviewed-by: Jan KundrÃ¡t <jan.kundrat@cesnet.cz>
Tested-by: Jan KundrÃ¡t <jan.kundrat@cesnet.cz>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index d0e7dfc647cf2..c5f1045561acc 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -713,11 +713,9 @@ static int spidev_probe(struct spi_device *spi)
 	 * compatible string, it is a Linux implementation thing
 	 * rather than a description of the hardware.
 	 */
-	if (spi->dev.of_node && !of_match_device(spidev_dt_ids, &spi->dev)) {
-		dev_err(&spi->dev, "buggy DT: spidev listed directly in DT\n");
-		WARN_ON(spi->dev.of_node &&
-			!of_match_device(spidev_dt_ids, &spi->dev));
-	}
+	WARN(spi->dev.of_node &&
+	     of_device_is_compatible(spi->dev.of_node, "spidev"),
+	     "%pOF: buggy DT: spidev listed directly in DT\n", spi->dev.of_node);
 
 	/* Allocate driver data */
 	spidev = kzalloc(sizeof(*spidev), GFP_KERNEL);
-- 
2.20.1



