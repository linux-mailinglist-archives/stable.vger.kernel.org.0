Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B128F692
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 23:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbfHOVnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 17:43:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38180 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbfHOVna (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 17:43:30 -0400
Received: by mail-qk1-f193.google.com with SMTP id u190so3085180qkh.5
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 14:43:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=d6WLpdZ2yEn+mDATvlIGRNuYhnHn859x3eQliULuTT0=;
        b=og/0rZ0xw+bwNNeFRQUX8alOdWHqnglcO2xenSWWdEivbVdyu/mIVmzTmIKpXuSjcX
         a8mpyBD+BBmzZ8A+g5S+uNa8Y9ZOym7nZJF7DGY2iMyqUYw/xHVLx8EuY9g9tc/o3F1Y
         argrXIXp0EOsAk2PDepA+61U570oIaFKr/A5wnQpoV+HoT6VxroGzhTKH5/zXp6cYp/U
         SwKXdcenvPeyyXQdvhG4XWPeZ+aS4FVBtaZCYuXEanta/muWSsoi3OSs2CjL8rzT+qiC
         py6+QoK5RY/4xbPI/Kbnet7BBjKr26JyxcWFVMle4/WIIapelL93PozI6aeFjQAfO2oA
         2eVw==
X-Gm-Message-State: APjAAAVGH10v5u7wrPAYSMCLXDf0jbwgwhlTOXo6bEnbMLwWjtuodJMk
        o4JtqBFeyNJjMrIjV3mpf3YuYRjf0DmSpNJ2TnURzKeVhWs=
X-Google-Smtp-Source: APXvYqyJavfL41/5pnzAAXV6bFBE5y75IB1XiCT6gbwLORhZvEOV04meJ0MuM+XezFxp7Yx4ZNtB9GOgHWPLIajnL7I=
X-Received: by 2002:a05:620a:b:: with SMTP id j11mr6095060qki.352.1565905409450;
 Thu, 15 Aug 2019 14:43:29 -0700 (PDT)
MIME-Version: 1.0
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 15 Aug 2019 23:43:13 +0200
Message-ID: <CAK8P3a2Ew0oOQS781Q=FGvEywDspBhsZXaP1w+Ca=8HRhvf4cA@mail.gmail.com>
Subject: stable backports, from contents found in xilinx-4.19
To:     "stable-4.19" <stable@vger.kernel.org>
Cc:     Michal Simek <monstr@monstr.eu>,
        gregkh <gregkh@linuxfoundation.org>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Felipe Balbi <balbi@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to the 4.9 series, I looked at xilinx-4.19 from
https://github.com/Xilinx/linux-xlnx/tree/xlnx_rebase_v4.19
for possible backports to LTS kernels

These are the ones that look like they should be in the 4.19 lts
tree:

d86c5a676e5b ("usb: dwc3: gadget: always try to prepare on started_list first")
60208a267208 ("mmc: sdhci-of-arasan: Do now show error message in case
of deffered probe")
899ecaedd155 ("net: ethernet: cadence: fix socket buffer corruption problem")
a98086e00420 ("mtd: spi-nor: add entry for mt35xu512aba flash")
2e14f94cf4bc ("microblaze: move "... is ready" messages to
arch/microblaze/Makefile")
4722a3e6b716 ("microblaze: fix multiple bugs in arch/microblaze/boot/Makefile")
81de0cd60fd4 ("can: xilinx: fix return type of ndo_start_xmit function")
6169005ceb8c ("gpio: zynq: Report gpio direction at boot")
a7351807bd8b ("usb: dwc3: update stream id in depcmd")
0e03aca2659e ("dmaengine: xilinx_dma: Fix 64-bit simple CDMA transfer")
a62520473f15 ("net: macb driver, check for SKBTX_HW_TSTAMP")

Whereas these are harmless but probably not helpful:

77ec669f257b ("serial: uartps: Do not initialize field to zero again")
ea42d7a67a9e ("tty: serial: uartlite: Enable clocks at probe")
415b43bdb008 ("tty: serial: uartlite: Move uart register to probe")
5f6825d1cef7 ("tty: serial: uartlite: remove console_init")
deeb33e8fdd8 ("tty: serial: uartlite: Use dynamic array for console port")
95bf69a22d97 ("dt-bindings: firmware: Add bindings for ZynqMP firmware")
0005aad09453 ("mtd: spi-nor: add macros related to MICRON flash")
811496c9679a ("media: uvcvideo: Refactor URB descriptors")
b12a084c8729 ("spi: spi-mem: add support for octal mode I/O data transfer")
bafcc61d998c ("microblaze: adjust the help to the real behavior")
19d111ccce9f ("microblaze: remove the explicit removal of system.dtb")
c5435adc3d29 ("dt-bindings: can: xilinx_can: add Xilinx CAN FD 2.0 bindings")
eca42d4cf3c5 ("tty: xilinx_uartps: Correct return value in probe")
86df8dd14723 ("serial: uartps: Add the device_init_wakeup")
2bda2f811b36 ("mtd: spi-nor: add octal read flag for flash mt35xu512aba")
0837ae46ff00 ("mtd: m25p80: add support of octal mode I/O transfer")
9558281572e3 ("mtd: spi-nor: cadence-quadspi: write upto 8-bytes data
in STIG mode")
734882a8bf98 ("spi: cadence: Correct initialisation of runtime PM")
8beb79b7ae93 ("net: macb: Check MDIO state before read/write and use timeouts")
f5473d1d44e4 ("net: macb: Support clock management for tsu_clk")

And these are the ones that don't look like LTS material at all:

380583227c0c ("spi: spi-mem: Add extra sanity checks on the op param")
4e6b823867e2 ("gpiolib: export gpiochip_irq_reqres/relres()")
4b9d33c6a306 ("serial: uartps: Fix suspend functionality")
46a460f0150a ("serial: uartps: Do not use static struct uart_driver
out of probe()")
14090ad1805f ("serial: uartps: Move alias reading higher in probe()")
e4bbb5194ea3 ("serial: uartps: Move register to probe based on run
time detection")
10a5315b47b0 ("serial: uartps: Fill struct uart_driver in probe()")
427c8ae9bebc ("serial: uartps: Change logic how console_port is setup")
024ca329bfb9 ("serial: uartps: Register own uart console and driver structures")
6ac1b91f346f ("serial: uartps: Enable automatic flow control")
b1078c355d76 ("of: base: Introduce of_alias_get_alias_list() to check
alias IDs")
20487a8ddf20 ("ARM: zynq: Convert to using %pOFn instead of device_node.name")
eb30596eae94 ("remoteproc: add rproc_va_to_pa function")
b0019ccd7e90 ("remoteproc: introduce rproc_find_carveout_by_name function")
c874bf59add0 ("remoteproc: add helper function to check carveout
device address")
c6aed238b7a9 ("remoteproc: modify vring allocation to rely on
centralized carveout allocator")
c6d664fe8a7a ("media: uvcvideo: Convert decode functions to use new
context structure")
e829b262a678 ("media: uvcvideo: Protect queue internals with helper")
01e90464e42e ("media: uvcvideo: queue: Support asynchronous buffer handling")
c14d107e7417 ("media: ov5640: Remove the clocks registers initialization")
644c2dcf2f2e ("dt-bindings: ASoC: xlnx, i2s: Document i2s bindings")
112a8900d4b0 ("ASoC: xlnx: Add i2s driver")
33f8db9a8920 ("ASoC: xlnx: enable i2s driver build")
fb6a691a23ca ("dt: bindings: Document ZynqMP DDRC in Synopsys documentation")
0db9071353a0 ("can: xilinx: add can 2.0 support")
3b209d253e7f ("serial-uartlite: Do not use static struct uart_driver
out of probe()")
ee0a29ba574b ("serial-uartlite: fix null pointer dereference on pointer port")
32cf21ac4edd ("serial: uartps: Fix error path when alloc failed")
9fd609ff6380 ("arm64: dts: zynqmp: Use mmc@ instead sdhci@")
e7abd89466df ("arm64: dts: zynqmp: Add DDRC node")
ac1e507fe61d ("ARM: dts: Use mmc@ instead sdhci@")
91b438286ef2 ("dmaengine: xilinx_dma: Refactor axidma channel allocation")
4e47d24a908c ("dmaengine: xilinx_dma: Introduce helper macro for
preparing dma address")
b0b41af12a1b ("dt-bindings: memory: Add pl353 smc controller
devicetree binding information")
fee10bd22678 ("memory: pl353: Add driver for arm pl353 static memory
controller")
ba3e1847d647 ("net: macb: remove unnecessary code")
3f1b66be4aaa ("dt-bindings: reset: Add bindings for ZynqMP reset driver")
940c2361b56a ("dt-bindings: nvmem: Add bindings for ZynqMP nvmem driver")
d4ff6c9efa2e ("dt-bindings: soc: Add ZynqMP PM bindings")
8fd27fb4cf76 ("dt-bindings: power: Add ZynqMP power domain bindings")
e3e12ec09a18 ("dt-bindings: ASoC: xlnx, audio-formatter: Document
audio formatter bindings")
6f6c3c36f091 ("ASoC: xlnx: add pcm formatter platform driver")
2f00f7715e62 ("dt-bindings: ASoC: xlnx, spdif: Document spdif bindings")
b1d2a4cca20c ("ASoC: xlnx: add SPDIF audio driver")
c284d4e31a0b ("ASoC: xlnx: parse AES audio parameters")
98719e42073f ("staging: android: ion: Add the GPL exception for syscalls")
c2df3de0d07e ("gpio: zynq: properly support runtime PM for GPIO used
as interrupts")
5591a3075e95 ("Documentation: add ibmvmc to toctree(index) and fix warnings")
4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
abdd85b6ba73 ("dt-bindings: mailbox: Add Xilinx IPI Mailbox")
d2920ef5d094 ("dt-bindings: spi: Add device tree binding documentation
for Zynq QSPI controller")
67dca5e580f1 ("spi: spi-mem: Add support for Zynq QSPI controller")
9a80ba067a9c ("net: xilinx: emaclite: add minimal ethtool ops")
fcf9782573ec ("net: xilinx: emaclite: add minimal ndo_do_ioctl hook")
b1072b4f6e84 ("dt-bindings: xilinx-uartps: Add support for cts-override")
1863178b20c5 ("serial: uartps: Add support for cts-override")

       Arnd
