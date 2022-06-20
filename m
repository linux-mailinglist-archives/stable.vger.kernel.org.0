Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9E95511CE
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239557AbiFTHuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbiFTHuz (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAF7DEEF
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CF326120B
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29DCC3411B;
        Mon, 20 Jun 2022 07:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711454;
        bh=ZGyn5musB7/DuA2h9xr1ikM0rHunkJNgdKxXxPv35yg=;
        h=Subject:To:From:Date:From;
        b=aS1U+b8b9N3zRv212A2auiiZqOqWnoTxLwxG2jJzaYAlpsQG0EhLqpP2OdeEYJsUs
         XCs+F0LZQSNPoYr4ntk1K5PJq84XYJKmUYZm7o3A/N1+zqD9CCbnutyk3xIWtEeLYf
         GRBzaNhEQ24yMGFt78snOVzKfIgh56viAEBVKVE8=
Subject: patch "iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()" added to char-misc-linus
To:     zheyuma97@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:38 +0200
Message-ID: <1655711438175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


This is a note to let you know that I've just added the patch titled

    iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b2f5ad97645e1deb5ca9bcb7090084b92cae35d2 Mon Sep 17 00:00:00 2001
From: Zheyu Ma <zheyuma97@gmail.com>
Date: Tue, 10 May 2022 17:24:31 +0800
Subject: iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()

The driver should disable regulators when fails at regmap_update_bits().

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220510092431.1711284-1-zheyuma97@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/gyro/mpu3050-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/gyro/mpu3050-core.c b/drivers/iio/gyro/mpu3050-core.c
index ea387efab62d..f4c2f4cb4834 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -874,6 +874,7 @@ static int mpu3050_power_up(struct mpu3050 *mpu3050)
 	ret = regmap_update_bits(mpu3050->map, MPU3050_PWR_MGM,
 				 MPU3050_PWR_MGM_SLEEP, 0);
 	if (ret) {
+		regulator_bulk_disable(ARRAY_SIZE(mpu3050->regs), mpu3050->regs);
 		dev_err(mpu3050->dev, "error setting power mode\n");
 		return ret;
 	}
-- 
2.36.1


