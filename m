Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434608F67A
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 23:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbfHOVe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 17:34:26 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32779 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730517AbfHOVe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 17:34:26 -0400
Received: by mail-qt1-f195.google.com with SMTP id v38so3978824qtb.0
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 14:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xBCjFujfOQnJgofmartoNzGsfTN1jUU8fTxh9JjjYII=;
        b=j3D3PAMPFHrINYPI4euIFF+E0E79xwVwil9ywRtyUgHJNILIa/1NgCDErG74cH5RgM
         uI5jdh6e3eFF0wSrnVDXxsoxOQlbKez9aatoHH26pNXFKssoIHqQqCbfDICXbE9KLWu+
         n5rT1X819TZMURvAYzj95llnZDDBxQ16n4oG68U5/ogK0zPs/+nF5K6GzdgU1BC9/znd
         orrTgWmNN5oY423WO9jOfhESD1G8MSbQkRSSlxcbkXiIeApdu3VS6sRo0wxn69gDGG2R
         y5WevqqkiUUa11W+bkTXzhMluL0mcXFqECbMoI9gSMr6tosB3J5XPYS4fJ3LVBSmYPnh
         LorQ==
X-Gm-Message-State: APjAAAWeL/85N1wrUhof7igGinhES0WSWE7Z1T6FSutYCck5VUd3RvbH
        LTsXs/NVktb9XoVpYZ9ugY1zlKzsPwkaylLJHZjhcp98b+k=
X-Google-Smtp-Source: APXvYqw+DfBs1jkwVhJAJVAyESgJLnaAEFS61Dm26hDQLACiKIzLsiyjJbqce40QBXSrKJaRlOsyIe1Kt5XQyzqu8BY=
X-Received: by 2002:a0c:ba2c:: with SMTP id w44mr4690143qvf.62.1565904865160;
 Thu, 15 Aug 2019 14:34:25 -0700 (PDT)
MIME-Version: 1.0
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 15 Aug 2019 23:34:08 +0200
Message-ID: <CAK8P3a0gX2dM=VDjs2Ezh1EYM-buXCZ+79bdG2E+HCjO21StcA@mail.gmail.com>
Subject: stable backports, from contents found in xilinx-4.9
To:     "stable-4.9" <stable@vger.kernel.org>
Cc:     gregkh <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I searched through https://github.com/Xilinx/linux-xlnx/tree/xlnx_rebase_v4.9
for commits that got backported from mainline, and categorized them
to see if we want them in an LTS kernel.

Most of the contents are specific to xilinx hardware, but some changes are for
generic drivers.

