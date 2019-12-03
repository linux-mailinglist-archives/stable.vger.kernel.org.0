Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CE7111C13
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfLCWkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbfLCWkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9B672080A;
        Tue,  3 Dec 2019 22:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412800;
        bh=9TLK4L7Jad4OWtE/pyFkOW+A3Wp40W7hLp01Qgwh+aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fqGjDcjSWaa0nWMzaT/PF8TLhFR8CTjGGeMyRajJxD/5u+QOmp0ipcOGzBjV+1kn
         vS0k4fRfmBTaNtVYeZT//DL+wfFlZBneeDF51mQ9H/kTw78biei4YFgXAGCG4/BbQM
         UaZlCo8BizTeB/4yM/bLdmvLm9QbgvjkGnNNq1Sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 021/135] ARM: dts: imx6qdl-sabreauto: Fix storm of accelerometer interrupts
Date:   Tue,  3 Dec 2019 23:34:21 +0100
Message-Id: <20191203213009.888052763@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 7e5d0bf6afcc7bd72f78e7f33570e2e0945624f0 ]

Since commit a211b8c55f3c ("ARM: dts: imx6qdl-sabreauto: Add sensors")
a storm of accelerometer interrupts is seen:

[  114.211283] irq 260: nobody cared (try booting with the "irqpoll" option)
[  114.218108] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.4 #1
[  114.223960] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  114.230531] [<c0112858>] (unwind_backtrace) from [<c010cdc8>] (show_stack+0x10/0x14)
[  114.238301] [<c010cdc8>] (show_stack) from [<c0c1aa1c>] (dump_stack+0xd8/0x110)
[  114.245644] [<c0c1aa1c>] (dump_stack) from [<c0193594>] (__report_bad_irq+0x30/0xc0)
[  114.253417] [<c0193594>] (__report_bad_irq) from [<c01933ac>] (note_interrupt+0x108/0x298)
[  114.261707] [<c01933ac>] (note_interrupt) from [<c018ffe4>] (handle_irq_event_percpu+0x70/0x80)
[  114.270433] [<c018ffe4>] (handle_irq_event_percpu) from [<c019002c>] (handle_irq_event+0x38/0x5c)
[  114.279326] [<c019002c>] (handle_irq_event) from [<c019438c>] (handle_level_irq+0xc8/0x154)
[  114.287701] [<c019438c>] (handle_level_irq) from [<c018eda0>] (generic_handle_irq+0x20/0x34)
[  114.296166] [<c018eda0>] (generic_handle_irq) from [<c0534214>] (mxc_gpio_irq_handler+0x30/0xf0)
[  114.304975] [<c0534214>] (mxc_gpio_irq_handler) from [<c0534334>] (mx3_gpio_irq_handler+0x60/0xb0)
[  114.313955] [<c0534334>] (mx3_gpio_irq_handler) from [<c018eda0>] (generic_handle_irq+0x20/0x34)
[  114.322762] [<c018eda0>] (generic_handle_irq) from [<c018f3ac>] (__handle_domain_irq+0x64/0xe0)
[  114.331485] [<c018f3ac>] (__handle_domain_irq) from [<c05215a8>] (gic_handle_irq+0x4c/0xa8)
[  114.339862] [<c05215a8>] (gic_handle_irq) from [<c0101a70>] (__irq_svc+0x70/0x98)
[  114.347361] Exception stack(0xc1301ec0 to 0xc1301f08)
[  114.352435] 1ec0: 00000001 00000006 00000000 c130c340 00000001 c130f688 9785636d c13ea2e8
[  114.360635] 1ee0: 9784907d 0000001a eaf99d78 0000001a 00000000 c1301f10 c0182b00 c0878de4
[  114.368830] 1f00: 20000013 ffffffff
[  114.372349] [<c0101a70>] (__irq_svc) from [<c0878de4>] (cpuidle_enter_state+0x168/0x5f4)
[  114.380464] [<c0878de4>] (cpuidle_enter_state) from [<c08792ac>] (cpuidle_enter+0x28/0x38)
[  114.388751] [<c08792ac>] (cpuidle_enter) from [<c015ef9c>] (do_idle+0x224/0x2a8)
[  114.396168] [<c015ef9c>] (do_idle) from [<c015f3b8>] (cpu_startup_entry+0x18/0x20)
[  114.403765] [<c015f3b8>] (cpu_startup_entry) from [<c1200e54>] (start_kernel+0x43c/0x500)
[  114.411958] handlers:
[  114.414302] [<a01028b8>] irq_default_primary_handler threaded [<fd7a3b08>] mma8452_interrupt
[  114.422974] Disabling IRQ #260

           CPU0       CPU1
....
260:     100001          0  gpio-mxc  31 Level     mma8451

The MMA8451 interrupt triggers as low level, so the GPIO6_IO31 pin
needs to activate its pull up, otherwise it will stay always at low level
generating multiple interrupts.

The current device tree does not configure the IOMUX for this pin, so
it uses whathever comes configured from the bootloader.

The IOMUXC_SW_PAD_CTL_PAD_EIM_BCLK register value comes as 0x8000 from
the bootloader, which has PKE bit cleared, hence disabling the
pull-up.

Instead of relying on a previous configuration from the bootloader,
configure the GPIO6_IO31 pin with pull-up enabled in order to fix
this problem.

Fixes: a211b8c55f3c ("ARM: dts: imx6qdl-sabreauto: Add sensors")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-By: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index f3404dd105377..cf628465cd0a3 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -230,6 +230,8 @@
 			accelerometer@1c {
 				compatible = "fsl,mma8451";
 				reg = <0x1c>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_mma8451_int>;
 				interrupt-parent = <&gpio6>;
 				interrupts = <31 IRQ_TYPE_LEVEL_LOW>;
 			};
@@ -628,6 +630,12 @@
 			>;
 		};
 
+		pinctrl_mma8451_int: mma8451intgrp {
+			fsl,pins = <
+				MX6QDL_PAD_EIM_BCLK__GPIO6_IO31		0xb0b1
+			>;
+		};
+
 		pinctrl_pwm3: pwm1grp {
 			fsl,pins = <
 				MX6QDL_PAD_SD4_DAT1__PWM3_OUT		0x1b0b1
-- 
2.20.1



