Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF4A19B445
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733301AbgDAQVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732662AbgDAQVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:21:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E734215A4;
        Wed,  1 Apr 2020 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758103;
        bh=ZYO6Fm/OrSInh6/jkdhnmOJsKSV+pI6kV4FLqAAtDtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+3H8ZiFlgqjvijI1fCZmNjUQBOXBBRzeJiYDJQ3BSzuClp0TDcZxD/Xu34367mPn
         rn8VZWsslUpDwxcrvdUlxuRVNcHGKlLWv7x0X34EoyeFrO6LJUC67lfSLj+wXAtJSS
         qv7jNx/FumrfeExufpolMYNTVH2anP7xaAQhOffQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marc Lehmann <schmorp@schmorp.de>
Subject: [PATCH 5.4 13/27] gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 CHT + AXP288 model
Date:   Wed,  1 Apr 2020 18:17:41 +0200
Message-Id: <20200401161425.626948291@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
References: <20200401161414.352722470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 0c625ccfe6f754d0896b8881f5c85bcb81699f1f upstream.

There are at least 3 models of the HP x2 10 models:

Bay Trail SoC + AXP288 PMIC
Cherry Trail SoC + AXP288 PMIC
Cherry Trail SoC + TI PMIC

Like on the other HP x2 10 models we need to ignore wakeup for ACPI GPIO
events on the external embedded-controller pin to avoid spurious wakeups
on the HP x2 10 CHT + AXP288 model too.

This commit adds an extra DMI based quirk for the HP x2 10 CHT + AXP288
model, ignoring wakeups for ACPI GPIO events on the EC interrupt pin
on this model. This fixes spurious wakeups from suspend on this model.

Fixes: aa23ca3d98f7 ("gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism")
Reported-and-tested-by: Marc Lehmann <schmorp@schmorp.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200302111225.6641-4-hdegoede@redhat.com
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-acpi.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1430,6 +1430,21 @@ static const struct dmi_system_id gpioli
 			.ignore_wake = "INT33FC:02@28",
 		},
 	},
+	{
+		/*
+		 * HP X2 10 models with Cherry Trail SoC + AXP288 PMIC use an
+		 * external embedded-controller connected via I2C + an ACPI GPIO
+		 * event handler on INT33FF:01 pin 0, causing spurious wakeups.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
+			DMI_MATCH(DMI_BOARD_NAME, "813E"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "INT33FF:01@0",
+		},
+	},
 	{} /* Terminating entry */
 };
 


