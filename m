Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA1B635D41
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbiKWMl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiKWMlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:41:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78F76A6B7;
        Wed, 23 Nov 2022 04:41:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5801DB81EA3;
        Wed, 23 Nov 2022 12:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8240EC433D6;
        Wed, 23 Nov 2022 12:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207280;
        bh=cQLk4V11on8FnoiHKTYdZUObu8yqBcscey+wbTRzR78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAu4GXfOI4yNa8Y/eAXE4SJcNusCYGWUC7/BBhQs9H0SvaCCKzt/sGIK088wd0G5F
         mwYgzYBid8DWPj4Y3REIVOD1J04cNU7qynOp/Jp4FQS2uP+aSI57ztDYgC19Eo62/Z
         p5c+jgpn0eZsq6h0XcdmmikT+q2ptfNgMWiEtYBGzq8k9Wd8wU8qY+bM6NXLIsnd5o
         2/YsY1KbO0Q4MN5FlJxfYD+NJtHev3fCxYtme3ljlTK7ASLLYbegcLuxx7kro2U0XP
         Uso5+/C5PDUIg+m5xS5aqOnioqO2rs10zI/kznHBrQEMLjuGwYn0GNKyjnUgnU6gTX
         Yam5EVGKl8cUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        yang.jie@linux.intel.com, alsa-devel@alsa-project.org,
        sound-open-firmware@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 08/44] ASoC: SOF: ipc3-topology: use old pipeline teardown flow with SOF2.1 and older
Date:   Wed, 23 Nov 2022 07:40:17 -0500
Message-Id: <20221123124057.264822-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 003b786b678919e072c2b12ffa73901ef840963e ]

Originally in commit b2ebcf42a48f ("ASoC: SOF: free widgets in
sof_tear_down_pipelines() for static pipelines"), freeing of pipeline
components at suspend was only done with recent FW as there were known
limitations in older firmware versions.

Tests show that if static pipelines are used, i.e. all pipelines are
setup whenever firmware is powered up, the reverse action of freeing all
components at power down, leads to firmware failures with also SOF2.0
and SOF2.1 based firmware.

The problems can be specific to certain topologies with e.g. components
not prepared to be freed at suspend (as this did not happen with older
SOF kernels).

To avoid hitting these problems when kernel is upgraded and used with an
older firmware, bump the firmware requirement to SOF2.2 or newer. If an
older firmware is used, and pipeline is a static one, do not free the
components at suspend. This ensures the suspend flow remains backwards
compatible with older firmware versions. This limitation does not apply
if the product configuration is updated to dynamic pipelines.

The limitation is not linked to firmware ABI, as the interface to free
pipeline components has been available already before ABI3.19. The
problem is in the implementation, so firmware version should be used to
decide whether it is safe to use the newer flow or not. This patch adds
a new SOF_FW_VER() macro to compare SOF firmware release versions.

Link: https://github.com/thesofproject/sof/issues/6475
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20221101114913.1292671-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sof/info.h      |  4 ++++
 sound/soc/sof/ipc3-topology.c | 15 ++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/sound/sof/info.h b/include/sound/sof/info.h
index 65e86e4e9fd8..75193850ead0 100644
--- a/include/sound/sof/info.h
+++ b/include/sound/sof/info.h
@@ -36,6 +36,10 @@ enum sof_ipc_ext_data {
 	SOF_IPC_EXT_USER_ABI_INFO	= 4,
 };
 
+/* Build u32 number in format MMmmmppp */
+#define SOF_FW_VER(MAJOR, MINOR, PATCH) ((uint32_t)( \
+	((MAJOR) << 24) | ((MINOR) << 12) | (PATCH)))
+
 /* FW version - SOF_IPC_GLB_VERSION */
 struct sof_ipc_fw_version {
 	struct sof_ipc_hdr hdr;
diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index a39b43850f0e..bf8a46463cec 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -2242,6 +2242,7 @@ static int sof_ipc3_tear_down_all_pipelines(struct snd_sof_dev *sdev, bool verif
 	struct sof_ipc_fw_version *v = &sdev->fw_ready.version;
 	struct snd_sof_widget *swidget;
 	struct snd_sof_route *sroute;
+	bool dyn_widgets = false;
 	int ret;
 
 	/*
@@ -2251,12 +2252,14 @@ static int sof_ipc3_tear_down_all_pipelines(struct snd_sof_dev *sdev, bool verif
 	 * topology loading the sound card unavailable to open PCMs.
 	 */
 	list_for_each_entry(swidget, &sdev->widget_list, list) {
-		if (swidget->dynamic_pipeline_widget)
+		if (swidget->dynamic_pipeline_widget) {
+			dyn_widgets = true;
 			continue;
+		}
 
-		/* Do not free widgets for static pipelines with FW ABI older than 3.19 */
+		/* Do not free widgets for static pipelines with FW older than SOF2.2 */
 		if (!verify && !swidget->dynamic_pipeline_widget &&
-		    v->abi_version < SOF_ABI_VER(3, 19, 0)) {
+		    SOF_FW_VER(v->major, v->minor, v->micro) < SOF_FW_VER(2, 2, 0)) {
 			swidget->use_count = 0;
 			swidget->complete = 0;
 			continue;
@@ -2270,9 +2273,11 @@ static int sof_ipc3_tear_down_all_pipelines(struct snd_sof_dev *sdev, bool verif
 	/*
 	 * Tear down all pipelines associated with PCMs that did not get suspended
 	 * and unset the prepare flag so that they can be set up again during resume.
-	 * Skip this step for older firmware.
+	 * Skip this step for older firmware unless topology has any
+	 * dynamic pipeline (in which case the step is mandatory).
 	 */
-	if (!verify && v->abi_version >= SOF_ABI_VER(3, 19, 0)) {
+	if (!verify && (dyn_widgets || SOF_FW_VER(v->major, v->minor, v->micro) >=
+	    SOF_FW_VER(2, 2, 0))) {
 		ret = sof_tear_down_left_over_pipelines(sdev);
 		if (ret < 0) {
 			dev_err(sdev->dev, "failed to tear down paused pipelines\n");
-- 
2.35.1

