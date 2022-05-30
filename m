Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E95253827C
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbiE3OYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240867AbiE3OVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E27A777A;
        Mon, 30 May 2022 06:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7EE661001;
        Mon, 30 May 2022 13:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E6AC385B8;
        Mon, 30 May 2022 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918617;
        bh=SCrb2B54rfJkpjKpDTRTPDuM7Oj8CekCHGji+4OOpcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsMFRLyo1Qect7ulrMmijtkxv4nO++QD+xCTuUjOPmifuLWBopFdiuL3kwugO78lb
         BCKChI/h0Up/qYcc9TqfFzMTzU4W7ETA18CTd1SYMCLpYindnGTSF+rTRzC/34t7Uo
         7UTdp5prRBpvIL8+h18t3Gb82MIOWvsr6Wu4tQELEOg3guCDQzagILPBdX0h6sEOjB
         682wJrQSjwzbNDMYQqDcjLTNSUSP/di8ela/OHrBhqAka4nAPzrXeXkiyCHdqusHFV
         aQPwegYxsGfLtciVJkrDNTiOM39agkxNoawM7b5evjH7vS/SoOGmqXHcrIJ1bhgBMh
         Vet1T45TJVk0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 21/38] ASoC: dapm: Don't fold register value changes into notifications
Date:   Mon, 30 May 2022 09:49:07 -0400
Message-Id: <20220530134924.1936816-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134924.1936816-1-sashal@kernel.org>
References: <20220530134924.1936816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit ad685980469b9f9b99d4d6ea05f4cb8f57cb2234 ]

DAPM tracks and reports the value presented to the user from DAPM controls
separately to the register value, these may diverge during initialisation
or when an autodisable control is in use.

When writing DAPM controls we currently report that a change has occurred
if either the DAPM value or the value stored in the register has changed,
meaning that if the two are out of sync we may appear to report a spurious
event to userspace. Since we use this folded in value for nothing other
than the value reported to userspace simply drop the folding in of the
register change.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220428161833.3690050-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index af9f28dd957d..4d70e6bc2c12 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3302,7 +3302,6 @@ int snd_soc_dapm_put_volsw(struct snd_kcontrol *kcontrol,
 			update.val = val;
 			card->update = &update;
 		}
-		change |= reg_change;
 
 		ret = soc_dapm_mixer_update_power(card, kcontrol, connect,
 						  rconnect);
@@ -3408,7 +3407,6 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 			update.val = val;
 			card->update = &update;
 		}
-		change |= reg_change;
 
 		ret = soc_dapm_mux_update_power(card, kcontrol, item[0], e);
 
-- 
2.35.1

