Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BB9574388
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbiGNEgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237713AbiGNEej (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:34:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA443B979;
        Wed, 13 Jul 2022 21:26:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0E4A61E91;
        Thu, 14 Jul 2022 04:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF12C3411C;
        Thu, 14 Jul 2022 04:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772781;
        bh=fh11CQGg78fCZlvxIkEKdZTt+V7QMJNel34lx3CZraQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQwfl6RdG9FzlI9HWJBhNx2g4exaXniS+7yOFwO1ruTEZEzVy8S89wjPuzSgokRhr
         iXt6LHKGol6P7e2XgkxdtX9Ybe21gZpqkwVAtm1ky2JqE13hPlt/r9n8MfJdB9aTYi
         Ac6LhlyfJkZeD6aGHHXwTiQFeTWVOzZrmmRHhCyuRY8CM8X9MZ882B3v57pEHOHFqA
         W/CdRt3us8K8rwg1lkQOa20ti0w4iofwh7RC7HJHTP+i2DBG/adJpWvBdLEixkUJKG
         GoP7AQ0IsHF5C3AhbOMAVulZ0D7h6UaW5CqfqKsg3WKOLlEyQy0Xraf4h8qrUx+jpF
         vfthnu3MmU6qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rf@opensource.cirrus.com,
        james.schulman@cirrus.com, david.rhodes@cirrus.com,
        tanureal@opensource.cirrus.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 03/10] ASoC: cs47l15: Fix event generation for low power mux control
Date:   Thu, 14 Jul 2022 00:26:05 -0400
Message-Id: <20220714042612.282378-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042612.282378-1-sashal@kernel.org>
References: <20220714042612.282378-1-sashal@kernel.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 7f103af4a10f375b9b346b4d0b730f6a66b8c451 ]

cs47l15_in1_adc_put always returns zero regardless of if the control
value was updated. This results in missing notifications to user-space
of the control change. Update the handling to return 1 when the value is
changed.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220623105120.1981154-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs47l15.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs47l15.c b/sound/soc/codecs/cs47l15.c
index ece1276f38eb..1f7148794a5a 100644
--- a/sound/soc/codecs/cs47l15.c
+++ b/sound/soc/codecs/cs47l15.c
@@ -122,6 +122,9 @@ static int cs47l15_in1_adc_put(struct snd_kcontrol *kcontrol,
 		snd_soc_kcontrol_component(kcontrol);
 	struct cs47l15 *cs47l15 = snd_soc_component_get_drvdata(component);
 
+	if (!!ucontrol->value.integer.value[0] == cs47l15->in1_lp_mode)
+		return 0;
+
 	switch (ucontrol->value.integer.value[0]) {
 	case 0:
 		/* Set IN1 to normal mode */
@@ -150,7 +153,7 @@ static int cs47l15_in1_adc_put(struct snd_kcontrol *kcontrol,
 		break;
 	}
 
-	return 0;
+	return 1;
 }
 
 static const struct snd_kcontrol_new cs47l15_snd_controls[] = {
-- 
2.35.1

