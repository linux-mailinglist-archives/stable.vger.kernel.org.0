Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82FB26357C0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbiKWJoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbiKWJno (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05DE10553
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:41:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98150B81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1538C433C1;
        Wed, 23 Nov 2022 09:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196478;
        bh=/m+ws4LtJVeV9zdgtIhbPo9cdoq0Rje2NJJD+yX3fok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eu0RNZWowrenEAMdB50IT7h1Xm37onELbNwI8Qf4KZFzmaKCcIWcBeh2YeS9wjkwc
         qJZhzKxF/w8IUlMNYGpy/NWZ6GxXdtqsg0KRLOWWN5PPpbbKxbICauNal71Z07ySR5
         3pSIJg+J+nWomiNHNdS+SDHWpIbxzC3hRCAjoQc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Siarhei Volkau <lis8215@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 012/314] ASoC: codecs: jz4725b: add missed Line In power control bit
Date:   Wed, 23 Nov 2022 09:47:37 +0100
Message-Id: <20221123084626.052130114@linuxfoundation.org>
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

From: Siarhei Volkau <lis8215@gmail.com>

[ Upstream commit 1013999b431b4bcdc1f5ae47dd3338122751db31 ]

Line In path stayed powered off during capturing or
bypass to mixer.

Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
Link: https://lore.kernel.org/r/20221016132648.3011729-2-lis8215@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/jz4725b.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/jz4725b.c b/sound/soc/codecs/jz4725b.c
index 5201a8f6d7b6..cc7a48c96aa4 100644
--- a/sound/soc/codecs/jz4725b.c
+++ b/sound/soc/codecs/jz4725b.c
@@ -236,7 +236,8 @@ static const struct snd_soc_dapm_widget jz4725b_codec_dapm_widgets[] = {
 	SND_SOC_DAPM_MIXER("DAC to Mixer", JZ4725B_CODEC_REG_CR1,
 			   REG_CR1_DACSEL_OFFSET, 0, NULL, 0),
 
-	SND_SOC_DAPM_MIXER("Line In", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_MIXER("Line In", JZ4725B_CODEC_REG_PMR1,
+			   REG_PMR1_SB_LIN_OFFSET, 1, NULL, 0),
 	SND_SOC_DAPM_MIXER("HP Out", JZ4725B_CODEC_REG_CR1,
 			   REG_CR1_HP_DIS_OFFSET, 1, NULL, 0),
 
-- 
2.35.1



