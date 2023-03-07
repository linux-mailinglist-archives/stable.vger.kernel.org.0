Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31256AEA67
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjCGRdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjCGRdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:33:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0BB8E3D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:28:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37E1C611A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8DCC433D2;
        Tue,  7 Mar 2023 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210130;
        bh=NXGQ01tlgLQN7MbI9LHosK6ExbGw+zd4mydgOVcpzk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdjYOK85ACdZi6FPXTLZe6VIi1d6C+sNIwy6pBw5a4x78MVnoQdHbkbMR7VK+gFvf
         P1Tof8c/ze5adgdIbSqBRtcYaLBipao2oAkjuFY6xDVEkpxs6uccewirB3FMPS8MEd
         Vr4PcTnfm1w7bMf0zcFfNa1KAf8EfuQSUqTG6Sgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0425/1001] ASoC: qcom: q6apm-dai: fix race condition while updating the position pointer
Date:   Tue,  7 Mar 2023 17:53:17 +0100
Message-Id: <20230307170039.805975962@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 84222ef54bfd8f043c23c8603fd5257a64b00780 ]

It is noticed that the position pointer value seems to get a get corrupted
due to missing locking between updating and reading.

Fix this by adding a spinlock around the position pointer.

Fixes: 9b4fe0f1cd79 ("ASoC: qdsp6: audioreach: add q6apm-dai support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230209122806.18923-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm-dai.c b/sound/soc/qcom/qdsp6/q6apm-dai.c
index ee59ef36b85a6..bd35067a40521 100644
--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
+#include <linux/spinlock.h>
 #include <sound/pcm.h>
 #include <asm/dma.h>
 #include <linux/dma-mapping.h>
@@ -53,6 +54,7 @@ struct q6apm_dai_rtd {
 	uint16_t session_id;
 	enum stream_state state;
 	struct q6apm_graph *graph;
+	spinlock_t lock;
 };
 
 struct q6apm_dai_data {
@@ -99,20 +101,25 @@ static void event_handler(uint32_t opcode, uint32_t token, uint32_t *payload, vo
 {
 	struct q6apm_dai_rtd *prtd = priv;
 	struct snd_pcm_substream *substream = prtd->substream;
+	unsigned long flags;
 
 	switch (opcode) {
 	case APM_CLIENT_EVENT_CMD_EOS_DONE:
 		prtd->state = Q6APM_STREAM_STOPPED;
 		break;
 	case APM_CLIENT_EVENT_DATA_WRITE_DONE:
+	        spin_lock_irqsave(&prtd->lock, flags);
 		prtd->pos += prtd->pcm_count;
+		spin_unlock_irqrestore(&prtd->lock, flags);
 		snd_pcm_period_elapsed(substream);
 		if (prtd->state == Q6APM_STREAM_RUNNING)
 			q6apm_write_async(prtd->graph, prtd->pcm_count, 0, 0, 0);
 
 		break;
 	case APM_CLIENT_EVENT_DATA_READ_DONE:
+	        spin_lock_irqsave(&prtd->lock, flags);
 		prtd->pos += prtd->pcm_count;
+		spin_unlock_irqrestore(&prtd->lock, flags);
 		snd_pcm_period_elapsed(substream);
 		if (prtd->state == Q6APM_STREAM_RUNNING)
 			q6apm_read(prtd->graph);
@@ -253,6 +260,7 @@ static int q6apm_dai_open(struct snd_soc_component *component,
 	if (prtd == NULL)
 		return -ENOMEM;
 
+	spin_lock_init(&prtd->lock);
 	prtd->substream = substream;
 	prtd->graph = q6apm_graph_open(dev, (q6apm_cb)event_handler, prtd, graph_id);
 	if (IS_ERR(prtd->graph)) {
@@ -332,11 +340,17 @@ static snd_pcm_uframes_t q6apm_dai_pointer(struct snd_soc_component *component,
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct q6apm_dai_rtd *prtd = runtime->private_data;
+	snd_pcm_uframes_t ptr;
+	unsigned long flags;
 
+	spin_lock_irqsave(&prtd->lock, flags);
 	if (prtd->pos == prtd->pcm_size)
 		prtd->pos = 0;
 
-	return bytes_to_frames(runtime, prtd->pos);
+	ptr =  bytes_to_frames(runtime, prtd->pos);
+	spin_unlock_irqrestore(&prtd->lock, flags);
+
+	return ptr;
 }
 
 static int q6apm_dai_hw_params(struct snd_soc_component *component,
-- 
2.39.2



