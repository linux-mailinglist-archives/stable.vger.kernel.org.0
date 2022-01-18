Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A954917F2
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344510AbiARCnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345310AbiARCim (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:38:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC2AC06177B;
        Mon, 17 Jan 2022 18:35:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DF526122E;
        Tue, 18 Jan 2022 02:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552E8C36AF4;
        Tue, 18 Jan 2022 02:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473317;
        bh=P+/XBOu5s7oPYo9vT30MvHhnGwcXN4IbeJ/wTC2gVvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJcchd1zh8xou/15+Ky2fM3I+sHmFKF4w8ApWqfG1k2IsIYT/s2bMfyvk5kTONmUH
         FBMeolrroZVrasKsbPgdFJHQNQMwQXuYx8uYGFtVULKk0c5yMzaZJe5YFSR4YqG++A
         s1keHzv/e6s2CwX91ni8qnpde/rO7FWsl7XtHNdCkG/JVYiDIQ8+lXEi1/aEPhgfLd
         eCi5gf/s8yyAB9N32mngGBBwIMWH45YlHij6iqWea+YnzSOnTMJR6mCkhob/Z75wfA
         UchecLnxQE1ul0Q7koPv+gSU6npHBvrQp2lDoB3rfktXBQYPBBs4T5jt9E7S0DjzNB
         cszujo/HODN7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 068/188] media: venus: avoid calling core_clk_setrate() concurrently during concurrent video sessions
Date:   Mon, 17 Jan 2022 21:29:52 -0500
Message-Id: <20220118023152.1948105-68-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit 91f2b7d269e5c885c38c7ffa261f5276bd42f907 ]

In existing implementation, core_clk_setrate() is getting called
concurrently in concurrent video sessions. Before the previous call to
core_clk_setrate returns, new call to core_clk_setrate is invoked from
another video session running concurrently. This results in latest
calculated frequency being set (higher/lower) instead of actual frequency
required for that video session. It also results in stability crashes
mention below. These resources are specific to video core, hence keeping
under core lock would ensure that they are estimated for all running video
sessions and called once for the video core.

Crash logs:

[    1.900089] WARNING: CPU: 4 PID: 1 at drivers/opp/debugfs.c:33 opp_debug_remove_one+0x2c/0x48
[    1.908493] Modules linked in:
[    1.911524] CPU: 4 PID: 1 Comm: swapper/0 Not tainted 5.10.67 #35 f8edb8c30cf2dd6838495dd9ef9be47af7f5f60c
[    1.921036] Hardware name: Qualcomm Technologies, Inc. sc7280 IDP SKU2 platform (DT)
[    1.928673] pstate: 60800009 (nZCv daif -PAN +UAO -TCO BTYPE=--)
[    1.934608] pc : opp_debug_remove_one+0x2c/0x48
[    1.939080] lr : opp_debug_remove_one+0x2c/0x48
[    1.943560] sp : ffffffc011d7b7f0
[    1.946836] pmr_save: 000000e0
[    1.949854] x29: ffffffc011d7b7f0 x28: ffffffc010733bbc
[    1.955104] x27: ffffffc010733ba8 x26: ffffff8083cedd00
[    1.960355] x25: 0000000000000001 x24: 0000000000000000
[    1.965603] x23: ffffff8083cc2878 x22: ffffff8083ceb900
[    1.970852] x21: ffffff8083ceb910 x20: ffffff8083cc2800
[    1.976101] x19: ffffff8083ceb900 x18: 00000000ffff0a10
[    1.981352] x17: ffffff80837a5620 x16: 00000000000000ec
[    1.986601] x15: ffffffc010519ad4 x14: 0000000000000003
[    1.991849] x13: 0000000000000004 x12: 0000000000000001
[    1.997100] x11: c0000000ffffdfff x10: 00000000ffffffff
[    2.002348] x9 : d2627c580300dc00 x8 : d2627c580300dc00
[    2.007596] x7 : 0720072007200720 x6 : ffffff80802ecf00
[    2.012845] x5 : 0000000000190004 x4 : 0000000000000000
[    2.018094] x3 : ffffffc011d7b478 x2 : ffffffc011d7b480
[    2.023343] x1 : 00000000ffffdfff x0 : 0000000000000017
[    2.028594] Call trace:
[    2.031022]  opp_debug_remove_one+0x2c/0x48
[    2.035160]  dev_pm_opp_put+0x94/0xb0
[    2.038780]  _opp_remove_all+0x7c/0xc8
[    2.042486]  _opp_remove_all_static+0x54/0x7c
[    2.046796]  dev_pm_opp_remove_table+0x74/0x98
[    2.051183]  devm_pm_opp_of_table_release+0x18/0x24
[    2.056001]  devm_action_release+0x1c/0x28
[    2.060053]  release_nodes+0x23c/0x2b8
[    2.063760]  devres_release_group+0xcc/0xd0
[    2.067900]  component_bind+0xac/0x168
[    2.071608]  component_bind_all+0x98/0x124
[    2.075664]  msm_drm_bind+0x1e8/0x678
[    2.079287]  try_to_bring_up_master+0x60/0x134
[    2.083674]  component_master_add_with_match+0xd8/0x120
[    2.088834]  msm_pdev_probe+0x20c/0x2a0
[    2.092629]  platform_drv_probe+0x9c/0xbc
[    2.096598]  really_probe+0x11c/0x46c
[    2.100217]  driver_probe_device+0x8c/0xf0
[    2.104270]  device_driver_attach+0x54/0x78
[    2.108407]  __driver_attach+0x48/0x148
[    2.112201]  bus_for_each_dev+0x88/0xd4
[    2.115998]  driver_attach+0x2c/0x38
[    2.119534]  bus_add_driver+0x10c/0x200
[    2.123330]  driver_register+0x6c/0x104
[    2.127122]  __platform_driver_register+0x4c/0x58
[    2.131767]  msm_drm_register+0x6c/0x70
[    2.135560]  do_one_initcall+0x64/0x23c
[    2.139357]  do_initcall_level+0xac/0x15c
[    2.143321]  do_initcalls+0x5c/0x9c
[    2.146778]  do_basic_setup+0x2c/0x38
[    2.150401]  kernel_init_freeable+0xf8/0x15c
[    2.154622]  kernel_init+0x1c/0x11c
[    2.158079]  ret_from_fork+0x10/0x30
[    2.161615] ---[ end trace a2cc45a0f784b212 ]---

