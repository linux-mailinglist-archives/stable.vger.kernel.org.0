Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5E96648A8
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbjAJSNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbjAJSMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:12:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFAF1DF0E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:11:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDBCFB81905
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B2DC433EF;
        Tue, 10 Jan 2023 18:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374282;
        bh=BFrKb7OzDrrezFusLSnmXhdPhl7qpmXKLqHt+jRXvcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMaYbX+vICoFyS1/s8BxDpFlFUKxuDzM2dEZ3iJ63DF+WdzC/MDOL1xI9PNs+OFwK
         tl/USHtpAJa5MMouuHIol84vhmi4I8uZVdElBWRT9kzAdLiaoHOxrSP1JoFwIzbEYx
         9RIk08qdv9yc81+LCnxBN7iABXWpEB08CIL6vUws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Archana Patni <archana.patni@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 115/148] ASoC: SOF: Intel: pci-tgl: unblock S5 entry if DMA stop has failed"
Date:   Tue, 10 Jan 2023 19:03:39 +0100
Message-Id: <20230110180020.837875449@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

[ Upstream commit 2aa2a5ead0ee0a358bf80a2984a641d1bf2adc2a ]

If system shutdown has not been completed cleanly, it is possible the
DMA stream shutdown has not been done, or was not clean.

If this is the case, Intel TGL/ADL HDA platforms may fail to shutdown
cleanly due to pending HDA DMA transactions. To avoid this, detect this
scenario in the shutdown callback, and perform an additional controller
reset. This has been tested to unblock S5 entry if this condition is
hit.

Co-developed-by: Archana Patni <archana.patni@intel.com>
Signed-off-by: Archana Patni <archana.patni@intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20221209114529.3909192-2-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dsp.c | 72 +++++++++++++++++++++++++++++++++++
 sound/soc/sof/intel/hda.h     |  1 +
 sound/soc/sof/intel/tgl.c     |  2 +-
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-dsp.c b/sound/soc/sof/intel/hda-dsp.c
index eddfd77ad90f..0ab111814f1c 100644
--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -901,6 +901,78 @@ int hda_dsp_suspend(struct snd_sof_dev *sdev, u32 target_state)
 	return snd_sof_dsp_set_power_state(sdev, &target_dsp_state);
 }
 
+static unsigned int hda_dsp_check_for_dma_streams(struct snd_sof_dev *sdev)
+{
+	struct hdac_bus *bus = sof_to_bus(sdev);
+	struct hdac_stream *s;
+	unsigned int active_streams = 0;
+	int sd_offset;
+	u32 val;
+
+	list_for_each_entry(s, &bus->stream_list, list) {
+		sd_offset = SOF_STREAM_SD_OFFSET(s);
+		val = snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR,
+				       sd_offset);
+		if (val & SOF_HDA_SD_CTL_DMA_START)
+			active_streams |= BIT(s->index);
+	}
+
+	return active_streams;
+}
+
+static int hda_dsp_s5_quirk(struct snd_sof_dev *sdev)
+{
+	int ret;
+
+	/*
+	 * Do not assume a certain timing between the prior
+	 * suspend flow, and running of this quirk function.
+	 * This is needed if the controller was just put
+	 * to reset before calling this function.
+	 */
+	usleep_range(500, 1000);
+
+	/*
+	 * Take controller out of reset to flush DMA
+	 * transactions.
+	 */
+	ret = hda_dsp_ctrl_link_reset(sdev, false);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(500, 1000);
+
+	/* Restore state for shutdown, back to reset */
+	ret = hda_dsp_ctrl_link_reset(sdev, true);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
+int hda_dsp_shutdown_dma_flush(struct snd_sof_dev *sdev)
+{
+	unsigned int active_streams;
+	int ret, ret2;
+
+	/* check if DMA cleanup has been successful */
+	active_streams = hda_dsp_check_for_dma_streams(sdev);
+
+	sdev->system_suspend_target = SOF_SUSPEND_S3;
+	ret = snd_sof_suspend(sdev->dev);
+
+	if (active_streams) {
+		dev_warn(sdev->dev,
+			 "There were active DSP streams (%#x) at shutdown, trying to recover\n",
+			 active_streams);
+		ret2 = hda_dsp_s5_quirk(sdev);
+		if (ret2 < 0)
+			dev_err(sdev->dev, "shutdown recovery failed (%d)\n", ret2);
+	}
+
+	return ret;
+}
+
 int hda_dsp_shutdown(struct snd_sof_dev *sdev)
 {
 	sdev->system_suspend_target = SOF_SUSPEND_S3;
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index 5ef3e8775e36..554891e78cca 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -578,6 +578,7 @@ int hda_dsp_resume(struct snd_sof_dev *sdev);
 int hda_dsp_runtime_suspend(struct snd_sof_dev *sdev);
 int hda_dsp_runtime_resume(struct snd_sof_dev *sdev);
 int hda_dsp_runtime_idle(struct snd_sof_dev *sdev);
+int hda_dsp_shutdown_dma_flush(struct snd_sof_dev *sdev);
 int hda_dsp_shutdown(struct snd_sof_dev *sdev);
 int hda_dsp_set_hw_params_upon_resume(struct snd_sof_dev *sdev);
 void hda_dsp_dump(struct snd_sof_dev *sdev, u32 flags);
diff --git a/sound/soc/sof/intel/tgl.c b/sound/soc/sof/intel/tgl.c
index 6dfb4786c782..0173e5b255da 100644
--- a/sound/soc/sof/intel/tgl.c
+++ b/sound/soc/sof/intel/tgl.c
@@ -60,7 +60,7 @@ int sof_tgl_ops_init(struct snd_sof_dev *sdev)
 	memcpy(&sof_tgl_ops, &sof_hda_common_ops, sizeof(struct snd_sof_dsp_ops));
 
 	/* probe/remove/shutdown */
-	sof_tgl_ops.shutdown	= hda_dsp_shutdown;
+	sof_tgl_ops.shutdown	= hda_dsp_shutdown_dma_flush;
 
 	if (sdev->pdata->ipc_type == SOF_IPC) {
 		/* doorbell */
-- 
2.35.1



