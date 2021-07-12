Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65ECE3C5560
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355626AbhGLIKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353571AbhGLICf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC8CD61CB4;
        Mon, 12 Jul 2021 07:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076552;
        bh=Crni5yoyfhjj9GN7eLxg0dsrWvQHa/qqDSfZO8IvLls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRDGt1L2tEj5oeMLHySF7U/kRlsKSmIJhq1KF+WrVJtSw1j0NTfQyA3gIeCSRnv/5
         5CK7M3i3yBsEYSACuekdUFM1bFEbM48diVkEO1JNVdXWs10Vhl0Rt5NvhhT+co7FR8
         5Kxb+QdEUHyoJfLz5BwdjASiCiTlBzJLUjT8BAj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 691/800] ASoC: rt715-sdca-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:54 +0200
Message-Id: <20210712061040.343289886@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit d34d0897a753f42c8a7a6af3866781dd57344a45 ]

The intent of the status check on resume was to verify if a SoundWire
peripheral reported ATTACHED before waiting for the initialization to
complete. This is required to avoid timeouts that will happen with
'ghost' devices that are exposed in the platform firmware but are not
populated in hardware.

Unfortunately we used 'hw_init' instead of 'first_hw_init'. Due to
another error, the resume operation never timed out, but the volume
settings were not properly restored.

This patch renames the status flag to 'first_hw_init' for consistency
with other drivers (was 'first_init')

BugLink: https://github.com/thesofproject/linux/issues/2908
BugLink: https://github.com/thesofproject/linux/issues/2637
Fixes: 20d17057f0a8c ('ASoC: rt715-sdca: Add RT715 sdca vendor-specific driver')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-10-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt715-sdca-sdw.c | 2 +-
 sound/soc/codecs/rt715-sdca.c     | 6 +++---
 sound/soc/codecs/rt715-sdca.h     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/rt715-sdca-sdw.c b/sound/soc/codecs/rt715-sdca-sdw.c
index 1350798406f0..7646bbe739f1 100644
--- a/sound/soc/codecs/rt715-sdca-sdw.c
+++ b/sound/soc/codecs/rt715-sdca-sdw.c
@@ -224,7 +224,7 @@ static int __maybe_unused rt715_dev_resume(struct device *dev)
 	struct rt715_sdca_priv *rt715 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!rt715->hw_init)
+	if (!rt715->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
diff --git a/sound/soc/codecs/rt715-sdca.c b/sound/soc/codecs/rt715-sdca.c
index 7db76c19e048..d82166f1a378 100644
--- a/sound/soc/codecs/rt715-sdca.c
+++ b/sound/soc/codecs/rt715-sdca.c
@@ -997,7 +997,7 @@ int rt715_sdca_init(struct device *dev, struct regmap *mbq_regmap,
 	 * HW init will be performed when device reports present
 	 */
 	rt715->hw_init = false;
-	rt715->first_init = false;
+	rt715->first_hw_init = false;
 
 	ret = devm_snd_soc_register_component(dev,
 			&soc_codec_dev_rt715_sdca,
@@ -1018,7 +1018,7 @@ int rt715_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 	/*
 	 * PM runtime is only enabled when a Slave reports as Attached
 	 */
-	if (!rt715->first_init) {
+	if (!rt715->first_hw_init) {
 		/* set autosuspend parameters */
 		pm_runtime_set_autosuspend_delay(&slave->dev, 3000);
 		pm_runtime_use_autosuspend(&slave->dev);
@@ -1031,7 +1031,7 @@ int rt715_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 
 		pm_runtime_enable(&slave->dev);
 
-		rt715->first_init = true;
+		rt715->first_hw_init = true;
 	}
 
 	pm_runtime_get_noresume(&slave->dev);
diff --git a/sound/soc/codecs/rt715-sdca.h b/sound/soc/codecs/rt715-sdca.h
index 85ce4d95e5eb..0c1fdd5bc7ca 100644
--- a/sound/soc/codecs/rt715-sdca.h
+++ b/sound/soc/codecs/rt715-sdca.h
@@ -27,7 +27,7 @@ struct rt715_sdca_priv {
 	enum sdw_slave_status status;
 	struct sdw_bus_params params;
 	bool hw_init;
-	bool first_init;
+	bool first_hw_init;
 	int l_is_unmute;
 	int r_is_unmute;
 	int hw_sdw_ver;
-- 
2.30.2



