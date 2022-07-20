Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9CD57ABC1
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241037AbiGTBPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240630AbiGTBOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:14:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50696873B;
        Tue, 19 Jul 2022 18:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A3A61384;
        Wed, 20 Jul 2022 01:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4136FC341C6;
        Wed, 20 Jul 2022 01:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279592;
        bh=4j684ydNnDY2FnLOno8VZSN1YwtwifMKEKDHjbqAIUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8AJeRURe5zAqqXXQLubPdQXBXUO8hnV8EDXY9qkpMSPoEGgxalI0PolPd0FdCHuU
         as0wUhvD6K3g4arSf73QMuQ47wndvmraJ1tuv0QB69PfH8XMh7jFx3+0/CwlxfFKIy
         coiisX5Pe8a7psDW+AKNlfgizwEb6uTmo3zMOMi80ot5t3o251ELtKy+2Q9sEpAVpR
         VjjyHj51/8QzfCSiWglkAVKnvVAMJUD02PWFP+LpQqsaqxLhHqPFSb6PkL3VOyGztK
         ZtLwOuauPSsKugDlb9O8JEcTVr05kiiL83GcOnRiIZTrbdJ4Vel3Bd+acQplUPvfAa
         U/bdgVGN5qA5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 42/54] ASoC: arizona: Update arizona_aif_cfg_changed to use RX_BCLK_RATE
Date:   Tue, 19 Jul 2022 21:10:19 -0400
Message-Id: <20220720011031.1023305-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
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

