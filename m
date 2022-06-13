Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947CA548AA5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386554AbiFMOpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385702AbiFMOnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F2AB2E90;
        Mon, 13 Jun 2022 04:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62E55612AC;
        Mon, 13 Jun 2022 11:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7211FC341C4;
        Mon, 13 Jun 2022 11:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121047;
        bh=FLrjGgUTQv6fCtRv8Vq1Iy1NjHMHnXddlPMjRF9DYdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/1oqYHAc/AeMdwD6NBzv11AO8GmG8o2jP9nnQt7Ls+3hmQZP0mv0q3h8O+7QRIY4
         kQi6GAL3I7rhcPwxytYApu8wKiakzqY0UmvMkFksDc5WhNfpth9U0xt5lV8Fh5XuRf
         /Ts/qw4iqjrk8zEXBaeoE0FNG95HX9gaSeavJz2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 253/298] platform/x86: barco-p50-gpio: Add check for platform_driver_register
Date:   Mon, 13 Jun 2022 12:12:27 +0200
Message-Id: <20220613094932.753788739@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index f5c72e33f9ae..f8b796820ef4 100644
--- a/drivers/platform/x86/barco-p50-gpio.c
+++ b/drivers/platform/x86/barco-p50-gpio.c
@@ -406,11 +406,14 @@ MODULE_DEVICE_TABLE(dmi, dmi_ids);
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



