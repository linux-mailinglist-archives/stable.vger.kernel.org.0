Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D084213F7EF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733150AbgAPQ4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732570AbgAPQ4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E5F524680;
        Thu, 16 Jan 2020 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193763;
        bh=/LFljjM9wXtT7AF1NZ86AQkwrJppmbCRjR8pgtvV8dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlOjce5YaXePq/0zafStpmO7pqnn1E7wWIejS4TeHwUsSj/rBw1y3OWYgdNKEp7/w
         wEmuKEsQYdWvnIQ0zS3Df5zXR9mNcdIRUzI94e43ihN5aLMMqrQS4CS08aHT1B/ss2
         gdfVI66jGK/+3RePGintiwcKFs7nx+GZuPuBlixs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 049/671] ASoC: sun8i-codec: add missing route for ADC
Date:   Thu, 16 Jan 2020 11:44:40 -0500
Message-Id: <20200116165502.8838-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 9ee325d029c4abb75716851ce38863845911d605 ]

sun8i-codec misses a route from ADC to AIF1 Slot 0 ADC. Add it
to the driver to avoid adding it to every dts.

Fixes: eda85d1fee05d ("ASoC: sun8i-codec: Add ADC support for a33")
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun8i-codec.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sunxi/sun8i-codec.c b/sound/soc/sunxi/sun8i-codec.c
index bf615fa16dc8..a3db6a68dfe6 100644
--- a/sound/soc/sunxi/sun8i-codec.c
+++ b/sound/soc/sunxi/sun8i-codec.c
@@ -465,7 +465,11 @@ static const struct snd_soc_dapm_route sun8i_codec_dapm_routes[] = {
 	{ "Right Digital DAC Mixer", "AIF1 Slot 0 Digital DAC Playback Switch",
 	  "AIF1 Slot 0 Right"},
 
-	/* ADC routes */
+	/* ADC Routes */
+	{ "AIF1 Slot 0 Right ADC", NULL, "ADC" },
+	{ "AIF1 Slot 0 Left ADC", NULL, "ADC" },
+
+	/* ADC Mixer Routes */
 	{ "Left Digital ADC Mixer", "AIF1 Data Digital ADC Capture Switch",
 	  "AIF1 Slot 0 Left ADC" },
 	{ "Right Digital ADC Mixer", "AIF1 Data Digital ADC Capture Switch",
-- 
2.20.1

