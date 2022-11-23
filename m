Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9A4635807
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbiKWJuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236610AbiKWJtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5A1112C41
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 153B6B81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690B9C433C1;
        Wed, 23 Nov 2022 09:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196774;
        bh=3tLvJtMNbBd47YR9+bv6xKmABh2xvsfhJQRQlVP21c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kb/6qWU2HKGqfhq+9WirBv1IYpDGcfonUaG6tmEzgai+w91vgaUhhbcdd5AGWosQG
         YUk4Wl6jDd+ekiQrRtq64oVTE/N4E4yZ2n8gJ1M/eC/QyF5h2MuLbTknKrs5E04Lpu
         Qg2vcc6HV0iqQK9detE3ocxEecGEMIoaLjwBb98c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Montleon <jmontleo@redhat.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 103/314] ASoC: rt5677: fix legacy dai naming
Date:   Wed, 23 Nov 2022 09:49:08 +0100
Message-Id: <20221123084630.162795459@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Montleon <jmontleo@redhat.com>

[ Upstream commit a1dca8774faf3f77eb34fa0ac6f3e2b82290b1e4 ]

Starting with 6.0-rc1 the CPU DAI is not registered and the sound
card is unavailable. Adding legacy_dai_naming causes it to function
properly again.

Fixes: fc34ece41f71 ("ASoC: Refactor non_legacy_dai_naming flag")
Signed-off-by: Jason Montleon <jmontleo@redhat.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221103144612.4431-2-jmontleo@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5677-spi.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/rt5677-spi.c b/sound/soc/codecs/rt5677-spi.c
index 8f3993a4c1cc..d25703dd7499 100644
--- a/sound/soc/codecs/rt5677-spi.c
+++ b/sound/soc/codecs/rt5677-spi.c
@@ -396,15 +396,16 @@ static int rt5677_spi_pcm_probe(struct snd_soc_component *component)
 }
 
 static const struct snd_soc_component_driver rt5677_spi_dai_component = {
-	.name		= DRV_NAME,
-	.probe		= rt5677_spi_pcm_probe,
-	.open		= rt5677_spi_pcm_open,
-	.close		= rt5677_spi_pcm_close,
-	.hw_params	= rt5677_spi_hw_params,
-	.hw_free	= rt5677_spi_hw_free,
-	.prepare	= rt5677_spi_prepare,
-	.pointer	= rt5677_spi_pcm_pointer,
-	.pcm_construct	= rt5677_spi_pcm_new,
+	.name			= DRV_NAME,
+	.probe			= rt5677_spi_pcm_probe,
+	.open			= rt5677_spi_pcm_open,
+	.close			= rt5677_spi_pcm_close,
+	.hw_params		= rt5677_spi_hw_params,
+	.hw_free		= rt5677_spi_hw_free,
+	.prepare		= rt5677_spi_prepare,
+	.pointer		= rt5677_spi_pcm_pointer,
+	.pcm_construct		= rt5677_spi_pcm_new,
+	.legacy_dai_naming	= 1,
 };
 
 /* Select a suitable transfer command for the next transfer to ensure
-- 
2.35.1



