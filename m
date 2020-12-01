Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616B62C9E82
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 11:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgLAJ74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:59:56 -0500
Received: from forward103p.mail.yandex.net ([77.88.28.106]:32962 "EHLO
        forward103p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725967AbgLAJ74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 04:59:56 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2020 04:59:53 EST
Received: from mxback11g.mail.yandex.net (mxback11g.mail.yandex.net [IPv6:2a02:6b8:c03:773:0:640:1cd5:3285])
        by forward103p.mail.yandex.net (Yandex) with ESMTP id E8D3718C25B1
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 12:51:35 +0300 (MSK)
Received: from myt6-9bdf92ffd111.qloud-c.yandex.net (myt6-9bdf92ffd111.qloud-c.yandex.net [2a02:6b8:c12:468a:0:640:9bdf:92ff])
        by mxback11g.mail.yandex.net (mxback/Yandex) with ESMTP id rLLE7bahAY-pZmSe8ca;
        Tue, 01 Dec 2020 12:51:35 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1606816295;
        bh=tEhC3oKRu4H9sqpI3sbXmPgybLoWfA7LrGXLD1oxjwY=;
        h=Subject:To:From:Cc:Date:Message-Id;
        b=i5+BIvbr0qMxa2N/l77csrrrvxzyaQPbHJf+Lt2YjlLgApHifFCn6kuSxKktJWICs
         YsVcLDw6cXIIC3wp+IA+pTgX8SwHAPVVvvrOWRILFLk7QFgBATCKZs6IZ0GVcZBO8g
         tK12Iep00fWqWSJfclqIQ+Dx/w6iUNwdyzyX0pbA=
Authentication-Results: mxback11g.mail.yandex.net; dkim=pass header.i=@maquefel.me
Received: by myt6-9bdf92ffd111.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id jMHG2R51T2-pZI8fFGx;
        Tue, 01 Dec 2020 12:51:35 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Nikita Shubin <nikita.shubin@maquefel.me>
To:     nikita.shubin@maquefel.me
Cc:     stable@vger.kernel.org
Subject: [PATCH] rtc: ep93xx: Fix NULL pointer dereference in ep93xx_rtc_read_time
Date:   Tue,  1 Dec 2020 12:51:31 +0300
Message-Id: <20201201095131.9772-1-nikita.shubin@maquefel.me>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
pc : [<c02b01c8>]    lr : [<c02ac38c>]    psr: 40000053
sp : c441dcf0  ip : c441dd50  fp : 00000000
r10: fffffdfb  r9 : 00000000  r8 : c0520ca8
r7 : c149b53c  r6 : c149b400  r5 : c441dd2c  r4 : c149b400
r3 : 00000000  r2 : c441dd2c  r1 : c441dd2c  r0 : c04ea2a0
Flags: nZcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
Control: 0000717f  Table: 00004000  DAC: 00000053
Process swapper (pid: 1, stack limit = 0x(ptrval))
Stack: (0xc441dcf0 to 0xc441e000)
dce0:                                     c149b400 c02ac38c 00000000 c441dd2c
dd00: c149b400 c02ac3f8 c441dde4 c04ea290 c149b400 c149b400 c0520ca8 c02acc54
dd20: c400ce60 c04e5230 ffffffff 00000000 00000000 00000000 00000000 00000000
dd40: 00000000 00000000 00000000 00000000 c144f745 c144f740 00000005 c441dd7c
dd60: c045c56e c0231240 00000000 c045c56f 00000004 c04e5228 c04ea290 c1496120
dd80: c04ea290 c149b400 00000000 c0520ca8 00000000 fffffdfb 00000000 c02abd80
dda0: c14967c0 c00ab884 c4400160 00000dc0 c14967c0 c4400160 00000dc0 c02ae70c
ddc0: 40000053 c03b6f10 c149b400 c0265700 c14967e0 c149b400 00000000 c14967e0
dde0: c0503d44 c14967e4 00000004 c02ae754 00000000 c1496120 c04ea290 ffffffff
de00: 00000000 c0520ca8 00000000 c04e5228 c1496120 c04ea290 ffffffff c0520ca8
de20: 00000000 fffffdfb 00000000 c02b028c c04ea2a0 c0503e90 00000000 c0503e90
de40: c0520ca8 c026424c c04ea2a0 00000000 00000000 c0262918 00000000 c04ea2a0
de60: c0503e90 c0502240 c050e000 c0498504 c04d5840 c0262da0 00000000 c04ea2a0
de80: c0503e90 c0262e70 c04ea2a0 c0503e90 c0262dbc c0260d44 c0502240 c4408c70
dea0: c4478440 c04e5228 c0503e90 c45b6900 00000000 c026223c c0503e90 c0261dd8
dec0: c04347ed c04347f5 c441ba60 c0503e90 c04cb99c ffffe000 00000000 c026342c
dee0: c050e000 c04cb99c ffffe000 c0264210 c050e000 c04cb9ac c050e000 c000973c
df00: c04466a2 c002d734 c440a480 c04b9300 c0498504 0000005c 00000006 00000006
df20: 00000000 c0498c34 0000005b c0498c34 c4400200 c440a4ef 00000000 c04e5228
df40: 00000dc0 00000006 0000005c c04e5228 c04d585c 00000007 0000005c c440a480
df60: c04d5860 c04b9ecc 00000006 00000006 00000000 c04b93e4 00000000 c04dfb50
df80: c441c000 00000000 c03b2220 00000000 00000000 00000000 00000000 00000000
dfa0: 00000000 c03b2228 00000000 c00082c0 00000000 00000000 00000000 00000000
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
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

Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
Cc: stable@vger.kernel.org
---
 drivers/rtc/rtc-ep93xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 8ec9ea1ca72e..6f90b85a5814 100644
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
@@ -51,7 +51,7 @@ static int ep93xx_rtc_get_swcomp(struct device *dev, unsigned short *preload,
 
 static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_drvdata(dev);
 	unsigned long time;
 
 	time = readl(ep93xx_rtc->mmio_base + EP93XX_RTC_DATA);
@@ -62,7 +62,7 @@ static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 static int ep93xx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_drvdata(dev);
 	unsigned long secs = rtc_tm_to_time64(tm);
 
 	writel(secs + 1, ep93xx_rtc->mmio_base + EP93XX_RTC_LOAD);
-- 
2.26.2

