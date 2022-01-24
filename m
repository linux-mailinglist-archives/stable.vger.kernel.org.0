Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10FD49A446
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371299AbiAYAH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2366201AbiAXXwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:52:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60820C07A95C;
        Mon, 24 Jan 2022 13:45:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C206B8123D;
        Mon, 24 Jan 2022 21:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E85C340E4;
        Mon, 24 Jan 2022 21:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060705;
        bh=X6bcEQhAVYDXS9HjNJEQEd9zlEK1/veNAwt54lPKiSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sban9Tv8XNy6OX76M66EjlQydFZycyrvkUV75Ab0jXg081qv1Qh+XXx3a6C/8SBzj
         jYJ+5+QSSzoCRS77bClpb0yPvus1XslbuYOtX2p3FTB5jCT6DzRftpvwUwYZwLtn4f
         BKM29p1CRsfe49Xo2W0sOyfmKlySEiQlbhH8bNPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 1036/1039] ASoC: SOF: topology: remove sof_load_pipeline_ipc()
Date:   Mon, 24 Jan 2022 19:47:05 +0100
Message-Id: <20220124184200.112391921@linuxfoundation.org>
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

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit 7cc7b9ba21d4978d19f0e3edc2b00d44c9d66ff6 upstream.

Remove the function sof_load_pipeline_ipc() and directly
send the IPC instead. The pipeline core is already enabled
with the call to sof_pipeline_core_enable() in sof_widget_setup().

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211119192621.4096077-7-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.c |    3 ++-
 sound/soc/sof/sof-audio.h |    4 ----
 sound/soc/sof/topology.c  |   17 -----------------
 3 files changed, 2 insertions(+), 22 deletions(-)

--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -203,7 +203,8 @@ int sof_widget_setup(struct snd_sof_dev
 		break;
 	case snd_soc_dapm_scheduler:
 		pipeline = swidget->private;
-		ret = sof_load_pipeline_ipc(sdev, pipeline, &r);
+		ret = sof_ipc_tx_message(sdev->ipc, pipeline->hdr.cmd, pipeline,
+					 sizeof(*pipeline), &r, sizeof(r));
 		break;
 	default:
 		hdr = swidget->private;
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -184,10 +184,6 @@ void snd_sof_control_notify(struct snd_s
 int snd_sof_load_topology(struct snd_soc_component *scomp, const char *file);
 int snd_sof_complete_pipeline(struct snd_sof_dev *sdev,
 			      struct snd_sof_widget *swidget);
-
-int sof_load_pipeline_ipc(struct snd_sof_dev *sdev,
-			  struct sof_ipc_pipe_new *pipeline,
-			  struct sof_ipc_comp_reply *r);
 int sof_pipeline_core_enable(struct snd_sof_dev *sdev,
 			     const struct snd_sof_widget *swidget);
 
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1690,23 +1690,6 @@ err:
 /*
  * Pipeline Topology
  */
-int sof_load_pipeline_ipc(struct snd_sof_dev *sdev,
-			  struct sof_ipc_pipe_new *pipeline,
-			  struct sof_ipc_comp_reply *r)
-{
-	int ret = sof_core_enable(sdev, pipeline->core);
-
-	if (ret < 0)
-		return ret;
-
-	ret = sof_ipc_tx_message(sdev->ipc, pipeline->hdr.cmd, pipeline,
-				 sizeof(*pipeline), r, sizeof(*r));
-	if (ret < 0)
-		dev_err(sdev->dev, "error: load pipeline ipc failure\n");
-
-	return ret;
-}
-
 static int sof_widget_load_pipeline(struct snd_soc_component *scomp, int index,
 				    struct snd_sof_widget *swidget,
 				    struct snd_soc_tplg_dapm_widget *tw)


