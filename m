Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1143C4AD6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240813AbhGLGx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239999AbhGLGub (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:50:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4CBE61004;
        Mon, 12 Jul 2021 06:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072450;
        bh=N5mFeFyMJpJ+eKX7OHhYIsAVDJ8n3oc4CFCForiEMeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKJMuvtUQUuewLr694/kVn7cMo0gKEn1koPghUEPaB7C+VuRKRz9mswGIT1nnKbic
         cjWpwZzGSZ7BC0wOzFw6e2XU0qb3xMxiv/4niCRYSvCBv6q1ygvaKuPV7YS7WWdgpg
         zphguHWYOyB/PIqa3ev5a1sTw17QIt+7+EFQtiV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/593] ASoC: max98373-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:01 +0200
Message-Id: <20210712060946.706141389@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 14fd2f9a0bf3..39afa011f0e2 100644
--- a/sound/soc/codecs/max98373-sdw.c
+++ b/sound/soc/codecs/max98373-sdw.c
@@ -258,7 +258,7 @@ static __maybe_unused int max98373_resume(struct device *dev)
 	struct max98373_priv *max98373 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!max98373->hw_init)
+	if (!max98373->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
@@ -349,7 +349,7 @@ static int max98373_io_init(struct sdw_slave *slave)
 	struct device *dev = &slave->dev;
 	struct max98373_priv *max98373 = dev_get_drvdata(dev);
 
-	if (max98373->pm_init_once) {
+	if (max98373->first_hw_init) {
 		regcache_cache_only(max98373->regmap, false);
 		regcache_cache_bypass(max98373->regmap, true);
 	}
@@ -357,7 +357,7 @@ static int max98373_io_init(struct sdw_slave *slave)
 	/*
 	 * PM runtime is only enabled when a Slave reports as Attached
 	 */
-	if (!max98373->pm_init_once) {
+	if (!max98373->first_hw_init) {
 		/* set autosuspend parameters */
 		pm_runtime_set_autosuspend_delay(dev, 3000);
 		pm_runtime_use_autosuspend(dev);
@@ -449,12 +449,12 @@ static int max98373_io_init(struct sdw_slave *slave)
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
@@ -773,7 +773,7 @@ static int max98373_init(struct sdw_slave *slave, struct regmap *regmap)
 	max98373_slot_config(dev, max98373);
 
 	max98373->hw_init = false;
-	max98373->pm_init_once = false;
+	max98373->first_hw_init = false;
 
 	/* codec registration  */
 	ret = devm_snd_soc_register_component(dev, &soc_codec_dev_max98373_sdw,
diff --git a/sound/soc/codecs/max98373.h b/sound/soc/codecs/max98373.h
index 4ab29b9d51c7..010f6bb21e9a 100644
--- a/sound/soc/codecs/max98373.h
+++ b/sound/soc/codecs/max98373.h
@@ -215,7 +215,7 @@ struct max98373_priv {
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



