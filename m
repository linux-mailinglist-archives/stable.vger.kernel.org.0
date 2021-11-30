Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DC94637B0
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbhK3Oze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47724 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243054AbhK3Oxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD1DAB81A46;
        Tue, 30 Nov 2021 14:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5559C53FCF;
        Tue, 30 Nov 2021 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283828;
        bh=gaLHEZOmGrFT2whpn0ScRYWbeNzDqi8Z4Q8Px2n88DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOFC5uPQvQvgY4pCkxbuVz3nVqxmOmzDO0LVs0gboUAxziUqPkoavLxipY6vM6bPM
         ZTyh8ZgJUT75pvNw03LwgLVTwFaBxsYb1P5isr1wWWEmD5tPrsKhdlD3YU7XbKBryW
         icSZF8x/Xmqwl2sWQX8vOIkuQs8N1fXwwlRIvADBSkqT+YVldsoM18xgAY3QAU+pmR
         0a3FmmRQLUk4iUrqBmIb22Td2qRhi7qiZGbaY86UHaVc4KDS4k3LoiSH5b2Rag1P2Q
         4GNH5vb8boGQhBGCgEtxcDQGuMsvKAKVkBzCxq7ku09KxMjFPuOsQIMaqyKNSuZHBm
         a0KvDgaX1a8SA==
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
        libin.yang@intel.com, yong.zhi@intel.com,
        vamshi.krishna.gopal@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 02/43] ASoC: Intel: sof_sdw: Add support for SKU 0AF3 product
Date:   Tue, 30 Nov 2021 09:49:39 -0500
Message-Id: <20211130145022.945517-2-sashal@kernel.org>
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

[ Upstream commit 8f4fa45982b3f2daf5b3626ca0f12bde735f31ff ]

This product supports SoundWire capture from local microphones
and two SoundWire amplifiers(no headset codec).

Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211105022646.26305-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 25548555d8d79..05fe300b796c8 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -199,6 +199,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_PCH_DMIC),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0AF3"),
+		},
+		/* No Jack */
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_FOUR_SPK),
+	},
 	{}
 };
 
-- 
2.33.0

