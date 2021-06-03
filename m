Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C854739A73B
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhFCRKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231959AbhFCRKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB1661408;
        Thu,  3 Jun 2021 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740121;
        bh=wyvcZVyrAKg3Of51qDYBDz11+OhTLNFlo+cyg6Ji2xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3FjtRlq4gzm5zaZC2DwMSuRwA0VTtYLVxzfd57E/SfZ7T8ghjuwg5aoU/31doCD4
         I7NLM/M94e3h8/W6sU8/fWGJHEpUPWAcozC14InK5fa6MmgKwCg4O6hcmQLMFvLVjY
         3ej+TVDH4HffSAfl4B3jQg7t3PJ2d26FQhbzaBU/3dSJ3YvRuxVOqhE5T+zl8GtyYO
         /MzwFxlYVilxtBdlmo2RPtyqZAHYMxydl9MZJZ0tELABiZ1kbDtt2qg5bxcy73ahi7
         IpO6t0AupFYuepFnPkuFPosmOllqpXyKOsdZOAGE3FnxH4XiaGb25CEAx6FSkzg/+M
         opztSwX0urpFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 09/39] ASoC: Intel: bytcr_rt5640: Add quirk for the Lenovo Miix 3-830 tablet
Date:   Thu,  3 Jun 2021 13:07:59 -0400
Message-Id: <20210603170829.3168708-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f0353e1f53f92f7b3da91e6669f5d58ee222ebe8 ]

The Lenovo Miix 3-830 tablet has only 1 speaker, has an internal analog
mic on IN1 and uses JD2 for jack-detect, add a quirk to automatically
apply these settings on Lenovo Miix 3-830 tablets.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210508150146.28403-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index d5c905b00685..ca14730232ba 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -659,6 +659,20 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_MONO_SPEAKER |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* Lenovo Miix 3-830 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo MIIX 3-830"),
+		},
+		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_MONO_SPEAKER |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* Linx Linx7 tablet */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LINX"),
-- 
2.30.2

