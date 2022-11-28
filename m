Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D5663B009
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiK1RsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiK1Rqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:46:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A022D748;
        Mon, 28 Nov 2022 09:41:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14F39B80E9D;
        Mon, 28 Nov 2022 17:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797D7C433D7;
        Mon, 28 Nov 2022 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657299;
        bh=DPPczfweauoHm+8fcnAinxuupRv+3HXZOb4CpCady1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCRNOGpyReN81FmMDiMlTu2uCIgruXZdo/TCZ+ycUQfuKamS1LfUAkOL8x/n5hD5V
         2eIh8xkBYjE9Jinly8Dfi2GIUje+5ECK3CpYnsGkxPeRV/PpXWiwDrLtgvMLvdp0FE
         Gp95aJm1xov5zzlZOqmCExFtXvBoRLB5/NFxinvoL47Rlf4LQdqmQDLBBEZFErRGC7
         HNL8j49R7hzYWpppIzaZWNbWxXTKobrY88UrZsQyQd33PyfE/ODPI+93RJdGHIaQmw
         5KuY39CPvywP41w/jUqfMgvjoUqS5iGRjcS52fVO25xoZ1eEZ73czr1HCTfMFEkIVc
         VKJQDY17WnJhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chancel Liu <chancel.liu@nxp.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, steve@sk2.org,
        chi.minghao@zte.com.cn, aford173@gmail.com,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 08/19] ASoC: wm8962: Wait for updated value of WM8962_CLOCKING1 register
Date:   Mon, 28 Nov 2022 12:41:08 -0500
Message-Id: <20221128174120.1442235-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174120.1442235-1-sashal@kernel.org>
References: <20221128174120.1442235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 3ca507bf99611c82dafced73e921c1b10ee12869 ]

DSPCLK_DIV field in WM8962_CLOCKING1 register is used to generate
correct frequency of LRCLK and BCLK. Sometimes the read-only value
can't be updated timely after enabling SYSCLK. This results in wrong
calculation values. Delay is introduced here to wait for newest value
from register. The time of the delay should be at least 500~1000us
according to test.

Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221109121354.123958-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8962.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 21574447650c..57aeded978c2 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2489,6 +2489,14 @@ static void wm8962_configure_bclk(struct snd_soc_component *component)
 		snd_soc_component_update_bits(component, WM8962_CLOCKING2,
 				WM8962_SYSCLK_ENA_MASK, WM8962_SYSCLK_ENA);
 
+	/* DSPCLK_DIV field in WM8962_CLOCKING1 register is used to generate
+	 * correct frequency of LRCLK and BCLK. Sometimes the read-only value
+	 * can't be updated timely after enabling SYSCLK. This results in wrong
+	 * calculation values. Delay is introduced here to wait for newest
+	 * value from register. The time of the delay should be at least
+	 * 500~1000us according to test.
+	 */
+	usleep_range(500, 1000);
 	dspclk = snd_soc_component_read(component, WM8962_CLOCKING1);
 
 	if (snd_soc_component_get_bias_level(component) != SND_SOC_BIAS_ON)
-- 
2.35.1

