Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759F2323DDB
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbhBXNUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234546AbhBXNKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:10:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C9764FA3;
        Wed, 24 Feb 2021 12:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171306;
        bh=yQAgMDyITst9g0NyJRGTB4/GSgpl4NRKvwYNCcA0daU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HN5x+Xk6x/cf5hYFTQjaBxbztRlSwJfaLnhqVesRyXFjCZ1ObMrYj3qFTBnnj9aqU
         KFxBx//vKT+OZxag7fF8P5H/lS+Y65bu/f3YdlYgXP72853DeosDMaevxFwtoQQow2
         XxGTY1z2rDmhUcXENGrB2TmxkvJjPVdarwXQRXcYJl6CsGlGb9BAJrvNpPJYcGWYHA
         62meBoQ4CrmTKr3+Svl4DNIu3t1lcol82qX6jZbxPcFqplvPu2WtwLgLGIbdaTqm8o
         YYlbVYZLZVQ5nJ3KKkpw8BfEuhLTfe4icQlcfPRaYwc6X6KxLOS9LDVef3+iTkRdwf
         XrglrnnefZJmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 24/26] ASoC: Intel: bytcr_rt5640: Add quirk for the Estar Beauty HD MID 7316R tablet
Date:   Wed, 24 Feb 2021 07:54:32 -0500
Message-Id: <20210224125435.483539-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125435.483539-1-sashal@kernel.org>
References: <20210224125435.483539-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bdea43fc0436c9e98fdfe151c2ed8a3fc7277404 ]

The Estar Beauty HD MID 7316R tablet almost fully works with out default
settings. The only problem is that it has only 1 speaker so any sounds
only playing on the right channel get lost.

Add a quirk for this model using the default settings + MONO_SPEAKER.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210216213555.36555-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index ec630127ef2f3..4dd1941d4147f 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -510,6 +510,16 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_MONO_SPEAKER |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* Estar Beauty HD MID 7316R */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Estar"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "eSTAR BEAUTY HD Intel Quad core"),
+		},
+		.driver_data = (void *)(BYTCR_INPUT_DEFAULTS |
+					BYT_RT5640_MONO_SPEAKER |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-- 
2.27.0

