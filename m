Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5121661E45C
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiKFRKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiKFRKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA6F1147C;
        Sun,  6 Nov 2022 09:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60BAFB80C69;
        Sun,  6 Nov 2022 17:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4C4C43142;
        Sun,  6 Nov 2022 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754375;
        bh=BMx0qXfysCm6idszSFX1CP/wYoVZfQ+FpHyLUpSlzXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMY6AXVxDCHnG5buEQCGgeVnkWBh2Gdk0vGOlgTPdEjlfaYT7e6OoTtXxBPvAZKND
         dSrFysdL53toC1+aDBTC/bHjk1+1PrpNtCLZ6m0cF7rnpionyYNbWVhFUvxBRcvhYv
         spBnHZmPdXBUdL7UKtXA2WmSV6av1PCe3/Gz/siNa+MU10frtdeDWp7vBQAjRFvPgs
         WWNkPWTv7ilezOi2w/S9ckI4Ds+UneIKZGzuK9M9pr5p6I7ciV6tjU6d0bIpUjk+6c
         fhCavsrYEt9V81rPzQ9ec4S8x/RW1Yld/tQxu39E4lM8XwI7AdVQ1GBDdnmKC2U2LP
         Voy+TNyjOFrNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siarhei Volkau <lis8215@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, paul@crapouillou.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        linux-mips@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 07/16] ASoC: codecs: jz4725b: add missed Line In power control bit
Date:   Sun,  6 Nov 2022 12:05:44 -0500
Message-Id: <20221106170555.1580584-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170555.1580584-1-sashal@kernel.org>
References: <20221106170555.1580584-1-sashal@kernel.org>
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
index e49374c72e70..9f6f4e941e55 100644
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

