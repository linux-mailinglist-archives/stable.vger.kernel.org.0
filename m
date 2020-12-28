Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B9C2E6444
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408256AbgL1Ptj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404134AbgL1NmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCC4321D94;
        Mon, 28 Dec 2020 13:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162893;
        bh=/tBF4wLTT/bWMpAG6Ixir2YRrjI8wrg63knwE7ip8/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYUQvQULwfc6Y6jxwlxMe7pPy8H2TNi8Z4I98ise20s7vYy8w0vncp7lbnzvWjQTH
         54QmxOvKXioF1k86MW5AdD3iAn26SWkeIDmAh2DEkTl4WYMcqjrnzdzkbY5jD7PPyL
         EJH91O9ThSJVh6r2PBMZJziZO3+79T0DhkmR5uko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/453] ASoC: sun4i-i2s: Fix lrck_period computation for I2S justified mode
Date:   Mon, 28 Dec 2020 13:45:33 +0100
Message-Id: <20201228124941.896113299@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Péron <peron.clem@gmail.com>

[ Upstream commit 93c0210671d8f3ec2262da703fab93a1497158a8 ]

Left and Right justified mode are computed using the same formula
as DSP_A and DSP_B mode.
Which is wrong and the user manual explicitly says:

LRCK_PERDIOD:
PCM Mode: Number of BCLKs within (Left + Right) channel width.
I2S/Left-Justified/Right-Justified Mode: Number of BCLKs within each
individual channel width(Left or Right)

Fix this by using the same formula as the I2S mode.

Fixes: 7ae7834ec446 ("ASoC: sun4i-i2s: Add support for DSP formats")
Signed-off-by: Clément Péron <peron.clem@gmail.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20201030144648.397824-2-peron.clem@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-i2s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sunxi/sun4i-i2s.c b/sound/soc/sunxi/sun4i-i2s.c
index d0a8d5810c0a5..9655dec4166b6 100644
--- a/sound/soc/sunxi/sun4i-i2s.c
+++ b/sound/soc/sunxi/sun4i-i2s.c
@@ -442,11 +442,11 @@ static int sun8i_i2s_set_chan_cfg(const struct sun4i_i2s *i2s,
 	switch (i2s->format & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_DSP_A:
 	case SND_SOC_DAIFMT_DSP_B:
-	case SND_SOC_DAIFMT_LEFT_J:
-	case SND_SOC_DAIFMT_RIGHT_J:
 		lrck_period = params_physical_width(params) * slots;
 		break;
 
+	case SND_SOC_DAIFMT_LEFT_J:
+	case SND_SOC_DAIFMT_RIGHT_J:
 	case SND_SOC_DAIFMT_I2S:
 		lrck_period = params_physical_width(params);
 		break;
-- 
2.27.0



