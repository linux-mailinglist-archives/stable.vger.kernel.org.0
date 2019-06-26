Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EEF55FBD
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfFZDls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfFZDlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:41:47 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CEFE216C8;
        Wed, 26 Jun 2019 03:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520507;
        bh=SvGAx1+3wj2XrlWakZ5zNMq4zBzwzZZkLa1wSb4gGg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHv2Cm4ZZxTrNe2uQVZHcqJG0xHKsjWmjCSRxSTQSB1V3jJIqB8av2oyVa0inTgau
         1kbr7uHzAihZz/KE0X/WoKwQFRVAvivC/5VNFZNvq+qqrKhKXAVL5rPoXfIhVVvoBc
         3FsEI0vw9gKv6jCSgG3AfCNFApKSNyC3uEnOsyuk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Kov=C3=A1cs=20Tam=C3=A1s?= <kepszlok@zohomail.eu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 13/51] ASoC: Intel: Baytrail: add quirk for Aegex 10 (RU2) tablet
Date:   Tue, 25 Jun 2019 23:40:29 -0400
Message-Id: <20190626034117.23247-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kovács Tamás <kepszlok@zohomail.eu>

[ Upstream commit 3e951e7914408aee196db77a5cb377801c85692a ]

This tablet has an incorrect acpi identifier just like
Thinkpad10 tablet, which is why it is trying to load the RT5640 driver
instead of the RT5762 driver. The RT5640 driver, on the other hand, checks
the hardware ID, so no driver are loaded during boot. This fix resolves to
load the RT5672 driver on this tablet during boot. It also provides the
correct IO configuration, like the jack detect mode 3, for 1.8V pullup. I
would like to thank Pierre-Louis Bossart for helping with this patch.

Signed-off-by: Kovács Tamás <kepszlok@zohomail.eu>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5670.c                       | 12 ++++++++++++
 .../soc/intel/common/soc-acpi-intel-byt-match.c | 17 +++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/sound/soc/codecs/rt5670.c b/sound/soc/codecs/rt5670.c
index 9a037108b1ae..a746e11ccfe3 100644
--- a/sound/soc/codecs/rt5670.c
+++ b/sound/soc/codecs/rt5670.c
@@ -2882,6 +2882,18 @@ static const struct dmi_system_id dmi_platform_intel_quirks[] = {
 						 RT5670_DEV_GPIO |
 						 RT5670_JD_MODE3),
 	},
+	{
+		.callback = rt5670_quirk_cb,
+		.ident = "Aegex 10 tablet (RU2)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "AEGEX"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "RU2"),
+		},
+		.driver_data = (unsigned long *)(RT5670_DMIC_EN |
+						 RT5670_DMIC2_INR |
+						 RT5670_DEV_GPIO |
+						 RT5670_JD_MODE3),
+	},
 	{}
 };
 
diff --git a/sound/soc/intel/common/soc-acpi-intel-byt-match.c b/sound/soc/intel/common/soc-acpi-intel-byt-match.c
index fe812a909db4..3a37f4eca437 100644
--- a/sound/soc/intel/common/soc-acpi-intel-byt-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-byt-match.c
@@ -22,6 +22,7 @@ static unsigned long byt_machine_id;
 
 #define BYT_THINKPAD_10  1
 #define BYT_POV_P1006W   2
+#define BYT_AEGEX_10     3
 
 static int byt_thinkpad10_quirk_cb(const struct dmi_system_id *id)
 {
@@ -35,6 +36,12 @@ static int byt_pov_p1006w_quirk_cb(const struct dmi_system_id *id)
 	return 1;
 }
 
+static int byt_aegex10_quirk_cb(const struct dmi_system_id *id)
+{
+	byt_machine_id = BYT_AEGEX_10;
+	return 1;
+}
+
 static const struct dmi_system_id byt_table[] = {
 	{
 		.callback = byt_thinkpad10_quirk_cb,
@@ -75,9 +82,18 @@ static const struct dmi_system_id byt_table[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "0E57"),
 		},
 	},
+	{
+		/* Aegex 10 tablet (RU2) */
+		.callback = byt_aegex10_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "AEGEX"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "RU2"),
+		},
+	},
 	{ }
 };
 
+/* The Thinkapd 10 and Aegex 10 tablets have the same ID problem */
 static struct snd_soc_acpi_mach byt_thinkpad_10 = {
 	.id = "10EC5640",
 	.drv_name = "cht-bsw-rt5672",
@@ -104,6 +120,7 @@ static struct snd_soc_acpi_mach *byt_quirk(void *arg)
 
 	switch (byt_machine_id) {
 	case BYT_THINKPAD_10:
+	case BYT_AEGEX_10:
 		return &byt_thinkpad_10;
 	case BYT_POV_P1006W:
 		return &byt_pov_p1006w;
-- 
2.20.1

