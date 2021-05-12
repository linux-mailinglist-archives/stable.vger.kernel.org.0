Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E5B37D2D3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241388AbhELSOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236637AbhELSHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:07:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E88561480;
        Wed, 12 May 2021 18:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842681;
        bh=s92oYAD0pIycQPClhSAIO5z4FY7NVlq/UdH3F5J7FV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsaYpO0hD33Fc2BRR0lo5CM1Z3dmgtHYf23Ebsy9Xb2hWpxpdp/yJ5i3sbUaUqLwX
         9rUOcpNcHkJIh1q9mC6mb/1kxE7M/4uLLX2LY9T2JSJ2HiXbPiISrjzXAOyO8afC2o
         qs+BkDbu7YAPfuYlaeMBiZ1eF/d9zEp68XP1l51/pEH2b05fgWeLarC10yWF/x4I5J
         8hVS0UYzl5ZFshCKyvlWqWMWXuQzci0vLHQpmqwmdCr0CLD3XztcAn9ZQcd/fHUnAi
         84GJVF3GLk/JUOWSRx/GmTeEheqlbnemxXsG8iYs7qHFUrpnuXtYuIhpdmAmeONZfy
         TqI6hSU8jrA/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/23] gpiolib: acpi: Add quirk to ignore EC wakeups on Dell Venue 10 Pro 5055
Date:   Wed, 12 May 2021 14:04:03 -0400
Message-Id: <20210512180408.665338-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180408.665338-1-sashal@kernel.org>
References: <20210512180408.665338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit da91ece226729c76f60708efc275ebd4716ad089 ]

Like some other Bay and Cherry Trail SoC based devices the Dell Venue
10 Pro 5055 has an embedded-controller which uses ACPI GPIO events to
report events instead of using the standard ACPI EC interface for this.

The EC interrupt is only used to report battery-level changes and
it keeps doing this while the system is suspended, causing the system
to not stay suspended.

Add an ignore-wake quirk for the GPIO pin used by the EC to fix the
spurious wakeups from suspend.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 66dcab6ab26d..e3ddc99c105d 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1394,6 +1394,20 @@ static const struct dmi_system_id gpiolib_acpi_quirks[] = {
 			.no_edge_events_on_boot = true,
 		},
 	},
+	{
+		/*
+		 * The Dell Venue 10 Pro 5055, with Bay Trail SoC + TI PMIC uses an
+		 * external embedded-controller connected via I2C + an ACPI GPIO
+		 * event handler on INT33FFC:02 pin 12, causing spurious wakeups.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Venue 10 Pro 5055"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "INT33FC:02@12",
+		},
+	},
 	{
 		/*
 		 * HP X2 10 models with Cherry Trail SoC + TI PMIC use an
-- 
2.30.2

