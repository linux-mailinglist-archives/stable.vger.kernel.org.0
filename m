Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A4A29BF5A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793716AbgJ0PH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2899198AbgJ0PAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:00:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD13A22284;
        Tue, 27 Oct 2020 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810840;
        bh=JCqkuyZ3RSpGTdzTJQyAtefNvboJJGIa/QlusIln+oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXURm2XlStKzxki3aF3YcZGMvMfV8dynf4VGKBYyx3ul5oyok5BVzpjwRE/EbVABO
         SUWIxfnDf2xFbCVUp0af2xAQHBbOeaQv762r6JqrVycEAwrbyMPmaFh1TsgAJWU0xT
         KhZidLg+cLH9HEavlKAdGJkylzLSC5ADsiRFtvF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 250/633] ASoC: tlv320aic32x4: Fix bdiv clock rate derivation
Date:   Tue, 27 Oct 2020 14:49:53 +0100
Message-Id: <20201027135534.405128668@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 40b37136287ba6b34aa2f1f6123f3d6d205dc2f0 ]

Current code expects a single channel to be always used. Fix this
situation by forwarding the number of channels used. Then fix the
derivation of the bdiv clock rate.

Fixes: 96c3bb00239d ("ASoC: tlv320aic32x4: Dynamically Determine Clocking")
Suggested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20200911173140.29984-3-miquel.raynal@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index d087f3b20b1d5..50b66cf9ea8f9 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -665,7 +665,7 @@ static int aic32x4_set_processing_blocks(struct snd_soc_component *component,
 }
 
 static int aic32x4_setup_clocks(struct snd_soc_component *component,
-				unsigned int sample_rate)
+				unsigned int sample_rate, unsigned int channels)
 {
 	u8 aosr;
 	u16 dosr;
@@ -753,7 +753,9 @@ static int aic32x4_setup_clocks(struct snd_soc_component *component,
 							dosr);
 
 						clk_set_rate(clocks[5].clk,
-							sample_rate * 32);
+							sample_rate * 32 *
+							channels);
+
 						return 0;
 					}
 				}
@@ -775,7 +777,8 @@ static int aic32x4_hw_params(struct snd_pcm_substream *substream,
 	u8 iface1_reg = 0;
 	u8 dacsetup_reg = 0;
 
-	aic32x4_setup_clocks(component, params_rate(params));
+	aic32x4_setup_clocks(component, params_rate(params),
+			     params_channels(params));
 
 	switch (params_width(params)) {
 	case 16:
-- 
2.25.1



