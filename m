Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793AD4F3B47
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347271AbiDELwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356905AbiDEKZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:25:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B755C1CB1;
        Tue,  5 Apr 2022 03:09:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9093A617A7;
        Tue,  5 Apr 2022 10:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD81C385A0;
        Tue,  5 Apr 2022 10:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153353;
        bh=IsYGMWcOLC2kDDO8OFJfhbKJ+skf8w8cVCluqFXU9Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtNTPIdbJRz95hv2cMnmc7rPI6Ls5P9iHZ/hb3bYy+KpkAt/jGei33j/cB7apvZ3N
         JdAGOx4LJ9SObdzMA0Zp1yd0qpC+NKRNsjFQk5h5MFWt+0E7lLLg2GLwcpQVc79usI
         BtTxGINaCxeeyEANGCaslC9Ggq6gmFPOLNTJtjSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/599] ASoC: xilinx: xlnx_formatter_pcm: Handle sysclk setting
Date:   Tue,  5 Apr 2022 09:28:05 +0200
Message-Id: <20220405070304.524638747@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 1c5091fbe7e0d0804158200b7feac5123f7b4fbd ]

This driver did not set the MM2S Fs Multiplier Register to the proper
value for playback streams. This needs to be set to the sample rate to
MCLK multiplier, or random stream underflows can occur on the downstream
I2S transmitter.

Store the sysclk value provided via the set_sysclk callback and use that
in conjunction with the sample rate in the hw_params callback to calculate
the proper value to set for this register.

Fixes: 6f6c3c36f091 ("ASoC: xlnx: add pcm formatter platform driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220120195832.1742271-2-robert.hancock@calian.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/xilinx/xlnx_formatter_pcm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/sound/soc/xilinx/xlnx_formatter_pcm.c b/sound/soc/xilinx/xlnx_formatter_pcm.c
index ce19a6058b27..5c4158069a5a 100644
--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -84,6 +84,7 @@ struct xlnx_pcm_drv_data {
 	struct snd_pcm_substream *play_stream;
 	struct snd_pcm_substream *capture_stream;
 	struct clk *axi_clk;
+	unsigned int sysclk;
 };
 
 /*
@@ -314,6 +315,15 @@ static irqreturn_t xlnx_s2mm_irq_handler(int irq, void *arg)
 	return IRQ_NONE;
 }
 
+static int xlnx_formatter_set_sysclk(struct snd_soc_component *component,
+				     int clk_id, int source, unsigned int freq, int dir)
+{
+	struct xlnx_pcm_drv_data *adata = dev_get_drvdata(component->dev);
+
+	adata->sysclk = freq;
+	return 0;
+}
+
 static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 				   struct snd_pcm_substream *substream)
 {
@@ -450,11 +460,25 @@ static int xlnx_formatter_pcm_hw_params(struct snd_soc_component *component,
 	u64 size;
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct xlnx_pcm_stream_param *stream_data = runtime->private_data;
+	struct xlnx_pcm_drv_data *adata = dev_get_drvdata(component->dev);
 
 	active_ch = params_channels(params);
 	if (active_ch > stream_data->ch_limit)
 		return -EINVAL;
 
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+	    adata->sysclk) {
+		unsigned int mclk_fs = adata->sysclk / params_rate(params);
+
+		if (adata->sysclk % params_rate(params) != 0) {
+			dev_warn(component->dev, "sysclk %u not divisible by rate %u\n",
+				 adata->sysclk, params_rate(params));
+			return -EINVAL;
+		}
+
+		writel(mclk_fs, stream_data->mmio + XLNX_AUD_FS_MULTIPLIER);
+	}
+
 	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE &&
 	    stream_data->xfer_mode == AES_TO_PCM) {
 		val = readl(stream_data->mmio + XLNX_AUD_STS);
@@ -552,6 +576,7 @@ static int xlnx_formatter_pcm_new(struct snd_soc_component *component,
 
 static const struct snd_soc_component_driver xlnx_asoc_component = {
 	.name		= DRV_NAME,
+	.set_sysclk	= xlnx_formatter_set_sysclk,
 	.open		= xlnx_formatter_pcm_open,
 	.close		= xlnx_formatter_pcm_close,
 	.hw_params	= xlnx_formatter_pcm_hw_params,
-- 
2.34.1



