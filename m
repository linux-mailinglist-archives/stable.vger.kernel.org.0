Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0AB3CDA7C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241456AbhGSOgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343517AbhGSOe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7AFE6113E;
        Mon, 19 Jul 2021 15:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707710;
        bh=LSenNnVVeoZlw0kd2kGYG4MPZ1yWHLzvtc7JT3okQzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OT1TtqU9dnBq79du0JQ06q5GZ5VNZ9MguIDB3Ym8ygQkHiiMwd181/jIX32s4A7Lq
         8+MZvzRdQ7d+4xbPnugyOvFH+ddyopYGrXK5GyR+q7F/TCuIYnXUvhkuwAyaotDv0Z
         L2wkibVSkiFX4XRC/bU+fUYL+nJwM9axwkpQBgYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.14 025/315] rtc: stm32: Fix unbalanced clk_disable_unprepare() on probe error path
Date:   Mon, 19 Jul 2021 16:48:34 +0200
Message-Id: <20210719144943.713094298@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

commit 950ac33dbe6ff656a623d862022f0762ec061ba7 upstream.

The STM32MP1 RTC may have 2 clocks, the pclk and the rtc_ck.

If clk_prepare_enable() fails for the second clock (rtc_ck) we must only
call clk_disable_unprepare() for the first clock (pclk) but currently we
call it on both leading to a WARN:

[   15.629568] WARNING: CPU: 0 PID: 146 at drivers/clk/clk.c:958 clk_core_disable+0xb0/0xc8
[   15.637620] ck_rtc already disabled
[   15.663322] CPU: 0 PID: 146 Comm: systemd-udevd Not tainted 5.4.77-pknbsp-svn5759-atag-v5.4.77-204-gea4235203137-dirty #2413
[   15.674510] Hardware name: STM32 (Device Tree Support)
[   15.679658] [<c0111148>] (unwind_backtrace) from [<c010c0b8>] (show_stack+0x10/0x14)
[   15.687371] [<c010c0b8>] (show_stack) from [<c0ab3d28>] (dump_stack+0xc0/0xe0)
[   15.694574] [<c0ab3d28>] (dump_stack) from [<c012360c>] (__warn+0xc8/0xf0)
[   15.701428] [<c012360c>] (__warn) from [<c0123694>] (warn_slowpath_fmt+0x60/0x94)
[   15.708894] [<c0123694>] (warn_slowpath_fmt) from [<c053b518>] (clk_core_disable+0xb0/0xc8)
[   15.717230] [<c053b518>] (clk_core_disable) from [<c053c190>] (clk_core_disable_lock+0x18/0x24)
[   15.725924] [<c053c190>] (clk_core_disable_lock) from [<bf0adc44>] (stm32_rtc_probe+0x124/0x5e4 [rtc_stm32])
[   15.735739] [<bf0adc44>] (stm32_rtc_probe [rtc_stm32]) from [<c05f7d4c>] (platform_drv_probe+0x48/0x98)
[   15.745095] [<c05f7d4c>] (platform_drv_probe) from [<c05f5cec>] (really_probe+0x1f0/0x458)
[   15.753338] [<c05f5cec>] (really_probe) from [<c05f61c4>] (driver_probe_device+0x70/0x1c4)
[   15.761584] [<c05f61c4>] (driver_probe_device) from [<c05f6580>] (device_driver_attach+0x58/0x60)
[   15.770439] [<c05f6580>] (device_driver_attach) from [<c05f6654>] (__driver_attach+0xcc/0x170)
[   15.779032] [<c05f6654>] (__driver_attach) from [<c05f40d8>] (bus_for_each_dev+0x58/0x7c)
[   15.787191] [<c05f40d8>] (bus_for_each_dev) from [<c05f4ffc>] (bus_add_driver+0xdc/0x1f8)
[   15.795352] [<c05f4ffc>] (bus_add_driver) from [<c05f6ed8>] (driver_register+0x7c/0x110)
[   15.803425] [<c05f6ed8>] (driver_register) from [<c01027bc>] (do_one_initcall+0x70/0x1b8)
[   15.811588] [<c01027bc>] (do_one_initcall) from [<c01a1094>] (do_init_module+0x58/0x1f8)
[   15.819660] [<c01a1094>] (do_init_module) from [<c01a0074>] (load_module+0x1e58/0x23c8)
[   15.827646] [<c01a0074>] (load_module) from [<c01a0860>] (sys_finit_module+0xa0/0xd4)
[   15.835459] [<c01a0860>] (sys_finit_module) from [<c01011e0>] (__sys_trace_return+0x0/0x20)

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Fixes: 4e64350f42e2 ("rtc: add STM32 RTC driver")
Cc: stable@vger.kernel.org
Reviewed-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/1623087421-19722-1-git-send-email-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-stm32.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-stm32.c
+++ b/drivers/rtc/rtc-stm32.c
@@ -636,7 +636,7 @@ static int stm32_rtc_probe(struct platfo
 	 */
 	ret = stm32_rtc_init(pdev, rtc);
 	if (ret)
-		goto err;
+		goto err_no_rtc_ck;
 
 	rtc->irq_alarm = platform_get_irq(pdev, 0);
 	if (rtc->irq_alarm <= 0) {
@@ -680,10 +680,12 @@ static int stm32_rtc_probe(struct platfo
 		dev_warn(&pdev->dev, "Date/Time must be initialized\n");
 
 	return 0;
+
 err:
+	clk_disable_unprepare(rtc->rtc_ck);
+err_no_rtc_ck:
 	if (rtc->data->has_pclk)
 		clk_disable_unprepare(rtc->pclk);
-	clk_disable_unprepare(rtc->rtc_ck);
 
 	regmap_update_bits(rtc->dbp, PWR_CR, PWR_CR_DBP, 0);
 


