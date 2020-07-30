Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C296D232CB4
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 09:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgG3HvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 03:51:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41810 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbgG3HvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 03:51:01 -0400
Received: from [123.112.106.30] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1k13L5-0000Wf-HG; Thu, 30 Jul 2020 07:50:56 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, broonie@kernel.org,
        Vijendar.Mukunda@amd.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] ASoC: amd: renoir: restore two more registers during resume
Date:   Thu, 30 Jul 2020 15:50:20 +0800
Message-Id: <20200730075020.15667-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recently we found an issue about the suspend and resume. If dmic is
recording the sound, and we run suspend and resume, after the resume,
the dmic can't work well anymore. we need to close the app and reopen
the app, then the dmic could record the sound again.

For example, we run "arecord -D hw:CARD=acp,DEV=0 -f S32_LE -c 2
-r 48000 test.wav", then suspend and resume, after the system resume
back, we speak to the dmic. then stop the arecord, use aplay to play
the test.wav, we could hear the sound recorded after resume is weird,
it is not what we speak to the dmic.

I found two registers are set in the dai_hw_params(), if the two
registers are set in the resume() too, this issue could be fixed.

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index 623dfd3ea705..8acb0315a169 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -474,6 +474,11 @@ static int acp_pdm_resume(struct device *dev)
 		rtd = runtime->private_data;
 		period_bytes = frames_to_bytes(runtime, runtime->period_size);
 		buffer_len = frames_to_bytes(runtime, runtime->buffer_size);
+		if (runtime->channels == TWO_CH) {
+			rn_writel(0x0 , rtd->acp_base + ACP_WOV_PDM_NO_OF_CHANNELS);
+			rn_writel(PDM_DECIMATION_FACTOR, rtd->acp_base +
+				  ACP_WOV_PDM_DECIMATION_FACTOR);
+		}
 		config_acp_dma(rtd, SNDRV_PCM_STREAM_CAPTURE);
 		init_pdm_ring_buffer(MEM_WINDOW_START, buffer_len, period_bytes,
 				     adata->acp_base);
-- 
2.17.1

