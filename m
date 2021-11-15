Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6973E450D8F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238793AbhKOR7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239215AbhKOR5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:57:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66F5263280;
        Mon, 15 Nov 2021 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997714;
        bh=jG2DudVcIDSjjviA/a57SjL7lMspYdTBXabl3uQCoJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZBPddnJcaya0bk0oOEmjpRt9fSxNAu0c35jgXIC4gi5yrJHm98/3rsYtzUzw0Bub
         bdAcs/e+rtEujRgLMvpl7X0XVXkHv/ywHSl4HW33Ac7cQ/gXKlLa/d94bY/2yIRqCU
         qCVA2GcftV89I0Qou/khiXSEfrquIy9SM3JZyAVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Schaeckeler <schaecsn@gmx.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/575] ACPI: AC: Quirk GK45 to skip reading _PSR
Date:   Mon, 15 Nov 2021 17:59:32 +0100
Message-Id: <20211115165352.296124159@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Schaeckeler <schaecsn@gmx.net>

[ Upstream commit 3d730ee686800d71ecc5c3cb8460dcdcdeaf38a3 ]

Let GK45 not go into BIOS for determining the AC power state.

The BIOS wrongly returns 0, so hardcode the power state to 1.

The mini PC GK45 by Besstar Tech Lld. (aka Kodlix) just runs
off AC. It does not include any batteries. Nevertheless BIOS
reports AC off:

root@kodlix:/usr/src/linux# cat /sys/class/power_supply/ADP1/online
0

root@kodlix:/usr/src/linux# modprobe acpi_dbg
root@kodlix:/usr/src/linux# tools/power/acpi/acpidbg

- find _PSR
   \_SB.PCI0.SBRG.H_EC.ADP1._PSR Method       000000009283cee8 001 Args 0 Len 001C Aml 00000000f54e5f67

- execute \_SB.PCI0.SBRG.H_EC.ADP1._PSR
Evaluating \_SB.PCI0.SBRG.H_EC.ADP1._PSR
Evaluation of \_SB.PCI0.SBRG.H_EC.ADP1._PSR returned object 00000000dc08c187, external buffer length 18
 [Integer] = 0000000000000000

that should be

 [Integer] = 0000000000000001

Signed-off-by: Stefan Schaeckeler <schaecsn@gmx.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ac.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 46a64e9fa7165..23ca1a1c67b75 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -64,6 +64,7 @@ static SIMPLE_DEV_PM_OPS(acpi_ac_pm, NULL, acpi_ac_resume);
 
 static int ac_sleep_before_get_state_ms;
 static int ac_check_pmic = 1;
+static int ac_only;
 
 static struct acpi_driver acpi_ac_driver = {
 	.name = "ac",
@@ -99,6 +100,11 @@ static int acpi_ac_get_state(struct acpi_ac *ac)
 	if (!ac)
 		return -EINVAL;
 
+	if (ac_only) {
+		ac->state = 1;
+		return 0;
+	}
+
 	status = acpi_evaluate_integer(ac->device->handle, "_PSR", NULL,
 				       &ac->state);
 	if (ACPI_FAILURE(status)) {
@@ -212,6 +218,12 @@ static int __init ac_do_not_check_pmic_quirk(const struct dmi_system_id *d)
 	return 0;
 }
 
+static int __init ac_only_quirk(const struct dmi_system_id *d)
+{
+	ac_only = 1;
+	return 0;
+}
+
 /* Please keep this list alphabetically sorted */
 static const struct dmi_system_id ac_dmi_table[]  __initconst = {
 	{
@@ -221,6 +233,13 @@ static const struct dmi_system_id ac_dmi_table[]  __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "EF20EA"),
 		},
 	},
+	{
+		/* Kodlix GK45 returning incorrect state */
+		.callback = ac_only_quirk,
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "GK45"),
+		},
+	},
 	{
 		/* Lenovo Ideapad Miix 320, AXP288 PMIC, separate fuel-gauge */
 		.callback = ac_do_not_check_pmic_quirk,
-- 
2.33.0



