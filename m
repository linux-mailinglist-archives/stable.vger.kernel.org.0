Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5DF374077
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhEEQe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234227AbhEEQdc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:33:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC3666140F;
        Wed,  5 May 2021 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232342;
        bh=mKkjTfBgYYQuYW9XJMVZqW5OfGH+RE/LXevOvmxnd4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyBBi1haV51XL2nuwE0fw2osfqjWgzXVVE5KmMu/SnvY8J9d3XZbWl+e6wlSCBSgC
         njI+ty/WD0LUt4mr3SKHPSoGUCNVs6Y/8hNnFnKdycwBIF77s+WrIBW+OjVZbGMuOu
         HBP/nqYX+wA8VPSc0pO7USaTbpviVofcccBOdG5txcRTWXt6sBmYMIeoX1gsKiZfZ5
         MW+6pCb1FQ2Omc3zc8T812RO+nPo4gZKj8zwXFyfUU6eAS8i0CG8+Bp1ZbGFcRIgx5
         c1yyO227EPOcEPkTFwy6pXJgo85lQUQLLc6RUB6H0EdxNFgh07ffG8vdsB98dNDnd6
         0PsS3PB20aV/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 042/116] ASoC: rt5670: Add a quirk for the Dell Venue 10 Pro 5055
Date:   Wed,  5 May 2021 12:30:10 -0400
Message-Id: <20210505163125.3460440-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 84cb0d5581b6a7bd5d96013f67e9f2eb0c7b4378 ]

Add a quirk with the jack-detect and dmic settings necessary to make
jack-detect and the builtin mic work on Dell Venue 10 Pro 5055 tablets.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210402140747.174716-5-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5670.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/rt5670.c b/sound/soc/codecs/rt5670.c
index 4063aac2a443..dd69d874bad2 100644
--- a/sound/soc/codecs/rt5670.c
+++ b/sound/soc/codecs/rt5670.c
@@ -2980,6 +2980,18 @@ static const struct dmi_system_id dmi_platform_intel_quirks[] = {
 						 RT5670_GPIO1_IS_IRQ |
 						 RT5670_JD_MODE3),
 	},
+	{
+		.callback = rt5670_quirk_cb,
+		.ident = "Dell Venue 10 Pro 5055",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Venue 10 Pro 5055"),
+		},
+		.driver_data = (unsigned long *)(RT5670_DMIC_EN |
+						 RT5670_DMIC2_INR |
+						 RT5670_GPIO1_IS_IRQ |
+						 RT5670_JD_MODE1),
+	},
 	{
 		.callback = rt5670_quirk_cb,
 		.ident = "Aegex 10 tablet (RU2)",
-- 
2.30.2

