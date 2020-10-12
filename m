Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E044928C132
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbgJLTCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbgJLTCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 15:02:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66B022074A;
        Mon, 12 Oct 2020 19:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529363;
        bh=cduUDZvkrYEAh12US1kRSYryGKCHMAi4nTVVdj3I2mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KX3+PFrfENxe8ymrDQKWmrloUtfFjPGegnfGcUycBliQ0FD5LShtI3fWRYJxyCw4O
         E87C+KmUhGF8lcFhSpwFKLuulvp9EWbbh9dCoDkMtiZLlG2WUCcOlGjqyM8szORuXS
         gG03HB1ULMflUyCsneBju15CBJDRvNoGwOjB6k4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 02/24] platform/x86: touchscreen_dmi: Add info for the MPMAN Converter9 2-in-1
Date:   Mon, 12 Oct 2020 15:02:17 -0400
Message-Id: <20201012190239.3279198-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit efe813d0b0e90a19102a36fd1d448a65dbf5d474 ]

Add touchscreen info for the MPMAN Converter9 2-in-1. This device uses the
same case as the ITworks TW891, but it uses a different digitizer, so it
needs its own firmware.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 5c223015ee71b..dda60f89c9512 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -373,6 +373,23 @@ static const struct ts_dmi_data jumper_ezpad_mini3_data = {
 	.properties	= jumper_ezpad_mini3_props,
 };
 
+static const struct property_entry mpman_converter9_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 8),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 8),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1664),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 880),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-mpman-converter9.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data mpman_converter9_data = {
+	.acpi_name	= "MSSL1680:00",
+	.properties	= mpman_converter9_props,
+};
+
 static const struct property_entry mpman_mpwin895cl_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-x", 3),
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 9),
@@ -976,6 +993,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "FlexBook edge11 - M-FBE11"),
 		},
 	},
+	{
+		/* MP Man Converter 9 */
+		.driver_data = (void *)&mpman_converter9_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MPMAN"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Converter9"),
+		},
+	},
 	{
 		/* MP Man MPWIN895CL */
 		.driver_data = (void *)&mpman_mpwin895cl_data,
-- 
2.25.1

