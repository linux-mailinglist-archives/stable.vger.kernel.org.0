Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4439579F00
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243228AbiGSNJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243099AbiGSNIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:08:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B944B0DD;
        Tue, 19 Jul 2022 05:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C32460908;
        Tue, 19 Jul 2022 12:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC259C341CA;
        Tue, 19 Jul 2022 12:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233685;
        bh=wOFnb+h38ZHkQ71ZrI57raY9yE4kjjI4LOL96pxBNUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krF9xmZvhmsKdz0XjOdLM9N8uwlXWQdpUF4HmtXO0++KqHuR33pVqEz6Rw4ySe51c
         lqjUaoycIr+ZYm2Bsxph3tAfgl8un1o3NcHyXN5b+Ugj+nQI6rc3TEPOm6l3H+K/nZ
         lBc1QyEjxy/+Gpp7hxY+m8DxfqU3XYe1Hh84d/ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 206/231] ASoC: madera: Fix event generation for rate controls
Date:   Tue, 19 Jul 2022 13:54:51 +0200
Message-Id: <20220719114731.275818416@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8095a87117cf..b9f19fbd2911 100644
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



