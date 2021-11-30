Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A02E4637C3
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242706AbhK3Ozz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58330 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243087AbhK3OyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:54:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8DD1ACE1A65;
        Tue, 30 Nov 2021 14:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB1BC53FD3;
        Tue, 30 Nov 2021 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283838;
        bh=fyEvy9kwtzdKYhjm1Uj8axEeKB4Dex6IpQa9k4RQyPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GluosqRNMlgODbPL6Mzp31231DNFGOMe9J1kdiP4c9tuFUs3yCh50OxEboggirl12
         dujQ+YErJUsshZ4R+nAWeHnQD2nqK3p88hZT/J4KvG8KzETxwWN9hQ2g6ZmQzCGFfb
         fWMpJcMfBOyOVdtJ9m1Io9DvhiY9qbwXwcFMvlQDymKaV30WKMFu7X42RZ20DAHuiA
         YuhdJHOiSyU8SzUknFMc7aa9P0TfV05njwfmMAeTFqmSRiVk3btLWUh2OnRK0bcSOK
         3wrjnd3ecW1rS9C+rOKadP0mJphyr2m0MtrMYmBFx5y3bbyQaHW0R30hEWXLCRnwx6
         Ovw6b7NEpxBgA==
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
        vamshi.krishna.gopal@intel.com, yong.zhi@intel.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 05/43] ASoC: Intel: sof_sdw: Add support for SKU 0B13 product
Date:   Tue, 30 Nov 2021 09:49:42 -0500
Message-Id: <20211130145022.945517-5-sashal@kernel.org>
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

[ Upstream commit 6448d0596e48dbc16a910f04ffc248c3f3c0a65c ]

This product supports SoundWire capture from local microphones
and one SoundWire amplifier(no headset codec).

Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211105022646.26305-6-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index c7a6a4d6570cf..f141b38ed71d6 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -239,6 +239,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					RT711_JD2 |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B13"),
+		},
+		/* No Jack */
+		.driver_data = (void *)SOF_SDW_TGL_HDMI,
+	},
 	{}
 };
 
-- 
2.33.0

