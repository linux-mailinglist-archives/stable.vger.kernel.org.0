Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610123C5558
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355596AbhGLIJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353548AbhGLICc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3837761CC7;
        Mon, 12 Jul 2021 07:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076533;
        bh=G8t99U+uzAYf/Sfi398Xo8OgCLovmaXK5Z4imgrLDRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMSMvz0f3UuYdM5SGicFNjCAmmcTCOOFVXhf3BNBSjT1HWmVKzM+JDStt8cEEXSmf
         gDnzFZaUW8EjNAAZziXi76tttTDbbv98HfkfHyc7fbXoZePDanu5dNf8ktmfu81NUw
         MJUjLC+gJJNiEak6/BLitXCeDEZQDW3p28HfFlrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 684/800] ASoC: max98373-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:47 +0200
Message-Id: <20210712061039.609220837@linuxfoundation.org>
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

[ Upstream commit bf881170311ea74ff30c3be0be8fb097132ce696 ]

The intent of the status check on resume was to verify if a SoundWire
peripheral reported ATTACHED before waiting for the initialization to
complete. This is required to avoid timeouts that will happen with
'ghost' devices that are exposed in the platform firmware but are not
populated in hardware.

Unfortunately we used 'hw_init' instead of 'first_hw_init'. Due to
another error, the resume operation never timed out, but the volume
settings were not properly restored.

This patch renames the status flag to 'first_hw_init' for consistency
with other drivers.

BugLink: https://github.com/thesofproject/linux/issues/2637
Fixes: 56a5b7910e96 ('ASoC: codecs: max98373: add SoundWire support')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98373-sdw.c | 12 ++++++------
 sound/soc/codecs/max98373.h     |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/max98373-sdw.c b/sound/soc/codecs/max98373-sdw.c
index c7a3506046db..dc520effc61c 100644
--- a/sound/soc/codecs/max98373-sdw.c
+++ b/sound/soc/codecs/max98373-sdw.c
@@ -271,7 +271,7 @@ static __maybe_unused int max98373_resume(struct device *dev)
 	struct max98373_priv *max98373 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!max98373->hw_init)
+	if (!max98373->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
@@ -362,7 +362,7 @@ static int max98373_io_init(struct sdw_slave *slave)
 	struct device *dev = &slave->dev;
 	struct max98373_priv *max98373 = dev_get_drvdata(dev);
 
-	if (max98373->pm_init_once) {
+	if (max98373->first_hw_init) {
 		regcache_cache_only(max98373->regmap, false);
 		regcache_cache_bypass(max98373->regmap, true);
 	}
@@ -370,7 +370,7 @@ static int max98373_io_init(struct sdw_slave *slave)
 	/*
 	 * PM runtime is only enabled when a Slave reports as Attached
 	 */
-	if (!max98373->pm_init_once) {
+	if (!max98373->first_hw_init) {
 		/* set autosuspend parameters */
 		pm_runtime_set_autosuspend_delay(dev, 3000);
 		pm_runtime_use_autosuspend(dev);
@@ -462,12 +462,12 @@ static int max98373_io_init(struct sdw_slave *slave)
 	regmap_write(max98373->regmap, MAX98373_R20B5_BDE_EN, 1);
 	regmap_write(max98373->regmap, MAX98373_R20E2_LIMITER_EN, 1);
 
-	if (max98373->pm_init_once) {
+	if (max98373->first_hw_init) {
 		regcache_cache_bypass(max98373->regmap, false);
 		regcache_mark_dirty(max98373->regmap);
 	}
 
-	max98373->pm_init_once = true;
+	max98373->first_hw_init = true;
 	max98373->hw_init = true;
 
 	pm_runtime_mark_last_busy(dev);
@@ -797,7 +797,7 @@ static int max98373_init(struct sdw_slave *slave, struct regmap *regmap)
 	max98373_slot_config(dev, max98373);
 
 	max98373->hw_init = false;
-	max98373->pm_init_once = false;
+	max98373->first_hw_init = false;
 
 	/* codec registration  */
 	ret = devm_snd_soc_register_component(dev, &soc_codec_dev_max98373_sdw,
diff --git a/sound/soc/codecs/max98373.h b/sound/soc/codecs/max98373.h
index 73a2cf69d84a..e1810b3b1620 100644
--- a/sound/soc/codecs/max98373.h
+++ b/sound/soc/codecs/max98373.h
@@ -226,7 +226,7 @@ struct max98373_priv {
 	/* variables to support soundwire */
 	struct sdw_slave *slave;
 	bool hw_init;
-	bool pm_init_once;
+	bool first_hw_init;
 	int slot;
 	unsigned int rx_mask;
 };
-- 
2.30.2



