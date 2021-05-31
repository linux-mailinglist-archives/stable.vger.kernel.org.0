Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDEA39624B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhEaOxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233605AbhEaOvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:51:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E44EB6192F;
        Mon, 31 May 2021 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469495;
        bh=CIfVlU3+wV0uj2rS+MlMz+qHMLRWBkF6CLZxdql3ps0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFDmEmEnxX1+Klh3NTe7TiEUpBR/a5Gpbr2irQ6ThVyHCrhE18vcrypZYjHPxnqOI
         PH9P7ySOs687KlxXN+9WVPjX/tSeyOONsVsZgzn2HPfUWN8v3qQhHTVROwMIbGBAAN
         qaxLBikPNVIlTbKjdJ944AZziabFEz3dmv0Ag8Lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leilk Liu <leilk.liu@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 220/296] spi: take the SPI IO-mutex in the spi_set_cs_timing method
Date:   Mon, 31 May 2021 15:14:35 +0200
Message-Id: <20210531130711.230929777@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leilk Liu <leilk.liu@mediatek.com>

[ Upstream commit dc5fa590273890a8541ce6e999d606bfb2d73797 ]

this patch takes the io_mutex to prevent an unprotected HW
register modification in the set_cs_timing callback.

Fixes: 4cea6b8cc34e ("spi: add power control when set_cs_timing")
Signed-off-by: Leilk Liu <leilk.liu@mediatek.com>
Link: https://lore.kernel.org/r/20210508060214.1485-1-leilk.liu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 8da4fe475b84..5495138c257e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3463,9 +3463,12 @@ int spi_set_cs_timing(struct spi_device *spi, struct spi_delay *setup,
 
 	if (spi->controller->set_cs_timing &&
 	    !(spi->cs_gpiod || gpio_is_valid(spi->cs_gpio))) {
+		mutex_lock(&spi->controller->io_mutex);
+
 		if (spi->controller->auto_runtime_pm) {
 			status = pm_runtime_get_sync(parent);
 			if (status < 0) {
+				mutex_unlock(&spi->controller->io_mutex);
 				pm_runtime_put_noidle(parent);
 				dev_err(&spi->controller->dev, "Failed to power device: %d\n",
 					status);
@@ -3476,11 +3479,13 @@ int spi_set_cs_timing(struct spi_device *spi, struct spi_delay *setup,
 								hold, inactive);
 			pm_runtime_mark_last_busy(parent);
 			pm_runtime_put_autosuspend(parent);
-			return status;
 		} else {
-			return spi->controller->set_cs_timing(spi, setup, hold,
+			status = spi->controller->set_cs_timing(spi, setup, hold,
 							      inactive);
 		}
+
+		mutex_unlock(&spi->controller->io_mutex);
+		return status;
 	}
 
 	if ((setup && setup->unit == SPI_DELAY_UNIT_SCK) ||
-- 
2.30.2



