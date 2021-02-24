Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49808323D07
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbhBXNBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235145AbhBXM5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 526B064F2B;
        Wed, 24 Feb 2021 12:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171115;
        bh=UA1cjq6Hc+i424PI2eCmjxgxpKlOqgX3H3ZG8GRjsp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXZp0ZSyRBkBjyNTsuqE9maXT9jvoJ0FQBLURh3JSXK13nTWVXw7Pbz3f3w7mnUJI
         2nHNK6ugnx9sYUanzX/8LN1GVt13fWrcl8MrfaxZziZy+AD9gGj9XxHORSqmMwOPbR
         30z2upDlrEF0ztTY1ZICv9oK/XQcA37zWkpEHzZqDaCb9gD3Am5qGoa5WMY6MMqBIo
         pHGh3eNE8XS3TEQFcf54cf9t2peb5VnlX+eA+VmTj2AQOphWVLu1y1XF2EyW0wopXr
         2FKN1ivwitoPkj+6aLdeYsVCVJASVnzV/C6w05sdIV/e3fnYvMNfannyYCzHsLZFRJ
         hYRp7a4Ew0i3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 66/67] ASoC: Intel: bytcr_rt5651: Add quirk for the Jumper EZpad 7 tablet
Date:   Wed, 24 Feb 2021 07:50:24 -0500
Message-Id: <20210224125026.481804-66-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index f289ec8563a11..148b7b1bd3e8c 100644
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

