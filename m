Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5EA60FD9E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiJ0Q5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiJ0Q5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F714B4B6
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F74662369
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312A0C433D6;
        Thu, 27 Oct 2022 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889829;
        bh=nTd0g28VlVfKt/qv5tKuTQ0OmA+qjBi6yxTdEjXgm6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQOT4aZ8K8JBwrr4YelL8YfWK7gt8y++rtDQSKrUHPTJg/tfm5eY1RpwXhvW37Z4+
         uFPn4/zEIAcFvGZHmihgHeM8unbEliSoDrEfoN3rOfjtWoFhCdG3V85JFzWgiZdJp+
         PklAFnQ/gGX5LU3xVAm8d31PmPruB5tR4u8JRMIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.0 07/94] i2c: qcom-cci: Fix ordering of pm_runtime_xx and i2c_add_adapter
Date:   Thu, 27 Oct 2022 18:54:09 +0200
Message-Id: <20221027165057.453056202@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 61775d54d674ff8ec3658495e0dbc537227dc5c1 upstream.

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
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -639,6 +639,11 @@ static int cci_probe(struct platform_dev
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
@@ -650,14 +655,12 @@ static int cci_probe(struct platform_dev
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


