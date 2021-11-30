Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAAE4637B2
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242499AbhK3Ozf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58256 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243064AbhK3Oxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4B4BCE1A63;
        Tue, 30 Nov 2021 14:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7ABC53FCD;
        Tue, 30 Nov 2021 14:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283832;
        bh=UF4YSgyj6cargNxm1BJt3Ur+WQOJZipD5pD1UdTv/+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VA6NpYjEuhnqLg+c76CKak8f2gVmZtRLTQeyqrTJv4Zho0ZxZ5+DXuQwnCRcZWTDF
         TLtVrfvIj5adCWWwDqVPQrYvmDOsAa7a6msHB7EXJyeyBJFNv1X71AATFjayvi6WAB
         TcEywdD0Yzu4ZyGt6GtX4OJGEiQE7X0LA10WdJOnRVVZ7f3IVdPjNkiVsnkzdZpLTH
         nYl649ZyKKAm/cTRN2f9UuxhvdZMmjkjKFv/hKOE52Fq0834x3DLDluFoyF6dyOukn
         KKKN0ZUaXbtvOVL9UdNYQvThx2+I1u+fxUFMnwW5NSHbL3+oR1ajbUBBvQ3ZgrdzmL
         UQxbXBWjqCtnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gongjun Song <gongjun.song@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yang.jie@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, kai.vehmanen@linux.intel.com,
        vamshi.krishna.gopal@intel.com, libin.yang@intel.com,
        yong.zhi@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 03/43] ASoC: Intel: sof_sdw: Add support for SKU 0B00 and 0B01 products
Date:   Tue, 30 Nov 2021 09:49:40 -0500
Message-Id: <20211130145022.945517-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gongjun Song <gongjun.song@intel.com>

[ Upstream commit cf304329e4afb97ffabce232eadaba94f025641d ]

Both products support a SoundWire headset codec, SoundWire
capture from local microphones and two SoundWire amplifiers.

Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211105022646.26305-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 05fe300b796c8..5738aff4937fc 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -209,6 +209,26 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B00")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2 |
+					SOF_SDW_FOUR_SPK),
+	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B01")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2 |
+					SOF_SDW_FOUR_SPK),
+	},
 	{}
 };
 
-- 
2.33.0

