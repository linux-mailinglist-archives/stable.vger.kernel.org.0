Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6A4461E6A
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351969AbhK2Sfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:35:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38606 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379420AbhK2Sdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:33:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C343B815D8;
        Mon, 29 Nov 2021 18:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B6CC53FC7;
        Mon, 29 Nov 2021 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210632;
        bh=Wf8GKM8z5WnE8vHIUIm8MYhQ3Y9i3qDKoX2WwiIwVv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeGr0/6hme0MK6MBU5ZvI+1sWcvhPJC5WCOis4Txdoszrz1YcGSXHmNs+jnvktC1M
         QsQzV/NMmTWzncDQWtoHNcQ+kamk3Ib15baoGtHLm0s195niaDJEq11/6ta+4PEFYX
         lNptZ1ck65aPfCAMknHObWTwWzskpio07lmepua0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/121] ASoC: qdsp6: q6asm: fix q6asm_dai_prepare error handling
Date:   Mon, 29 Nov 2021 19:18:00 +0100
Message-Id: <20211129181713.308133935@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 721a94b4352dc8e47bff90b549a0118c39776756 ]

Error handling in q6asm_dai_prepare() seems to be completely broken,
Fix this by handling it properly.

Fixes: 2a9e92d371db ("ASoC: qdsp6: q6asm: Add q6asm dai driver")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211116114721.12517-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6asm-dai.c b/sound/soc/qcom/qdsp6/q6asm-dai.c
index 9766725c29166..84cf190aa01a6 100644
--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -269,9 +269,7 @@ static int q6asm_dai_prepare(struct snd_soc_component *component,
 
 	if (ret < 0) {
 		dev_err(dev, "%s: q6asm_open_write failed\n", __func__);
-		q6asm_audio_client_free(prtd->audio_client);
-		prtd->audio_client = NULL;
-		return -ENOMEM;
+		goto open_err;
 	}
 
 	prtd->session_id = q6asm_get_session_id(prtd->audio_client);
@@ -279,7 +277,7 @@ static int q6asm_dai_prepare(struct snd_soc_component *component,
 			      prtd->session_id, substream->stream);
 	if (ret) {
 		dev_err(dev, "%s: stream reg failed ret:%d\n", __func__, ret);
-		return ret;
+		goto routing_err;
 	}
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
@@ -301,10 +299,19 @@ static int q6asm_dai_prepare(struct snd_soc_component *component,
 	}
 	if (ret < 0)
 		dev_info(dev, "%s: CMD Format block failed\n", __func__);
+	else
+		prtd->state = Q6ASM_STREAM_RUNNING;
 
-	prtd->state = Q6ASM_STREAM_RUNNING;
+	return ret;
 
-	return 0;
+routing_err:
+	q6asm_cmd(prtd->audio_client, prtd->stream_id,  CMD_CLOSE);
+open_err:
+	q6asm_unmap_memory_regions(substream->stream, prtd->audio_client);
+	q6asm_audio_client_free(prtd->audio_client);
+	prtd->audio_client = NULL;
+
+	return ret;
 }
 
 static int q6asm_dai_trigger(struct snd_soc_component *component,
-- 
2.33.0



