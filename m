Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F9E2E4291
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436492AbgL1PYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:24:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407570AbgL1N7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDB8E207AB;
        Mon, 28 Dec 2020 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163910;
        bh=fa32XThH0eE/2W4UsWH8fzYbgtHNcVvwX2R7eX4u694=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9bhn7yUtmvD8SXIsFANV54Xzp3IwBv2FUyeBArTqiSlDiaP71ILocmH9qRGj8YCv
         N/ThkXn6T6UV7Ddl5SpU0aKYPpc8wTml3k3wTeV9rpvX4k/TY6YyBRXc0s5yY6oskw
         RqhhXnKDz2ZEr1hjAVPQUwVz05Gu0iIQlzD9d5Nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Shubin <nikita.shubin@maquefel.me>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 452/453] rtc: ep93xx: Fix NULL pointer dereference in ep93xx_rtc_read_time
Date:   Mon, 28 Dec 2020 13:51:28 +0100
Message-Id: <20201228124958.971578828@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Shubin <nikita.shubin@maquefel.me>

commit 00c33482bb6110bce8110daa351f9b3baf4df7dc upstream.

Mismatch in probe platform_set_drvdata set's and method's that call
dev_get_platdata will result in "Unable to handle kernel NULL pointer
dereference", let's use according method for getting driver data after
platform_set_drvdata.

8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = (ptrval)
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1] ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 5.9.10-00003-g723e101e0037-dirty #4
Hardware name: Technologic Systems TS-72xx SBC
PC is at ep93xx_rtc_read_time+0xc/0x2c
LR is at __rtc_read_time+0x4c/0x8c
[...]
[<c02b01c8>] (ep93xx_rtc_read_time) from [<c02ac38c>] (__rtc_read_time+0x4c/0x8c)
[<c02ac38c>] (__rtc_read_time) from [<c02ac3f8>] (rtc_read_time+0x2c/0x4c)
[<c02ac3f8>] (rtc_read_time) from [<c02acc54>] (__rtc_read_alarm+0x28/0x358)
[<c02acc54>] (__rtc_read_alarm) from [<c02abd80>] (__rtc_register_device+0x124/0x2ec)
[<c02abd80>] (__rtc_register_device) from [<c02b028c>] (ep93xx_rtc_probe+0xa4/0xac)
[<c02b028c>] (ep93xx_rtc_probe) from [<c026424c>] (platform_drv_probe+0x24/0x5c)
[<c026424c>] (platform_drv_probe) from [<c0262918>] (really_probe+0x218/0x374)
[<c0262918>] (really_probe) from [<c0262da0>] (device_driver_attach+0x44/0x60)
[<c0262da0>] (device_driver_attach) from [<c0262e70>] (__driver_attach+0xb4/0xc0)
[<c0262e70>] (__driver_attach) from [<c0260d44>] (bus_for_each_dev+0x68/0xac)
[<c0260d44>] (bus_for_each_dev) from [<c026223c>] (driver_attach+0x18/0x24)
[<c026223c>] (driver_attach) from [<c0261dd8>] (bus_add_driver+0x150/0x1b4)
[<c0261dd8>] (bus_add_driver) from [<c026342c>] (driver_register+0xb0/0xf4)
[<c026342c>] (driver_register) from [<c0264210>] (__platform_driver_register+0x30/0x48)
[<c0264210>] (__platform_driver_register) from [<c04cb9ac>] (ep93xx_rtc_driver_init+0x10/0x1c)
[<c04cb9ac>] (ep93xx_rtc_driver_init) from [<c000973c>] (do_one_initcall+0x7c/0x1c0)
[<c000973c>] (do_one_initcall) from [<c04b9ecc>] (kernel_init_freeable+0x168/0x1ac)
[<c04b9ecc>] (kernel_init_freeable) from [<c03b2228>] (kernel_init+0x8/0xf4)
[<c03b2228>] (kernel_init) from [<c00082c0>] (ret_from_fork+0x14/0x34)
Exception stack(0xc441dfb0 to 0xc441dff8)
dfa0:                                     00000000 00000000 00000000 00000000
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
Code: e12fff1e e92d4010 e590303c e1a02001 (e5933000)
---[ end trace c914d6030eaa95c8 ]---

Fixes: b809d192eb98 ("rtc: ep93xx: stop setting platform_data")
Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201201095507.10317-1-nikita.shubin@maquefel.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-ep93xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -33,7 +33,7 @@ struct ep93xx_rtc {
 static int ep93xx_rtc_get_swcomp(struct device *dev, unsigned short *preload,
 				 unsigned short *delete)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_drvdata(dev);
 	unsigned long comp;
 
 	comp = readl(ep93xx_rtc->mmio_base + EP93XX_RTC_SWCOMP);
@@ -51,7 +51,7 @@ static int ep93xx_rtc_get_swcomp(struct
 
 static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_drvdata(dev);
 	unsigned long time;
 
 	time = readl(ep93xx_rtc->mmio_base + EP93XX_RTC_DATA);
@@ -62,7 +62,7 @@ static int ep93xx_rtc_read_time(struct d
 
 static int ep93xx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_drvdata(dev);
 	unsigned long secs = rtc_tm_to_time64(tm);
 
 	writel(secs + 1, ep93xx_rtc->mmio_base + EP93XX_RTC_LOAD);


