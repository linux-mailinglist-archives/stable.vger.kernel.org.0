Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C11B341CAC
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhCSMWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231401AbhCSMVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D008B64F72;
        Fri, 19 Mar 2021 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156504;
        bh=VXkTG6rOTkWlJ9hdLPjJeSzlcFrA8+DVDxsQY5T/Fys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1ZXCJizfgcyw9E5L/HB2BnK78vq/76bF+KbCG42jPO/h73wUzFXdPcrKIYnmVArR
         zVotDY85VACRHJQjSMQApT/AoxnBf9OS45icoKL1KzBz/rI6R5a19aFP90+vxBUDHn
         JkGdpQ1fP1BYLM4m/LrGflB72NxxypY10NCXByZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 15/31] regulator: pca9450: Enable system reset on WDOG_B assertion
Date:   Fri, 19 Mar 2021 13:19:09 +0100
Message-Id: <20210319121747.691843661@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit f7684f5a048febd2a7bc98ee81d6dce52f7268b8 ]

By default the PCA9450 doesn't handle the assertion of the WDOG_B
signal, but this is required to guarantee that things like software
resets triggered by the watchdog work reliably.

As we don't want to rely on the bootloader to enable this, we tell
the PMIC to issue a cold reset in case the WDOG_B signal is
asserted (WDOG_B_CFG = 10), just as the NXP U-Boot code does.

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20210211105534.38972-3-frieder.schrempf@kontron.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 8 ++++++++
 include/linux/regulator/pca9450.h     | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 1bba8fdcb7b7..833d398c6aa2 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -797,6 +797,14 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	/* Set reset behavior on assertion of WDOG_B signal */
+	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_RESET_CTRL,
+				WDOG_B_CFG_MASK, WDOG_B_CFG_COLD_LDO12);
+	if (ret) {
+		dev_err(&i2c->dev, "Failed to set WDOG_B reset behavior\n");
+		return ret;
+	}
+
 	/*
 	 * The driver uses the LDO5CTRL_H register to control the LDO5 regulator.
 	 * This is only valid if the SD_VSEL input of the PMIC is high. Let's
diff --git a/include/linux/regulator/pca9450.h b/include/linux/regulator/pca9450.h
index 1bbd3014f906..ccdb5320a240 100644
--- a/include/linux/regulator/pca9450.h
+++ b/include/linux/regulator/pca9450.h
@@ -216,4 +216,11 @@ enum {
 #define IRQ_THERM_105			0x02
 #define IRQ_THERM_125			0x01
 
+/* PCA9450_REG_RESET_CTRL bits */
+#define WDOG_B_CFG_MASK			0xC0
+#define WDOG_B_CFG_NONE			0x00
+#define WDOG_B_CFG_WARM			0x40
+#define WDOG_B_CFG_COLD_LDO12		0x80
+#define WDOG_B_CFG_COLD			0xC0
+
 #endif /* __LINUX_REG_PCA9450_H__ */
-- 
2.30.1



