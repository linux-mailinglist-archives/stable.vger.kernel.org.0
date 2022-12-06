Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F7E64403E
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiLFJu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbiLFJuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:50:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C824BB841;
        Tue,  6 Dec 2022 01:49:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59FD9615E7;
        Tue,  6 Dec 2022 09:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C990FC433D6;
        Tue,  6 Dec 2022 09:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320187;
        bh=xApacaaiV8UL0u+br9ApSOYSXQZmwwuKKkSLgb+ZMvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpxF3IeDvdljyozWwEky1dkELuzJS+s5EbUpWmk2QnrZ/WccOorSqTkgLjru9r/++
         mfELsCqKyKm9LBIRLUvtsUwvd0wLco8bW7+qxvsFEKd1Wq8CHGtv9kR57bKM8mUvQf
         Lb0r6/OJTickN/ZNj1TmCkhL38IQGinDAOzioi8ikm3U7fYNrVgl9HCnvOKZiIrR8n
         CMnSJQow3+71tOr0+LQ5bfVdYsTWDTfOok0LkYNaGhC4E6ELu8Dueb/PHFZBOK+vPN
         ujvHPuIMo/l+VWeB6rCEpbp4Jmpb7ki45W5oNlG0UTZLgTfywk9ouq/RdjuE/pgcRn
         fOceDq7Kns1ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, james.schulman@cirrus.com,
        david.rhodes@cirrus.com, tanureal@opensource.cirrus.com,
        rf@opensource.cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.0 10/13] ASoC: cs42l51: Correct PGA Volume minimum value
Date:   Tue,  6 Dec 2022 04:49:13 -0500
Message-Id: <20221206094916.987259-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094916.987259-1-sashal@kernel.org>
References: <20221206094916.987259-1-sashal@kernel.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 3d1bb6cc1a654c8693a85b1d262e610196edec8b ]

The table in the datasheet actually shows the volume values in the wrong
order, with the two -3dB values being reversed. This appears to have
caused the lower of the two values to be used in the driver when the
higher should have been, correct this mixup.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221125162348.1288005-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l51.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 51721edd8f53..e88d9ff95cdf 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -143,7 +143,7 @@ static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 			0, 0xA0, 96, adc_att_tlv),
 	SOC_DOUBLE_R_SX_TLV("PGA Volume",
 			CS42L51_ALC_PGA_CTL, CS42L51_ALC_PGB_CTL,
-			0, 0x19, 30, pga_tlv),
+			0, 0x1A, 30, pga_tlv),
 	SOC_SINGLE("Playback Deemphasis Switch", CS42L51_DAC_CTL, 3, 1, 0),
 	SOC_SINGLE("Auto-Mute Switch", CS42L51_DAC_CTL, 2, 1, 0),
 	SOC_SINGLE("Soft Ramp Switch", CS42L51_DAC_CTL, 1, 1, 0),
-- 
2.35.1

