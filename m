Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231033ED59A
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbhHPNM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238554AbhHPNHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:07:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B28FB6328D;
        Mon, 16 Aug 2021 13:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119209;
        bh=bze5kZnjIDqbXpUFTLHN6hnMRd3CqCvRXNeKhqUNPz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=no2RQ3QOQ9/IF2wxlxi0Dlplaz+99JN3H9lTqZQGr+KP8AEwRaJ3YscgfhhTijmIX
         J/UUNAsUmfS2MsY1d25r9qNcfYcYJ6goTbWhQ3P/lLhuSesYvl/2oNi4fGLyOsqnOw
         Isz7CZcNJuAFpSi5i2WrUMS+otLMzVavFQjqOIv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 06/96] ASoC: xilinx: Fix reference to PCM buffer address
Date:   Mon, 16 Aug 2021 15:01:16 +0200
Message-Id: <20210816125435.147602768@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 42bc62c9f1d3d4880bdc27acb5ab4784209bb0b0 upstream.

PCM buffers might be allocated dynamically when the buffer
preallocation failed or a larger buffer is requested, and it's not
guaranteed that substream->dma_buffer points to the actually used
buffer.  The driver needs to refer to substream->runtime->dma_addr
instead for the buffer address.

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20210728112353.6675-4-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/xilinx/xlnx_formatter_pcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -452,8 +452,8 @@ static int xlnx_formatter_pcm_hw_params(
 
 	stream_data->buffer_size = size;
 
-	low = lower_32_bits(substream->dma_buffer.addr);
-	high = upper_32_bits(substream->dma_buffer.addr);
+	low = lower_32_bits(runtime->dma_addr);
+	high = upper_32_bits(runtime->dma_addr);
 	writel(low, stream_data->mmio + XLNX_AUD_BUFF_ADDR_LSB);
 	writel(high, stream_data->mmio + XLNX_AUD_BUFF_ADDR_MSB);
 


