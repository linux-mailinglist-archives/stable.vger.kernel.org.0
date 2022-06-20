Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803AB551A3E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243063AbiFTMyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243062AbiFTMyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:54:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546ED167E9;
        Mon, 20 Jun 2022 05:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE172B811B3;
        Mon, 20 Jun 2022 12:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4C9C3411B;
        Mon, 20 Jun 2022 12:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729646;
        bh=bk35GxZMSvgCi98hPj3XUWJh2GZvRMQ+zORPkX2Ju3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5jVZ6TLiVYuKv3PHbGvLxhTrFi4pQeDL129rMZGt4xO5rvOqzZaMAVtF8/OSjVdE
         VugY7/n87+LaY0OJdnWQgP8i6CWZgfIN34qfL0vfVT05HMrwZu5gIY7R+3QJazGrvG
         nR/7SsoxiasjcWyl6SFPbj9iULD87yGJkPifIvHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Lin <ctlin0@nuvoton.com>,
        John Hsu <kchsu0@nuvoton.com>, Seven Li <wtli@nuvoton.com>,
        Hui Wang <hui.wang@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 006/141] ASoC: nau8822: Add operation for internal PLL off and on
Date:   Mon, 20 Jun 2022 14:49:04 +0200
Message-Id: <20220620124729.704218116@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit aeca8a3295022bcec46697f16e098140423d8463 ]

We tried to enable the audio on an imx6sx EVB with the codec nau8822,
after setting the internal PLL fractional parameters, the audio still
couldn't work and the there was no sdma irq at all.

After checking with the section "8.1.1 Phase Locked Loop (PLL) Design
Example" of "NAU88C22 Datasheet Rev 0.6", we found we need to
turn off the PLL before programming fractional parameters and turn on
the PLL after programming.

After this change, the audio driver could record and play sound and
the sdma's irq is triggered when playing or recording.

Cc: David Lin <ctlin0@nuvoton.com>
Cc: John Hsu <kchsu0@nuvoton.com>
Cc: Seven Li <wtli@nuvoton.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20220530040151.95221-2-hui.wang@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8822.c | 4 ++++
 sound/soc/codecs/nau8822.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/sound/soc/codecs/nau8822.c b/sound/soc/codecs/nau8822.c
index 58123390c7a3..b436e532993d 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -740,6 +740,8 @@ static int nau8822_set_pll(struct snd_soc_dai *dai, int pll_id, int source,
 		pll_param->pll_int, pll_param->pll_frac,
 		pll_param->mclk_scaler, pll_param->pre_factor);
 
+	snd_soc_component_update_bits(component,
+		NAU8822_REG_POWER_MANAGEMENT_1, NAU8822_PLL_EN_MASK, NAU8822_PLL_OFF);
 	snd_soc_component_update_bits(component,
 		NAU8822_REG_PLL_N, NAU8822_PLLMCLK_DIV2 | NAU8822_PLLN_MASK,
 		(pll_param->pre_factor ? NAU8822_PLLMCLK_DIV2 : 0) |
@@ -757,6 +759,8 @@ static int nau8822_set_pll(struct snd_soc_dai *dai, int pll_id, int source,
 		pll_param->mclk_scaler << NAU8822_MCLKSEL_SFT);
 	snd_soc_component_update_bits(component,
 		NAU8822_REG_CLOCKING, NAU8822_CLKM_MASK, NAU8822_CLKM_PLL);
+	snd_soc_component_update_bits(component,
+		NAU8822_REG_POWER_MANAGEMENT_1, NAU8822_PLL_EN_MASK, NAU8822_PLL_ON);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/nau8822.h b/sound/soc/codecs/nau8822.h
index 489191ff187e..b45d42c15de6 100644
--- a/sound/soc/codecs/nau8822.h
+++ b/sound/soc/codecs/nau8822.h
@@ -90,6 +90,9 @@
 #define NAU8822_REFIMP_3K			0x3
 #define NAU8822_IOBUF_EN			(0x1 << 2)
 #define NAU8822_ABIAS_EN			(0x1 << 3)
+#define NAU8822_PLL_EN_MASK			(0x1 << 5)
+#define NAU8822_PLL_ON				(0x1 << 5)
+#define NAU8822_PLL_OFF				(0x0 << 5)
 
 /* NAU8822_REG_AUDIO_INTERFACE (0x4) */
 #define NAU8822_AIFMT_MASK			(0x3 << 3)
-- 
2.35.1



