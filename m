Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FB42E3C14
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391605AbgL1N6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391579AbgL1N6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:58:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76578207B2;
        Mon, 28 Dec 2020 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163879;
        bh=rOx0zv4PClnfji+d6QeAD2mvY5IM4oStEk6fOIU/We0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaHRaZXujfyxfA3if9XnZt/K0kF89KIFI73vIQwQJdlrIoHJ1JPRfFFamSZ5z8mFu
         Z41u1OcwuVaYZo5vRzXOliTqb54hNmKDj2X0tu7q8IqHbcPVBD+aqjNmNdtevOEr2x
         1vIm6dblzj+BQISqYiHjTpi7R2Ek8TmoOaK/1AL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Phil Reid <preid@electromag.com.au>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 410/453] spi: sc18is602: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:50:46 +0100
Message-Id: <20201228124956.939750481@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -239,13 +239,12 @@ static int sc18is602_probe(struct i2c_cl
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
 
@@ -299,15 +298,7 @@ static int sc18is602_probe(struct i2c_cl
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


