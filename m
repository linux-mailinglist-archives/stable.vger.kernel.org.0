Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C705055A7
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242149AbiDRNNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241867AbiDRNIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:08:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70E42C655;
        Mon, 18 Apr 2022 05:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FE3961268;
        Mon, 18 Apr 2022 12:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C6BC385A7;
        Mon, 18 Apr 2022 12:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286085;
        bh=q1vKdk3kHmzjciSUyf4Qz2XI3CxCsuIyWQCjFJhdjUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRmzWHVxW/MQ+YHgMGIShwiN50PuL8WByPkmhva/w6XNefmJ6TUXAx4Nmgfi///df
         tR/+yaBp7jeQfQcVG/X8B1GT4rJa4EqXSQg31yFDNwtPz6Pl4Jd3aWeg/LNiypb3r2
         UcTnppXLx2xCXlpdP17WtqKZfP+pzMrszyGVIbk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 4.14 024/284] pinctrl: samsung: drop pin banks references on error paths
Date:   Mon, 18 Apr 2022 14:10:05 +0200
Message-Id: <20220418121211.384754947@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -975,6 +975,16 @@ samsung_pinctrl_get_soc_data_for_of_alia
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
@@ -1089,19 +1099,19 @@ static int samsung_pinctrl_probe(struct
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
@@ -1111,6 +1121,12 @@ static int samsung_pinctrl_probe(struct
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


