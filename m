Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9811FE368
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgFRCJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730619AbgFRBV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:21:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042EB21974;
        Thu, 18 Jun 2020 01:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443316;
        bh=LLvcdmdZz68qpIfDhvDFOHGYsb4RNOmqre3wHAIdW0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK28iiREPl58wCk19xKjgFFrEb9AQcrQ72s4Ku8APTkqftDGVQaiWmvy6+bq0auFE
         jdU2Rtwo30FTn3Wvp7j146GDq/YaI7rJgpQQfSBEZO8XQgruJlkKxpAbo/hoA8qRbM
         F3zwJVOGILdHBqo2hv1/r/zujcpOtDkf2RtYUPXQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 252/266] ASoC: Intel: bytcr_rt5640: Add quirk for Toshiba Encore WT10-A tablet
Date:   Wed, 17 Jun 2020 21:16:17 -0400
Message-Id: <20200618011631.604574-252-sashal@kernel.org>
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

[ Upstream commit 199a5e8fda54ab3c8c6f6bf980c004e97ebf5ccb ]

The Toshiba Encore WT10-A tablet almost fully works with the default
settings for Bay Trail CR devices. The only issue is that it uses a
digital mic. connected the the DMIC1 input instead of an analog mic.

Add a quirk for this model using the default settings with the input-map
replaced with BYT_RT5640_DMIC1_MAP.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200608204634.93407-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index f222e1091bae..f7964d1ec486 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -754,6 +754,18 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_JD_NOT_INV |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* Toshiba Encore WT10-A */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "TOSHIBA WT10-A-103"),
+		},
+		.driver_data = (void *)(BYT_RT5640_DMIC1_MAP |
+					BYT_RT5640_JD_SRC_JD1_IN4P |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_SSP0_AIF2 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* Catch-all for generic Insyde tablets, must be last */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
-- 
2.25.1

