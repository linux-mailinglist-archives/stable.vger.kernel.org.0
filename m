Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2599463E02A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiK3SyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiK3SyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:54:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005D051325
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:54:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 910AE61D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E9AC433D6;
        Wed, 30 Nov 2022 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834449;
        bh=cQLk4V11on8FnoiHKTYdZUObu8yqBcscey+wbTRzR78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHnXvfTBSmNTXQb0dbOn2RJT7vQzW+d4axMhlpoLaYwPOupviH255ASXM26CmYbgR
         sR0daRBTL06n5bBJ9+fA5Abjx+iEcnSZUvZULKGM96mJ80KgxsFNc3zlVt9GNvA3Ij
         5C/g9ltShh6ipmydsfU6lUZTQcnp6Hwi+LniM6dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 230/289] ASoC: SOF: ipc3-topology: use old pipeline teardown flow with SOF2.1 and older
Date:   Wed, 30 Nov 2022 19:23:35 +0100
Message-Id: <20221130180549.328003334@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



