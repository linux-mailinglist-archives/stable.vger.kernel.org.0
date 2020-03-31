Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C39319916B
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731537AbgCaJSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730031AbgCaJSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:18:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09A322072E;
        Tue, 31 Mar 2020 09:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646301;
        bh=XhM8fbEbcelh1MZoQlcLIaHd/4GVI1N06+N/RH0R/VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sv5XwZthozphCMju4VXeupv4G43bBJbZFE/GAKZQj8zyyWEnF5tbVn+mKLrQmnLDF
         Oq9a3dNhDel9vF5BhTjcoUQxvMPx2RGcjOjVr1ztvPK7QgKq8zxsR831OczmOnfRab
         eYCiBA/HhJWxeVrVmcdt/VjM1N/TXAAH98u56Y0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 106/155] gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 BYT + AXP288 model
Date:   Tue, 31 Mar 2020 10:59:06 +0200
Message-Id: <20200331085430.555211375@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 0e91506ba00730f088961a8d39f8693b0f8e3fea upstream.

Commit aa23ca3d98f7 ("gpiolib: acpi: Add honor_wakeup module-option +
quirk mechanism") was added to deal with spurious wakeups on one specific
model of the HP x2 10 series. In the mean time I have learned that there
are at least 3 different HP x2 10 models:

Bay Trail SoC + AXP288 PMIC
Cherry Trail SoC + AXP288 PMIC
Cherry Trail SoC + TI PMIC

And the original quirk is only correct for (and only matches the)
Cherry Trail SoC + TI PMIC model.

The Bay Trail SoC + AXP288 PMIC model has different DMI strings, has
the external EC interrupt on a different GPIO pin and only needs to ignore
wakeups on the EC interrupt, the INT0002 device works fine on this model.

This commit adds an extra DMI based quirk for the HP x2 10 BYT + AXP288
model, ignoring wakeups for ACPI GPIO events on the EC interrupt pin
on this model. This fixes spurious wakeups from suspend on this model.

Fixes: aa23ca3d98f7 ("gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200302111225.6641-3-hdegoede@redhat.com
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-acpi.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1415,6 +1415,21 @@ static const struct dmi_system_id gpioli
 			.ignore_wake = "INT33FF:01@0,INT0002:00@2",
 		},
 	},
+	{
+		/*
+		 * HP X2 10 models with Bay Trail SoC + AXP288 PMIC use an
+		 * external embedded-controller connected via I2C + an ACPI GPIO
+		 * event handler on INT33FC:02 pin 28, causing spurious wakeups.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
+			DMI_MATCH(DMI_BOARD_NAME, "815D"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "INT33FC:02@28",
+		},
+	},
 	{} /* Terminating entry */
 };
 


