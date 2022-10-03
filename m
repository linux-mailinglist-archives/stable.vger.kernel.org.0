Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9DE5F2A74
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiJCHgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiJCHez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0AF52E48;
        Mon,  3 Oct 2022 00:22:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C994AB80E99;
        Mon,  3 Oct 2022 07:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DCEC433D7;
        Mon,  3 Oct 2022 07:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781715;
        bh=wV6w/5yjSXng0Df1vDN/QOCW81kAq0odOT+BHUZvNjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPFI+NuRjMCPwWWCH3QaJBxMMNijhBfHLOPeyqISJ18s3ppZDPrFxoO8DcjII1w1T
         YFvd90O0AfR/SVL3Tp8y4cbZbrrsNU/lmPT89g+o2LSpTvcEKZbGFrMIm+ybvwA4tj
         20LtWbhUBuHVFwxTvP9UtRy877KOVRUZ4r+7nFrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/52] ASoC: tas2770: Reinit regcache on reset
Date:   Mon,  3 Oct 2022 09:11:45 +0200
Message-Id: <20221003070719.871312679@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit 0a0342ede303fc420f3a388e1ae82da3ae8ff6bd ]

On probe of the ASoC component, the device is reset but the regcache is
retained. This means the regcache gets out of sync if the codec is
rebound to a sound card for a second time. Fix it by reinitializing the
regcache to defaults after the device is reset.

Fixes: b0bcbe615756 ("ASoC: tas2770: Fix calling reset in probe")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220919173453.84292-1-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 024ec68e8d35..171bbcc919d5 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -495,6 +495,8 @@ static struct snd_soc_dai_driver tas2770_dai_driver[] = {
 	},
 };
 
+static const struct regmap_config tas2770_i2c_regmap;
+
 static int tas2770_codec_probe(struct snd_soc_component *component)
 {
 	struct tas2770_priv *tas2770 =
@@ -508,6 +510,7 @@ static int tas2770_codec_probe(struct snd_soc_component *component)
 	}
 
 	tas2770_reset(tas2770);
+	regmap_reinit_cache(tas2770->regmap, &tas2770_i2c_regmap);
 
 	return 0;
 }
-- 
2.35.1



