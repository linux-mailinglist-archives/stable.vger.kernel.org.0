Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E89D1921A
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfEISr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbfEISrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E1A20578;
        Thu,  9 May 2019 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427674;
        bh=4mFI387IeNJ4MiJZrdLcUmO36LiP/VWMQVImiHpAHgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGnGIKyuk+y4GD8TGDKHD35e+8rjO3x/V5wCCdxpLR69mzTF54+hXD5kQs8N5V9KD
         96yk6jlnEmU2Hxmh+SBzrKaXcJH1ArkpjuuTsY+VhxNavpYlk3LJ/izdS/Zz7bzo78
         SkqQrh121uxXBIXcFwzgvn6PmuOK4JBg5n8YZUBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/66] ASoC: stm32: sai: fix exposed capabilities in spdif mode
Date:   Thu,  9 May 2019 20:41:45 +0200
Message-Id: <20190509181302.985812404@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b8468192971807c43a80d6e2c41f83141cb7b211 ]

Change capabilities exposed in SAI S/PDIF mode, to match
actually supported formats.
In S/PDIF mode only 32 bits stereo is supported.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index e8df3cc341b5e..2fb2b914e78b4 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -498,6 +498,14 @@ static int stm32_sai_startup(struct snd_pcm_substream *substream,
 
 	sai->substream = substream;
 
+	if (STM_SAI_PROTOCOL_IS_SPDIF(sai)) {
+		snd_pcm_hw_constraint_mask64(substream->runtime,
+					     SNDRV_PCM_HW_PARAM_FORMAT,
+					     SNDRV_PCM_FMTBIT_S32_LE);
+		snd_pcm_hw_constraint_single(substream->runtime,
+					     SNDRV_PCM_HW_PARAM_CHANNELS, 2);
+	}
+
 	ret = clk_prepare_enable(sai->sai_ck);
 	if (ret < 0) {
 		dev_err(cpu_dai->dev, "Failed to enable clock: %d\n", ret);
-- 
2.20.1



