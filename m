Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B87254A592
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353253AbiFNCTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354000AbiFNCRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:17:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3568036322;
        Mon, 13 Jun 2022 19:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D363B80AC1;
        Tue, 14 Jun 2022 02:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA27EC36B03;
        Tue, 14 Jun 2022 02:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172560;
        bh=dz5oqgMyOl5udEA0pAhKl3A7qxvjlMQK6WHXNFGKWkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAD2FkMW+vJafdhgEj2UGqL3rhjLMDs6o5xM9TQLxPYGU11DfQMMEpvc9mL+pOLx8
         YgxZ7ROJixGniICZojupDsqSk/4iaDLjZEbS3PKY35mnK2+AZg7jn6oeqNtw1AAxoR
         ttdAHNvWmVwgOR1MWyXTzGK310DbPzAPhMFlldDiLE7G3Sn1+dMpWfNSW3OrCkVesJ
         mbgHyCfs5IUpj3RIeo+MqGn1ItexfkTyWLQpHzFD8icAvlw+4t3rW32/fyGSmtAb3m
         23eZDlz2kwqYhWHxaBPlCPnXs+yb8121ZZpw5N5H6TA1+vBmEZufdpHYUwpzOnjnlw
         uqZ+H/DT1berg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 11/23] ASoC: es8328: Fix event generation for deemphasis control
Date:   Mon, 13 Jun 2022 22:08:47 -0400
Message-Id: <20220614020900.1100401-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020900.1100401-1-sashal@kernel.org>
References: <20220614020900.1100401-1-sashal@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8259610c2ec01c5cbfb61882ae176aabacac9c19 ]

Currently the put() method for the deemphasis control returns 0 when a new
value is written to the control even if the value changed, meaning events
are not generated. Fix this, skip the work of updating the value when it is
unchanged and then return 1 after having done so.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220603123937.4013603-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8328.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index fdf64c29f563..4117ab6e9b6f 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -161,13 +161,16 @@ static int es8328_put_deemph(struct snd_kcontrol *kcontrol,
 	if (deemph > 1)
 		return -EINVAL;
 
+	if (es8328->deemph == deemph)
+		return 0;
+
 	ret = es8328_set_deemph(component);
 	if (ret < 0)
 		return ret;
 
 	es8328->deemph = deemph;
 
-	return 0;
+	return 1;
 }
 
 
-- 
2.35.1

