Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB8560210B
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 04:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJRCTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 22:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiJRCTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 22:19:34 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B939ED118
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 19:19:31 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j16so21291827wrh.5
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 19:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwZtrx9kBniYABoRvDcMY2qPNP6zFDKkhZk2pmiIljM=;
        b=TUF3fe60ezCdKamcKj9noLbVquPlFC4py7fg2C0YZ3gZljw0ncz1qm0Ur0OJFnUpjN
         +YgqmR8qAMljbPSDcQ5+aRZ2Ou0jP+691hI4RgfGwkEH93kxxEjwEmAM9ba45tMuaiVZ
         Hwns6NdkCj6+wwbkbzqta+TlpX9hXba63MFgeqbFpKjkY9jK38Ed3WgQTwlo2G07BMdF
         07IkWOwHdK2YnS5RCDBjDhevkcwBOuJwmv8SWHTWYaOXDz5WX3btLBe9VJnUZqsrvjzc
         z+XruvrmOjdF3FT7bMl2YRmtq+rmLhJlVwDPf+t3GLAg4na8iE6HCfKy5GDan75gFkA1
         irQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uwZtrx9kBniYABoRvDcMY2qPNP6zFDKkhZk2pmiIljM=;
        b=vRGf3MtMsBOadAQDVSJJfxJdwofqNq9PNBACAPM6vRdioRcCkbcTln9ziX1y3+y0op
         3603/NqaP7T1dPH6e70vpJ8DXL8InO0r0olR/x+f/DIABZ9IQ+iExR5ywDwG8808KAqn
         ryE3vLC+hknjHI/hWMC0izw3/Mtun1yRh0g6JeZF/2gi6k3ioiHzUPM2loasmFBIBlLW
         gjJhVb+z22SITHGc7OHIuIAmQg1DlY3dZ0nQJa4LrcHNMiwtPdCrCSu0Dpt5IR1TztP3
         5IsqjGag9+Wwg/KVS63cxegFqzK9/wvXlxkeOitilkh041hs8hEityzkZ45gU/AzGZfN
         HWXQ==
X-Gm-Message-State: ACrzQf3UHkfMvZ0+VRjmAd6z/g6a3UxsyGLIJt4Xw75xVZRMeApXw3x5
        ACWHbYHpa4YbvZ4g1joU6QFe+A==
X-Google-Smtp-Source: AMsMyM4J92rRq52foZG0M7r0C2KA6h5gg9IjNfARErOjqkPDIWbPbaj7HDceWbdGjPX3UvGd5ua1TA==
X-Received: by 2002:a5d:6d8e:0:b0:22e:60ae:8875 with SMTP id l14-20020a5d6d8e000000b0022e60ae8875mr357716wrs.676.1666059570349;
        Mon, 17 Oct 2022 19:19:30 -0700 (PDT)
Received: from planet9.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id y6-20020a1c4b06000000b003a83ca67f73sm11921533wma.3.2022.10.17.19.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 19:19:29 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     loic.poulain@linaro.org, robert.foss@linaro.org, wsa@kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vladimir.zapolskiy@linaro.org, bryan.odonoghue@linaro.org,
        stable@vger.kernel.org
Subject: [PATCH v3 1/1] i2c: qcom-cci: Fix ordering of pm_runtime_xx and i2c_add_adapter
Date:   Tue, 18 Oct 2022 03:19:20 +0100
Message-Id: <20221018021920.3747344-2-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018021920.3747344-1-bryan.odonoghue@linaro.org>
References: <20221018021920.3747344-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we compile-in the CCI along with the imx412 driver and run on the RB5
we see that i2c_add_adapter() causes the probe of the imx412 driver to
happen.

This probe tries to perform an i2c xfer() and the xfer() in i2c-qcom-cci.c
fails on pm_runtime_get() because the i2c-qcom-cci.c::probe() function has
not completed to pm_runtime_enable(dev).

Fix this sequence by ensuring pm_runtime_xxx() calls happen prior to adding
the i2c adapter.

Fixes: e517526195de ("i2c: Add Qualcomm CCI I2C driver")
Reported-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Tested-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index 87739fb4388b..a4b97fe3c3a5 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -639,6 +639,11 @@ static int cci_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error;
 
+	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	for (i = 0; i < cci->data->num_masters; i++) {
 		if (!cci->master[i].cci)
 			continue;
@@ -650,14 +655,12 @@ static int cci_probe(struct platform_device *pdev)
 		}
 	}
 
-	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
-	pm_runtime_use_autosuspend(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
 	return 0;
 
 error_i2c:
+	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+
 	for (--i ; i >= 0; i--) {
 		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
-- 
2.34.1

