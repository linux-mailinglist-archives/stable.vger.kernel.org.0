Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1414D6B4ABB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbjCJP0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjCJPZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:25:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE19112583
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:15:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B1D661A01
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5659FC433EF;
        Fri, 10 Mar 2023 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461224;
        bh=viM77w2pKoYIR8mW1TR//Xnsk50vXEHLs/X7Xr88bsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBpYQheIn0eSVLoIWBGuzvLrWlUsk8kQ/bYSN9nmjLAyCTe7hK0SScaoQfLRVxh3j
         3Vi1LYZ/BuQpiDvwloIPJiZbpgzpkuroHeDG8/Yq2exhVGn41mE/BTgDFnhaRhXHnu
         RAjvRNZBKCLpphUhEbVRzbZqYqXISbPVSSfVcGRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/136] ASoC: adau7118: dont disable regulators on device unbind
Date:   Fri, 10 Mar 2023 14:43:09 +0100
Message-Id: <20230310133709.171843645@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit b5bfa7277ee7d944421e0ef193586c6e34d7492c ]

The regulators are supposed to be controlled through the
set_bias_level() component callback. Moreover, the regulators are not
enabled during probe and so, this would lead to a regulator unbalanced
use count.

Fixes: ca514c0f12b02 ("ASOC: Add ADAU7118 8 Channel PDM-to-I2S/TDM Converter driver")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20230224104551.1139981-1-nuno.sa@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau7118.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/sound/soc/codecs/adau7118.c b/sound/soc/codecs/adau7118.c
index 841229dcbca10..305f294b7710e 100644
--- a/sound/soc/codecs/adau7118.c
+++ b/sound/soc/codecs/adau7118.c
@@ -445,22 +445,6 @@ static const struct snd_soc_component_driver adau7118_component_driver = {
 	.non_legacy_dai_naming	= 1,
 };
 
-static void adau7118_regulator_disable(void *data)
-{
-	struct adau7118_data *st = data;
-	int ret;
-	/*
-	 * If we fail to disable DVDD, don't bother in trying IOVDD. We
-	 * actually don't want to be left in the situation where DVDD
-	 * is enabled and IOVDD is disabled.
-	 */
-	ret = regulator_disable(st->dvdd);
-	if (ret)
-		return;
-
-	regulator_disable(st->iovdd);
-}
-
 static int adau7118_regulator_setup(struct adau7118_data *st)
 {
 	st->iovdd = devm_regulator_get(st->dev, "iovdd");
@@ -482,8 +466,7 @@ static int adau7118_regulator_setup(struct adau7118_data *st)
 		regcache_cache_only(st->map, true);
 	}
 
-	return devm_add_action_or_reset(st->dev, adau7118_regulator_disable,
-					st);
+	return 0;
 }
 
 static int adau7118_parset_dt(const struct adau7118_data *st)
-- 
2.39.2



