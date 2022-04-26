Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9D95107F8
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240598AbiDZTFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349665AbiDZTE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:04:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848BC1597AB;
        Tue, 26 Apr 2022 12:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41166B8224F;
        Tue, 26 Apr 2022 19:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9CAC385AA;
        Tue, 26 Apr 2022 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999707;
        bh=Lczrt4+YUqRZ1mToh23wQuAlFBbPmfoWphl6BE6TpG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1Y3W/cDiQF6/YxPYC0jGB8sliXqFZlhFUltYGhUWmPAKyAtrjcZ86UEj23CJDfWT
         gQBw32n4QTJ91c3OX+FpVn7LfaMVezW7HbAEbJifEttVwJmLPwbF/1XTrawHziyKwK
         yeuQaogYfVUOqcz4j/LYCGKI3GMgmQDmHYDgG5a0JZdyNhxqDtX5Rgc9lDDSnwbc2r
         Tzkzx/cx4727XNHwJozoJr/CJt6X3XpNHvHKN+mnjhv7VuDBUtVFfStTYuS3rjrAke
         3F0Qnnb/HCAIB9UxKvCLShTRLEvTgZSTs1Y9RhvuNJjcd1s3EwHtIQtg9lNUems1p1
         JLlJafdNc0tMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 03/22] ASoC: rt711/5682: check if bus is active before deferred jack detection
Date:   Tue, 26 Apr 2022 15:01:26 -0400
Message-Id: <20220426190145.2351135-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
References: <20220426190145.2351135-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 770f3d992a3f7330f801dfeee98429b2885c9fdb ]

This patch takes a defensive programming and paranoid approach in case
the parent device (SoundWire) is pm_runtime resumed but the rt711
device is not. In that case, during the attachment and initialization,
a jack detection workqueue can be scheduled. Since the pm_runtime
suspend routines will not be invoked, the sequence to cancel all
deferred work is not executed, and the jack detection could happen
after the bus stops operating, leading to a timeout.

This patch applies the same solution to rt5682, based on the
similarities between codec drivers. The race condition with rt5682 was
not detected experimentally though.

BugLink: https://github.com/thesofproject/linux/issues/3459
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220406192005.262996-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 9 +++++++++
 sound/soc/codecs/rt711.c  | 7 +++++++
 2 files changed, 16 insertions(+)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index be68d573a490..e6f7e9f82511 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -1100,6 +1100,15 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		return;
 	}
 
+	if (rt5682->is_sdw) {
+		if (pm_runtime_status_suspended(rt5682->slave->dev.parent)) {
+			dev_dbg(&rt5682->slave->dev,
+				"%s: parent device is pm_runtime_status_suspended, skipping jack detection\n",
+				__func__);
+			return;
+		}
+	}
+
 	dapm = snd_soc_component_get_dapm(rt5682->component);
 
 	snd_soc_dapm_mutex_lock(dapm);
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index 6770825d037a..ea25fd58d43a 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -245,6 +245,13 @@ static void rt711_jack_detect_handler(struct work_struct *work)
 	if (!rt711->component->card->instantiated)
 		return;
 
+	if (pm_runtime_status_suspended(rt711->slave->dev.parent)) {
+		dev_dbg(&rt711->slave->dev,
+			"%s: parent device is pm_runtime_status_suspended, skipping jack detection\n",
+			__func__);
+		return;
+	}
+
 	reg = RT711_VERB_GET_PIN_SENSE | RT711_HP_OUT;
 	ret = regmap_read(rt711->regmap, reg, &jack_status);
 	if (ret < 0)
-- 
2.35.1

