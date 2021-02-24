Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75218323D74
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbhBXNLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235439AbhBXNCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:02:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0758064F62;
        Wed, 24 Feb 2021 12:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171206;
        bh=bS1ca47Xff6ruCUQ5UDq+dE6bxOTHi4o/rL821qdKUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7lLroU3RjL6/Y5QrErYWKEXQwpNVGTBN91ZG2ax09Iu8Z6RcTLHZHPvRp5N9cl45
         e+4I77BkAGPI1XkPwC1F4mjc9yU3/reerUL0qcg7ih/RwuhK8QdSmEB8OEmgi5mSd7
         N/vn0R+BIQgxYE6R2T/jJB1qIWQV+XLyRSmsxTZjv/FKC7sNykJktGn2Fq2nf1Y8LA
         v4kcgzHah6FpU5BsLvgYIeGOPRcYqYKeS8gtz0MvKUwob5rGy2VfYMrECpzwljrMzW
         b+QXmY8g19Rg1HqXTlebxbe9Wb+ydyv3BuTCESVXcYPHUbIurf2m2YbmmBkpY71HQ6
         VLzuDP6L3c4pA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 56/56] ASoC: Intel: bytcr_rt5640: Add quirk for the Acer One S1002 tablet
Date:   Wed, 24 Feb 2021 07:52:12 -0500
Message-Id: <20210224125212.482485-56-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c58947af08aedbdee0fce5ea6e6bf3e488ae0e2c ]

The Acer One S1002 tablet is using an analog mic on IN1 and has
its jack-detect connected to JD2_IN4N, instead of using the default
IN3 for its internal mic and JD1_IN4P for jack-detect.

Note it is also using AIF2 instead of AIF1 which is somewhat unusual,
this is correctly advertised in the ACPI CHAN package, so the speakers
do work without the quirk.

Add a quirk for the mic and jack-detect settings.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210216213555.36555-5-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 626677fa1b5c0..3af4cb87032ce 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -402,6 +402,19 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* Acer One 10 S1002 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "One S1002"),
+		},
+		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF2 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-- 
2.27.0

