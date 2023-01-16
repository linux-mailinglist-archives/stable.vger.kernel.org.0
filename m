Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E391366C5EC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbjAPQMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjAPQLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:11:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BEF29E24
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:07:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62020B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B643BC43392;
        Mon, 16 Jan 2023 16:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885239;
        bh=7F/ZC/lO+Y4Ws1SXSieUHR2GMHE9o1NUDaZghvCD7g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIP5VlL+EyIGxHXA8o1xL+YUztcbPH0sVBZBfTG0wLBMQp/0L5EpnPYr4mi722puM
         xF0CY4cJlx5+Ofn9QQbATMV1Zun6xvb+hAENNohv15IjcjnZIjMNF0MMDbUScoW3bF
         pIK+5IJ/+DrpU9Q70J3KtVvIm0DyW2VLb3wcrMJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/64] ASoC: wm8904: fix wrong outputs volume after power reactivation
Date:   Mon, 16 Jan 2023 16:51:47 +0100
Message-Id: <20230116154744.944811678@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 472a6309c6467af89dbf660a8310369cc9cb041f ]

Restore volume after charge pump and PGA activation to ensure
that volume settings are correctly applied when re-enabling codec
from SND_SOC_BIAS_OFF state.
CLASS_W, CHARGE_PUMP and POWER_MANAGEMENT_2 register configuration
affect how the volume register are applied and must be configured first.

Fixes: a91eb199e4dc ("ASoC: Initial WM8904 CODEC driver")
Link: https://lore.kernel.org/all/c7864c35-738c-a867-a6a6-ddf9f98df7e7@gmail.com/
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221223080247.7258-1-francesco@dolcini.it
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8904.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 1c360bae5652..cc96c9bdff41 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -697,6 +697,7 @@ static int out_pga_event(struct snd_soc_dapm_widget *w,
 	int dcs_mask;
 	int dcs_l, dcs_r;
 	int dcs_l_reg, dcs_r_reg;
+	int an_out_reg;
 	int timeout;
 	int pwr_reg;
 
@@ -712,6 +713,7 @@ static int out_pga_event(struct snd_soc_dapm_widget *w,
 		dcs_mask = WM8904_DCS_ENA_CHAN_0 | WM8904_DCS_ENA_CHAN_1;
 		dcs_r_reg = WM8904_DC_SERVO_8;
 		dcs_l_reg = WM8904_DC_SERVO_9;
+		an_out_reg = WM8904_ANALOGUE_OUT1_LEFT;
 		dcs_l = 0;
 		dcs_r = 1;
 		break;
@@ -720,6 +722,7 @@ static int out_pga_event(struct snd_soc_dapm_widget *w,
 		dcs_mask = WM8904_DCS_ENA_CHAN_2 | WM8904_DCS_ENA_CHAN_3;
 		dcs_r_reg = WM8904_DC_SERVO_6;
 		dcs_l_reg = WM8904_DC_SERVO_7;
+		an_out_reg = WM8904_ANALOGUE_OUT2_LEFT;
 		dcs_l = 2;
 		dcs_r = 3;
 		break;
@@ -792,6 +795,10 @@ static int out_pga_event(struct snd_soc_dapm_widget *w,
 		snd_soc_component_update_bits(component, reg,
 				    WM8904_HPL_ENA_OUTP | WM8904_HPR_ENA_OUTP,
 				    WM8904_HPL_ENA_OUTP | WM8904_HPR_ENA_OUTP);
+
+		/* Update volume, requires PGA to be powered */
+		val = snd_soc_component_read(component, an_out_reg);
+		snd_soc_component_write(component, an_out_reg, val);
 		break;
 
 	case SND_SOC_DAPM_POST_PMU:
-- 
2.35.1



