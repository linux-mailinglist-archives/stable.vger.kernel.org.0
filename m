Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480784ABDC0
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389067AbiBGLp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386743AbiBGLga (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:36:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B082C0401E2;
        Mon,  7 Feb 2022 03:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2C61B80EBD;
        Mon,  7 Feb 2022 11:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508B0C004E1;
        Mon,  7 Feb 2022 11:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233786;
        bh=vyXTZ8AOqJjuqo2aDoJFDqpiBjhdsEXIRrAn431eoUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tg1E62YzPok89s6TcrEKoVEWje4T8Xjdz6acw+E1d715BM+ojwGxxRayzuVZ2Z6Z0
         CcOH/+2SIt3HvUxzHL0TBv2LNGrNGpNdK56JK8nvxHFjQQaBUSO37xjndQU/MHiDQW
         1hnsePQOjGUqvK9AkKwcqIRO7/8IRvvx23kqzjOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 092/126] ASoC: qdsp6: q6apm-dai: only stop graphs that are started
Date:   Mon,  7 Feb 2022 12:07:03 +0100
Message-Id: <20220207103807.265670256@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 8f2e5c65ec7534cce6d315fccf2c3aef023f68f0 upstream.

Its possible that the sound card is just opened and closed without actually
playing stream, ex: if the audio file itself is missing.

Even in such cases we do call stop on graphs that are not yet started.
DSP can throw errors in such cases, so add a check to see if the graph
was started before stopping it.

Fixes: 9b4fe0f1cd79 ("ASoC: qdsp6: audioreach: add q6apm-dai support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220126113549.8853-5-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -308,8 +308,11 @@ static int q6apm_dai_close(struct snd_so
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct q6apm_dai_rtd *prtd = runtime->private_data;
 
-	q6apm_graph_stop(prtd->graph);
-	q6apm_unmap_memory_regions(prtd->graph, substream->stream);
+	if (prtd->state) { /* only stop graph that is started */
+		q6apm_graph_stop(prtd->graph);
+		q6apm_unmap_memory_regions(prtd->graph, substream->stream);
+	}
+
 	q6apm_graph_close(prtd->graph);
 	prtd->graph = NULL;
 	kfree(prtd);


