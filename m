Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AAD4981A8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbiAXODa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:03:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58232 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238344AbiAXODa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:03:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 845E4B81056
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B38CC340E9;
        Mon, 24 Jan 2022 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643033008;
        bh=TV6hP58wpv1msq4jjEAA6FmPKJZe/5ix55PIarJ1NTw=;
        h=Subject:To:Cc:From:Date:From;
        b=ZDPH103E92oVHJtmCCRUfY3EQIteyVxv+GCPic0/7Vj1FDfcwIgFWRzutGDs47Jrm
         ZCCKW9NKTOZ6q6uPeVYDTd+YSmoymf6cT8vMny48nav3LmucQ1rAhV+h87ktGVqoED
         CW6pX3v2qDmbGNHMTvBxiTI5n7lGkwbT1uB1pupI=
Subject: FAILED: patch "[PATCH] ASoC: SOF: sof-audio: setup sched widgets during pipeline" failed to apply to 5.16-stable tree
To:     pierre-louis.bossart@linux.intel.com, broonie@kernel.org,
        kai.vehmanen@linux.intel.com, ranjani.sridharan@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:59:55 +0100
Message-ID: <16430327951439@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 01429183f479c54c1b5d15453a8ce574ea43e525 Mon Sep 17 00:00:00 2001
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Date: Tue, 23 Nov 2021 19:16:04 +0200
Subject: [PATCH] ASoC: SOF: sof-audio: setup sched widgets during pipeline
 complete step

Older firmware prior to ABI 3.19 has a dependency where the scheduler
widgets need to be setup last. Moving the call to sof_widget_setup()
before the pipeline_complete() call also helps remove the need for the
'reverse' direction when walking through the widget list - this was
only working because of the topology macros but the topology does not
require any order.

Fixes: 5fcdbb2d45df ("ASoC: SOF: Add support for dynamic pipelines")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211123171606.129350-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 0f2566f7c094..f4e142ec0fbd 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -637,16 +637,25 @@ const struct sof_ipc_pipe_new *snd_sof_pipeline_find(struct snd_sof_dev *sdev,
 
 int sof_set_up_pipelines(struct snd_sof_dev *sdev, bool verify)
 {
+	struct sof_ipc_fw_version *v = &sdev->fw_ready.version;
 	struct snd_sof_widget *swidget;
 	struct snd_sof_route *sroute;
 	int ret;
 
 	/* restore pipeline components */
-	list_for_each_entry_reverse(swidget, &sdev->widget_list, list) {
+	list_for_each_entry(swidget, &sdev->widget_list, list) {
 		/* only set up the widgets belonging to static pipelines */
 		if (!verify && swidget->dynamic_pipeline_widget)
 			continue;
 
+		/*
+		 * For older firmware, skip scheduler widgets in this loop,
+		 * sof_widget_setup() will be called in the 'complete pipeline' loop
+		 */
+		if (v->abi_version < SOF_ABI_VER(3, 19, 0) &&
+		    swidget->id == snd_soc_dapm_scheduler)
+			continue;
+
 		/* update DAI config. The IPC will be sent in sof_widget_setup() */
 		if (WIDGET_IS_DAI(swidget->id)) {
 			struct snd_sof_dai *dai = swidget->private;
@@ -694,6 +703,12 @@ int sof_set_up_pipelines(struct snd_sof_dev *sdev, bool verify)
 			if (!verify && swidget->dynamic_pipeline_widget)
 				continue;
 
+			if (v->abi_version < SOF_ABI_VER(3, 19, 0)) {
+				ret = sof_widget_setup(sdev, swidget);
+				if (ret < 0)
+					return ret;
+			}
+
 			swidget->complete =
 				snd_sof_complete_pipeline(sdev, swidget);
 			break;
@@ -722,7 +737,7 @@ int sof_tear_down_pipelines(struct snd_sof_dev *sdev, bool verify)
 	 * sroute->setup because during suspend all streams are suspended and during topology
 	 * loading the sound card unavailable to open PCMs.
 	 */
-	list_for_each_entry_reverse(swidget, &sdev->widget_list, list) {
+	list_for_each_entry(swidget, &sdev->widget_list, list) {
 		if (swidget->dynamic_pipeline_widget)
 			continue;
 

