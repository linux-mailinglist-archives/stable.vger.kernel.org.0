Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF5C5742AD
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbiGNEZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiGNEY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:24:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904EE27CE7;
        Wed, 13 Jul 2022 21:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0738B82371;
        Thu, 14 Jul 2022 04:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71579C36AED;
        Thu, 14 Jul 2022 04:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772595;
        bh=/fHJWlnFXw+q/18s8kVtADDVxFDL1rLDIEpi1M9ytc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rd8TQ7SO5IbO02MrQG6DtqBVKRPlKxbsRqIt6RM/hyZh7eJBdVbniEfk+luvrjtEN
         ymbPJqKu7hFer5300sgheMxUgeeszGkqP1pVeKbmi9o+6aMVP0X3YQl24I6omSN0nT
         AdTNXWsjNgm+NGsg+XGVHE6rBIGLMzhG8kyLBWyPS3e49B2xxjurIuAKzf/G435dIL
         4q7UNuRaTU/9m4Sx8T/fRv7JtUzjBhAfClquhtBHjzKXHrGs2dFE75X6sBE3TuCNSU
         R6ULXB6GhGnIyxNANo2mxyEGj34ddeAZdBPy6908crqzpJzlMiPLYum4Slz7VhcfT+
         2NxEX++HiMUrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 20/41] ASoC: rt711-sdca: fix kernel NULL pointer dereference when IO error
Date:   Thu, 14 Jul 2022 00:22:00 -0400
Message-Id: <20220714042221.281187-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
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

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 1df793d479bef546569fc2e409ff8bb3f0fb8e99 ]

The initial settings will be written before the codec probe function.
But, the rt711->component doesn't be assigned yet.
If IO error happened during initial settings operations, it will cause the kernel panic.
This patch changed component->dev to slave->dev to fix this issue.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20220621090719.30558-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index d8821d535a24..ac75d8a2c9fe 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -34,7 +34,7 @@ static int rt711_sdca_index_write(struct rt711_sdca_priv *rt711,
 
 	ret = regmap_write(regmap, addr, value);
 	if (ret < 0)
-		dev_err(rt711->component->dev,
+		dev_err(&rt711->slave->dev,
 			"Failed to set private value: %06x <= %04x ret=%d\n",
 			addr, value, ret);
 
@@ -50,7 +50,7 @@ static int rt711_sdca_index_read(struct rt711_sdca_priv *rt711,
 
 	ret = regmap_read(regmap, addr, value);
 	if (ret < 0)
-		dev_err(rt711->component->dev,
+		dev_err(&rt711->slave->dev,
 			"Failed to get private value: %06x => %04x ret=%d\n",
 			addr, *value, ret);
 
-- 
2.35.1

