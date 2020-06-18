Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5536D1FE363
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgFRCIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729504AbgFRBV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:21:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A567221E8;
        Thu, 18 Jun 2020 01:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443318;
        bh=duojId18IbF5BHNz422QircXBW0ydcvP9t1TbK7s1W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzxio1GHQDQRsb++UGwybWLNUF2/mD8ONMmtsd5Oa3P1pA6jiSQBgv2fNl3AiA3ic
         jUQLvtgwUX7C64Mr9te2Bq4Ya5VMsc4eLGnZhvg/r1ZyrIbwfV69OhGScntEwxzLgL
         ZUWBCpPfeqrY95/LuMlqMKBYZyu+tbuXqdJ+LXjg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 253/266] ASoC: rt5645: Add platform-data for Asus T101HA
Date:   Wed, 17 Jun 2020 21:16:18 -0400
Message-Id: <20200618011631.604574-253-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 79d4f823a06796656289f97b922493da5690e46c ]

The Asus T101HA uses the default jack-detect mode 3, but instead of
using an analog microphone it is using a DMIC on dmic-data-pin 1,
like the Asus T100HA. Note unlike the T100HA its jack-detect is not
inverted.

Add a DMI quirk with the correct settings for this model.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200608204634.93407-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 19662ee330d6..c83f7f5da96b 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3625,6 +3625,12 @@ static const struct rt5645_platform_data asus_t100ha_platform_data = {
 	.inv_jd1_1 = true,
 };
 
+static const struct rt5645_platform_data asus_t101ha_platform_data = {
+	.dmic1_data_pin = RT5645_DMIC_DATA_IN2N,
+	.dmic2_data_pin = RT5645_DMIC2_DISABLE,
+	.jd_mode = 3,
+};
+
 static const struct rt5645_platform_data lenovo_ideapad_miix_310_pdata = {
 	.jd_mode = 3,
 	.in2_diff = true,
@@ -3702,6 +3708,14 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&asus_t100ha_platform_data,
 	},
+	{
+		.ident = "ASUS T101HA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T101HA"),
+		},
+		.driver_data = (void *)&asus_t101ha_platform_data,
+	},
 	{
 		.ident = "MINIX Z83-4",
 		.matches = {
-- 
2.25.1

