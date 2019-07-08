Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01255623D5
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbfGHPbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732189AbfGHPbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:31:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C6DB21707;
        Mon,  8 Jul 2019 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599869;
        bh=wkFPMCnEbNe5WVo0k2tyO9Ryx+myHPq/TVf8+9JKxpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wco/olYiMht774yTRRjnmCzB5PYWolnIDyLWCPK1obJiiDrXVgPP5P5Lh/r31xCqf
         Ay+J0MAw7fvQr7uKKYBqSlOUYioC1WKbWl9urig7EzUJz9gILf7hE0g5Y3lLw1boJq
         FEJlMQ7Qb4T2ZRPNpEeOb77ccNh5rjUWXaWCa4kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Kov=C3=A1cs=20Tam=C3=A1s?= <kepszlok@zohomail.eu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 17/96] ASoC: Intel: Baytrail: add quirk for Aegex 10 (RU2) tablet
Date:   Mon,  8 Jul 2019 17:12:49 +0200
Message-Id: <20190708150527.350638787@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



