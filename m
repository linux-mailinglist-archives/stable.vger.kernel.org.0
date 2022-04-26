Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8739450F486
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345168AbiDZIgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345231AbiDZIfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76A782313;
        Tue, 26 Apr 2022 01:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43B42617EB;
        Tue, 26 Apr 2022 08:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD0AC385AC;
        Tue, 26 Apr 2022 08:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961729;
        bh=sAv8qm0Z77pvWBsV0ej1topD7SZMzaglwU7qcAK61LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1jSVmjzV6B6EKuRfLeiaNv2RrNk55/v69txgIPSHFuw4kM72VdmqZn3EM9D2RvVr
         ITf+aqwH2or/aAFQVP/p/jjW72StkvrijW1z8Lb3+lX2HUuWrprnbuuscR5R5Hp/mu
         CJqVf+aZmC2i0g4UryMOEU8D2H7TWtH7M0bBJiIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/62] ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component
Date:   Tue, 26 Apr 2022 10:20:51 +0200
Message-Id: <20220426081737.550569415@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit e927b05f3cc20de87f6b7d912a5bbe556931caca ]

devm_snd_soc_register_component() may fails, we should check the error
and do the corresponding error handling.

Fixes: 150db8c5afa1 ("ASoC: codecs: Add msm8916-wcd digital codec")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220403115239.30140-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/msm8916-wcd-digital.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/msm8916-wcd-digital.c b/sound/soc/codecs/msm8916-wcd-digital.c
index d5269ab5f91c..e4cde214b7b2 100644
--- a/sound/soc/codecs/msm8916-wcd-digital.c
+++ b/sound/soc/codecs/msm8916-wcd-digital.c
@@ -1206,9 +1206,16 @@ static int msm8916_wcd_digital_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, priv);
 
-	return devm_snd_soc_register_component(dev, &msm8916_wcd_digital,
+	ret = devm_snd_soc_register_component(dev, &msm8916_wcd_digital,
 				      msm8916_wcd_digital_dai,
 				      ARRAY_SIZE(msm8916_wcd_digital_dai));
+	if (ret)
+		goto err_mclk;
+
+	return 0;
+
+err_mclk:
+	clk_disable_unprepare(priv->mclk);
 err_clk:
 	clk_disable_unprepare(priv->ahbclk);
 	return ret;
-- 
2.35.1



