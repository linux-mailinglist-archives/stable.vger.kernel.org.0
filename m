Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A716BBBDA
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjCOSTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjCOSTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:19:08 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD0F580E0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:19:06 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a2so21015121plm.4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678904346;
        h=content-transfer-encoding:author:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wMT5a+0N50LjnqJ8DeT4FwWt5REi2t/S+xWI0ToHGwg=;
        b=skqHJLcoG8K+I8S8KSD0VQCcE+P7rOiJrQ8WPyKC4zzaPIVrk26Ms17s2DFfsqKh8s
         mcqBMRwil9W4hFNwb8lsn67P8fCYXmT6oLc5fVNBl8geDuFkF9ioHNzyj65bbCJeB4DM
         +LNzw5Hq1NfeHOGl7vSImUoaGGelx8+WSI0T3bZ0TFU43/sOqjvGLf4ZarQr53Db1/rn
         xDm9iHv8ymiee4XCBl1cVIq7xutCJ6ydNsXpCkpshfOCW4SgL/KaRWbbWBkAhvm6hqsG
         WvWkcJl50R633VRvjyttcfus95jqFxx3H3x9nGOELt39Am+40A8Rqg1PCcHX3dQPWmb2
         mTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678904346;
        h=content-transfer-encoding:author:mime-version:message-id:date
         :subject:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMT5a+0N50LjnqJ8DeT4FwWt5REi2t/S+xWI0ToHGwg=;
        b=C1KwkJ1a25wBuTO2/9wON7YeI/YUQx4Oah+n1D3KBnIubmXFCiIxegXjWJYcJdZ9d3
         abeFHX9koNvTIXF/Wkw5LrpxBorMNhnRRDAayr6f52AnhaY9Np63CgYEpkow+M8MVZ6c
         PTWIOfKLpKU/bO/FDPn2Al/bIodevIdd4MA7BG8/ccjDMpKAtU05gVcnvglwUL8y/72X
         5NKB7vjcVSO1lSWtpQ6Ro3dPUxzVaNSenk1qb0sZnv8ZYE4khxvnLMSj1YFOcxE3vMVD
         k07en2//UY2p8iIcFO3MrL3IC0iDJgsHbD7xzfxA8ro1jNjxXvdbc6gGXj9oH2XjGEa/
         Rw0A==
X-Gm-Message-State: AO0yUKW7Iy71jEbdRMlhedvAB2l2JvjwK0rj5xx8bbYYYW3iCMys67GE
        qJu+Br+H5IyF0P2tcyHLfItpgDEiRi8eH7Ixue8=
X-Google-Smtp-Source: AK7set+CzjKnoyfvS/0CbrkyCxGCSi8yJ0a0AvmKdo9xjI4haYF2znwZRZwmKoXowkQww6uC5Fa9bA==
X-Received: by 2002:a17:903:4111:b0:19a:b6bf:1df6 with SMTP id r17-20020a170903411100b0019ab6bf1df6mr408316pld.20.1678904346080;
        Wed, 15 Mar 2023 11:19:06 -0700 (PDT)
Received: from localhost.localdomain ([122.171.16.15])
        by smtp.gmail.com with ESMTPSA id ky3-20020a170902f98300b001a065d3bb0esm3809948plb.211.2023.03.15.11.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 11:19:05 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH for-6.1.y] Revert "ASoC: codecs: lpass: register mclk after runtime pm"
Date:   Wed, 15 Mar 2023 23:49:00 +0530
Message-Id: <20230315181900.2107200-1-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Author: Amit Pundir <amit.pundir@linaro.org>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 7b642273438cf500d36cffde145b9739fa525c1d which is
commit 1dc3459009c33e335f0d62b84dd39a6bbd7fd5d2 upstream.

