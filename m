Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D715272F5C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgIUQ4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729264AbgIUQof (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DB5A23998;
        Mon, 21 Sep 2020 16:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706674;
        bh=A0X2pH/ayu0HHkp5Wg5d+5w4M1Qx4uUu3mKZE6m9nsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbKDjIdAbeP59vJn1g9UdG9NDWIqDFYqmlUoN8BVIU0oR4ekdVhwCH2Jgl+FM5EYH
         c4XEElCATNf8/ZeBAWlU2uwIfvOjMwTO4pl1K70esVuWKrqHDsRT5TwLO/j1pwbqtw
         eEXPQ0gbBzL0OP3OLVCPHnWbrMbNsgVUn5f6n6jQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Belin <nbelin@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 048/118] ASoC: meson: axg-toddr: fix channel order on g12 platforms
Date:   Mon, 21 Sep 2020 18:27:40 +0200
Message-Id: <20200921162038.548320048@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 9c4b205a20f483d8a5d1208cfec33e339347d4bd ]

On g12 and following platforms, The first channel of record with more than
2 channels ends being placed randomly on an even channel of the output.

On these SoCs, a bit was added to force the first channel to be placed at
the beginning of the output. Apparently the behavior if the bit is not set
is not easily predictable. According to the documentation, this bit is not
present on the axg series.

Set the bit on g12 and fix the problem.

Fixes: a3c23a8ad4dc ("ASoC: meson: axg-toddr: add g12a support")
Reported-by: Nicolas Belin <nbelin@baylibre.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20200828151438.350974-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-toddr.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/sound/soc/meson/axg-toddr.c b/sound/soc/meson/axg-toddr.c
index e711abcf8c124..d6adf7edea41f 100644
--- a/sound/soc/meson/axg-toddr.c
+++ b/sound/soc/meson/axg-toddr.c
@@ -18,6 +18,7 @@
 #define CTRL0_TODDR_SEL_RESAMPLE	BIT(30)
 #define CTRL0_TODDR_EXT_SIGNED		BIT(29)
 #define CTRL0_TODDR_PP_MODE		BIT(28)
+#define CTRL0_TODDR_SYNC_CH		BIT(27)
 #define CTRL0_TODDR_TYPE_MASK		GENMASK(15, 13)
 #define CTRL0_TODDR_TYPE(x)		((x) << 13)
 #define CTRL0_TODDR_MSB_POS_MASK	GENMASK(12, 8)
@@ -189,10 +190,31 @@ static const struct axg_fifo_match_data axg_toddr_match_data = {
 	.dai_drv		= &axg_toddr_dai_drv
 };
 
+static int g12a_toddr_dai_startup(struct snd_pcm_substream *substream,
+				 struct snd_soc_dai *dai)
+{
+	struct axg_fifo *fifo = snd_soc_dai_get_drvdata(dai);
+	int ret;
+
+	ret = axg_toddr_dai_startup(substream, dai);
+	if (ret)
+		return ret;
+
+	/*
+	 * Make sure the first channel ends up in the at beginning of the output
+	 * As weird as it looks, without this the first channel may be misplaced
+	 * in memory, with a random shift of 2 channels.
+	 */
+	regmap_update_bits(fifo->map, FIFO_CTRL0, CTRL0_TODDR_SYNC_CH,
+			   CTRL0_TODDR_SYNC_CH);
+
+	return 0;
+}
+
 static const struct snd_soc_dai_ops g12a_toddr_ops = {
 	.prepare	= g12a_toddr_dai_prepare,
 	.hw_params	= axg_toddr_dai_hw_params,
-	.startup	= axg_toddr_dai_startup,
+	.startup	= g12a_toddr_dai_startup,
 	.shutdown	= axg_toddr_dai_shutdown,
 };
 
-- 
2.25.1



