Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3016C594584
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348683AbiHOW3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351070AbiHOW1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57961422D1;
        Mon, 15 Aug 2022 12:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 197E0B80EB2;
        Mon, 15 Aug 2022 19:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EB7C433D6;
        Mon, 15 Aug 2022 19:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592816;
        bh=DxR5Te+0hr5YPpVC4TDSEMJ/BVrdzLv1VvmTAOdfL3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdhUyics8wCDWsDBg/SbQ8KqDx+7D5ac7aTuLHBsqzzhdi6Z15FzO9nwuyJdVhw6o
         haCNjveIowU8LICgWHRPo2h3Rk6C2jbUIgB88bAIWBJwu2wEMS4sf/lq2z+oczf1Rk
         RA3oDDjOJlfmNpdlYaBnGoSiZi4eKeC84Uat5NjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0849/1095] ASoC: samsung: change gpiod_speaker_power and rx1950_audio from global to static variables
Date:   Mon, 15 Aug 2022 20:04:08 +0200
Message-Id: <20220815180504.456123383@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit d2294461b90e0c5b3bbfaaf2c8baff4fd3e2bb13 ]

sparse reports
sound/soc/samsung/rx1950_uda1380.c:131:18: warning: symbol 'gpiod_speaker_power' was not declared. Should it be static?
sound/soc/samsung/rx1950_uda1380.c:231:24: warning: symbol 'rx1950_audio' was not declared. Should it be static?

Both gpiod_speaker_power and rx1950_audio are only used in rx1950_uda1380.c,
so their storage class specifiers should be static.

Fixes: 83d74e354200 ("ASoC: samsung: rx1950: turn into platform driver")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220629185345.910406-1-trix@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/rx1950_uda1380.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/rx1950_uda1380.c b/sound/soc/samsung/rx1950_uda1380.c
index 6ea1c8cc9167..2820097b00b9 100644
--- a/sound/soc/samsung/rx1950_uda1380.c
+++ b/sound/soc/samsung/rx1950_uda1380.c
@@ -128,7 +128,7 @@ static int rx1950_startup(struct snd_pcm_substream *substream)
 					&hw_rates);
 }
 
-struct gpio_desc *gpiod_speaker_power;
+static struct gpio_desc *gpiod_speaker_power;
 
 static int rx1950_spk_power(struct snd_soc_dapm_widget *w,
 				struct snd_kcontrol *kcontrol, int event)
@@ -227,7 +227,7 @@ static int rx1950_probe(struct platform_device *pdev)
 	return devm_snd_soc_register_card(dev, &rx1950_asoc);
 }
 
-struct platform_driver rx1950_audio = {
+static struct platform_driver rx1950_audio = {
 	.driver = {
 		.name = "rx1950-audio",
 		.pm = &snd_soc_pm_ops,
-- 
2.35.1



