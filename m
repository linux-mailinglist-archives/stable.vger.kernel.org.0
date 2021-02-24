Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DF5323DAF
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbhBXNOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235811AbhBXNHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3977F64F93;
        Wed, 24 Feb 2021 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171272;
        bh=o/agGiwWlfFWMMCKPvpiZpHx96+nMNwWOByCH78st50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbDgGennqnNnKJJ0QdkzmIvyFqDP78uZF334IFDL1JpuprBjGsZxkcT5nkYa8Gn8w
         f02uq9TFBNnrMZ/D0h9DF13uv/0uTKafQ2tJf71L/p4i8q6MfzRveRFae6qKVuL0dr
         J7d+PM537n6pNT+j2AOCQ5CkmASFFyCNz3K4LGv19MhWN89RSxctRPFghTP7/6jSRH
         tW967F8NSCWjwZbKtA/hW5u0ihtyXGnevGAaLzCrl0QOLcMo+jaRsWJH/tLUby8yZx
         FPQ3rKrVFYbR5N9QsrEdeb+ZKK/Y80b3W7xPAD2ZwnyPDAgWZOTp/C5Zzht7ePpJ21
         Eq4XEjJLOKYEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 39/40] ASoC: Intel: bytcr_rt5651: Add quirk for the Jumper EZpad 7 tablet
Date:   Wed, 24 Feb 2021 07:53:39 -0500
Message-Id: <20210224125340.483162-39-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit df8359c512fa770ffa6b0b0309807d9b9825a47f ]

Add a DMI quirk for the Jumper EZpad 7 tablet, this tablet has
a jack-detect switch which reads 1/high when a jack is inserted,
rather then using the standard active-low setup which most
jack-detect switches use. All other settings are using the defaults.

Add a DMI-quirk setting the defaults + the BYT_RT5651_JD_NOT_INV
flags for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210216213555.36555-4-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5651.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index 4606f6f582d6f..921c09cdb4800 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -435,6 +435,19 @@ static const struct dmi_system_id byt_rt5651_quirk_table[] = {
 					BYT_RT5651_SSP0_AIF1 |
 					BYT_RT5651_MONO_SPEAKER),
 	},
+	{
+		/* Jumper EZpad 7 */
+		.callback = byt_rt5651_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Jumper"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EZpad"),
+			/* Jumper12x.WJ2012.bsBKRCP05 with the version dropped */
+			DMI_MATCH(DMI_BIOS_VERSION, "Jumper12x.WJ2012.bsBKRCP"),
+		},
+		.driver_data = (void *)(BYT_RT5651_DEFAULT_QUIRKS |
+					BYT_RT5651_IN2_MAP |
+					BYT_RT5651_JD_NOT_INV),
+	},
 	{
 		/* KIANO SlimNote 14.2 */
 		.callback = byt_rt5651_quirk_cb,
-- 
2.27.0

