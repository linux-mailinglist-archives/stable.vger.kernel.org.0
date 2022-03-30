Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066984EC2B0
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbiC3MAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344889AbiC3L4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:56:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A822BB0B;
        Wed, 30 Mar 2022 04:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40A6DB81ACC;
        Wed, 30 Mar 2022 11:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0326C340F2;
        Wed, 30 Mar 2022 11:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641276;
        bh=N7VV4WU4ve5a9mkAhzkgXt2CymUm4Y3tFt0YFfoLEbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXdIoeDX0PfKBl0AOK4ma3bF3o7qHxhW+lnX9p9ERAJX5BLiQPSOtaMvrNdYethkB
         j56COJp15mHwaxdIZwF+RQnIebXF/UkEFsoTJhYRZJvmEfz71qxkptjaq2LmJgfzi1
         XBrhZoJrNeb9+7R+aRpj4AWNNKgx0twgHOntmIU3RUsVUVJjwQZx/dNEs3ebwPLdcU
         IgCjbNryV8g3fF4DIQGvKtYre7pt11EqQknDSZIg7nEQBsU7J1MBQalmXB1l8w7vpC
         Fiy8bQk4vaW6hOJ5BRZSANh/sCUnJFuqBT/Hd/Z0sqdZxemM5g4FWxEmSVsuZ4K7hg
         WBboBKvFCeOXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 17/17] ASoC: ak4642: Use of_device_get_match_data()
Date:   Wed, 30 Mar 2022 07:54:06 -0400
Message-Id: <20220330115407.1673214-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115407.1673214-1-sashal@kernel.org>
References: <20220330115407.1673214-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

[ Upstream commit 835ca59799f5c60b4b54bdc7aa785c99552f63e4 ]

Use of_device_get_match_data() to simplify the code.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Link: https://lore.kernel.org/r/20220315023226.2118354-1-chi.minghao@zte.com.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4613.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/ak4613.c b/sound/soc/codecs/ak4613.c
index e819dd8c82fd..b6b93c2b7593 100644
--- a/sound/soc/codecs/ak4613.c
+++ b/sound/soc/codecs/ak4613.c
@@ -500,15 +500,10 @@ static int ak4613_i2c_probe(struct i2c_client *i2c,
 	struct ak4613_priv *priv;
 
 	regmap_cfg = NULL;
-	if (np) {
-		const struct of_device_id *of_id;
-
-		of_id = of_match_device(ak4613_of_match, dev);
-		if (of_id)
-			regmap_cfg = of_id->data;
-	} else {
+	if (np)
+		regmap_cfg = of_device_get_match_data(dev);
+	else
 		regmap_cfg = (const struct regmap_config *)id->driver_data;
-	}
 
 	if (!regmap_cfg)
 		return -EINVAL;
-- 
2.34.1

