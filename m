Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44146579DAB
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbiGSMxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242108AbiGSMxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:53:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF1790DB0;
        Tue, 19 Jul 2022 05:20:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26B08618E1;
        Tue, 19 Jul 2022 12:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0874FC341C6;
        Tue, 19 Jul 2022 12:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233251;
        bh=krPBsNYKPzoOFgBFy5vJEFUAPdi761bW4QBFCNBjFy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ekbpt2pIBR/B690uz/+uBmUQClgExp2b2TTiGtznAC1XkSHJTvZM74vwQMqhkfohQ
         MNHs6/U4bmhTgNGee4rPsp3qvR/JTqTQnw8UczFyl1LZbhS7RH2rgClgph+M8t/A7c
         yJCfNH1f3i+LWT6NOsHNjMbbAFS+YtJHcdb/ypoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 057/231] ASoC: tas2764: Fix amp gain register offset & default
Date:   Tue, 19 Jul 2022 13:52:22 +0200
Message-Id: <20220719114718.988385994@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 1c4f29ec878bbf1cc0a1eb54ae7da5ff98e19641 ]

The register default is 0x28 per the datasheet, and the amp gain field
is supposed to be shifted left by one. With the wrong default, the ALSA
controls lie about the power-up state. With the wrong shift, we get only
half the gain we expect.

Signed-off-by: Hector Martin <marcan@marcan.st>
Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220630075135.2221-4-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index bd79bc7ecf6b..ec13ba01e522 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -541,7 +541,7 @@ static DECLARE_TLV_DB_SCALE(tas2764_playback_volume, -10050, 50, 1);
 static const struct snd_kcontrol_new tas2764_snd_controls[] = {
 	SOC_SINGLE_TLV("Speaker Volume", TAS2764_DVC, 0,
 		       TAS2764_DVC_MAX, 1, tas2764_playback_volume),
-	SOC_SINGLE_TLV("Amp Gain Volume", TAS2764_CHNL_0, 0, 0x14, 0,
+	SOC_SINGLE_TLV("Amp Gain Volume", TAS2764_CHNL_0, 1, 0x14, 0,
 		       tas2764_digital_tlv),
 };
 
@@ -566,7 +566,7 @@ static const struct reg_default tas2764_reg_defaults[] = {
 	{ TAS2764_SW_RST, 0x00 },
 	{ TAS2764_PWR_CTRL, 0x1a },
 	{ TAS2764_DVC, 0x00 },
-	{ TAS2764_CHNL_0, 0x00 },
+	{ TAS2764_CHNL_0, 0x28 },
 	{ TAS2764_TDM_CFG0, 0x09 },
 	{ TAS2764_TDM_CFG1, 0x02 },
 	{ TAS2764_TDM_CFG2, 0x0a },
-- 
2.35.1



