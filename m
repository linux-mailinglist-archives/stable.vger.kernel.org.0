Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D15656FB18
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiGKJZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbiGKJYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C642F326CE;
        Mon, 11 Jul 2022 02:15:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5051561226;
        Mon, 11 Jul 2022 09:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F63C341C8;
        Mon, 11 Jul 2022 09:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530908;
        bh=XIRK/QPcy0fpo090+o2Pp+uylOSPt5DoDRhcqmsfk6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezXSJBsEvo+KGZwDs1dL1/dL6SQ0lKTzbLOQ8MYdRrGfdoqV4Qcuantc80gYjo4wi
         P7xWwM8JS0VTpRMAKTwl+SF35e2H0F1WIcutelmZzBMCn0g4FJK/aEHhKuR+gKkj0L
         Nf9cCa5rIPfbDuCfCQzxA7P5xnneiZviEc/pn3uU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.18 027/112] ASoC: qdsp6: q6apm-dai: unprepare stream if its already prepared
Date:   Mon, 11 Jul 2022 11:06:27 +0200
Message-Id: <20220711090550.330720531@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 58136d93d4e2c1207a5e4f3044815cd40b1d95fd upstream.

prepare callback can be called multiple times, so unprepare the stream
if its already prepared.

Without this DSP is not happy to setting the params on a already
prepared graph.

Fixes: 9b4fe0f1cd79 ("ASoC: qdsp6: audioreach: add q6apm-dai support")
Reported-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220610144818.511797-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -147,6 +147,12 @@ static int q6apm_dai_prepare(struct snd_
 	cfg.num_channels = runtime->channels;
 	cfg.bit_width = prtd->bits_per_sample;
 
+	if (prtd->state) {
+		/* clear the previous setup if any  */
+		q6apm_graph_stop(prtd->graph);
+		q6apm_unmap_memory_regions(prtd->graph, substream->stream);
+	}
+
 	prtd->pcm_count = snd_pcm_lib_period_bytes(substream);
 	prtd->pos = 0;
 	/* rate and channels are sent to audio driver */


