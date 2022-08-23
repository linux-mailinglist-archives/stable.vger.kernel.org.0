Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8B759DA68
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352567AbiHWKIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352884AbiHWKG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D036565;
        Tue, 23 Aug 2022 01:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 718ACB8105C;
        Tue, 23 Aug 2022 08:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88E9C433D7;
        Tue, 23 Aug 2022 08:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244806;
        bh=ZJFE01siZK/UrXYJb26H6em5oEOiOk7q98WghNaIuhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJxzjGTtSpMlNNkW+2E+7u5N8UMKfrCvdJg4Hn+ae9sUPOh+y7pmEovTy740VPctY
         mCUDeiLwaUTLjxMmdDlIs/jcchPkBuT35H2AXSzxlL+DBWwvxPgIbtAFcTZR7let1d
         Hzl4vGaBEZGMGXofFdRzXzlM3zTcUZFe9CaaRvGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/244] ASoC: SOF: Intel: hda: Define rom_status_reg in sof_intel_dsp_desc
Date:   Tue, 23 Aug 2022 10:25:14 +0200
Message-Id: <20220823080104.370217616@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 71778f7940f0b496aa1ca1134f3b70b425a59bab ]

Add the rom_status_reg field to struct sof_intel_dsp_desc and define
it for HDA platforms. This will be used to check the ROM status during
FW boot.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220414184817.362215-14-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/apl.c        |  1 +
 sound/soc/sof/intel/cnl.c        |  2 ++
 sound/soc/sof/intel/hda-loader.c | 14 ++++++++------
 sound/soc/sof/intel/hda.c        |  8 ++++++--
 sound/soc/sof/intel/icl.c        |  1 +
 sound/soc/sof/intel/shim.h       |  1 +
 sound/soc/sof/intel/tgl.c        |  4 ++++
 7 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/sound/soc/sof/intel/apl.c b/sound/soc/sof/intel/apl.c
