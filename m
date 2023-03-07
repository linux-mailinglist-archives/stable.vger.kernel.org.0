Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F35C6AEAA7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbjCGRfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjCGRfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:35:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D51C9DE12
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:31:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5E8461517
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A6AC433EF;
        Tue,  7 Mar 2023 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210288;
        bh=/A9/zjeFXgxBwSBXH7SjEL0UTW3/o7r19KzxqbI9GWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1KuX59YJ1vACRdH5K3+FmTbwDAxPv31mzwaVTtu8byt9bVdDOmGBoLEpz9fV2HRk
         d8poysSmtPaZz3/WUA5bt+631Gnax+hynhcYu2CQC9rTJHBjTCj06qBvt6A5BvXGwm
         B5nIpl+JE2X2/ripVGaTB/SsjI0tIqZJedvKeueY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Henning Schild <henning.schild@siemens.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0464/1001] leds: simatic-ipc-leds-gpio: Make sure we have the GPIO providing driver
Date:   Tue,  7 Mar 2023 17:53:56 +0100
Message-Id: <20230307170041.530476358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henning Schild <henning.schild@siemens.com>

[ Upstream commit c64964ebee2a415384385205950ee7a05f78451e ]

If we register a "leds-gpio" platform device for GPIO pins that do not
exist we get a -EPROBE_DEFER and the probe will be tried again later.
If there is no driver to provide that pin we will poll forever and also
create a lot of log messages.

So check if that GPIO driver is configured, if so it will come up
eventually. If not, we exit our probe function early and do not even
bother registering the "leds-gpio". This method was chosen over "Kconfig
depends" since this way we can add support for more devices and GPIO
backends more easily without "depends":ing on all GPIO backends.

Fixes: a6c80bec3c93 ("leds: simatic-ipc-leds-gpio: Add GPIO version of Siemens driver")
Signed-off-by: Henning Schild <henning.schild@siemens.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221007153323.1326-1-henning.schild@siemens.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/simple/simatic-ipc-leds-gpio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/leds/simple/simatic-ipc-leds-gpio.c b/drivers/leds/simple/simatic-ipc-leds-gpio.c
index 07f0d79d604d4..e8d329b5a68c3 100644
--- a/drivers/leds/simple/simatic-ipc-leds-gpio.c
+++ b/drivers/leds/simple/simatic-ipc-leds-gpio.c
@@ -77,6 +77,8 @@ static int simatic_ipc_leds_gpio_probe(struct platform_device *pdev)
 
 	switch (plat->devmode) {
 	case SIMATIC_IPC_DEVICE_127E:
+		if (!IS_ENABLED(CONFIG_PINCTRL_BROXTON))
+			return -ENODEV;
 		simatic_ipc_led_gpio_table = &simatic_ipc_led_gpio_table_127e;
 		break;
 	case SIMATIC_IPC_DEVICE_227G:
-- 
2.39.2



