Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033F455D7BA
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbiF0LmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiF0LlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:41:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA3FBF6C;
        Mon, 27 Jun 2022 04:35:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADC6160C9B;
        Mon, 27 Jun 2022 11:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AC3C3411D;
        Mon, 27 Jun 2022 11:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329745;
        bh=ZihfiEhgVP+3UobtLxSB6N/VsrurWx2cOU/f/ZeLlxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSlw72ICWwAt18SwFJZc+15XVFCyBbpjJ8ctQHvgs2xMx7HmOS2SFOYKYgFqOWd+J
         IsPbn2uh5E39kBv/ItTZQS3C3J+LaCWhm6HoiHXS0FyNnH+wHwYGxoK/Tn1UXwsDlY
         zRaFF9+/ftOd0Nc/RtTyU+YJrtSH9lxxhGxPx85c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 101/135] iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()
Date:   Mon, 27 Jun 2022 13:21:48 +0200
Message-Id: <20220627111941.087537161@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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
@@ -876,6 +876,7 @@ static int mpu3050_power_up(struct mpu30
 	ret = regmap_update_bits(mpu3050->map, MPU3050_PWR_MGM,
 				 MPU3050_PWR_MGM_SLEEP, 0);
 	if (ret) {
+		regulator_bulk_disable(ARRAY_SIZE(mpu3050->regs), mpu3050->regs);
 		dev_err(mpu3050->dev, "error setting power mode\n");
 		return ret;
 	}


