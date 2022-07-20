Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A940C57AC47
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241618AbiGTBU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbiGTBTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:19:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF9D6E2FE;
        Tue, 19 Jul 2022 18:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4328EB81DD6;
        Wed, 20 Jul 2022 01:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32CAC341CA;
        Wed, 20 Jul 2022 01:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279753;
        bh=4j684ydNnDY2FnLOno8VZSN1YwtwifMKEKDHjbqAIUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ait0Ohibllvcf9d9B/YR4t7DcFPnzXzgiEsKGNrXoqw82+JJmk8wVYo9fJZNqnhtu
         i06ZTyHhgm+jqRQbjUz0yrKX9lA+JsSIObhkR8RBv/JCajH7fCvGE0QaPUbpcEVDrG
         QsPp1+dlPf5Mfr/FxvzKRKyTh46rJW6eU5bfs34JmVE0+9ZjXTyNR1l0K10GzbJlqg
         T7DjRWwAVwv5lLEqx8TNBmKmtWwpqAKjm64bFVLKM0DLIu9CEbQToAvR9DqYZoAFAs
         kcanBceLVzWicOJ/PT6vJ/TovvfugSlL1CwBIpCpQi02xyqenSbriVhaht2gb2bgIL
         ipMH/QZOxRs3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 33/42] ASoC: arizona: Update arizona_aif_cfg_changed to use RX_BCLK_RATE
Date:   Tue, 19 Jul 2022 21:13:41 -0400
Message-Id: <20220720011350.1024134-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit f99e930655f411453170a5f332e12c2d2748822e ]

Currently the function arizona_aif_cfg_changed uses the TX_BCLK_RATE,
however this register is not used on wm8998. This was not noticed as
previously snd_soc_component_read did not print an error message.
However, now the log gets filled with error messages, further more the
test for if the LRCLK changed will return spurious results.

Update the code to use the RX_BCLK_RATE register, the LRCLK parameters
are written to both registers and the RX_BCLK_RATE register is used
across all Arizona devices.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220628153409.3266932-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/arizona.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index e32871b3f68a..7434aeeda292 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -1760,8 +1760,8 @@ static bool arizona_aif_cfg_changed(struct snd_soc_component *component,
 	if (bclk != (val & ARIZONA_AIF1_BCLK_FREQ_MASK))
 		return true;
 
-	val = snd_soc_component_read(component, base + ARIZONA_AIF_TX_BCLK_RATE);
-	if (lrclk != (val & ARIZONA_AIF1TX_BCPF_MASK))
+	val = snd_soc_component_read(component, base + ARIZONA_AIF_RX_BCLK_RATE);
+	if (lrclk != (val & ARIZONA_AIF1RX_BCPF_MASK))
 		return true;
 
 	val = snd_soc_component_read(component, base + ARIZONA_AIF_FRAME_CTRL_1);
-- 
2.35.1

