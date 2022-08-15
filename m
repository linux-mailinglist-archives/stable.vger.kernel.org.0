Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4255B5950B6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiHPEou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiHPEn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:43:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B859E18D5B9;
        Mon, 15 Aug 2022 13:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 540C5B8114A;
        Mon, 15 Aug 2022 20:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ECDC433C1;
        Mon, 15 Aug 2022 20:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595930;
        bh=e2TD9E+SVyiUU6IIoHXUF+v0E/GZ5txe1BePd/12NS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uf+821/hHj2wufUFPeEDqoFrw5WeMM/KgXOBRZeEpYtfK03WA/P4VSPywstf9J+cL
         Kyf8JdlC9UtFVCAVFBuS7J/KMibSfV0YVPRWmOtdkttpiAZs1CZn6HXoenoPBj2xhh
         YDwKvrcJ9IqIl+k4zvnRvnlcAGAJQZo0IDENRBmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0919/1157] ASoC: samsung: change gpiod_speaker_power and rx1950_audio from global to static variables
Date:   Mon, 15 Aug 2022 20:04:35 +0200
Message-Id: <20220815180516.207752776@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index ff3acc94a454..abf28321f7d7 100644
--- a/sound/soc/samsung/rx1950_uda1380.c
+++ b/sound/soc/samsung/rx1950_uda1380.c
@@ -128,7 +128,7 @@ static int rx1950_startup(struct snd_pcm_substream *substream)
 					&hw_rates);
 }
 
-struct gpio_desc *gpiod_speaker_power;
+static struct gpio_desc *gpiod_speaker_power;
 
 static int rx1950_spk_power(struct snd_soc_dapm_widget *w,
 				struct snd_kcontrol *kcontrol, int event)
@@ -228,7 +228,7 @@ static int rx1950_probe(struct platform_device *pdev)
 	return devm_snd_soc_register_card(dev, &rx1950_asoc);
 }
 
-struct platform_driver rx1950_audio = {
+static struct platform_driver rx1950_audio = {
 	.driver = {
 		.name = "rx1950-audio",
 		.pm = &snd_soc_pm_ops,
-- 
2.35.1



