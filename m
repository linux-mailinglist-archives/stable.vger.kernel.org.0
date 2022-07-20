Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6153457ABC0
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241005AbiGTBPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241029AbiGTBOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:14:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3589966AF7;
        Tue, 19 Jul 2022 18:13:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E80F2B81DC0;
        Wed, 20 Jul 2022 01:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545F8C385A2;
        Wed, 20 Jul 2022 01:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279588;
        bh=Xvr4lD521Oz1DEqLOoPcl3KybZyDDe8QO1g8AOHOOII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xpm/JBMy/w6PK/qzgOjPdneBNBPmqJYDbsnnlZx594E1ScK9+OkOtrRAz54Ug9QBf
         8+IcJvkZ3uJCz78Sc6tGSV5P8rHtwL6vwQMhf4KQWT4RO69A2S6khatAeGpOnoJgAL
         Me4j3kQD4/jpCH4vEmQ+Axr6+aOUEqaM7JiBY7SPh2Q3zOyuUBafJzm9yhNvyfBcrY
         QfrX3CpenFODOcWJSdxXsZTfyKp7PDFST346v4ixtyaRbrA7fXEdf45zOaV6B3HovA
         fAnRFeOv3ZO9sTQ0GScoZmOKVDEbTNuCYuQ1dnmEr4vhtMD4eUCAwRvQJFzFaAKJLd
         IgrWGNDnw3KSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rf@opensource.cirrus.com,
        james.schulman@cirrus.com, david.rhodes@cirrus.com,
        tanureal@opensource.cirrus.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.18 41/54] ASoC: cs47l92: Fix event generation for OUT1 demux
Date:   Tue, 19 Jul 2022 21:10:18 -0400
Message-Id: <20220720011031.1023305-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
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
index a1b8dcdb9f7b..444026b7d54b 100644
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

