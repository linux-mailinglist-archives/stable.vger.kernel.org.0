Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6AC4520BD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239525AbhKPA4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343559AbhKOTVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1DF6632FE;
        Mon, 15 Nov 2021 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001734;
        bh=5Rlg9MeyloG2Lf6JHHtnmUerQqRX+FEwu5Ch3TjbGsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSSsz4FfzH28zEqL+q8ZIfDKjNJ899laBP8pjOKmFaqf5jL6wnXi6fmY1GhNUTV2w
         Fh7Xp3eQaQStK/QP6HsktSEZtCFbLb1x0oQBrv8CF09bL9DZHu9U51E4xExYLz01Ww
         rt3Oq6no1EatmtzglZelvI39EKnU9pggRjhQjCRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Schaeckeler <schaecsn@gmx.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/917] ACPI: AC: Quirk GK45 to skip reading _PSR
Date:   Mon, 15 Nov 2021 17:56:34 +0100
Message-Id: <20211115165438.896741497@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index b0cb662233f1a..81aff651a0d49 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -61,6 +61,7 @@ static SIMPLE_DEV_PM_OPS(acpi_ac_pm, NULL, acpi_ac_resume);
 
 static int ac_sleep_before_get_state_ms;
 static int ac_check_pmic = 1;
+static int ac_only;
 
 static struct acpi_driver acpi_ac_driver = {
 	.name = "ac",
@@ -93,6 +94,11 @@ static int acpi_ac_get_state(struct acpi_ac *ac)
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
@@ -200,6 +206,12 @@ static int __init ac_do_not_check_pmic_quirk(const struct dmi_system_id *d)
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
@@ -209,6 +221,13 @@ static const struct dmi_system_id ac_dmi_table[]  __initconst = {
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



