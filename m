Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A6E382E79
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237948AbhEQOHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237941AbhEQOGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65FDB6135F;
        Mon, 17 May 2021 14:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260332;
        bh=5O2liwMqaZt4lhfiaWK8N2et4qlF4GWYC3Ye/22lyGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nd+/BJ+iyiU0JrM0XuB0YFAw+1vTxCmdx51QvcsJW1VAQSryQ4exq8SCR2kkOVAot
         t/yuuH+/mG9Tzv3zSY9Z5nnxoCEvRYUa6XwCBTadHaBjomL7YiGuvekeQyEnIopOoO
         ALCqpyTVxjslCLy9ecNqe7IdAe6TTJIIDl/UCcuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikhail Durnev <mikhail_durnev@mentor.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 026/363] ASoC: rsnd: core: Check convert rate in rsnd_hw_params
Date:   Mon, 17 May 2021 15:58:12 +0200
Message-Id: <20210517140303.467211766@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikhail Durnev <mikhail_durnev@mentor.com>

[ Upstream commit 19c6a63ced5e07e40f3a5255cb1f0fe0d3be7b14 ]

snd_pcm_hw_params_set_rate_near can return incorrect sample rate in
some cases, e.g. when the backend output rate is set to some value higher
than 48000 Hz and the input rate is 8000 Hz. So passing the value returned
by snd_pcm_hw_params_set_rate_near to snd_pcm_hw_params will result in
"FSO/FSI ratio error" and playing no audio at all while the userland
is not properly notified about the issue.

If SRC is unable to convert the requested sample rate to the sample rate
the backend is using, then the requested sample rate should be adjusted in
rsnd_hw_params. The userland will be notified about that change in the
returned hw_params structure.

Signed-off-by: Mikhail Durnev <mikhail_durnev@mentor.com>
Link: https://lore.kernel.org/r/1615870055-13954-1-git-send-email-mikhail_durnev@mentor.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/core.c | 69 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index 1029d8d9d800..d2b4632d9c2a 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1428,8 +1428,75 @@ static int rsnd_hw_params(struct snd_soc_component *component,
 		}
 		if (io->converted_chan)
 			dev_dbg(dev, "convert channels = %d\n", io->converted_chan);
-		if (io->converted_rate)
+		if (io->converted_rate) {
+			/*
+			 * SRC supports convert rates from params_rate(hw_params)/k_down
+			 * to params_rate(hw_params)*k_up, where k_up is always 6, and
+			 * k_down depends on number of channels and SRC unit.
+			 * So all SRC units can upsample audio up to 6 times regardless
+			 * its number of channels. And all SRC units can downsample
+			 * 2 channel audio up to 6 times too.
+			 */
+			int k_up = 6;
+			int k_down = 6;
+			int channel;
+			struct rsnd_mod *src_mod = rsnd_io_to_mod_src(io);
+
 			dev_dbg(dev, "convert rate     = %d\n", io->converted_rate);
+
+			channel = io->converted_chan ? io->converted_chan :
+				  params_channels(hw_params);
+
+			switch (rsnd_mod_id(src_mod)) {
+			/*
+			 * SRC0 can downsample 4, 6 and 8 channel audio up to 4 times.
+			 * SRC1, SRC3 and SRC4 can downsample 4 channel audio
+			 * up to 4 times.
+			 * SRC1, SRC3 and SRC4 can downsample 6 and 8 channel audio
+			 * no more than twice.
+			 */
+			case 1:
+			case 3:
+			case 4:
+				if (channel > 4) {
+					k_down = 2;
+					break;
+				}
+				fallthrough;
+			case 0:
+				if (channel > 2)
+					k_down = 4;
+				break;
+
+			/* Other SRC units do not support more than 2 channels */
+			default:
+				if (channel > 2)
+					return -EINVAL;
+			}
+
+			if (params_rate(hw_params) > io->converted_rate * k_down) {
+				hw_param_interval(hw_params, SNDRV_PCM_HW_PARAM_RATE)->min =
+					io->converted_rate * k_down;
+				hw_param_interval(hw_params, SNDRV_PCM_HW_PARAM_RATE)->max =
+					io->converted_rate * k_down;
+				hw_params->cmask |= SNDRV_PCM_HW_PARAM_RATE;
+			} else if (params_rate(hw_params) * k_up < io->converted_rate) {
+				hw_param_interval(hw_params, SNDRV_PCM_HW_PARAM_RATE)->min =
+					(io->converted_rate + k_up - 1) / k_up;
+				hw_param_interval(hw_params, SNDRV_PCM_HW_PARAM_RATE)->max =
+					(io->converted_rate + k_up - 1) / k_up;
+				hw_params->cmask |= SNDRV_PCM_HW_PARAM_RATE;
+			}
+
+			/*
+			 * TBD: Max SRC input and output rates also depend on number
+			 * of channels and SRC unit:
+			 * SRC1, SRC3 and SRC4 do not support more than 128kHz
+			 * for 6 channel and 96kHz for 8 channel audio.
+			 * Perhaps this function should return EINVAL if the input or
+			 * the output rate exceeds the limitation.
+			 */
+		}
 	}
 
 	return rsnd_dai_call(hw_params, io, substream, hw_params);
-- 
2.30.2



