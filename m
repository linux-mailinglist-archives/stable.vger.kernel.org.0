Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE32408FAF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243225AbhIMNpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241463AbhIMNoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8174C61350;
        Mon, 13 Sep 2021 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539847;
        bh=aR1/j4mTQJKSQr2RZXBR6jtZYZyAhqihq51z16wOFDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ikk97YBn4x6DNk3g+urFUz54pZDsry+3NqL9SJQM1InAnyLqjBhLI5k5q9stWl3+f
         ZdiA7Elvt5h65UmcM+jWPFrnumDf1kYlQVk8IE20RFS/LavvpwIZTd8BeOHtEzlOw0
         eWUnHPCj7uVj39FU0ImSL8rMn3OnCt0fXWJsQqL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/236] ASoC: Intel: Skylake: Fix module resource and format selection
Date:   Mon, 13 Sep 2021 15:14:50 +0200
Message-Id: <20210913131106.665156610@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit e8b374b649afe756c2470e0e6668022e90bf8518 ]

Module configuration may differ between its instances depending on
resources required and input and output audio format. Available
parameters to select from are stored in module resource and interface
(format) lists. These come from topology, together with description of
each of pipe's modules.

Ignoring index value provided by topology and relying always on 0th
entry leads to unexpected module behavior due to under/overbudged
resources assigned or impropper format selection. Fix by taking entry at
index specified by topology.

Fixes: f6fa56e22559 ("ASoC: Intel: Skylake: Parse and update module config structure")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Tested-by: Lukasz Majczak <lma@semihalf.com>
Link: https://lore.kernel.org/r/20210818075742.1515155-5-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-topology.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index 16f9f3bd68be..73976c6dfbdc 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -113,7 +113,7 @@ static int is_skl_dsp_widget_type(struct snd_soc_dapm_widget *w,
 
 static void skl_dump_mconfig(struct skl_dev *skl, struct skl_module_cfg *mcfg)
 {
-	struct skl_module_iface *iface = &mcfg->module->formats[0];
+	struct skl_module_iface *iface = &mcfg->module->formats[mcfg->fmt_idx];
 
 	dev_dbg(skl->dev, "Dumping config\n");
 	dev_dbg(skl->dev, "Input Format:\n");
@@ -195,8 +195,8 @@ static void skl_tplg_update_params_fixup(struct skl_module_cfg *m_cfg,
 	struct skl_module_fmt *in_fmt, *out_fmt;
 
 	/* Fixups will be applied to pin 0 only */
-	in_fmt = &m_cfg->module->formats[0].inputs[0].fmt;
-	out_fmt = &m_cfg->module->formats[0].outputs[0].fmt;
+	in_fmt = &m_cfg->module->formats[m_cfg->fmt_idx].inputs[0].fmt;
+	out_fmt = &m_cfg->module->formats[m_cfg->fmt_idx].outputs[0].fmt;
 
 	if (params->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		if (is_fe) {
@@ -239,9 +239,9 @@ static void skl_tplg_update_buffer_size(struct skl_dev *skl,
 	/* Since fixups is applied to pin 0 only, ibs, obs needs
 	 * change for pin 0 only
 	 */
-	res = &mcfg->module->resources[0];
-	in_fmt = &mcfg->module->formats[0].inputs[0].fmt;
-	out_fmt = &mcfg->module->formats[0].outputs[0].fmt;
+	res = &mcfg->module->resources[mcfg->res_idx];
+	in_fmt = &mcfg->module->formats[mcfg->fmt_idx].inputs[0].fmt;
+	out_fmt = &mcfg->module->formats[mcfg->fmt_idx].outputs[0].fmt;
 
 	if (mcfg->m_type == SKL_MODULE_TYPE_SRCINT)
 		multiplier = 5;
@@ -1631,11 +1631,12 @@ int skl_tplg_update_pipe_params(struct device *dev,
 			struct skl_module_cfg *mconfig,
 			struct skl_pipe_params *params)
 {
-	struct skl_module_res *res = &mconfig->module->resources[0];
+	struct skl_module_res *res;
 	struct skl_dev *skl = get_skl_ctx(dev);
 	struct skl_module_fmt *format = NULL;
 	u8 cfg_idx = mconfig->pipe->cur_config_idx;
 
+	res = &mconfig->module->resources[mconfig->res_idx];
 	skl_tplg_fill_dma_id(mconfig, params);
 	mconfig->fmt_idx = mconfig->mod_cfg[cfg_idx].fmt_idx;
 	mconfig->res_idx = mconfig->mod_cfg[cfg_idx].res_idx;
@@ -1644,9 +1645,9 @@ int skl_tplg_update_pipe_params(struct device *dev,
 		return 0;
 
 	if (params->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		format = &mconfig->module->formats[0].inputs[0].fmt;
+		format = &mconfig->module->formats[mconfig->fmt_idx].inputs[0].fmt;
 	else
-		format = &mconfig->module->formats[0].outputs[0].fmt;
+		format = &mconfig->module->formats[mconfig->fmt_idx].outputs[0].fmt;
 
 	/* set the hw_params */
 	format->s_freq = params->s_freq;
-- 
2.30.2



