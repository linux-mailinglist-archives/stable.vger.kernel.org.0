Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70E8548F5A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbiFMKl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346204AbiFMKj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:39:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E24528E0D;
        Mon, 13 Jun 2022 03:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49C94B80E94;
        Mon, 13 Jun 2022 10:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36B6C34114;
        Mon, 13 Jun 2022 10:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115812;
        bh=PyINb2rJZQ7Qe5pjNIZ7+ywP2k++AnplNV1utZalMI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVtQdXveThP8TxAx3Oir3BewkCaeUrqEGln1V/VR9khmIQOVKXS2KlV/SADDNQbhK
         MzKXVu5noQlUCEA0l0s01d6YRTFQ6AYl0emwE6YfP4+VYAU6AzUI9Qnuv7bqnlVG0U
         6U0FkJKOQp3j/YrKGhkvHDbMneW1275jtBvDXBxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 050/218] ASoC: mediatek: Fix missing of_node_put in mt2701_wm8960_machine_probe
Date:   Mon, 13 Jun 2022 12:08:28 +0200
Message-Id: <20220613094920.227053512@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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

[ Upstream commit 05654431a18fe24e5e46a375d98904134628a102 ]

This node pointer is returned by of_parse_phandle() with
refcount incremented in this function.
Calling of_node_put() to avoid the refcount leak.

Fixes: 8625c1dbd876 ("ASoC: mediatek: Add mt2701-wm8960 machine driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220404093526.30004-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt2701/mt2701-wm8960.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt2701/mt2701-wm8960.c b/sound/soc/mediatek/mt2701/mt2701-wm8960.c
index a08ce2323bdc..3db92506ccea 100644
--- a/sound/soc/mediatek/mt2701/mt2701-wm8960.c
+++ b/sound/soc/mediatek/mt2701/mt2701-wm8960.c
@@ -126,7 +126,8 @@ static int mt2701_wm8960_machine_probe(struct platform_device *pdev)
 	if (!codec_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_platform_node;
 	}
 	for (i = 0; i < card->num_links; i++) {
 		if (mt2701_wm8960_dai_links[i].codec_name)
@@ -137,7 +138,7 @@ static int mt2701_wm8960_machine_probe(struct platform_device *pdev)
 	ret = snd_soc_of_parse_audio_routing(card, "audio-routing");
 	if (ret) {
 		dev_err(&pdev->dev, "failed to parse audio-routing: %d\n", ret);
-		return ret;
+		goto put_codec_node;
 	}
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
@@ -145,6 +146,10 @@ static int mt2701_wm8960_machine_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
 
+put_codec_node:
+	of_node_put(codec_node);
+put_platform_node:
+	of_node_put(platform_node);
 	return ret;
 }
 
-- 
2.35.1