[    2.166272] Removing OPP: 300000000

Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/qcom/venus/pm_helpers.c    | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index e031fd17f4e75..8b2fb02099c1c 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -163,14 +163,12 @@ static u32 load_per_type(struct venus_core *core, u32 session_type)
 	struct venus_inst *inst = NULL;
 	u32 mbs_per_sec = 0;
 
-	mutex_lock(&core->lock);
 	list_for_each_entry(inst, &core->instances, list) {
 		if (inst->session_type != session_type)
 			continue;
 
 		mbs_per_sec += load_per_instance(inst);
 	}
-	mutex_unlock(&core->lock);
 
 	return mbs_per_sec;
 }
@@ -219,14 +217,12 @@ static int load_scale_bw(struct venus_core *core)
 	struct venus_inst *inst = NULL;
 	u32 mbs_per_sec, avg, peak, total_avg = 0, total_peak = 0;
 
-	mutex_lock(&core->lock);
 	list_for_each_entry(inst, &core->instances, list) {
 		mbs_per_sec = load_per_instance(inst);
 		mbs_to_bw(inst, mbs_per_sec, &avg, &peak);
 		total_avg += avg;
 		total_peak += peak;
 	}
-	mutex_unlock(&core->lock);
 
 	/*
 	 * keep minimum bandwidth vote for "video-mem" path,
@@ -253,8 +249,9 @@ static int load_scale_v1(struct venus_inst *inst)
 	struct device *dev = core->dev;
 	u32 mbs_per_sec;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
+	mutex_lock(&core->lock);
 	mbs_per_sec = load_per_type(core, VIDC_SESSION_TYPE_ENC) +
 		      load_per_type(core, VIDC_SESSION_TYPE_DEC);
 
@@ -279,17 +276,19 @@ static int load_scale_v1(struct venus_inst *inst)
 	if (ret) {
 		dev_err(dev, "failed to set clock rate %lu (%d)\n",
 			freq, ret);
-		return ret;
+		goto exit;
 	}
 
 	ret = load_scale_bw(core);
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth (%d)\n",
 			ret);
-		return ret;
+		goto exit;
 	}
 
-	return 0;
+exit:
+	mutex_unlock(&core->lock);
+	return ret;
 }
 
 static int core_get_v1(struct venus_core *core)
@@ -1116,13 +1115,13 @@ static int load_scale_v4(struct venus_inst *inst)
 	struct device *dev = core->dev;
 	unsigned long freq = 0, freq_core1 = 0, freq_core2 = 0;
 	unsigned long filled_len = 0;
-	int i, ret;
+	int i, ret = 0;
 
 	for (i = 0; i < inst->num_input_bufs; i++)
 		filled_len = max(filled_len, inst->payloads[i]);
 
 	if (inst->session_type == VIDC_SESSION_TYPE_DEC && !filled_len)
-		return 0;
+		return ret;
 
 	freq = calculate_inst_freq(inst, filled_len);
 	inst->clk_data.freq = freq;
@@ -1138,7 +1137,6 @@ static int load_scale_v4(struct venus_inst *inst)
 			freq_core2 += inst->clk_data.freq;
 		}
 	}
-	mutex_unlock(&core->lock);
 
 	freq = max(freq_core1, freq_core2);
 
@@ -1162,17 +1160,19 @@ static int load_scale_v4(struct venus_inst *inst)
 	if (ret) {
 		dev_err(dev, "failed to set clock rate %lu (%d)\n",
 			freq, ret);
-		return ret;
+		goto exit;
 	}
 
 	ret = load_scale_bw(core);
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth (%d)\n",
 			ret);
-		return ret;
+		goto exit;
 	}
 
-	return 0;
+exit:
+	mutex_unlock(&core->lock);
+	return ret;
 }
 
 static const struct venus_pm_ops pm_ops_v4 = {
-- 
2.34.1

