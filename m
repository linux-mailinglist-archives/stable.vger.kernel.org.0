Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4595C561C91
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbiF3OAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236635AbiF3N7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:59:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D0E5C9F5;
        Thu, 30 Jun 2022 06:52:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC30F6204B;
        Thu, 30 Jun 2022 13:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC10C341CB;
        Thu, 30 Jun 2022 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597100;
        bh=d1Eti8jqM8ERROJNaBYHwNplh+J+0sEmfbW8/ADoM90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lz60JmxCzhi2aW7VC9HNWle2bTOHoEJrShFi7y2AR6m5jNruRl8mweYhtuOsxDCSG
         MjenoEm4bGGfJWVSpuNqJcGDbtwTXFGH8O/2mA1qavW499NOgkminYAB/8r9YoCfSH
         SzOfc29o5oWIbDI2/86B4S+wjrA1TKS02NKQffJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 27/49] iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()
Date:   Thu, 30 Jun 2022 15:46:40 +0200
Message-Id: <20220630133234.697437645@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

commit b2f5ad97645e1deb5ca9bcb7090084b92cae35d2 upstream.

The driver should disable regulators when fails at regmap_update_bits().

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220510092431.1711284-1-zheyuma97@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -873,6 +873,7 @@ static int mpu3050_power_up(struct mpu30
 	ret = regmap_update_bits(mpu3050->map, MPU3050_PWR_MGM,
 				 MPU3050_PWR_MGM_SLEEP, 0);
 	if (ret) {
+		regulator_bulk_disable(ARRAY_SIZE(mpu3050->regs), mpu3050->regs);
 		dev_err(mpu3050->dev, "error setting power mode\n");
 		return ret;
 	}


