Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE7FA256
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbfKMCCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731068AbfKMCCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:02:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 035C420674;
        Wed, 13 Nov 2019 02:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610564;
        bh=W+ZYmJ3tALheWbUv4P01KUCmLl9oUrjKMEXFXL+OArg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2+wH2FVUoUd5TeBBi0Un5L/D2dFDUCNh0yFPyzlQnqrRfaHTG9hr15sh+08r9D20
         XJyoRylUg4B+uhIwJkAbC6OZteTcFz2Jpx8ELHedcZZDOG/3SKPyVsgrE1X23Qd2z6
         pQ2KlrZV8UzVK7vxpeZBd/ND+avujTO83kHdoFIs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trent Piepho <tpiepho@impinj.com>,
        =?UTF-8?q?Jan=20Kundr=C3=83=C2=A1t?= <jan.kundrat@cesnet.cz>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 43/48] spi: spidev: Fix OF tree warning logic
Date:   Tue, 12 Nov 2019 21:01:26 -0500
Message-Id: <20191113020131.13356-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

