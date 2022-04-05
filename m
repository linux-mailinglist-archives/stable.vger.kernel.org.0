Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C81C4F27B5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbiDEIIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiDEH77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA931CB3C;
        Tue,  5 Apr 2022 00:57:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00692B81B90;
        Tue,  5 Apr 2022 07:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B94C340EE;
        Tue,  5 Apr 2022 07:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145424;
        bh=crWXL8M3ZbJbxnQixr9aRZM4fdsgYuS+RPOQpMn+idA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrOjOaXorXTEc1lp/q7/RJZ+t1j/v9Ba2NyDs5Pufx9PjnHrQt6O67e4TN+z1IDl1
         Ck7Ic7KGDIpz1XisbIAdVgyDUXnVoiiI5CK6Q4LINtzw9pwLeqA/4iDrVBcOKNCBE/
         KB+2arXbQnyp9JNe5s7D5x72ILAXB1/41gGdY3Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0383/1126] ASoC: dwc-i2s: Handle errors for clk_enable
Date:   Tue,  5 Apr 2022 09:18:50 +0200
Message-Id: <20220405070418.868555065@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 45ea97d74313bae681328b0c36fa348036777644 ]

As the potential failure of the clk_enable(),
it should be better to check it, as same as clk_prepare_enable().

Fixes: c9afc1834e81 ("ASoC: dwc: Disallow building designware_pcm as a module")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220301084742.3751939-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/dwc/dwc-i2s.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/sound/soc/dwc/dwc-i2s.c b/sound/soc/dwc/dwc-i2s.c
index 5cb58929090d..1edac3e10f34 100644
--- a/sound/soc/dwc/dwc-i2s.c
+++ b/sound/soc/dwc/dwc-i2s.c
@@ -403,9 +403,13 @@ static int dw_i2s_runtime_suspend(struct device *dev)
 static int dw_i2s_runtime_resume(struct device *dev)
 {
 	struct dw_i2s_dev *dw_dev = dev_get_drvdata(dev);
+	int ret;
 
-	if (dw_dev->capability & DW_I2S_MASTER)
-		clk_enable(dw_dev->clk);
+	if (dw_dev->capability & DW_I2S_MASTER) {
+		ret = clk_enable(dw_dev->clk);
+		if (ret)
+			return ret;
+	}
 	return 0;
 }
 
@@ -422,10 +426,13 @@ static int dw_i2s_resume(struct snd_soc_component *component)
 {
 	struct dw_i2s_dev *dev = snd_soc_component_get_drvdata(component);
 	struct snd_soc_dai *dai;
-	int stream;
+	int stream, ret;
 
-	if (dev->capability & DW_I2S_MASTER)
-		clk_enable(dev->clk);
+	if (dev->capability & DW_I2S_MASTER) {
+		ret = clk_enable(dev->clk);
+		if (ret)
+			return ret;
+	}
 
 	for_each_component_dais(component, dai) {
 		for_each_pcm_streams(stream)
-- 
2.34.1



