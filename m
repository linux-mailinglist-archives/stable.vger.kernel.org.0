Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD422C9B26
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388172AbgLAJFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388807AbgLAJES (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:04:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E01921D7F;
        Tue,  1 Dec 2020 09:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813442;
        bh=5NNyRLEct+hm7THH7fiLLwe7wvo/lMM13bbW3N8HnHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZYRuKGrTdfEjE5v5rEiRBEMXaM7Tp0a6of5lT/d22U+WBm9DMGebY4f1x+sn7RHX
         uhckYiAutW+Hp6T+w8N52yQ0OXWlpRzQ3VyPJuR6Esbdmn0mmYFO3zTnpEr/pKGcux
         Zdl/BPdlD8yv3kDXdKENV/n5sYnuf1cWSTA2CZZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Ruslan Sushko <rus@sushko.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/98] net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset
Date:   Tue,  1 Dec 2020 09:53:18 +0100
Message-Id: <20201201084657.114842504@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit a3dcb3e7e70c72a68a79b30fc3a3adad5612731c ]

When the switch is hardware reset, it reads the contents of the
EEPROM. This can contain instructions for programming values into
registers and to perform waits between such programming. Reading the
EEPROM can take longer than the 100ms mv88e6xxx_hardware_reset() waits
after deasserting the reset GPIO. So poll the EEPROM done bit to
ensure it is complete.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ruslan Sushko <rus@sushko.dev>
Link: https://lore.kernel.org/r/20201116164301.977661-1-rus@sushko.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  2 ++
 drivers/net/dsa/mv88e6xxx/global1.c | 31 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  1 +
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 92e4d140df6fa..469b155df4885 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2143,6 +2143,8 @@ static void mv88e6xxx_hardware_reset(struct mv88e6xxx_chip *chip)
 		usleep_range(10000, 20000);
 		gpiod_set_value_cansleep(gpiod, 0);
 		usleep_range(10000, 20000);
+
+		mv88e6xxx_g1_wait_eeprom_done(chip);
 	}
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 8a903624fdd7c..938dd146629f1 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -75,6 +75,37 @@ static int mv88e6xxx_g1_wait_init_ready(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_STS, bit, 1);
 }
 
+void mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip)
+{
+	const unsigned long timeout = jiffies + 1 * HZ;
+	u16 val;
+	int err;
+
+	/* Wait up to 1 second for the switch to finish reading the
+	 * EEPROM.
+	 */
+	while (time_before(jiffies, timeout)) {
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_STS, &val);
+		if (err) {
+			dev_err(chip->dev, "Error reading status");
+			return;
+		}
+
+		/* If the switch is still resetting, it may not
+		 * respond on the bus, and so MDIO read returns
+		 * 0xffff. Differentiate between that, and waiting for
+		 * the EEPROM to be done by bit 0 being set.
+		 */
+		if (val != 0xffff &&
+		    val & BIT(MV88E6XXX_G1_STS_IRQ_EEPROM_DONE))
+			return;
+
+		usleep_range(1000, 2000);
+	}
+
+	dev_err(chip->dev, "Timeout waiting for EEPROM done");
+}
+
 /* Offset 0x01: Switch MAC Address Register Bytes 0 & 1
  * Offset 0x02: Switch MAC Address Register Bytes 2 & 3
  * Offset 0x03: Switch MAC Address Register Bytes 4 & 5
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 0ae96a1e919b6..08d66ef6aace6 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -277,6 +277,7 @@ int mv88e6xxx_g1_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr);
 int mv88e6185_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6352_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6250_g1_reset(struct mv88e6xxx_chip *chip);
+void mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip);
 
 int mv88e6185_g1_ppu_enable(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_ppu_disable(struct mv88e6xxx_chip *chip);
-- 
2.27.0



