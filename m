Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4366712B640
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfL0Rl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:41:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbfL0Rl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E814C22525;
        Fri, 27 Dec 2019 17:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468485;
        bh=dV7STmm2iBGY2r3YniMMJLM4k7yP3C9+1xPgxh8JTYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nPpgY4LToYKfyiQJtrkj4NMsg7EjUkXdGf1kzYkaytg83Ecqo6h6fRvqSwRfqzzd
         T46so2tpTbfSLSnWd1asVNLcGxmDjnUZtbbb/fF8dssG15QvMgxrcRgrMKuSh0BH9P
         jhkoaCfIMaAghTUtuUWXJYafB2LTQtZGTi49SHt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 023/187] ASoC: Intel: bytcr_rt5640: Update quirk for Teclast X89
Date:   Fri, 27 Dec 2019 12:38:11 -0500
Message-Id: <20191227174055.4923-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7eccc05c7101f34cc36afe9405d15de6d4099fb4 ]

When the Teclast X89 quirk was added we did not have jack-detection
support yet.

Note the over-current detection limit is set to 2mA instead of the usual
1.5mA because this tablet tends to give false-positive button-presses
when it is set to 1.5mA.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191203221442.2657-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 9c1aa4ec9cba..cb511ea3b771 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -705,13 +705,17 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_MCLK_EN),
 	},
 	{
+		/* Teclast X89 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "TECLAST"),
 			DMI_MATCH(DMI_BOARD_NAME, "tPAD"),
 		},
 		.driver_data = (void *)(BYT_RT5640_IN3_MAP |
-					BYT_RT5640_MCLK_EN |
-					BYT_RT5640_SSP0_AIF1),
+					BYT_RT5640_JD_SRC_JD1_IN4P |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_1P0 |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
 	},
 	{	/* Toshiba Satellite Click Mini L9W-B */
 		.matches = {
-- 
2.20.1

