Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DEA53D02E
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiFCSBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346292AbiFCSAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:00:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8CC53A67;
        Fri,  3 Jun 2022 10:56:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 868B3B82189;
        Fri,  3 Jun 2022 17:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7F9C385A9;
        Fri,  3 Jun 2022 17:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278960;
        bh=Cd2X9X9D1pUtLT7Y22U/EmbcPT8vW5ZoQ885p5Z6CdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpeUzV4OG9zZYGQTzutAbLQerWz6+LnmmX8uzyxXSITxd+fG/eVyaeI3bhpqKYaDT
         wSCAi19A1d+xRwiFUQ4whvkKlevi41wzgfV2+nGnKwq4QtDPvXmRRAtb2rZWGfDizv
         zjzLThxL2oPAtmBMvUGv2wVRID/wY2BmlkVrv1Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.17 62/75] media: i2c: imx412: Fix reset GPIO polarity
Date:   Fri,  3 Jun 2022 19:43:46 +0200
Message-Id: <20220603173823.494405806@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit bb25f071fc92d3d227178a45853347c7b3b45a6b upstream.

The imx412/imx577 sensor has a reset line that is active low not active
high. Currently the logic for this is inverted.

The right way to define the reset line is to declare it active low in the
DTS and invert the logic currently contained in the driver.

The DTS should represent the hardware does i.e. reset is active low.
So:
+               reset-gpios = <&tlmm 78 GPIO_ACTIVE_LOW>;
not:
-               reset-gpios = <&tlmm 78 GPIO_ACTIVE_HIGH>;

I was a bit reticent about changing this logic since I thought it might
negatively impact @intel.com users. Googling a bit though I believe this
sensor is used on "Keem Bay" which is clearly a DTS based system and is not
upstream yet.

Fixes: 9214e86c0cc1 ("media: i2c: Add imx412 camera sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Reviewed-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx412.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -1011,7 +1011,7 @@ static int imx412_power_on(struct device
 	struct imx412 *imx412 = to_imx412(sd);
 	int ret;
 
-	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
 
 	ret = clk_prepare_enable(imx412->inclk);
 	if (ret) {
@@ -1024,7 +1024,7 @@ static int imx412_power_on(struct device
 	return 0;
 
 error_reset:
-	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
 
 	return ret;
 }
@@ -1040,7 +1040,7 @@ static int imx412_power_off(struct devic
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct imx412 *imx412 = to_imx412(sd);
 
-	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
 
 	clk_disable_unprepare(imx412->inclk);
 


