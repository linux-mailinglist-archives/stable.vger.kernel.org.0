Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4831538250
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiE3OW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241357AbiE3ORc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A118FD61;
        Mon, 30 May 2022 06:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F3F060F24;
        Mon, 30 May 2022 13:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F3C3411F;
        Mon, 30 May 2022 13:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918336;
        bh=r0fIl1paJppCtESdUdyUAQ98xxiKIcSO5MMEPsCXkb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZOvhyi3tcmCeh4Eyo2M93ZAXZswYDx21A1weOcgby0iPYyH6CPRh7yOxd7mWne31
         7jB6BUas77oCmBHwtPCFlhaAZmmec7RsImY1XevrFiJlkwD71t9QzYMBDcWMw3tkqc
         4pnMaYRyg97bgTHfFxZM4B8fwdQCnGwxYFO41iGnUhvQR0cC13FBQbobP0Q4DIcI6J
         1+kj0nkmB4J8ImWhUqtq9tnkgB4/r/Xy3al5jjJJ1tnqhI1j68IuyozvyEiqK1Vn1V
         VASe0KUu4o5++k1dgrT41HyVfVj/oKZhzXazdl1rzKyxouObrN0AMmhSY/b3vQ2dK9
         TTBdgZ3jYz2zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 40/76] ASoC: dapm: Don't fold register value changes into notifications
Date:   Mon, 30 May 2022 09:43:30 -0400
Message-Id: <20220530134406.1934928-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
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
index 417732bdf286..f2f7f2dde93c 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3427,7 +3427,6 @@ int snd_soc_dapm_put_volsw(struct snd_kcontrol *kcontrol,
 			update.val = val;
 			card->update = &update;
 		}
-		change |= reg_change;
 
 		ret = soc_dapm_mixer_update_power(card, kcontrol, connect,
 						  rconnect);
@@ -3529,7 +3528,6 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 			update.val = val;
 			card->update = &update;
 		}
-		change |= reg_change;
 
 		ret = soc_dapm_mux_update_power(card, kcontrol, item[0], e);
 
-- 
2.35.1

