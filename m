Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A97500E93
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243804AbiDNNTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243832AbiDNNSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:18:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7E491557;
        Thu, 14 Apr 2022 06:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD4A8612ED;
        Thu, 14 Apr 2022 13:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B13C385A1;
        Thu, 14 Apr 2022 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942144;
        bh=EOdu4CEmkcnDwJMBk6OsqstsD3MrKYOf+7r24Eg9bds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=id5oyzun+923AKQQxrf4QcTk2Cq+ipNTqQF2mmYIyoRf2XUIBfbuaqhlejP0cV9FX
         1O6HrnG4AMx2KRFWmWIoyvDrCD3VGyNZUe0RUJQjWVXx6RrCO8cvP6Q+GRnk7PMYAb
         33h/UOKGLgdeY0ckTppIis0hQhk4Tto4uT9yeRcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 4.19 031/338] pinctrl: samsung: drop pin banks references on error paths
Date:   Thu, 14 Apr 2022 15:08:54 +0200
Message-Id: <20220414110839.778126605@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 50ebd19e3585b9792e994cfa8cbee8947fe06371 upstream.

The driver iterates over its devicetree children with
for_each_child_of_node() and stores for later found node pointer.  This
has to be put in error paths to avoid leak during re-probing.

Fixes: ab663789d697 ("pinctrl: samsung: Match pin banks with their device nodes")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Chanho Park <chanho61.park@samsung.com>
Link: https://lore.kernel.org/r/20220111201426.326777-2-krzysztof.kozlowski@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/samsung/pinctrl-samsung.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -1002,6 +1002,16 @@ samsung_pinctrl_get_soc_data_for_of_alia
 	return &(of_data->ctrl[id]);
 }
 
+static void samsung_banks_of_node_put(struct samsung_pinctrl_drv_data *d)
+{
+	struct samsung_pin_bank *bank;
+	unsigned int i;
+
+	bank = d->pin_banks;
+	for (i = 0; i < d->nr_banks; ++i, ++bank)
+		of_node_put(bank->of_node);
+}
+
 /* retrieve the soc specific data */
 static const struct samsung_pin_ctrl *
 samsung_pinctrl_get_soc_data(struct samsung_pinctrl_drv_data *d,
@@ -1116,19 +1126,19 @@ static int samsung_pinctrl_probe(struct
 	if (ctrl->retention_data) {
 		drvdata->retention_ctrl = ctrl->retention_data->init(drvdata,
 							  ctrl->retention_data);
-		if (IS_ERR(drvdata->retention_ctrl))
-			return PTR_ERR(drvdata->retention_ctrl);
+		if (IS_ERR(drvdata->retention_ctrl)) {
+			ret = PTR_ERR(drvdata->retention_ctrl);
+			goto err_put_banks;
+		}
 	}
 
 	ret = samsung_pinctrl_register(pdev, drvdata);
 	if (ret)
-		return ret;
+		goto err_put_banks;
 
 	ret = samsung_gpiolib_register(pdev, drvdata);
-	if (ret) {
-		samsung_pinctrl_unregister(pdev, drvdata);
-		return ret;
-	}
+	if (ret)
+		goto err_unregister;
 
 	if (ctrl->eint_gpio_init)
 		ctrl->eint_gpio_init(drvdata);
@@ -1138,6 +1148,12 @@ static int samsung_pinctrl_probe(struct
 	platform_set_drvdata(pdev, drvdata);
 
 	return 0;
+
+err_unregister:
+	samsung_pinctrl_unregister(pdev, drvdata);
+err_put_banks:
+	samsung_banks_of_node_put(drvdata);
+	return ret;
 }
 
 /**


