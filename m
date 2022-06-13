Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3E4549019
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356679AbiFMLuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356899AbiFMLtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909CF4D688;
        Mon, 13 Jun 2022 03:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0726A61361;
        Mon, 13 Jun 2022 10:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11132C34114;
        Mon, 13 Jun 2022 10:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117610;
        bh=2eEQkWOHcUlRS4z5PvTRLC5Y3/yTlasXSKzSjFQVwzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlgaNRGI3zJ80R5UYl++H6x0A2+ali8DNpRiiS887sQVNRpOED4LQV1k90pVj4nag
         x+bmtR4w9aZNSmS5kZjPUw9F9SEKEy58YFrCzlkw0GdAn1Z6/9uZW1XhEjQwkgeuIq
         H/eFN0lUkaZklcvt0WVms4OXt/2NaoiTj+8dYjwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/287] ASoC: mediatek: Fix error handling in mt8173_max98090_dev_probe
Date:   Mon, 13 Jun 2022 12:08:05 +0200
Message-Id: <20220613094925.719503061@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 4f4e0454e226de3bf4efd7e7924d1edc571c52d5 ]

Call of_node_put(platform_node) to avoid refcount leak in
the error path.

Fixes: 94319ba10eca ("ASoC: mediatek: Use platform_of_node for machine drivers")
Fixes: 493433785df0 ("ASoC: mediatek: mt8173: fix device_node leak")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220404092903.26725-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-max98090.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8173/mt8173-max98090.c b/sound/soc/mediatek/mt8173/mt8173-max98090.c
index 431ba3db1759..c9fc719c2af9 100644
--- a/sound/soc/mediatek/mt8173/mt8173-max98090.c
+++ b/sound/soc/mediatek/mt8173/mt8173-max98090.c
@@ -156,7 +156,8 @@ static int mt8173_max98090_dev_probe(struct platform_device *pdev)
 	if (!codec_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_platform_node;
 	}
 	for (i = 0; i < card->num_links; i++) {
 		if (mt8173_max98090_dais[i].codec_name)
@@ -171,6 +172,8 @@ static int mt8173_max98090_dev_probe(struct platform_device *pdev)
 			__func__, ret);
 
 	of_node_put(codec_node);
+
+put_platform_node:
 	of_node_put(platform_node);
 	return ret;
 }
-- 
2.35.1



