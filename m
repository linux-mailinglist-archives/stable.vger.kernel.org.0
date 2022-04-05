Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A204F36CC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352318AbiDELH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348757AbiDEJsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1364BFE6;
        Tue,  5 Apr 2022 02:34:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04362B81B75;
        Tue,  5 Apr 2022 09:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D823C385A4;
        Tue,  5 Apr 2022 09:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151290;
        bh=rrq5DQ4s3Epa8STH7GdSx073QvvtZEtfAAz8FBiN6QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1atCNA2C3N/2zoFBNds1hPeBQXcu42y6/L5xNK5M5ggZmNwgGRsomGQQw9bLFzXI
         P0CTiYZAb14pZCekT8PX1fg4SY3+x2v2Bk5tMa1oWDlbBUrzE+W10sBXHoKuURJnsV
         86xnMEML+Pg2rVbXC9N8zlobuDDKK2JNruixew4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 361/913] ASoC: dmaengine: do not use a NULL prepare_slave_config() callback
Date:   Tue,  5 Apr 2022 09:23:43 +0200
Message-Id: <20220405070350.666729129@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit 9a1e13440a4f2e7566fd4c5eae6a53e6400e08a4 ]

Even if struct snd_dmaengine_pcm_config is used, prepare_slave_config()
callback might not be set. Check if this callback is set before using it.

Fixes: fa654e085300 ("ASoC: dmaengine-pcm: Provide default config")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20220307122202.2251639-2-codrin.ciubotariu@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 4aa48c74f21a..38f3f36c1d72 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -82,10 +82,10 @@ static int dmaengine_pcm_hw_params(struct snd_soc_component *component,
 
 	memset(&slave_config, 0, sizeof(slave_config));
 
-	if (!pcm->config)
-		prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config;
-	else
+	if (pcm->config && pcm->config->prepare_slave_config)
 		prepare_slave_config = pcm->config->prepare_slave_config;
+	else
+		prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config;
 
 	if (prepare_slave_config) {
 		int ret = prepare_slave_config(substream, params, &slave_config);
-- 
2.34.1



