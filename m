Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AD34F2709
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbiDEIFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiDEIAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE0A1AF33;
        Tue,  5 Apr 2022 00:57:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 475C8B81B90;
        Tue,  5 Apr 2022 07:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9838CC340EE;
        Tue,  5 Apr 2022 07:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145474;
        bh=QlK+fwpu7ZtD2C3yV/ydrvguyf3FpGIVVQmFwYhvBoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pgn9cO2gS8nMPdLsZzs0ErlSwuWfAHOBVpCUEQbCAqt4LSrStauBCAcqjkNGsKawY
         t1lGuoiT48H2W3jMOB+0kXeyW9q7hotunr7ZsqyByYrYzclg/lkxSNUFjlcWWp0yga
         05DvMEvr90ePRkIVIhUU4za/2f/waXmTgDB8ZR7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0417/1126] ASoC: mediatek: mt8195: Fix error handling in mt8195_mt6359_rt1019_rt5682_dev_probe
Date:   Tue,  5 Apr 2022 09:19:24 +0200
Message-Id: <20220405070419.865907939@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c4b7174fe5bb875a09a78674a14a1589d1a672f3 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

This function only calls of_node_put() in the regular path.
And it will cause refcount leak in error path.

Fixes: 082482a50227 ("ASoC: mediatek: mt8195: release device_node after snd_soc_register_card")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220316084623.24238-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c b/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
index 29c2d3407cc7..e3146311722f 100644
--- a/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
+++ b/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
@@ -1342,7 +1342,8 @@ static int mt8195_mt6359_rt1019_rt5682_dev_probe(struct platform_device *pdev)
 					      "mediatek,dai-link");
 		if (ret) {
 			dev_dbg(&pdev->dev, "Parse dai-link fail\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto put_node;
 		}
 	} else {
 		if (!sof_on)
@@ -1398,6 +1399,7 @@ static int mt8195_mt6359_rt1019_rt5682_dev_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 
+put_node:
 	of_node_put(platform_node);
 	of_node_put(adsp_node);
 	of_node_put(dp_node);
-- 
2.34.1



