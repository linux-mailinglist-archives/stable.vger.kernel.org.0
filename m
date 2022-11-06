Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5096061E49D
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiKFRM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiKFRLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:11:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723A4140AC;
        Sun,  6 Nov 2022 09:07:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 31E8CCE01BD;
        Sun,  6 Nov 2022 17:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5993DC43145;
        Sun,  6 Nov 2022 17:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754412;
        bh=e1zY74w8f4+l/6QfJLwmoA1WI0KbNI093vQ5gi1TV2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpV6r9wQZMcCIQsR9DZMwXDT5vkdmlIjqqUmB04mTwp7iJ39S+kZ8HCHu20KIGuew
         xAHfvmMjDl9bBZydGYzotb4wRFgWs7/4oOVwBPyC0WnTmazwJ+FqFoN1oNWBO6sTCD
         v7CNHJ23865C96UxHk6HTyCFcql/BH0bQ2F+6kwY46rRFQ29qVpagIBMwJJUJWnC/5
         TjT+6oqJ3/5cNVAR5agJPAo4kXO20jCuy4pJb1lKAsGcFHtlqIcX2sUn8mt5QTO/Oj
         Lke+FuoQWEiNFTN482d9Bsk61qRqc/NQXua4NLcrgiz14QLp0y8KkbP39n4oOGcBrY
         sx8uNjWxgBnCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siarhei Volkau <lis8215@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, paul@crapouillou.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        linux-mips@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 06/12] ASoC: codecs: jz4725b: add missed Line In power control bit
Date:   Sun,  6 Nov 2022 12:06:30 -0500
Message-Id: <20221106170637.1580802-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170637.1580802-1-sashal@kernel.org>
References: <20221106170637.1580802-1-sashal@kernel.org>
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
index 2567a5d15b55..a04b8d5d1ded 100644
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

