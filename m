Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7388F66C14D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbjAPOJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjAPOJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:09:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01495279A5;
        Mon, 16 Jan 2023 06:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9287160FD3;
        Mon, 16 Jan 2023 14:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C592AC433D2;
        Mon, 16 Jan 2023 14:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877848;
        bh=pBSKFNX9dLZmMfXupTcrFDO/R0T2iW1mUQuwyYyc9xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTYFN9Mu+Kd3rEWv8fbHl9Qxz/hSsblq6lS5Jl1NGVdTzLlYH4rfn5lRr1TLDu08o
         Ecw2J5RL4Z9qp6+yVR8RJOJqu5jeYvqvg1RcQVQCtb6syuiybPuUbprQt6ljy9UpAk
         6oyW6QTE8665P08uetFEAdFfio+4qPjBYwa3kRwcTkm1RDGoxuEZEyqWzrg61lILW8
         g3At92y30o7PE3GbgIdgCxdrMI5icrMjTZtn+FHwzqR3GNCqF1He11odyXKVJOaCg9
         Q646CfadlyGDcgDt0L21lHrstTSnVpMc35oBuNY5wuiL+xtxHnVav3tWTX1vv8O5Lu
         yBhTUGmT/Y4iA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chancel Liu <chancel.liu@nxp.com>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Xiubo.Lee@gmail.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 05/24] ASoC: fsl_micfil: Correct the number of steps on SX controls
Date:   Mon, 16 Jan 2023 09:03:40 -0500
Message-Id: <20230116140359.115716-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140359.115716-1-sashal@kernel.org>
References: <20230116140359.115716-1-sashal@kernel.org>
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

[ Upstream commit cdfa92eb90f5770b26a79824ef213ebdbbd988b1 ]

The parameter "max" of SOC_SINGLE_SX_TLV() means the number of steps
rather than maximum value. This patch corrects the minimum value to -8
and the number of steps to 15.

Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20230104025754.3019235-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index d1cd104f8584..38d4d1b7cfe3 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -88,21 +88,21 @@ static DECLARE_TLV_DB_SCALE(gain_tlv, 0, 100, 0);
 
 static const struct snd_kcontrol_new fsl_micfil_snd_controls[] = {
 	SOC_SINGLE_SX_TLV("CH0 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(0), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(0), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH1 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(1), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(1), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH2 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(2), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(2), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH3 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(3), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(3), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH4 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(4), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(4), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH5 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(5), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(5), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH6 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(6), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(6), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH7 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(7), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(7), 0x8, 0xF, gain_tlv),
 	SOC_ENUM_EXT("MICFIL Quality Select",
 		     fsl_micfil_quality_enum,
 		     snd_soc_get_enum_double, snd_soc_put_enum_double),
-- 
2.35.1

