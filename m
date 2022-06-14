Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB3854A648
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350908AbiFNCYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355138AbiFNCYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:24:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E69A40A1E;
        Mon, 13 Jun 2022 19:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CC2FB816A9;
        Tue, 14 Jun 2022 02:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079B3C385A2;
        Tue, 14 Jun 2022 02:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172647;
        bh=qIYgr84JW2wfwskmNEvNzTtO/Z+QttXhLdhRIbSR53E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTkHwt/fBnidoBGg2eSx5uuOvSMKdbHFHAnRLWmhrfTxNhTfeUIoTQNq5hgWIpCxf
         u8nhBqJjKi7ayff5n6l9oVq4Y1P5TYugd6Ml12csbsCmF0c9nUexQIFtV+mChgLbMQ
         XeJ1Pttt6S5ByCqfacSCK+hH5hWvS6lOnwit6mx4XrW3x3WiLzTiw4g0ahT/dwAgC3
         OZ2YgDQBd+dL3kLEDwPSa94GCpYS8f9GvqPY9RqQh/xc42hv839txBXMupurRy/7B7
         oJmBFn2sY+J+XU4jQcgbFP99Mv4cpLmylh7sxm7pZYfYadVNFMXpQKlHfLd0L4+aFP
         11pKSuRc6zAtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 03/12] ASoC: cs42l52: Correct TLV for Bypass Volume
Date:   Mon, 13 Jun 2022 22:10:31 -0400
Message-Id: <20220614021040.1101131-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021040.1101131-1-sashal@kernel.org>
References: <20220614021040.1101131-1-sashal@kernel.org>
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

[ Upstream commit 91e90c712fade0b69cdff7cc6512f6099bd18ae5 ]

The Bypass Volume is accidentally using a -6dB minimum TLV rather than
the correct -60dB minimum. Add a new TLV to correct this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220602162119.3393857-5-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l52.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index f733f6b42b53..47f2439fd7b0 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -141,6 +141,8 @@ static DECLARE_TLV_DB_SCALE(mic_tlv, 1600, 100, 0);
 
 static DECLARE_TLV_DB_SCALE(pga_tlv, -600, 50, 0);
 
+static DECLARE_TLV_DB_SCALE(pass_tlv, -6000, 50, 0);
+
 static DECLARE_TLV_DB_SCALE(mix_tlv, -5150, 50, 0);
 
 static DECLARE_TLV_DB_SCALE(beep_tlv, -56, 200, 0);
@@ -355,7 +357,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 			      CS42L52_SPKB_VOL, 0, 0x40, 0xC0, hl_tlv),
 
 	SOC_DOUBLE_R_SX_TLV("Bypass Volume", CS42L52_PASSTHRUA_VOL,
-			      CS42L52_PASSTHRUB_VOL, 0, 0x88, 0x90, pga_tlv),
+			      CS42L52_PASSTHRUB_VOL, 0, 0x88, 0x90, pass_tlv),
 
 	SOC_DOUBLE("Bypass Mute", CS42L52_MISC_CTL, 4, 5, 1, 0),
 
-- 
2.35.1

