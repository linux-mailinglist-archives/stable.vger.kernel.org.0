Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630BF54A59E
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353439AbiFNCT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354754AbiFNCTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:19:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF7636689;
        Mon, 13 Jun 2022 19:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D266461016;
        Tue, 14 Jun 2022 02:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23644C341C4;
        Tue, 14 Jun 2022 02:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172599;
        bh=Hwo8q9zw5YEMb8z+GLJ3vvn58zoeMsu/HFXHomQvAEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKJygIjk12cz+q0vOPG83zYutX+SbdMumh1NSFZ++tQWS0SnQSThqIs7q6QUuMg2g
         3g3i5/XXf/2I/5hW3ciBSv1DT9EXw60xnmOuMJI2clgwl0VnJ45XaG07YMs7ItShA+
         xHB1FNz8dFbXxU+SgNDaVAyaN/RWMQ1GdYoIYAZSeA6WHfQtCQWC+YZjfJA/27BIiM
         vSKaCKbjR7bqv7oChl+UWLjLdv6dIDooYbQuuQXyK9an659y25/QCHwF5BIg45foOW
         3zZo8Tlng8ffAsUBEME8qbIAbs1d4I/QUdUPGLWSYnK0KZV6gxZM6JTue7I6kS4p/e
         Hf14A/+B8G+Lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 04/18] ASoC: cs42l52: Correct TLV for Bypass Volume
Date:   Mon, 13 Jun 2022 22:09:27 -0400
Message-Id: <20220614020941.1100702-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020941.1100702-1-sashal@kernel.org>
References: <20220614020941.1100702-1-sashal@kernel.org>
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
index 9a3180e71bd8..de311299432b 100644
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

