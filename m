Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1852E67BD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbgL1NGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbgL1NGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:06:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A0D9208B6;
        Mon, 28 Dec 2020 13:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160771;
        bh=X9HNZ+ASp+IG55Xm89EYEWHTOUeAR9+dTbE1hmThyWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qog3up1zmAvROPJXUU4xt7KNZOefNY08www6J6o/Gm0hfoZ1GUPApu9dzpEencsAd
         0ADkA2X8qq/IzvgEn7a0NvtnWBVUaMwJWTdvFf628Unl6ql3sdp5RR1uBnT7mO78a9
         PrUwCxkQbVuDrjgMBMXEsSLUFzNo8jY7NiKEmIWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Phil Reid <preid@electromag.com.au>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 166/175] spi: sc18is602: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:50:19 +0100
Message-Id: <20201228124901.278663533@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 5b8c88462d83331dacb48aeaec8388117fef82e0 upstream.

If the call to devm_gpiod_get_optional() fails on probe of the NXP
SC18IS602/603 SPI driver, the spi_master struct is erroneously not freed.

Fix by switching over to the new devm_spi_alloc_master() helper.

Fixes: f99008013e19 ("spi: sc18is602: Add reset control via gpio pin.")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.9+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.9+
Cc: Phil Reid <preid@electromag.com.au>
Link: https://lore.kernel.org/r/d5f715527b894b91d530fe11a86f51b3184a4e1a.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-sc18is602.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/drivers/spi/spi-sc18is602.c
+++ b/drivers/spi/spi-sc18is602.c
@@ -247,13 +247,12 @@ static int sc18is602_probe(struct i2c_cl
 	struct sc18is602_platform_data *pdata = dev_get_platdata(dev);
 	struct sc18is602 *hw;
 	struct spi_master *master;
-	int error;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C |
 				     I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
 		return -EINVAL;
 
-	master = spi_alloc_master(dev, sizeof(struct sc18is602));
+	master = devm_spi_alloc_master(dev, sizeof(struct sc18is602));
 	if (!master)
 		return -ENOMEM;
 
@@ -304,15 +303,7 @@ static int sc18is602_probe(struct i2c_cl
 	master->min_speed_hz = hw->freq / 128;
 	master->max_speed_hz = hw->freq / 4;
 
-	error = devm_spi_register_master(dev, master);
-	if (error)
-		goto error_reg;
-
-	return 0;
-
-error_reg:
-	spi_master_put(master);
-	return error;
+	return devm_spi_register_master(dev, master);
 }
 
 static const struct i2c_device_id sc18is602_id[] = {


