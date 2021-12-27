Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A788E480039
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhL0Pn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43318 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238519AbhL0Pl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C560DB810A3;
        Mon, 27 Dec 2021 15:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162E8C36AE7;
        Mon, 27 Dec 2021 15:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619713;
        bh=xB6y9pmk6BloWQEoNdPW63dT6FcKlLKhQkSvmXng4j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGG+hYm9NTCuscoVRvIYDVpE/eKDwH+O8OUbWbTsioW4yyyV9V3wp2w9G118u8wxk
         vmx+pHPfKQ2HydYv1lmLbckLcs1vsHWOUh1v5sVU/DFQ+PjJTJLujc37KJ63IQRVVi
         6maCG6M9XlYOF/9QCJIkzRG0Ur10IYer3JoTI0jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/128] ASoC: meson: aiu: fifo: Add missing dma_coerce_mask_and_coherent()
Date:   Mon, 27 Dec 2021 16:29:51 +0100
Message-Id: <20211227151332.063494733@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 1bcd326631dc4faa3322d60b4fc45e8b3747993e ]

The FIFO registers which take an DMA-able address are only 32-bit wide
on AIU. Add dma_coerce_mask_and_coherent() to make the DMA core aware of
this limitation.

Fixes: 6ae9ca9ce986bf ("ASoC: meson: aiu: add i2s and spdif support")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20211206210804.2512999-2-martin.blumenstingl@googlemail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/aiu-fifo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/meson/aiu-fifo.c b/sound/soc/meson/aiu-fifo.c
index 4ad23267cace5..d67ff4cdabd5a 100644
--- a/sound/soc/meson/aiu-fifo.c
+++ b/sound/soc/meson/aiu-fifo.c
@@ -5,6 +5,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dai.h>
@@ -179,6 +180,11 @@ int aiu_fifo_pcm_new(struct snd_soc_pcm_runtime *rtd,
 	struct snd_card *card = rtd->card->snd_card;
 	struct aiu_fifo *fifo = dai->playback_dma_data;
 	size_t size = fifo->pcm->buffer_bytes_max;
+	int ret;
+
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	snd_pcm_set_managed_buffer_all(rtd->pcm, SNDRV_DMA_TYPE_DEV,
 				       card->dev, size, size);
-- 
2.34.1



