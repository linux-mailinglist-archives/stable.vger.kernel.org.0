Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8C71197F4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbfLJVfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbfLJVfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC3B52465C;
        Tue, 10 Dec 2019 21:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013737;
        bh=63LUu6LyMFY3U2I+028HHw3AyRetmSe2Ru2XoijVS+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTYmBaHMxyvt8secSJR0/sEfKSwW+k3xN2v4Lsx34MtLxZrr9KOIXlB0npPzlb1wB
         R3E7GbRI+5N0czQ5+0V8iXPGVKiNKsca8h48hsTUiKmgXmBZUwr1vAQiF0uBi5sASH
         DxETa19pLAJa11k/UiXC32BjlJ8gqfgtjlgU72WQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 161/177] ASoC: Intel: bytcr_rt5640: Update quirk for Acer Switch 10 SW5-012 2-in-1
Date:   Tue, 10 Dec 2019 16:32:05 -0500
Message-Id: <20191210213221.11921-161-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0bb887709eb16bdc4b5baddd8337abf3de72917f ]

When the Acer Switch 10 SW5-012 quirk was added we did not have
jack-detection support yet; and the builtin microphone selection of
the original quirk is wrong too.

Fix the microphone-input quirk and add jack-detection info so that the
internal-microphone and headphone/set jack on the Switch 10 work properly.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191119145138.59162-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index b6dc524830b21..6acd5dd599dc4 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -414,10 +414,12 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire SW5-012"),
 		},
-		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
-						 BYT_RT5640_MCLK_EN |
-						 BYT_RT5640_SSP0_AIF1),
-
+		.driver_data = (void *)(BYT_RT5640_DMIC1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
 	},
 	{
 		.matches = {
-- 
2.20.1

