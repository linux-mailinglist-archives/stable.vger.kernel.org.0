Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336FE6357A6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbiKWJn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiKWJnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84ACD80
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:41:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78CDF61A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C02EC433D6;
        Wed, 23 Nov 2022 09:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196467;
        bh=hHn3uj9udXEW2PsBihWFWubMIXeVhEdzeMEIGSruT8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmBvFvhvdNy113GHaeazyYVyuN2d8jpN9J+bAGoADjB5MMbxdX21VStnHvmu0EQKj
         mGre3Dr2Q3q7Yghicjt5mcl5zvyQtHL+Ts7pfZ/K6AGADaBgHntRYOfYED8Z23RKc9
         dBU4w6KZNgMiVoqfx9uMnWQ+uCdcth4SEajwUm30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 009/314] ASoC: rt1019: Fix the TDM settings
Date:   Wed, 23 Nov 2022 09:47:34 +0100
Message-Id: <20221123084625.916915339@linuxfoundation.org>
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

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit f2635d45a750182c6d5de15e2d6b059e0c302d7e ]

Complete the missing and correct the TDM settings.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20221012030102.4042-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1019.c | 20 +++++++++++---------
 sound/soc/codecs/rt1019.h |  6 ++++++
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/rt1019.c b/sound/soc/codecs/rt1019.c
index b66bfecbb879..49f527c61a7a 100644
--- a/sound/soc/codecs/rt1019.c
+++ b/sound/soc/codecs/rt1019.c
@@ -391,18 +391,18 @@ static int rt1019_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 			unsigned int rx_mask, int slots, int slot_width)
 {
 	struct snd_soc_component *component = dai->component;
-	unsigned int val = 0, rx_slotnum;
+	unsigned int cn = 0, cl = 0, rx_slotnum;
 	int ret = 0, first_bit;
 
 	switch (slots) {
 	case 4:
-		val |= RT1019_I2S_TX_4CH;
+		cn = RT1019_I2S_TX_4CH;
 		break;
 	case 6:
-		val |= RT1019_I2S_TX_6CH;
+		cn = RT1019_I2S_TX_6CH;
 		break;
 	case 8:
-		val |= RT1019_I2S_TX_8CH;
+		cn = RT1019_I2S_TX_8CH;
 		break;
 	case 2:
 		break;
@@ -412,16 +412,16 @@ static int rt1019_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 
 	switch (slot_width) {
 	case 20:
-		val |= RT1019_I2S_DL_20;
+		cl = RT1019_TDM_CL_20;
 		break;
 	case 24:
-		val |= RT1019_I2S_DL_24;
+		cl = RT1019_TDM_CL_24;
 		break;
 	case 32:
-		val |= RT1019_I2S_DL_32;
+		cl = RT1019_TDM_CL_32;
 		break;
 	case 8:
-		val |= RT1019_I2S_DL_8;
+		cl = RT1019_TDM_CL_8;
 		break;
 	case 16:
 		break;
@@ -470,8 +470,10 @@ static int rt1019_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 		goto _set_tdm_err_;
 	}
 
+	snd_soc_component_update_bits(component, RT1019_TDM_1,
+		RT1019_TDM_CL_MASK, cl);
 	snd_soc_component_update_bits(component, RT1019_TDM_2,
-		RT1019_I2S_CH_TX_MASK | RT1019_I2S_DF_MASK, val);
+		RT1019_I2S_CH_TX_MASK, cn);
 
 _set_tdm_err_:
 	return ret;
diff --git a/sound/soc/codecs/rt1019.h b/sound/soc/codecs/rt1019.h
index 64df831eeb72..48ba15efb48d 100644
--- a/sound/soc/codecs/rt1019.h
+++ b/sound/soc/codecs/rt1019.h
@@ -95,6 +95,12 @@
 #define RT1019_TDM_BCLK_MASK		(0x1 << 6)
 #define RT1019_TDM_BCLK_NORM		(0x0 << 6)
 #define RT1019_TDM_BCLK_INV			(0x1 << 6)
+#define RT1019_TDM_CL_MASK			(0x7)
+#define RT1019_TDM_CL_8				(0x4)
+#define RT1019_TDM_CL_32			(0x3)
+#define RT1019_TDM_CL_24			(0x2)
+#define RT1019_TDM_CL_20			(0x1)
+#define RT1019_TDM_CL_16			(0x0)
 
 /* 0x0401 TDM Control-2 */
 #define RT1019_I2S_CH_TX_MASK		(0x3 << 6)
-- 
2.35.1



