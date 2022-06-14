Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F4554A4A6
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352391AbiFNCJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352559AbiFNCJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:09:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D9736312;
        Mon, 13 Jun 2022 19:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54900B816A3;
        Tue, 14 Jun 2022 02:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB69C385A5;
        Tue, 14 Jun 2022 02:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172382;
        bh=m++Hn3Fk2NwdqAxL7YXJgjX3tvqr/94r7cEDTL6dAr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQpfmgoqG5XVx1bf6WwvFmYvggt77z7DJqq6T9cArv/Jl+5V6SWgakQbwnKKMBrJa
         s5/eyiHBj8oTK+oyJ53llaFXxQg0mo/aMK517JITpvHx62VOGW4jtPUHvNfxjfeAeF
         remirYkCTYW84k9cnIilPKNjHjYEDLomEcCK8/gapfSKSAZwvptfEuxxTqBVFpN70Z
         FUSb1lyfaA+YcaPz/95DWtQHHbOSY0e2ON3TluKFLkqAmXbBUB6IaMSqJMed1Me9hR
         wRTAu7eb25HWXeIx9g+yUjWED0qRdy91lXdNmHL0RQmWs9s+kls4u2JxHXOj4QpcHQ
         XKe+1nCoFOcQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 12/43] ASoC: cs42l51: Correct minimum value for SX volume control
Date:   Mon, 13 Jun 2022 22:05:31 -0400
Message-Id: <20220614020602.1098943-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020602.1098943-1-sashal@kernel.org>
References: <20220614020602.1098943-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit fcb3b5a58926d16d9a338841b74af06d4c29be15 ]

The minimum value for the PGA Volume is given as 0x1A, however the
values from there to 0x19 are all the same volume and this is not
represented in the TLV structure. The number of volumes given is correct
so this leads to all the volumes being shifted. Move the minimum value
up to 0x19 to fix this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220602162119.3393857-7-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l51.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index c61b17dc2af8..fc6a2bc311b4 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -146,7 +146,7 @@ static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 			0, 0xA0, 96, adc_att_tlv),
 	SOC_DOUBLE_R_SX_TLV("PGA Volume",
 			CS42L51_ALC_PGA_CTL, CS42L51_ALC_PGB_CTL,
-			0, 0x1A, 30, pga_tlv),
+			0, 0x19, 30, pga_tlv),
 	SOC_SINGLE("Playback Deemphasis Switch", CS42L51_DAC_CTL, 3, 1, 0),
 	SOC_SINGLE("Auto-Mute Switch", CS42L51_DAC_CTL, 2, 1, 0),
 	SOC_SINGLE("Soft Ramp Switch", CS42L51_DAC_CTL, 1, 1, 0),
-- 
2.35.1