index c7ed2b3d6abc..0a42034c4655 100644
--- a/sound/soc/sof/intel/apl.c
+++ b/sound/soc/sof/intel/apl.c
@@ -139,6 +139,7 @@ const struct sof_intel_dsp_desc apl_chip_info = {
 	.ipc_ack = HDA_DSP_REG_HIPCIE,
 	.ipc_ack_mask = HDA_DSP_REG_HIPCIE_DONE,
 	.ipc_ctl = HDA_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 150,
 	.ssp_count = APL_SSP_COUNT,
 	.ssp_base_offset = APL_SSP_BASE_OFFSET,
diff --git a/sound/soc/sof/intel/cnl.c b/sound/soc/sof/intel/cnl.c
index e115e12a856f..a63b235763ed 100644
--- a/sound/soc/sof/intel/cnl.c
+++ b/sound/soc/sof/intel/cnl.c
@@ -344,6 +344,7 @@ const struct sof_intel_dsp_desc cnl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = CNL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
@@ -363,6 +364,7 @@ const struct sof_intel_dsp_desc jsl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index ee09393d42cb..439cb33d2a71 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -163,7 +163,7 @@ static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 
 	/* step 7: wait for ROM init */
 	ret = snd_sof_dsp_read_poll_timeout(sdev, HDA_DSP_BAR,
-					HDA_DSP_SRAM_REG_ROM_STATUS, status,
+					chip->rom_status_reg, status,
 					((status & HDA_DSP_ROM_STS_MASK)
 						== HDA_DSP_ROM_INIT),
 					HDA_DSP_REG_POLL_INTERVAL_US,
@@ -174,8 +174,8 @@ static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 
 	if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
 		dev_err(sdev->dev,
-			"error: %s: timeout HDA_DSP_SRAM_REG_ROM_STATUS read\n",
-			__func__);
+			"%s: timeout with rom_status_reg (%#x) read\n",
+			__func__, chip->rom_status_reg);
 
 err:
 	flags = SOF_DBG_DUMP_REGS | SOF_DBG_DUMP_PCI | SOF_DBG_DUMP_MBOX;
@@ -251,6 +251,8 @@ static int cl_cleanup(struct snd_sof_dev *sdev, struct snd_dma_buffer *dmab,
 
 static int cl_copy_fw(struct snd_sof_dev *sdev, struct hdac_ext_stream *stream)
 {
+	struct sof_intel_hda_dev *hda = sdev->pdata->hw_pdata;
+	const struct sof_intel_dsp_desc *chip = hda->desc;
 	unsigned int reg;
 	int ret, status;
 
@@ -261,7 +263,7 @@ static int cl_copy_fw(struct snd_sof_dev *sdev, struct hdac_ext_stream *stream)
 	}
 
 	status = snd_sof_dsp_read_poll_timeout(sdev, HDA_DSP_BAR,
-					HDA_DSP_SRAM_REG_ROM_STATUS, reg,
+					chip->rom_status_reg, reg,
 					((reg & HDA_DSP_ROM_STS_MASK)
 						== HDA_DSP_ROM_FW_ENTERED),
 					HDA_DSP_REG_POLL_INTERVAL_US,
@@ -274,8 +276,8 @@ static int cl_copy_fw(struct snd_sof_dev *sdev, struct hdac_ext_stream *stream)
 
 	if (status < 0) {
 		dev_err(sdev->dev,
-			"error: %s: timeout HDA_DSP_SRAM_REG_ROM_STATUS read\n",
-			__func__);
+			"%s: timeout with rom_status_reg (%#x) read\n",
+			__func__, chip->rom_status_reg);
 	}
 
 	ret = cl_trigger(sdev, stream, SNDRV_PCM_TRIGGER_STOP);
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index ddf70902e53c..e733c401562f 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -353,11 +353,13 @@ static const struct hda_dsp_msg_code hda_dsp_rom_msg[] = {
 
 static void hda_dsp_get_status(struct snd_sof_dev *sdev)
 {
+	const struct sof_intel_dsp_desc *chip;
 	u32 status;
 	int i;
 
+	chip = get_chip_info(sdev->pdata);
 	status = snd_sof_dsp_read(sdev, HDA_DSP_BAR,
-				  HDA_DSP_SRAM_REG_ROM_STATUS);
+				  chip->rom_status_reg);
 
 	for (i = 0; i < ARRAY_SIZE(hda_dsp_rom_msg); i++) {
 		if (status == hda_dsp_rom_msg[i].code) {
@@ -402,13 +404,15 @@ static void hda_dsp_get_registers(struct snd_sof_dev *sdev,
 /* dump the first 8 dwords representing the extended ROM status */
 static void hda_dsp_dump_ext_rom_status(struct snd_sof_dev *sdev, u32 flags)
 {
+	const struct sof_intel_dsp_desc *chip;
 	char msg[128];
 	int len = 0;
 	u32 value;
 	int i;
 
+	chip = get_chip_info(sdev->pdata);
 	for (i = 0; i < HDA_EXT_ROM_STATUS_SIZE; i++) {
-		value = snd_sof_dsp_read(sdev, HDA_DSP_BAR, HDA_DSP_SRAM_REG_ROM_STATUS + i * 0x4);
+		value = snd_sof_dsp_read(sdev, HDA_DSP_BAR, chip->rom_status_reg + i * 0x4);
 		len += snprintf(msg + len, sizeof(msg) - len, " 0x%x", value);
 	}
 
diff --git a/sound/soc/sof/intel/icl.c b/sound/soc/sof/intel/icl.c
index ee095b8f2d01..4065c4d3912a 100644
--- a/sound/soc/sof/intel/icl.c
+++ b/sound/soc/sof/intel/icl.c
@@ -139,6 +139,7 @@ const struct sof_intel_dsp_desc icl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
diff --git a/sound/soc/sof/intel/shim.h b/sound/soc/sof/intel/shim.h
index e9f7d4d7fcce..96707758ebc5 100644
--- a/sound/soc/sof/intel/shim.h
+++ b/sound/soc/sof/intel/shim.h
@@ -161,6 +161,7 @@ struct sof_intel_dsp_desc {
 	int ipc_ack;
 	int ipc_ack_mask;
 	int ipc_ctl;
+	int rom_status_reg;
 	int rom_init_timeout;
 	int ssp_count;			/* ssp count of the platform */
 	int ssp_base_offset;		/* base address of the SSPs */
diff --git a/sound/soc/sof/intel/tgl.c b/sound/soc/sof/intel/tgl.c
index 199d41a7dc9b..aba52d8628aa 100644
--- a/sound/soc/sof/intel/tgl.c
+++ b/sound/soc/sof/intel/tgl.c
@@ -134,6 +134,7 @@ const struct sof_intel_dsp_desc tgl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
@@ -153,6 +154,7 @@ const struct sof_intel_dsp_desc tglh_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
@@ -172,6 +174,7 @@ const struct sof_intel_dsp_desc ehl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
@@ -191,6 +194,7 @@ const struct sof_intel_dsp_desc adls_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
-- 
2.35.1



