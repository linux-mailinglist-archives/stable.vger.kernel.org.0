Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C8953D043
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346407AbiFCSBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244393AbiFCR72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:59:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA9058380;
        Fri,  3 Jun 2022 10:55:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 825B8B823B0;
        Fri,  3 Jun 2022 17:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91F1C385A9;
        Fri,  3 Jun 2022 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278920;
        bh=1dDCelCnd3TDU/oKMdf68Nki42Ch/uDP9y6NwwQdRnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJcgi/suhGPRM/PX6zuNYdsdiD9ONVlr8YiG18pZWLXdaZdsRAO4gJ2rZyAVq4AoU
         fbhjr37rzW2fGh78wXpgZRxhVFx0dKMo9+zqecGpuAGROCZeuY/LTg/okmZ0EH1t7Q
         MOR9r8sDQU8NsieBV5K2cmDuzbiQbJAivDtzd4TE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.17 63/75] media: i2c: imx412: Fix power_off ordering
Date:   Fri,  3 Jun 2022 19:43:47 +0200
Message-Id: <20220603173823.522138192@linuxfoundation.org>
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

commit 9a199694c6a1519522ec73a4571f68abe9f13d5d upstream.

The enable path does
- gpio
- clock

The disable path does
- gpio
- clock

Fix the order on the power-off path so that power-off and power-on have the
same ordering for clock and gpio.

Fixes: 9214e86c0cc1 ("media: i2c: Add imx412 camera sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Reviewed-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx412.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -1040,10 +1040,10 @@ static int imx412_power_off(struct devic
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct imx412 *imx412 = to_imx412(sd);
 
-	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
-
 	clk_disable_unprepare(imx412->inclk);
 
+	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
+
 	return 0;
 }
 


