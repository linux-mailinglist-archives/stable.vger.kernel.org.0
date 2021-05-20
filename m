Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651D838A801
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbhETKp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237540AbhETKno (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0105161453;
        Thu, 20 May 2021 09:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504611;
        bh=pQZEfyZEKinmQBCrr9LaO4EAPD5z60u7vxCjGfHI8cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHFG7VdOIMC+0CmSKPr6eR5Rb74KGox/bbShvDWg5I/rVeqea+tJNyv0IrQZNpwmM
         uIJFsFuMwPo31VS5SYMgO1ALLk3kik8swHWQyk+wbz+EeD0V/ZP0h11s2ghd0xBoO4
         1VDq03la21aZcMFwD9PpuXGrzJnNZzAQcc7Q17Zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 315/323] gpiolib: acpi: Add quirk to ignore EC wakeups on Dell Venue 10 Pro 5055
Date:   Thu, 20 May 2021 11:23:27 +0200
Message-Id: <20210520092131.044905543@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ab5de5196080..c380ce957d8d 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1404,6 +1404,20 @@ static const struct dmi_system_id gpiolib_acpi_quirks[] = {
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



