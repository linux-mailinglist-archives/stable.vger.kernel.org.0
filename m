Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609D4541AC2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376930AbiFGViB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381141AbiFGVgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:36:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1899814087F;
        Tue,  7 Jun 2022 12:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85961B823B0;
        Tue,  7 Jun 2022 19:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DDCC385A2;
        Tue,  7 Jun 2022 19:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628695;
        bh=ldGhd7bSBWMTDEq9RvkJwTdry4k2qspt5cCyIwrHyVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odDAOy5Q+GORoSe/DdlY2JYPaqLZa+DHLsl+asNtyackLQL4r2uFCILI2nyC30fZz
         W0KPbSbRdXAClePrh5z6gqz3VzIDQg1yL3UDUCfGn2rxC/UNs29/hmk8VbOXkCZtRV
         T2vcjbn0WQcjPwdlMsXVI3QaOdUcGVSTXtauQjeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 423/879] ASoC: samsung: Fix refcount leak in aries_audio_probe
Date:   Tue,  7 Jun 2022 18:59:01 +0200
Message-Id: <20220607165015.144184549@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

[ Upstream commit bf4a9b2467b775717d0e9034ad916888e19713a3 ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
If extcon_find_edev_by_node() fails, it doesn't call of_node_put()
Calling of_node_put() after extcon_find_edev_by_node() to fix this.

Fixes: 7a3a7671fa6c ("ASoC: samsung: Add driver for Aries boards")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220512043828.496-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/aries_wm8994.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/aries_wm8994.c b/sound/soc/samsung/aries_wm8994.c
index 5265e546b124..83acbe57b248 100644
--- a/sound/soc/samsung/aries_wm8994.c
+++ b/sound/soc/samsung/aries_wm8994.c
@@ -585,10 +585,10 @@ static int aries_audio_probe(struct platform_device *pdev)
 
 	extcon_np = of_parse_phandle(np, "extcon", 0);
 	priv->usb_extcon = extcon_find_edev_by_node(extcon_np);
+	of_node_put(extcon_np);
 	if (IS_ERR(priv->usb_extcon))
 		return dev_err_probe(dev, PTR_ERR(priv->usb_extcon),
 				     "Failed to get extcon device");
-	of_node_put(extcon_np);
 
 	priv->adc = devm_iio_channel_get(dev, "headset-detect");
 	if (IS_ERR(priv->adc))
-- 
2.35.1