This patch broke RB5 (Qualcomm SM8250) devboard. The device
reboots into USB crash dump mode after following error:

    qcom_q6v5_pas 17300000.remoteproc: fatal error received: \
    ABT_dal.c:278:ABTimeout: AHB Bus hang is detected, \
    Number of bus hang detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 sound/soc/codecs/lpass-rx-macro.c  |  8 ++++----
 sound/soc/codecs/lpass-tx-macro.c  |  8 ++++----
 sound/soc/codecs/lpass-va-macro.c  | 20 ++++++++++----------
 sound/soc/codecs/lpass-wsa-macro.c |  9 +++++----
 4 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 8621cfabcf5b..92e61f2206cb 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -3601,6 +3601,10 @@ static int rx_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_fsgen;
 
+	ret = rx_macro_register_mclk_output(rx);
+	if (ret)
+		goto err_clkout;
+
 	ret = devm_snd_soc_register_component(dev, &rx_macro_component_drv,
 					      rx_macro_dai,
 					      ARRAY_SIZE(rx_macro_dai));
@@ -3614,10 +3618,6 @@ static int rx_macro_probe(struct platform_device *pdev)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	ret = rx_macro_register_mclk_output(rx);
-	if (ret)
-		goto err_clkout;
-
 	return 0;
 
 err_clkout:
diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 5d1c58df081a..33760213f406 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1889,6 +1889,10 @@ static int tx_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_fsgen;
 
+	ret = tx_macro_register_mclk_output(tx);
+	if (ret)
+		goto err_clkout;
+
 	ret = devm_snd_soc_register_component(dev, &tx_macro_component_drv,
 					      tx_macro_dai,
 					      ARRAY_SIZE(tx_macro_dai));
@@ -1901,10 +1905,6 @@ static int tx_macro_probe(struct platform_device *pdev)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	ret = tx_macro_register_mclk_output(tx);
-	if (ret)
-		goto err_clkout;
-
 	return 0;
 
 err_clkout:
diff --git a/sound/soc/codecs/lpass-va-macro.c b/sound/soc/codecs/lpass-va-macro.c
index 1623ba78ddb3..b0b6cf29cba3 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -1524,6 +1524,16 @@ static int va_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_mclk;
 
+	ret = va_macro_register_fsgen_output(va);
+	if (ret)
+		goto err_clkout;
+
+	va->fsgen = clk_hw_get_clk(&va->hw, "fsgen");
+	if (IS_ERR(va->fsgen)) {
+		ret = PTR_ERR(va->fsgen);
+		goto err_clkout;
+	}
+
 	if (va->has_swr_master) {
 		/* Set default CLK div to 1 */
 		regmap_update_bits(va->regmap, CDC_VA_TOP_CSR_SWR_MIC_CTL0,
@@ -1550,16 +1560,6 @@ static int va_macro_probe(struct platform_device *pdev)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	ret = va_macro_register_fsgen_output(va);
-	if (ret)
-		goto err_clkout;
-
-	va->fsgen = clk_hw_get_clk(&va->hw, "fsgen");
-	if (IS_ERR(va->fsgen)) {
-		ret = PTR_ERR(va->fsgen);
-		goto err_clkout;
-	}
-
 	return 0;
 
 err_clkout:
diff --git a/sound/soc/codecs/lpass-wsa-macro.c b/sound/soc/codecs/lpass-wsa-macro.c
index c012033fb69e..5e0abefe7cce 100644
--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -2449,6 +2449,11 @@ static int wsa_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_fsgen;
 
+	ret = wsa_macro_register_mclk_output(wsa);
+	if (ret)
+		goto err_clkout;
+
+
 	ret = devm_snd_soc_register_component(dev, &wsa_macro_component_drv,
 					      wsa_macro_dai,
 					      ARRAY_SIZE(wsa_macro_dai));
@@ -2461,10 +2466,6 @@ static int wsa_macro_probe(struct platform_device *pdev)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	ret = wsa_macro_register_mclk_output(wsa);
-	if (ret)
-		goto err_clkout;
-
 	return 0;
 
 err_clkout:
-- 
2.25.1

