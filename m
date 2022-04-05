Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3454F280B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbiDEIKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbiDEH7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEAF58E4C;
        Tue,  5 Apr 2022 00:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3765B81B90;
        Tue,  5 Apr 2022 07:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECA7C340EE;
        Tue,  5 Apr 2022 07:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145262;
        bh=+K8QVbvjVCkB+pHCfAmdtlCO8MMFBvdObYLBU5VrA+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kj9uWOxB00ra0HfMjOxg4QqmCZVM9lYB8Hk1jWa48QeFR+71hOuZfKsMkjsMxxS/v
         MZPo+iujnBblU08GWdstwrtsQPkEIgeV6LR3x9ZY+p5QX2wr1PFboSgjpxT7Dldnew
         e6Z/0UugxmtswpYAYiDVM3CLZieSYYIZ+UysoL5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0304/1126] ASoC: sh: rz-ssi: Drop calling rz_ssi_pio_recv() recursively
Date:   Tue,  5 Apr 2022 09:17:31 +0200
Message-Id: <20220405070416.537912192@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 6570f991582e32b7992601d0497c61962a2c5dcc ]

Instead of recursively calling rz_ssi_pio_recv() use a while loop
to read the samples from RX fifo.

This also fixes an issue where the return value of rz_ssi_pio_recv()
was ignored when called recursively.

Fixes: 03e786bd4341 ("ASoC: sh: Add RZ/G2L SSIF-2 driver")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20220110094711.8574-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 68 ++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index e8d98b362f9d..2ac2c9722b3b 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -411,54 +411,56 @@ static int rz_ssi_pio_recv(struct rz_ssi_priv *ssi, struct rz_ssi_stream *strm)
 {
 	struct snd_pcm_substream *substream = strm->substream;
 	struct snd_pcm_runtime *runtime;
+	bool done = false;
 	u16 *buf;
 	int fifo_samples;
 	int frames_left;
-	int samples = 0;
+	int samples;
 	int i;
 
 	if (!rz_ssi_stream_is_valid(ssi, strm))
 		return -EINVAL;
 
 	runtime = substream->runtime;
-	/* frames left in this period */
-	frames_left = runtime->period_size - (strm->buffer_pos %
-					      runtime->period_size);
-	if (frames_left == 0)
-		frames_left = runtime->period_size;
 
-	/* Samples in RX FIFO */
-	fifo_samples = (rz_ssi_reg_readl(ssi, SSIFSR) >>
-			SSIFSR_RDC_SHIFT) & SSIFSR_RDC_MASK;
-
-	/* Only read full frames at a time */
-	while (frames_left && (fifo_samples >= runtime->channels)) {
-		samples += runtime->channels;
-		fifo_samples -= runtime->channels;
-		frames_left--;
-	}
+	while (!done) {
+		/* frames left in this period */
+		frames_left = runtime->period_size -
+			      (strm->buffer_pos % runtime->period_size);
+		if (!frames_left)
+			frames_left = runtime->period_size;
+
+		/* Samples in RX FIFO */
+		fifo_samples = (rz_ssi_reg_readl(ssi, SSIFSR) >>
+				SSIFSR_RDC_SHIFT) & SSIFSR_RDC_MASK;
+
+		/* Only read full frames at a time */
+		samples = 0;
+		while (frames_left && (fifo_samples >= runtime->channels)) {
+			samples += runtime->channels;
+			fifo_samples -= runtime->channels;
+			frames_left--;
+		}
 
-	/* not enough samples yet */
-	if (samples == 0)
-		return 0;
+		/* not enough samples yet */
+		if (!samples)
+			break;
 
-	/* calculate new buffer index */
-	buf = (u16 *)(runtime->dma_area);
-	buf += strm->buffer_pos * runtime->channels;
+		/* calculate new buffer index */
+		buf = (u16 *)(runtime->dma_area);
+		buf += strm->buffer_pos * runtime->channels;
 
-	/* Note, only supports 16-bit samples */
-	for (i = 0; i < samples; i++)
-		*buf++ = (u16)(rz_ssi_reg_readl(ssi, SSIFRDR) >> 16);
+		/* Note, only supports 16-bit samples */
+		for (i = 0; i < samples; i++)
+			*buf++ = (u16)(rz_ssi_reg_readl(ssi, SSIFRDR) >> 16);
 
-	rz_ssi_reg_mask_setl(ssi, SSIFSR, SSIFSR_RDF, 0);
-	rz_ssi_pointer_update(strm, samples / runtime->channels);
+		rz_ssi_reg_mask_setl(ssi, SSIFSR, SSIFSR_RDF, 0);
+		rz_ssi_pointer_update(strm, samples / runtime->channels);
 
-	/*
-	 * If we finished this period, but there are more samples in
-	 * the RX FIFO, call this function again
-	 */
-	if (frames_left == 0 && fifo_samples >= runtime->channels)
-		rz_ssi_pio_recv(ssi, strm);
+		/* check if there are no more samples in the RX FIFO */
+		if (!(!frames_left && fifo_samples >= runtime->channels))
+			done = true;
+	}
 
 	return 0;
 }
-- 
2.34.1



