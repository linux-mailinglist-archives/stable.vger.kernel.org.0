Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BD157ACCC
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239828AbiGTB1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242084AbiGTB01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:26:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FAD67587;
        Tue, 19 Jul 2022 18:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD1CD617B4;
        Wed, 20 Jul 2022 01:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7871C385A9;
        Wed, 20 Jul 2022 01:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279884;
        bh=7IZTApLTynglbD7aV1nvNHgpHlfeAnDxZGwzIB+MTSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obvAygvF3OPRWA46JJydGQIHx4GscMo0JdEJUSdMFXoouhVI1Q2yRvi/BHvI7btg5
         pH5NDKen1nf7fiPWS+kKTz92NQgwAVDGoJAdYDNs67yOMAltkoILqP9j5MEIUu0Qlm
         N5ghAQsAGBRdOA+So3vHmpBBb65NqAn5Vxycb8rJa/dUGvFSd8gQEb9RUOPmjlUm5l
         pA2QTXTpFEhsNgL8M9N+5h0whrc99VBGHC2a/MxS1YXG/Wsbcvmsp0PBgyDhDnd846
         mrB5BOuHbfL3523293SilJzHfncbtAKdhDcWk9N4QWnXNkX7kECNtkbZK7ayePADwn
         lLm787sYgRJ4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rf@opensource.cirrus.com,
        james.schulman@cirrus.com, david.rhodes@cirrus.com,
        tanureal@opensource.cirrus.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 12/16] ASoC: cs47l92: Fix event generation for OUT1 demux
Date:   Tue, 19 Jul 2022 21:17:26 -0400
Message-Id: <20220720011730.1025099-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011730.1025099-1-sashal@kernel.org>
References: <20220720011730.1025099-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 870d72ab9228575b2f005c9a23ea08787e0f63e6 ]

cs47l92_put_demux returns the value of snd_soc_dapm_mux_update_power,
which returns a 1 if a path was found for the kcontrol. This is
obviously different to the expected return a 1 if the control
was updated value. This results in spurious notifications to
user-space. Update the handling to only return a 1 when the value is
changed.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220628153409.3266932-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs47l92.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs47l92.c b/sound/soc/codecs/cs47l92.c
index d50f75f3b3e4..cb7d02c3f11b 100644
--- a/sound/soc/codecs/cs47l92.c
+++ b/sound/soc/codecs/cs47l92.c
@@ -119,7 +119,13 @@ static int cs47l92_put_demux(struct snd_kcontrol *kcontrol,
 end:
 	snd_soc_dapm_mutex_unlock(dapm);
 
-	return snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	ret = snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	if (ret < 0) {
+		dev_err(madera->dev, "Failed to update demux power state: %d\n", ret);
+		return ret;
+	}
+
+	return change;
 }
 
 static SOC_ENUM_SINGLE_DECL(cs47l92_outdemux_enum,
-- 
2.35.1

