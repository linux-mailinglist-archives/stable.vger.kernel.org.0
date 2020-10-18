Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F8E2919D2
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgJRTUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728721AbgJRTUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E9B222E9;
        Sun, 18 Oct 2020 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048813;
        bh=dtox73wfY74Rorx2zd1G+GstnJWkn2syZz33vughbJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lvu5Hmb6g1Fl02XKJ+ws5P5r2h+A5qysKT/Yn/pt1rvuza0UyEbJS88Yes2ToSiQw
         dB1YbIoxNjQteW649Y8KZ+XSHC9LNnqiioQm8vLEGNSBrPbntDbYhCbZT5tClZCQiO
         4XD2oA/x7NgCbbarSd9zrxCgebSdPSN373h57qe0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 103/111] soundwire: intel: reinitialize IP+DSP in .prepare(), but only when resuming
Date:   Sun, 18 Oct 2020 15:17:59 -0400
Message-Id: <20201018191807.4052726-103-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit a5a0239c27fe1125826c5cad4dec9cd1fd960d4a ]

The .prepare() callback is invoked for normal streaming, underflows or
during the system resume transition. In the latter case, the context
for the ALH PDIs is lost, and the DSP is not initialized properly
either, but the bus parameters don't need to be recomputed.

Conversely, when doing a regular .prepare() during an underflow, the
ALH/SHIM registers shall not be changed as the hardware cannot be
reprogrammed after the DMA started (hardware spec requirement).

This patch adds storage of PDI and hw_params in the DAI dma context,
and the difference between the types of .prepare() usages is handled
via a simple boolean, updated when suspending, and tested for in the
.prepare() case.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200817152923.3259-6-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.h |  4 ++
 drivers/soundwire/intel.c          | 71 +++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/cadence_master.h b/drivers/soundwire/cadence_master.h
index 15b0834030866..4d1aab5b5ec2d 100644
--- a/drivers/soundwire/cadence_master.h
+++ b/drivers/soundwire/cadence_master.h
@@ -84,6 +84,8 @@ struct sdw_cdns_stream_config {
  * @bus: Bus handle
  * @stream_type: Stream type
  * @link_id: Master link id
+ * @hw_params: hw_params to be applied in .prepare step
+ * @suspended: status set when suspended, to be used in .prepare
  */
 struct sdw_cdns_dma_data {
 	char *name;
@@ -92,6 +94,8 @@ struct sdw_cdns_dma_data {
 	struct sdw_bus *bus;
 	enum sdw_stream_type stream_type;
 	int link_id;
+	struct snd_pcm_hw_params *hw_params;
+	bool suspended;
 };
 
 /**
diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index a283670659a92..11d90fd4cc0d2 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -856,6 +856,10 @@ static int intel_hw_params(struct snd_pcm_substream *substream,
 	intel_pdi_alh_configure(sdw, pdi);
 	sdw_cdns_config_stream(cdns, ch, dir, pdi);
 
+	/* store pdi and hw_params, may be needed in prepare step */
+	dma->suspended = false;
+	dma->pdi = pdi;
+	dma->hw_params = params;
 
 	/* Inform DSP about PDI stream number */
 	ret = intel_params_stream(sdw, substream, dai, params,
@@ -899,7 +903,11 @@ static int intel_hw_params(struct snd_pcm_substream *substream,
 static int intel_prepare(struct snd_pcm_substream *substream,
 			 struct snd_soc_dai *dai)
 {
+	struct sdw_cdns *cdns = snd_soc_dai_get_drvdata(dai);
+	struct sdw_intel *sdw = cdns_to_intel(cdns);
 	struct sdw_cdns_dma_data *dma;
+	int ch, dir;
+	int ret;
 
 	dma = snd_soc_dai_get_dma_data(dai, substream);
 	if (!dma) {
@@ -908,7 +916,41 @@ static int intel_prepare(struct snd_pcm_substream *substream,
 		return -EIO;
 	}
 
-	return sdw_prepare_stream(dma->stream);
+	if (dma->suspended) {
+		dma->suspended = false;
+
+		/*
+		 * .prepare() is called after system resume, where we
+		 * need to reinitialize the SHIM/ALH/Cadence IP.
+		 * .prepare() is also called to deal with underflows,
+		 * but in those cases we cannot touch ALH/SHIM
+		 * registers
+		 */
+
+		/* configure stream */
+		ch = params_channels(dma->hw_params);
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			dir = SDW_DATA_DIR_RX;
+		else
+			dir = SDW_DATA_DIR_TX;
+
+		intel_pdi_shim_configure(sdw, dma->pdi);
+		intel_pdi_alh_configure(sdw, dma->pdi);
+		sdw_cdns_config_stream(cdns, ch, dir, dma->pdi);
+
+		/* Inform DSP about PDI stream number */
+		ret = intel_params_stream(sdw, substream, dai,
+					  dma->hw_params,
+					  sdw->instance,
+					  dma->pdi->intel_alh_id);
+		if (ret)
+			goto err;
+	}
+
+	ret = sdw_prepare_stream(dma->stream);
+
+err:
+	return ret;
 }
 
 static int intel_trigger(struct snd_pcm_substream *substream, int cmd,
@@ -979,6 +1021,9 @@ intel_hw_free(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 		return ret;
 	}
 
+	dma->hw_params = NULL;
+	dma->pdi = NULL;
+
 	return 0;
 }
 
@@ -988,6 +1033,29 @@ static void intel_shutdown(struct snd_pcm_substream *substream,
 
 }
 
+static int intel_component_dais_suspend(struct snd_soc_component *component)
+{
+	struct sdw_cdns_dma_data *dma;
+	struct snd_soc_dai *dai;
+
+	for_each_component_dais(component, dai) {
+		/*
+		 * we don't have a .suspend dai_ops, and we don't have access
+		 * to the substream, so let's mark both capture and playback
+		 * DMA contexts as suspended
+		 */
+		dma = dai->playback_dma_data;
+		if (dma)
+			dma->suspended = true;
+
+		dma = dai->capture_dma_data;
+		if (dma)
+			dma->suspended = true;
+	}
+
+	return 0;
+}
+
 static int intel_pcm_set_sdw_stream(struct snd_soc_dai *dai,
 				    void *stream, int direction)
 {
@@ -1040,6 +1108,7 @@ static const struct snd_soc_dai_ops intel_pdm_dai_ops = {
 
 static const struct snd_soc_component_driver dai_component = {
 	.name           = "soundwire",
+	.suspend	= intel_component_dais_suspend
 };
 
 static int intel_create_dai(struct sdw_cdns *cdns,
-- 
2.25.1

