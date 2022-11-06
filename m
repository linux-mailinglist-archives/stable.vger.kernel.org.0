Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2ED461E447
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiKFRJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiKFRJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:09:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA4BFAFF;
        Sun,  6 Nov 2022 09:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC923B80C70;
        Sun,  6 Nov 2022 17:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7146CC43470;
        Sun,  6 Nov 2022 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754376;
        bh=Yju+PhhyVD9sWa2cDZ0LBKCrZ14Wgc8+ncDP2v35HR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBtgP52u4GRm3XaWUIMsyFQ2kP7KA8+gRHKoEc+gRofxNhBtIL1MgkPKG9vAj7Gwt
         rO62BrXLTNBnwlJYAp/ebJSkKkIY/whP0vLAtv+zTcnUU7oa/icuL4Jh8bXBg/PTGV
         FXTSt6Su2v8fXr+VLdSPR5h1vvL35miwc70Q+Ls8Cy75HOVV8XhsJFZbNkwk1Tkbhe
         euE3jR7SQfyqw24LgqkDusGBdUK2TD+cWeIElRMaEX0NmDqt2pO2E+hqtHGPpPmeQ/
         FIpFiMucWj9xKtIQzYKr63jcrwZsQYtPsq5ilrhyljiuaofQxGb7Le8AjD7vSVPsMz
         oQjEvvinfpqBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siarhei Volkau <lis8215@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, paul@crapouillou.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        linux-mips@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 08/16] ASoC: codecs: jz4725b: fix reported volume for Master ctl
Date:   Sun,  6 Nov 2022 12:05:45 -0500
Message-Id: <20221106170555.1580584-8-sashal@kernel.org>
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

[ Upstream commit 088777bf65b98cfa4b5378119d0a7d49a58ece44 ]

DAC volume control is the Master Playback Volume at the moment
and it reports wrong levels in alsamixer and other alsa apps.

The patch fixes that, as stated in manual on the jz4725b SoC
(16.6.3.4 Programmable attenuation: GOD) the ctl range varies
from -22.5dB to 0dB with 1.5dB step.

Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
Link: https://lore.kernel.org/r/20221016132648.3011729-3-lis8215@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/jz4725b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/jz4725b.c b/sound/soc/codecs/jz4725b.c
index 9f6f4e941e55..6f3d4ead9150 100644
--- a/sound/soc/codecs/jz4725b.c
+++ b/sound/soc/codecs/jz4725b.c
@@ -142,8 +142,8 @@ struct jz_icdc {
 	struct clk *clk;
 };
 
-static const SNDRV_CTL_TLVD_DECLARE_DB_LINEAR(jz4725b_dac_tlv, -2250, 0);
 static const SNDRV_CTL_TLVD_DECLARE_DB_LINEAR(jz4725b_line_tlv, -1500, 600);
+static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(jz4725b_dac_tlv, -2250, 150, 0);
 
 static const struct snd_kcontrol_new jz4725b_codec_controls[] = {
 	SOC_DOUBLE_TLV("Master Playback Volume",
-- 
2.35.1

