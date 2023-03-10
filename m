Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA556B4AA4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbjCJPZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbjCJPYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:24:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F5212EE68
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:14:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E2A1B8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CABC433D2;
        Fri, 10 Mar 2023 15:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461233;
        bh=PHb53PWgk6pVkn5WyBphxLqhoYsjYRjP6gRoXxckd+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5TmLv2OLt7fQ2/POruSJidqbGwKEXXoaNugzHXl7jlx4J6mybGegeX/2m4Gwxmhw
         p1uVUbXhLtnw2IVLthojE3hphRv6AOl91kaG6y/6hYmCtB9/PocOUznrpO021PaCwf
         YvgI47n7/xE3j4+ggdNahphm2KAa6UDzl/qwklCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Trevor Wu <trevor.wu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/136] ASoC: mediatek: mt8195: add missing initialization
Date:   Fri, 10 Mar 2023 14:43:12 +0100
Message-Id: <20230310133709.267980408@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trevor Wu <trevor.wu@mediatek.com>

[ Upstream commit b56ec2992a2e43bc3e60d6db86849d31640e791f ]

In etdm dai driver, dai_etdm_parse_of() function is used to parse dts
properties to get parameters. There are two for-loops which are
sepearately for all etdm and etdm input only cases. In etdm in only
loop, dai_id is not initialized, so it keeps the value intiliazed in
another loop.

In the patch, add the missing initialization to fix the unexpected
parsing problem.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Signed-off-by: Trevor Wu <trevor.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230301110200.26177-3-trevor.wu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index 7378e42f27669..9031d410bbd0a 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -2567,6 +2567,9 @@ static void mt8195_dai_etdm_parse_of(struct mtk_base_afe *afe)
 
 	/* etdm in only */
 	for (i = 0; i < 2; i++) {
+		dai_id = ETDM_TO_DAI_ID(i);
+		etdm_data = afe_priv->dai_priv[dai_id];
+
 		ret = snprintf(prop, sizeof(prop),
 			       "mediatek,%s-chn-disabled",
 			       of_afe_etdms[i].name);
-- 
2.39.2



