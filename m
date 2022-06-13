Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FDD5486A6
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380744AbiFMN71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380397AbiFMN6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:58:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6377044A37;
        Mon, 13 Jun 2022 04:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 588A361306;
        Mon, 13 Jun 2022 11:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62346C3411C;
        Mon, 13 Jun 2022 11:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120259;
        bh=NAIQG1l2FirVUzMbuRQQdkfhzSCBC5Eunt0cXQIbI78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMKNEfh3FvHHdruCOb8135q614zwgSIEqNsHSOHFWYvUGCtHHRiDnoU8mWB9D6kSw
         arfc4WVK2FJudjDZDnR0AmR212kvXobhigDsbCLYH3IHeHUllwHw7Zh5NGcwJDaJoz
         wrMYO/0HvNTc596bBYdnsc+fR/uI9BDkuOoF7iKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 289/339] platform/x86: barco-p50-gpio: Add check for platform_driver_register
Date:   Mon, 13 Jun 2022 12:11:54 +0200
Message-Id: <20220613094935.399154218@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 011881b80ebe773914b59905bce0f5e0ef93e7ba ]

As platform_driver_register() could fail, it should be better
to deal with the return value in order to maintain the code
consisitency.

Fixes: 86af1d02d458 ("platform/x86: Support for EC-connected GPIOs for identify LED/button on Barco P50 board")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Peter Korsgaard <peter.korsgaard@barco.com>
Link: https://lore.kernel.org/r/20220526090345.1444172-1-jiasheng@iscas.ac.cn
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/barco-p50-gpio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/barco-p50-gpio.c b/drivers/platform/x86/barco-p50-gpio.c
index 05534287bc26..8dd672339485 100644
--- a/drivers/platform/x86/barco-p50-gpio.c
+++ b/drivers/platform/x86/barco-p50-gpio.c
@@ -405,11 +405,14 @@ MODULE_DEVICE_TABLE(dmi, dmi_ids);
 static int __init p50_module_init(void)
 {
 	struct resource res = DEFINE_RES_IO(P50_GPIO_IO_PORT_BASE, P50_PORT_CMD + 1);
+	int ret;
 
 	if (!dmi_first_match(dmi_ids))
 		return -ENODEV;
 
-	platform_driver_register(&p50_gpio_driver);
+	ret = platform_driver_register(&p50_gpio_driver);
+	if (ret)
+		return ret;
 
 	gpio_pdev = platform_device_register_simple(DRIVER_NAME, PLATFORM_DEVID_NONE, &res, 1);
 	if (IS_ERR(gpio_pdev)) {
-- 
2.35.1