These commits look like we should have them in the LTS kernel, and
they apply cleanly:

  d86c5a676e5b ("usb: dwc3: gadget: always try to prepare on
started_list first")
  63b7c83ebea0 ("microblaze: Fix return value from xilinx_timer_init")
  7181e5590e5b ("microblaze: Add missing syscalls")
  8ee80500ad78 ("microblaze: Add missing release version code v9.6 and v10")
  3400606d8ffd ("microblaze: Add new fpga families")
  26b54be568ad ("PCI: xilinx-nwl: Remove mask for messages not
supported by AXI")
  acf6ef1d6c96 ("i2c: mux: pca954x: Export OF device ID table as
module aliases")
  dbe4d69d252e ("i2c: mux: pca954x: Add missing pca9546 definition to
chip_desc")
  360a3a90c626 ("[media] uvcvideo: Fix empty packet statistic")
  a753499d4360 ("microblaze: mm: Flush TLB to ensure correct mapping
when higmem ON")
  faf154cd49ba ("microblaze: Separate GP registers from MSR handling")
  14ef905bb2ee ("microblaze: Fix MSR flags when returning from exception")
  8064c616984e ("i2c: cadance: fix ctrl/addr reg write order")
  48767fd8982d ("spi: cadence: change sequence of calling runtime_enable")
  802740890c42 ("spi: cadence: Add support for context loss")
  e11de4de28c0 ("gpio: zynq: Add support for suspend resume")
  a5685781dfe9 ("cpufreq: dt: Add zynqmp to the cpufreq dt platdev")
  5c8f124893c4 ("mfd: Kconfig: Add missing Kconfig dependency for TPS65086")
  d15c56cad0e6 ("arm64: dts: xilinx: fix PCI bus dtc warnings")
  17e76f95a4be ("arm64: zynqmp: Add dcc console for zynqmp")
  8c50b1e435d1 ("arm64: zynqmp: Add CCI-400 node")
  e199f2cc1e55 ("arm64: zynqmp: Correct IRQ nr for the SMMU")
  db202f4d5c24 ("watchdog: cadence_wdt: Enable access to module parameters")
  3df3e41c3152 ("video: fbdev: Enable Xilinx FB for ZynqMP")
  1d67243a8e77 ("tty: xilinx_uartps: move to arch_initcall for earlier console")
  3c48d62de237 ("dmaengine: zynqmp_dma: Fix warning variable 'val' set
but not used")
  8d90035e379c ("dmaengine: zynqmp_dma: Fix issues with overflow interrupt")
  23059408b6a3 ("dmaengine: xilinx_dma: Fix race condition in the
driver for multiple descriptor scenario")
  48c62fb051af ("dmaengine: xilinx_dma: properly configure the SG mode
bit in the driver for cdma")
  4b597c634a2a ("dmaengine: xilinx_dma: Fix warning variable prev set
but not used")
  1fd4c45d6cd3 ("usb: gadget: udc-xilinx: remove redundant pointer udc")

These look useful, but require a backport to apply:

06aa09081d44 ("gpio: zynq: Provided workaround for GPIO")
6e037fb77086 ("ata: ceva: Correct the AXI bus configuration for SATA ports")
f8251f1dfda9 ("i2c: mux: pca954x: Add missing pca9542 definition to chip_desc")
25cd9721c2b1 ("usb: gadget: f_hid: fix: Don't access hidg->req without
spinlock held")
51218298a25e ("alarmtimer: Ensure RTC module is not unloaded")

These seem harmless but not necessary for stable backports, they could easily
get applied if there is a reason for them:

99c494077e2d ("idr: add ida_is_empty")
f59d4418c420 ("[media] media: adv7604: fix bindings inconsistency for
default-input")
6ab1a322dcaf ("[media] vivid: Enable 4k resolution for webcam capture device")
10eeb5e645b5 ("net: xilinx: constify net_device_ops structure")
e0d4fa5f7a50 ("microblaze: Update defconfigs")
17f4977ccd2b ("microblaze: Enabling CONFIGS related to MTD")
e16f1ad442e2 ("microblaze: Enabling CONFIG_BRIDGE in mmu_defconfig")
3638bd4a066c ("gpio: zynq: Clarify quirk and provide helper function")
9a181e1093af ("PCI: xilinx-nwl: Modify IRQ chip for legacy interrupts")
fdc71ce97c13 ("PCI: xilinx: Make of_device_ids const")
011e29e7d93d ("watchdog: cadence_wdt: make of_device_ids const.")
ce0d37614083 ("iio: adc: xadc: Fix coding style violations")
ef2b56df5a8a ("char: xilinx_hwicap: Fix kernel doc warnings")
4cb4142ba02c ("pinctrl: zynq: Fix kernel doc warnings")
6c2c9bd27cc5 ("pinctrl: zynq: Fix warnings in the driver")
6ae5104cbaa5 ("gpio: zynq: Fix kernel doc warnings")
2717cfcaf564 ("gpio: zynq: Fix warnings in the driver")
b09034892210 ("arm: zynq: Add adv7511 on i2c bus for zc70x")
e5e6f6872c7a ("arm: zynq: Add device-type property for zynq ethernet phy nodes")
3c220bf42090 ("arm: zynq: Label whole PL part as fpga_full region")
1188c024f216 ("arm: zynq: Use C pre-processor for includes in dts")
21ad06cc9e63 ("arm: zynq: Remove earlycon from bootargs")
26db4d8bc7cb ("arm64: zynqmp: Remove leading 0s from mtd table for spi flashes")
63301178e9a9 ("arm64: zynqmp: Move nodes which have no reg property out of bus")
400e188fa895 ("arm64: zynqmp: Add references to cpu nodes")
1e4e25c8ae8f ("arm64: zynqmp: Add idle state for ZynqMP")
e31b7bb8e21e ("arm64: zynqmp: Add operating points")
4a6514d523b5 ("arm64: zynqmp: Adding prefetchable memory space to pcie node")
7fb7820c579b ("arm64: zynqmp: Add support for RTC")
27af3993f77d ("arm64: zynqmp: Add new uartps compatible string")
2f9ed1999a41 ("arm64: zynqmp: Set status disabled in dtsi")
932bd0d8dbe8 ("arm64: zynqmp: Add fpd/lpd dmas")
e881e58709a7 ("arm64: zynqmp: Use C pre-processor for includes")
05e0bd10a9ee ("arm64: zynqmp: Added clocks to DT for ep108")
142574873e2b ("arm64: zynqmp: Enable can1 for ep108")
0286f3ea26a4 ("arm64: zynqmp: Add missing mmc aliases in ep108")
b6bc41645547 ("watchdog: of_xilinx_wdt: Add support for reading freq via CCF")
6f671c6b6288 ("watchdog: of_xilinx_wdt: Add suspend/resume support")
c7a03599b58f ("dmaengine: xilinx_dma: Differentiate probe based on the ip type")
025ba1841e5d ("ARM: dts: zynq: Add mmc alias for zc702/zc706/zed/zybo")
e7abd89466df ("arm64: dts: zynqmp: Add DDRC node")
c2df3de0d07e ("gpio: zynq: properly support runtime PM for GPIO used
as interrupts")
d2920ef5d094 ("dt-bindings: spi: Add device tree binding documentation
for Zynq QSPI controller")
67dca5e580f1 ("spi: spi-mem: Add support for Zynq QSPI controller")

And finally, these were backported into the xilinx tree, but are clearly not
material for an lts kernel.

0f57dc6ae1ff ("remoteproc: Keep local copy of firmware name")
2aefbef04149 ("remoteproc: Add a sysfs interface for firmware and state")
2bfc311a57f5 ("remoteproc: Drop wait in __rproc_boot()")
dbf499cf720a ("usb: gadget: f_hid add super speed support")
39a842e22c1b ("of/overlay: add of overlay notifications")
9dce0287a60d ("fpga: add method to get fpga manager from device")
40e83578fd1e ("doc: fpga-mgr: add fpga image info to api")
a33ddf80b67a ("fpga: add bindings document for fpga region")
1df2865f8dd9 ("fpga-mgr: add fpga image information struct")
12e2508213ac ("add sysfs document for fpga bridge class")
21aeda950c5f ("fpga: add fpga bridge framework")
0fa20cdfcc1f ("fpga: fpga-region: device tree control for FPGA")
1930c2865108 ("fpga zynq: Add missing \n to messages")
80baf649c277 ("fpga zynq: Remove priv->dev")
340c0c53ea30 ("fpga zynq: Fix incorrect ISR state on bootup")
7fe91fccc49f ("ARM: zynq: Remove skeleton.dtsi")
da457d57594b ("ARM: zynq: Fix W=1 dtc 1.4 warnings")
5935a2b3a57c ("serial: xuartps: Enable uart loopback mode")
6f05afcbb031 ("scripts/dtc: Update to upstream version 0931cea3ba20")
608d792192d7 ("remoteproc: Add RPROC_DELETED state")
7a20c64ddb3d ("remoteproc: Reduce asynchronous request_firmware to
auto-boot only")
f2114795f721 ("i2c: mux: pca954x: Add interrupt controller support")
ae3696c167cc ("net: macb: fix phy interrupt parsing")
52276df0b1ce ("[media] uvcvideo: Don't record timespec_sub")
89d123106a97 ("scripts/dtc: Update to upstream version v1.4.4-8-g756ffc4f52f6")
d62100f1aac2 ("serial: xilinx_uartps: Add pm runtime support")
81e33b51ed69 ("serial: xuartps: Cleanup the clock enable")
ecfc5771ef06 ("serial: xuartps: Enable clocks in the pm disable case also")
d653c43aefed ("serial: xilinx_uartps: Fix the error path")
094094a9373f ("serial: uartps: Fix kernel doc warnings")
f3a7f6f67fc7 ("watchdog: cadence_wdt: Show information when driver is probed")
00a0af9a6b04 ("video: fbdev: Fix multiple style issues in xilinxfb")
9053f4b9855c ("devicetree: bindings: Add sata port phy config
parameters in ahci-ceva")
fe8365bbf8ac ("ata: ceva: Move sata port phy oob settings to device-tree")
e8fc8b858cd8 ("ata: ceva: Add gen 3 mode support in driver")
ff0d63778ca0 ("ata: ceva: Disable Device Sleep capability")
05e890d84386 ("ata: ceva: Make RxWaterMark value as module parameter")
3bc867de85b5 ("ata: ceva: Add CCI support for SATA if CCI is enabled")
26bf3b6658a2 ("ata: ceva: Correct the suspend and resume logic for SATA")
f0a559aae57c ("ata: ceva: Add SMMU support for SATA IP")
b2b60bcc7d09 ("media: imx274: device tree binding file")
64c6f7da8c2c ("dmaengine: zynqmp_dma: Add runtime pm support")
30df4574e432 ("dmaengine: zynqmp_dma: Fix kernel doc-format")
49a83f002731 ("net: emaclite: Fix block comments style")
da7bf20e7758 ("tty: serial: uartlite: Add structure for private data")
14288befeb57 ("tty: serial: uartlite: Add clock adaptation")
a3a10614ca0f ("tty: serial: uartlite: Add support for suspend and resume")
