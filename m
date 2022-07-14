Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD89257438E
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbiGNEgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbiGNEfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:35:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B083CBC1;
        Wed, 13 Jul 2022 21:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A31DB82376;
        Thu, 14 Jul 2022 04:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985ECC34115;
        Thu, 14 Jul 2022 04:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772784;
        bh=yq3en7uJrOMsKfoyfIqOia6edMmizWg+luTeklrv0dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhpmAk+TrtDI78ujxgpYy1b31r6v4otZTfjZWUrefW/a4g3LTvfFmgkgmX72A+pBK
         lcfvnoHknnBu9ZhzYIAqsDmZmvzBne+czWGx9VHUPmZxPpoSgWvL6InxHDgIEHXR7M
         soewmfU6w3+ia0N5NDzrWkH6AkEYoLKIGfISPQuj4Iz1szdBbg1UlaO7i7QVZBgMzu
         hi+c5kAVo01wS/aTXtN7F0WvnUmc29Srp5RJdVN4HyqanonSQqa5KWYZYUzWBm1ByZ
         rE3R2n63g9rUiWTd/332hSQeZjFCPn/KplHOgdwgLLAqx1aFPmmIKcWAWRXArFuk/a
         P27ZaQPiZ5ifQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rf@opensource.cirrus.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 05/10] ASoC: madera: Fix event generation for rate controls
Date:   Thu, 14 Jul 2022 00:26:07 -0400
Message-Id: <20220714042612.282378-5-sashal@kernel.org>
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
index e375dca9ba8d..4a56082a4c43 100644
--- a/sound/soc/codecs/madera.c
+++ b/sound/soc/codecs/madera.c
@@ -853,7 +853,7 @@ static int madera_adsp_rate_put(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	const int adsp_num = e->shift_l;
 	const unsigned int item = ucontrol->value.enumerated.item[0];
-	int ret;
+	int ret = 0;
 
 	if (item >= e->items)
 		return -EINVAL;
@@ -870,10 +870,10 @@ static int madera_adsp_rate_put(struct snd_kcontrol *kcontrol,
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

