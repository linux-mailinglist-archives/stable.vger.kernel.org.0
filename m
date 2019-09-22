Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17109BAA41
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfIVTYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404107AbfIVSxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:53:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B494821BE5;
        Sun, 22 Sep 2019 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178381;
        bh=kfvdiciDmqZ1VtqoBpuDh3Z6dlpATwLZE7GsvgO6uLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNAdVfn+p2R4freK5ZPpCvemxEKZKleMo7F+rvl67OKANyfkHhOGUdjso10vFdjX4
         627J6ulOkO+v7sVqT1M5X2aHSrHmMXkDYSK6d9QtcwAa8Njqh3ewgOxg7gHZ4MqCmI
         GkzH4AFpqwalXBnW5E4nhFgD+PKzNqb/BDXX0w1k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.2 129/185] ASoC: fsl_ssi: Fix clock control issue in master mode
Date:   Sun, 22 Sep 2019 14:48:27 -0400
Message-Id: <20190922184924.32534-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 696d05225cebffd172008d212657be90e823eac0 ]

The test case is
arecord -Dhw:0 -d 10 -f S16_LE -r 48000 -c 2 temp.wav &
aplay -Dhw:0 -d 30 -f S16_LE -r 48000 -c 2 test.wav

There will be error after end of arecord:
aplay: pcm_write:2051: write error: Input/output error

Capture and Playback work in parallel in master mode, one
substream stops, the other substream is impacted, the
reason is that clock is disabled wrongly.

The clock's reference count is not increased when second
substream starts, the hw_param() function returns in the
beginning because first substream is enabled, then in end
of first substream, the hw_free() disables the clock.

This patch is to move the clock enablement to the place
before checking of the device enablement in hw_param().

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1567012817-12625-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_ssi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 09b2967befd96..d83be26d64467 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -799,15 +799,6 @@ static int fsl_ssi_hw_params(struct snd_pcm_substream *substream,
 	u32 wl = SSI_SxCCR_WL(sample_size);
 	int ret;
 
-	/*
-	 * SSI is properly configured if it is enabled and running in
-	 * the synchronous mode; Note that AC97 mode is an exception
-	 * that should set separate configurations for STCCR and SRCCR
-	 * despite running in the synchronous mode.
-	 */
-	if (ssi->streams && ssi->synchronous)
-		return 0;
-
 	if (fsl_ssi_is_i2s_master(ssi)) {
 		ret = fsl_ssi_set_bclk(substream, dai, hw_params);
 		if (ret)
@@ -823,6 +814,15 @@ static int fsl_ssi_hw_params(struct snd_pcm_substream *substream,
 		}
 	}
 
+	/*
+	 * SSI is properly configured if it is enabled and running in
+	 * the synchronous mode; Note that AC97 mode is an exception
+	 * that should set separate configurations for STCCR and SRCCR
+	 * despite running in the synchronous mode.
+	 */
+	if (ssi->streams && ssi->synchronous)
+		return 0;
+
 	if (!fsl_ssi_is_ac97(ssi)) {
 		/*
 		 * Keep the ssi->i2s_net intact while having a local variable
-- 
2.20.1

