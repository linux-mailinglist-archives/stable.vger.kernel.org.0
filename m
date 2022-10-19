Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88299603D94
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiJSJFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiJSJEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF98FA6C00;
        Wed, 19 Oct 2022 01:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF49F61834;
        Wed, 19 Oct 2022 08:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6CBC433D7;
        Wed, 19 Oct 2022 08:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169724;
        bh=hvGvUU9CEjWIrKx8lFqFQJsfFIqXXtdKrx+cM1+mxxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIDRrTBrWFdGav36awmYBbuhyUrBKHga2rkzBH6Zu72WB1ymOnym7KhFcktL9iTmt
         78tTQjokZpchU6+i1AfnLsnsSCJV16TDNEU38NHF8dCs22coJvpkM//HLrQxdlHSJc
         F0TqUn4/lqPoOCTyRtJehqTKPRTsatvbquh4YI4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 385/862] ASoC: mediatek: mt8195-mt6359: Properly register sound card for SOF
Date:   Wed, 19 Oct 2022 10:27:52 +0200
Message-Id: <20221019083306.967386159@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 64ec924c781ee846bd469be8d1d6bbed78c0f439 ]

Adding a probe callback on this snd_soc_card is required when
Sound Open Firmware support is desired, as we need to appropriately
populate the stream_name for SOF to be able to bind widgets.
Failing to do so will produce errors when applying the SOF topology
leading to card registration failure (so, no sound).
While at it, also make sure to fill the topology_shortname as required.

Fixes: 0caf1120c583 ("ASoC: mediatek: mt8195: extract SOF common code")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220906092727.37324-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-mt6359.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/mediatek/mt8195/mt8195-mt6359.c b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
index c530e3fc27e4..961e769602d6 100644
--- a/sound/soc/mediatek/mt8195/mt8195-mt6359.c
+++ b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
@@ -1383,7 +1383,13 @@ static int mt8195_mt6359_dev_probe(struct platform_device *pdev)
 		sof_priv->num_streams = ARRAY_SIZE(g_sof_conn_streams);
 		sof_priv->sof_dai_link_fixup = mt8195_dai_link_fixup;
 		soc_card_data->sof_priv = sof_priv;
+		card->probe = mtk_sof_card_probe;
 		card->late_probe = mtk_sof_card_late_probe;
+		if (!card->topology_shortname_created) {
+			snprintf(card->topology_shortname, 32, "sof-%s", card->name);
+			card->topology_shortname_created = true;
+		}
+		card->name = card->topology_shortname;
 		sof_on = 1;
 	}
 
-- 
2.35.1



