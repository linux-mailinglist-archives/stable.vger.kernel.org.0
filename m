Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A779B5923A4
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241596AbiHNQX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241552AbiHNQWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:22:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5C9384;
        Sun, 14 Aug 2022 09:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F1D8B80B4D;
        Sun, 14 Aug 2022 16:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0D4C433D6;
        Sun, 14 Aug 2022 16:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494067;
        bh=Fat0dS/wzHEZg77Gcl07bd1wi0oqLAV1a1+v81FwFrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5D9TTu7mQ0drn62h/soUca+n27r2asxl/v5UCElte58ri7FmHytQwD6oVhoaJm7s
         LRsOv4Tnk+avyBBmZs1SVfs6Y8FMRoOQ3HbgMzAXYZ7HhpJk1SeEpal+KWi92sfnsQ
         81+rqW/kUx8leXRqFnVRJSmNDX9nBOCiJQjzNsHsaxBHtLV0z86+eq4AdExG+GTTvd
         SCCboFz0hdLCKppV0iOoObeaDZgdbt+olQ/Ig6TmQAZ164dJRiwaxfc16fIsu0N3d0
         JrIVR7WxUUiICvPhS75KrSsGFb3F3FLct2l6VoeDcCcg6l++hw5DMZVMjLMALdq/cl
         2LTTASbyNTL4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        pierre-louis.bossart@linux.intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        ndesaulniers@google.com, alsa-devel@alsa-project.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.19 22/48] ASoC: Intel: avs: Use lookup table to create modules
Date:   Sun, 14 Aug 2022 12:19:15 -0400
Message-Id: <20220814161943.2394452-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 1e744351bcb9c4cee81300de5a6097100d835386 ]

As reported by Nathan, when building avs driver using clang with:
  CONFIG_COMPILE_TEST=y
  CONFIG_FORTIFY_SOURCE=y
  CONFIG_KASAN=y
  CONFIG_PCI=y
  CONFIG_SOUND=y
  CONFIG_SND=y
  CONFIG_SND_SOC=y
  CONFIG_SND_SOC_INTEL_AVS=y

there are reports of too big stack use, like:
  sound/soc/intel/avs/path.c:815:18: error: stack frame size (2176) exceeds limit (2048) in 'avs_path_create' [-Werror,-Wframe-larger-than]
  struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
                   ^
  1 error generated.

This is apparently caused by inlining many calls to guid_equal which
inlines fortified memcpy, using 2 size_t variables.

Instead of hardcoding many calls to guid_equal, use lookup table with
one call, this improves stack usage.

Link: https://lore.kernel.org/alsa-devel/YtlzY9aYdbS4Y3+l@dev-arch.thelio-3990X/T/
Link: https://github.com/ClangBuiltLinux/linux/issues/1642
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Build-tested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20220722111959.2588597-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/path.c | 54 ++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index 3d46dd5e5bc4..ce157a8d6552 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -449,35 +449,39 @@ static int avs_modext_create(struct avs_dev *adev, struct avs_path_module *mod)
 	return ret;
 }
 
+static int avs_probe_create(struct avs_dev *adev, struct avs_path_module *mod)
+{
+	dev_err(adev->dev, "Probe module can't be instantiated by topology");
+	return -EINVAL;
+}
+
+struct avs_module_create {
+	guid_t *guid;
+	int (*create)(struct avs_dev *adev, struct avs_path_module *mod);
+};
+
+static struct avs_module_create avs_module_create[] = {
+	{ &AVS_MIXIN_MOD_UUID, avs_modbase_create },
+	{ &AVS_MIXOUT_MOD_UUID, avs_modbase_create },
+	{ &AVS_KPBUFF_MOD_UUID, avs_modbase_create },
+	{ &AVS_COPIER_MOD_UUID, avs_copier_create },
+	{ &AVS_MICSEL_MOD_UUID, avs_micsel_create },
+	{ &AVS_MUX_MOD_UUID, avs_mux_create },
+	{ &AVS_UPDWMIX_MOD_UUID, avs_updown_mix_create },
+	{ &AVS_SRCINTC_MOD_UUID, avs_src_create },
+	{ &AVS_AEC_MOD_UUID, avs_aec_create },
+	{ &AVS_ASRC_MOD_UUID, avs_asrc_create },
+	{ &AVS_INTELWOV_MOD_UUID, avs_wov_create },
+	{ &AVS_PROBE_MOD_UUID, avs_probe_create },
+};
+
 static int avs_path_module_type_create(struct avs_dev *adev, struct avs_path_module *mod)
 {
 	const guid_t *type = &mod->template->cfg_ext->type;
 
-	if (guid_equal(type, &AVS_MIXIN_MOD_UUID) ||
-	    guid_equal(type, &AVS_MIXOUT_MOD_UUID) ||
-	    guid_equal(type, &AVS_KPBUFF_MOD_UUID))
-		return avs_modbase_create(adev, mod);
-	if (guid_equal(type, &AVS_COPIER_MOD_UUID))
-		return avs_copier_create(adev, mod);
-	if (guid_equal(type, &AVS_MICSEL_MOD_UUID))
-		return avs_micsel_create(adev, mod);
-	if (guid_equal(type, &AVS_MUX_MOD_UUID))
-		return avs_mux_create(adev, mod);
-	if (guid_equal(type, &AVS_UPDWMIX_MOD_UUID))
-		return avs_updown_mix_create(adev, mod);
-	if (guid_equal(type, &AVS_SRCINTC_MOD_UUID))
-		return avs_src_create(adev, mod);
-	if (guid_equal(type, &AVS_AEC_MOD_UUID))
-		return avs_aec_create(adev, mod);
-	if (guid_equal(type, &AVS_ASRC_MOD_UUID))
-		return avs_asrc_create(adev, mod);
-	if (guid_equal(type, &AVS_INTELWOV_MOD_UUID))
-		return avs_wov_create(adev, mod);
-
-	if (guid_equal(type, &AVS_PROBE_MOD_UUID)) {
-		dev_err(adev->dev, "Probe module can't be instantiated by topology");
-		return -EINVAL;
-	}
+	for (int i = 0; i < ARRAY_SIZE(avs_module_create); i++)
+		if (guid_equal(type, avs_module_create[i].guid))
+			return avs_module_create[i].create(adev, mod);
 
 	return avs_modext_create(adev, mod);
 }
-- 
2.35.1

