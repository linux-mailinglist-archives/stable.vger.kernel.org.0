Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA83449A459
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371328AbiAYAHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2366202AbiAXXwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:52:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE79C07A95E;
        Mon, 24 Jan 2022 13:45:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E75A612E5;
        Mon, 24 Jan 2022 21:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75912C340E4;
        Mon, 24 Jan 2022 21:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060712;
        bh=SOfb4C2ObNwB0Fx6quXOL5rM5gjVI3KB+Of+5+kXXrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOWLDC0dZFBqo8zIK/cI1QityxP0Kxts4s1oqV6aCqo4Ue/Jzhknodkr6ha1dudeq
         kjYpZstZe8ryned15u9NfzTS0C1lmc+6u6f3ErulOwLPRaub5bUXj/QklLpqIfhnYT
         YI0k0vpDaUPiI47ONFLjBl4dOlXZWHSYcqP1Sg0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 1038/1039] ASoC: SOF: sof-audio: setup sched widgets during pipeline complete step
Date:   Mon, 24 Jan 2022 19:47:07 +0100
Message-Id: <20220124184200.174533144@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 01429183f479c54c1b5d15453a8ce574ea43e525 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -596,16 +596,25 @@ const struct sof_ipc_pipe_new *snd_sof_p
 
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
@@ -653,6 +662,12 @@ int sof_set_up_pipelines(struct snd_sof_
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
@@ -681,7 +696,7 @@ int sof_tear_down_pipelines(struct snd_s
 	 * sroute->setup because during suspend all streams are suspended and during topology
 	 * loading the sound card unavailable to open PCMs.
 	 */
-	list_for_each_entry_reverse(swidget, &sdev->widget_list, list) {
+	list_for_each_entry(swidget, &sdev->widget_list, list) {
 		if (swidget->dynamic_pipeline_widget)
 			continue;
 


