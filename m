Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F3A2C9D13
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389767AbgLAJSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:18:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389766AbgLAJKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E466F206CA;
        Tue,  1 Dec 2020 09:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813814;
        bh=vZSdMDn5q06dOoAvo7hfQwx/Fw6elYtbudxJ3O+GkiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZyUlPnhZnyxGCYSN0Akl5ro89P77TmIbKF/zK5oW/B7oJnbdF3evISueq3tn2Kmf
         R6Rz7WRw4j0auQUnNgNjGADVMdqvx/+8P3IuoRPlLKKSHgmZZmPmeZkSjO5bi2shC8
         1xlKqSmLcaZ/u9YClKRFTMhIhORNdHdAS7hM14pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Ruslan Sushko <rus@sushko.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 068/152] net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset
Date:   Tue,  1 Dec 2020 09:53:03 +0100
Message-Id: <20201201084720.838696091@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
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
index f0dbc05e30a4d..16040b13579ef 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2299,6 +2299,8 @@ static void mv88e6xxx_hardware_reset(struct mv88e6xxx_chip *chip)
 		usleep_range(10000, 20000);
 		gpiod_set_value_cansleep(gpiod, 0);
 		usleep_range(10000, 20000);
+
+		mv88e6xxx_g1_wait_eeprom_done(chip);
 	}
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index f62aa83ca08d4..33d443a37efc4 100644
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
index 1e3546f8b0727..e05abe61fa114 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -278,6 +278,7 @@ int mv88e6xxx_g1_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr);
 int mv88e6185_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6352_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6250_g1_reset(struct mv88e6xxx_chip *chip);
+void mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip);
 
 int mv88e6185_g1_ppu_enable(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_ppu_disable(struct mv88e6xxx_chip *chip);
-- 
2.27.0



