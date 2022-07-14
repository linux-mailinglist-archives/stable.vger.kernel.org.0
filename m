Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6566E57434A
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiGNEb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbiGNEai (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9A432067;
        Wed, 13 Jul 2022 21:25:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B219061E91;
        Thu, 14 Jul 2022 04:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC09C36AE2;
        Thu, 14 Jul 2022 04:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772712;
        bh=uJxQ5zkiSZVte2k7O6ftC2Aguzs3PGSDlpQSoHM8pms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNfKT/U+3U8ebJOXZCFWv2rIFfsYbzTu1ZOFhk2bM0YtyZP4XOjmGicPKwbLGugDv
         4cf1ZGSAQ6c/yWy/QI/lStn6TyW2jR0Xd7dP8n9d5i9QhvKejfOJPdIMZm7E9imjb8
         Lb0O47NBphv2aYXN83sX8EPNPI0TbtapXOlIzIgeE09RE75zWzQyf7FZWP8H3MFtfq
         K4qDYU3kNeMSmV+d2tdCR7Qc3y3JhLq5gatQaVUk/Eil2fGrJi/+YQdLz3yaa38CTP
         9ohZuovdrppevRz7v2fOmN4WbZP9o6HLt737jMlnPfdcs2mB90FGATFlbx7nVh7v4p
         E04Ie+4pHhSMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rf@opensource.cirrus.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.15 18/28] ASoC: madera: Fix event generation for rate controls
Date:   Thu, 14 Jul 2022 00:24:19 -0400
Message-Id: <20220714042429.281816-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042429.281816-1-sashal@kernel.org>
References: <20220714042429.281816-1-sashal@kernel.org>
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

[ Upstream commit 980555e95f7cabdc9c80a07107622b097ba23703 ]

madera_adsp_rate_put always returns zero regardless of if the control
value was updated. This results in missing notifications to user-space
of the control change. Update the handling to return 1 when the
value is changed.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220623105120.1981154-5-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/madera.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/madera.c b/sound/soc/codecs/madera.c
index d3e7a591b5a8..fd4fa1d5d2d1 100644
--- a/sound/soc/codecs/madera.c
+++ b/sound/soc/codecs/madera.c
@@ -899,7 +899,7 @@ static int madera_adsp_rate_put(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	const int adsp_num = e->shift_l;
 	const unsigned int item = ucontrol->value.enumerated.item[0];
-	int ret;
+	int ret = 0;
 
 	if (item >= e->items)
 		return -EINVAL;
@@ -916,10 +916,10 @@ static int madera_adsp_rate_put(struct snd_kcontrol *kcontrol,
 			 "Cannot change '%s' while in use by active audio paths\n",
 			 kcontrol->id.name);
 		ret = -EBUSY;
-	} else {
+	} else if (priv->adsp_rate_cache[adsp_num] != e->values[item]) {
 		/* Volatile register so defer until the codec is powered up */
 		priv->adsp_rate_cache[adsp_num] = e->values[item];
-		ret = 0;
+		ret = 1;
 	}
 
 	mutex_unlock(&priv->rate_lock);
-- 
2.35.1

