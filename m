Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C1A3442BD
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhCVMoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232629AbhCVMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6788619CE;
        Mon, 22 Mar 2021 12:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416850;
        bh=28dp9rm7vSOtIsRgIySR9/oKeFt137EmnXYVuUNsplc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cP46CcFkjM+qZ88O6zxanaaY8eAmpIpdQIg3nJCc0UgYyMig1kxVeqi+JY5TCX8SA
         sb04O1+D2suEb0cT36rFAVBR7jIOZQKldGiQqs379ZJaSHlg82m6AYglSst+hG3C8y
         UwsNjkroTlXK4Y9H0L91kgs+yWbwZUnkZAcpFHBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/157] regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3 voltage setting
Date:   Mon, 22 Mar 2021 13:27:48 +0100
Message-Id: <20210322121937.292034225@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 98b94b6e38ca0c4eeb29949c656f6a315000c23e ]

The driver uses the DVS registers PCA9450_REG_BUCKxOUT_DVS0 to set the
voltage for the buck regulators 1, 2 and 3. This has no effect as the
PRESET_EN bit is set by default and therefore the preset values are used
instead, which are set to 850 mV.

To fix this we clear the PRESET_EN bit at time of initialization.

Fixes: 0935ff5f1f0a ("regulator: pca9450: add pca9450 pmic driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20210222115229.166620-1-frieder.schrempf@kontron.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 8 ++++++++
 include/linux/regulator/pca9450.h     | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 833d398c6aa2..d38109cc3a01 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -797,6 +797,14 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	/* Clear PRESET_EN bit in BUCK123_DVS to use DVS registers */
+	ret = regmap_clear_bits(pca9450->regmap, PCA9450_REG_BUCK123_DVS,
+				BUCK123_PRESET_EN);
+	if (ret) {
+		dev_err(&i2c->dev, "Failed to clear PRESET_EN bit: %d\n", ret);
+		return ret;
+	}
+
 	/* Set reset behavior on assertion of WDOG_B signal */
 	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_RESET_CTRL,
 				WDOG_B_CFG_MASK, WDOG_B_CFG_COLD_LDO12);
diff --git a/include/linux/regulator/pca9450.h b/include/linux/regulator/pca9450.h
index ccdb5320a240..71902f41c919 100644
--- a/include/linux/regulator/pca9450.h
+++ b/include/linux/regulator/pca9450.h
@@ -147,6 +147,9 @@ enum {
 #define BUCK6_FPWM			0x04
 #define BUCK6_ENMODE_MASK		0x03
 
+/* PCA9450_REG_BUCK123_PRESET_EN bit */
+#define BUCK123_PRESET_EN		0x80
+
 /* PCA9450_BUCK1OUT_DVS0 bits */
 #define BUCK1OUT_DVS0_MASK		0x7F
 #define BUCK1OUT_DVS0_DEFAULT		0x14
-- 
2.30.1



