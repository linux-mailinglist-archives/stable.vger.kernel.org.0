Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1025582C10
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbiG0Qlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbiG0Qkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:40:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADDF5140A;
        Wed, 27 Jul 2022 09:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C210E619CB;
        Wed, 27 Jul 2022 16:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD695C433C1;
        Wed, 27 Jul 2022 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939364;
        bh=ReCbA0I7f/QWMMwN7Z40JHNUBCBF6sIrguLmZ2hyXRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XA+sWQpri9IsLoHITrzmWuAsFRv5lggoijCDQVwkYdvVa3fsVKoTRPY2o89geFKuY
         E4ppXba6pp7pKU/KmK1xTisCPWzhSDV8VHm0ha+l2DsbYpvET4+fDeLgjyNexBPtDG
         BecBFR1RimznKv6kFnHQMCR9UarZyX2RxNbrm0lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/87] gpio: pca953x: only use single read/write for No AI mode
Date:   Wed, 27 Jul 2022 18:10:35 +0200
Message-Id: <20220727161010.755473777@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit db8edaa09d7461ec08672a92a2eef63d5882bb79 ]

For the device use NO AI mode(not support auto address increment),
only use the single read/write when config the regmap.

We meet issue on PCA9557PW on i.MX8QXP/DXL evk board, this device
do not support AI mode, but when do the regmap sync, regmap will
sync 3 byte data to register 1, logically this means write first
data to register 1, write second data to register 2, write third data
to register 3. But this device do not support AI mode, finally, these
three data write only into register 1 one by one. the reault is the
value of register 1 alway equal to the latest data, here is the third
data, no operation happened on register 2 and register 3. This is
not what we expect.

Fixes: 49427232764d ("gpio: pca953x: Perform basic regmap conversion")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 54da66d02b0e..317f54f19477 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -379,6 +379,9 @@ static const struct regmap_config pca953x_i2c_regmap = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
+	.use_single_read = true,
+	.use_single_write = true,
+
 	.readable_reg = pca953x_readable_register,
 	.writeable_reg = pca953x_writeable_register,
 	.volatile_reg = pca953x_volatile_register,
-- 
2.35.1



