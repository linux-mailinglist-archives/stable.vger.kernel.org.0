Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B1410EAC5
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 14:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfLBNY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 08:24:56 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35242 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfLBNY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 08:24:56 -0500
Received: from hades.home (unknown [IPv6:2a00:23c5:582:9d00:2d93:25f:7679:a491])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 3B00A28FD40;
        Mon,  2 Dec 2019 13:24:55 +0000 (GMT)
From:   Martyn Welch <martyn.welch@collabora.com>
To:     stable@vger.kernel.org
Cc:     kernel@collabora.com, Martyn Welch <martyn.welch@collabora.com>
Subject: [PATCH 0/3] Kernel panic on USB removal with blkio throttling in place
Date:   Mon,  2 Dec 2019 13:24:43 +0000
Message-Id: <20191202132446.3623809-1-martyn.welch@collabora.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device set to throttle
￼	
the through put of a USB device (easily triggered when set to 4096),
￼	
removing the USB device causes the kernel to panic:
￼	
[   81.053401] Unable to handle kernel paging request at virtual address 3032343c
[   81.060710] pgd = 423a14c2
[   81.063450] [3032343c] *pgd=00000000
[   81.067072] Internal error: Oops: 805 [#1] SMP ARM
[   81.071913] Modules linked in: nls_ascii nls_cp437 vfat fat sg sd_mod uas usb_storage iptable_nat nf_nat_ipv4 nf_nat iptable_mangle iptable_filter ip6t_REJECT nf_reject_ipv6 nft_counter ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_state xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_compat nf_tables nfnetlink btrfs zstd_compress libcrc32c zlib_deflate zstd_decompress xxhash xor ofpart m25p80 dw_hdmi_ahb_audio spi_nor dw_hdmi_cec raid6_pq imx_media_csi(C) imx_media_ic(C) imx_media_capture(C) videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_common imx_media_vdic(C) imx_thermal snd_soc_imx_sgtl5000 snd_soc_sgtl5000 snd_soc_imx_audmux imx6_mipi_csi2(C) ov5640 snd_soc_fsl_ssi imx_pcm_dma imx_pcm_fiq snd_soc_core imx2_wdt snd_pcm_dmaengine snd_pcm snd_timer flexcan can_dev spi_imx
[   81.143117]  snd soundcore pwm_imx etnaviv dw_hdmi_imx dw_hdmi imx_media(C) gpu_sched imx_media_common(C) imx_ldb parallel_display v4l2_fwnode cec imxdrm imx_ipu_v3 panel_simple drm_kms_helper evdev drm imx6q_cpufreq fb_sys_fops pwm_bl ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb cls_cgroup ahci_imx libahci_platform libahci libata scsi_mod ci_hdrc_imx ci_hdrc ulpi ehci_hcd udc_core i2c_imx sdhci_esdhc_imx sdhci_pltfm sdhci usbcore usbmisc_imx phy_mxs_usb anatop_regulator dwc3_haps clk_pwm micrel
[   81.190475] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G         C        4.19.0-3-armmp #1 Debian 4.19.20-1co5
[   81.200309] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   81.206907] PC is at expire_timers+0x70/0x15c
[   81.211309] LR is at run_timer_softirq+0xb4/0x1dc
[   81.216061] pc : [<c03d7430>]    lr : [<c03d75d0>]    psr: 200f0193
[   81.222386] sp : ee991dd8  ip : ee991e10  fp : ee991e0c
[   81.227663] r10: ffffe000  r9 : c1105dc8  r8 : 00000000
[   81.234650] r7 : 00000200  r6 : ee991e10  r5 : ef6d0480  r4 : ed02a62c
[   81.242951] r3 : 30323438  r2 : ee991e10  r1 : ee991e10  r0 : ef6d0480
[   81.251238] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   81.260212] Control: 10c5387d  Table: 1331804a  DAC: 00000051
[   81.267678] Process swapper/3 (pid: 0, stack limit = 0x02c38c69)
[   81.275447] Stack: (0xee991dd8 to 0xee992000)
[   81.281596] 1dc0:                                                       c11f7db0 c1105df4
[   81.291569] 1de0: 00000038 ee991e10 ef6d0480 ee991e10 c1104d00 c1013480 c1105dc8 2e6bd000
[   81.301529] 1e00: ee991e64 ee991e10 c03d75d0 c03d73cc 30323438 ee991e20 c03da6e0 c03ebb40
[   81.311471] 1e20: 200f0193 0000000f 00000000 00000012 df137679 6fdeee9d ef6d1808 00000001
[   81.321400] 1e40: 00000002 c1104084 ffffe000 00000100 ee990000 00000282 ee991ecc ee991e68
[   81.331299] 1e60: c0302994 c03d7528 00000001 00000010 ee990000 c0b06478 00200042 c0c6ec40
[   81.341170] 1e80: c1104d00 ffff2a31 0000000a c1017500 c11f7a38 c100f368 c1105df4 c1104080
[   81.351032] 1ea0: c03c19e0 c10174b8 00000000 00000000 00000001 ee8d8400 ee990000 c0c727f0
[   81.360855] 1ec0: ee991edc ee991ed0 c0355400 c030285c ee991f04 ee991ee0 c03bc334 c0355330
[   81.370660] 1ee0: c11067e0 f400010c f4000100 ee991f30 f4001100 ee990000 ee991f2c ee991f08
[   81.380446] 1f00: c03025a0 c03bc2d0 c030abd4 600f0013 ffffffff ee991f64 00000001 ee990000
[   81.390212] 1f20: ee991f8c ee991f30 c0301a0c c0302554 00000000 0006313c ef6d0448 c03225c0
[   81.399968] 1f40: ffffe000 c1105df4 c1105e3c 00000008 00000001 c11f7534 c0c727f0 ee991f8c
[   81.409703] 1f60: ee991f90 ee991f80 c030abd0 c030abd4 600f0013 ffffffff 00000051 00000000
[   81.419435] 1f80: ee991f9c ee991f90 c0aeefd0 c030ab98 ee991fcc ee991fa0 c038398c c0aeefa4
[   81.429127] 1fa0: 00000001 00000086 00000003 10c0387d c121a928 1020406a 412fc09a 00000000
[   81.438816] 1fc0: ee991fdc ee991fd0 c0383c88 c0383870 ee991ff4 ee991fe0 c0312e80 c0383c6c
[   81.448505] 1fe0: 3e98006a 00000051 00000000 ee991ff8 10302c6c c0312d2c 00000000 00000000
[   81.458198] [<c03d7430>] (expire_timers) from [<c03d75d0>] (run_timer_softirq+0xb4/0x1dc)
[   81.467904] [<c03d75d0>] (run_timer_softirq) from [<c0302994>] (__do_softirq+0x144/0x390)
[   81.477631] [<c0302994>] (__do_softirq) from [<c0355400>] (irq_exit+0xdc/0x118)
[   81.486487] [<c0355400>] (irq_exit) from [<c03bc334>] (__handle_domain_irq+0x70/0xc4)
[   81.495863] [<c03bc334>] (__handle_domain_irq) from [<c03025a0>] (gic_handle_irq+0x58/0x94)
[   81.505790] [<c03025a0>] (gic_handle_irq) from [<c0301a0c>] (__irq_svc+0x6c/0x90)
[   81.514850] Exception stack(0xee991f30 to 0xee991f78)
[   81.521498] 1f20:                                     00000000 0006313c ef6d0448 c03225c0
[   81.531312] 1f40: ffffe000 c1105df4 c1105e3c 00000008 00000001 c11f7534 c0c727f0 ee991f8c
[   81.541142] 1f60: ee991f90 ee991f80 c030abd0 c030abd4 600f0013 ffffffff
[   81.549413] [<c0301a0c>] (__irq_svc) from [<c030abd4>] (arch_cpu_idle+0x48/0x4c)
[   81.558468] [<c030abd4>] (arch_cpu_idle) from [<c0aeefd0>] (default_idle_call+0x38/0x3c)
[   81.568240] [<c0aeefd0>] (default_idle_call) from [<c038398c>] (do_idle+0x128/0x164)
[   81.577651] [<c038398c>] (do_idle) from [<c0383c88>] (cpu_startup_entry+0x28/0x30)
[   81.586895] [<c0383c88>] (cpu_startup_entry) from [<c0312e80>] (secondary_start_kernel+0x160/0x188)
[   81.599226] [<c0312e80>] (secondary_start_kernel) from [<10302c6c>] (0x10302c6c)
[   81.608299] Code: e5943000 e5942004 e3530000 e5823000 (15832004)
[   81.616097] ---[ end trace caf7673330a23b6c ]---
[   81.622393] Kernel panic - not syncing: Fatal exception in interrupt
[   81.630434] CPU2: stopping
[   81.634784] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D  C        4.19.0-3-armmp #1 Debian 4.19.20-1co5
[   81.647844] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   81.656075] [<c0315cf8>] (unwind_backtrace) from [<c030ee34>] (show_stack+0x20/0x24)
[   81.665525] [<c030ee34>] (show_stack) from [<c0ad3300>] (dump_stack+0x94/0xa8)
[   81.674442] [<c0ad3300>] (dump_stack) from [<c0313498>] (handle_IPI+0x364/0x39c)
[   81.683517] [<c0313498>] (handle_IPI) from [<c03025d8>] (gic_handle_irq+0x90/0x94)
[   81.692744] [<c03025d8>] (gic_handle_irq) from [<c0301a0c>] (__irq_svc+0x6c/0x90)
[   81.701883] Exception stack(0xee98ff30 to 0xee98ff78)
[   81.708563] ff20:                                     00000000 000527c0 ef6bf448 c03225c0
[   81.718410] ff40: ffffe000 c1105df4 c1105e3c 00000004 00000001 c11f7534 c0c727f0 ee98ff8c
[   81.728241] ff60: ee98ff90 ee98ff80 c030abd0 c030abd4 60070013 ffffffff
[   81.745568] [<c030abd4>] (arch_cpu_idle) from [<c0aeefd0>] (default_idle_call+0x38/0x3c)
[   81.755318] [<c0aeefd0>] (default_idle_call) from [<c038398c>] (do_idle+0x128/0x164)
[   81.764702] [<c038398c>] (do_idle) from [<c0383c88>] (cpu_startup_entry+0x28/0x30)
[   81.773908] [<c0383c88>] (cpu_startup_entry) from [<c0312e80>] (secondary_start_kernel+0x160/0x188)
[   81.786168] [<c0312e80>] (secondary_start_kernel) from [<10302c6c>] (0x10302c6c)
[   81.795213] CPU0: stopping
[   81.799551] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D  C        4.19.0-3-armmp #1 Debian 4.19.20-1co5
[   81.812590] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   81.820790] [<c0315cf8>] (unwind_backtrace) from [<c030ee34>] (show_stack+0x20/0x24)
[   81.830200] [<c030ee34>] (show_stack) from [<c0ad3300>] (dump_stack+0x94/0xa8)
[   81.839078] [<c0ad3300>] (dump_stack) from [<c0313498>] (handle_IPI+0x364/0x39c)
[   81.848108] [<c0313498>] (handle_IPI) from [<c03025d8>] (gic_handle_irq+0x90/0x94)
[   81.857305] [<c03025d8>] (gic_handle_irq) from [<c0301a0c>] (__irq_svc+0x6c/0x90)
[   81.866408] Exception stack(0xc1101ee0 to 0xc1101f28)
[   81.873088] 1ee0: 00000000 00066914 ef69d448 c03225c0 ffffe000 c1105df4 c1105e3c 00000001
[   81.882924] 1f00: 00000001 c11f7534 c0c727f0 c1101f3c c1101f40 c1101f30 c030abd0 c030abd4
[   81.892746] 1f20: 60030013 ffffffff
[   81.897853] [<c0301a0c>] (__irq_svc) from [<c030abd4>] (arch_cpu_idle+0x48/0x4c)
[   81.906884] [<c030abd4>] (arch_cpu_idle) from [<c0aeefd0>] (default_idle_call+0x38/0x3c)
[   81.916614] [<c0aeefd0>] (default_idle_call) from [<c038398c>] (do_idle+0x128/0x164)
[   81.926012] [<c038398c>] (do_idle) from [<c0383c88>] (cpu_startup_entry+0x28/0x30)
[   81.935254] [<c0383c88>] (cpu_startup_entry) from [<c0ae85ec>] (rest_init+0xb8/0xbc)
[   81.944671] [<c0ae85ec>] (rest_init) from [<c0f01098>] (start_kernel+0x4d4/0x500)
[   81.953804] CPU1: stopping
[   81.958129] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D  C        4.19.0-3-armmp #1 Debian 4.19.20-1co5
[   81.971109] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   81.979303] [<c0315cf8>] (unwind_backtrace) from [<c030ee34>] (show_stack+0x20/0x24)
[   81.988712] [<c030ee34>] (show_stack) from [<c0ad3300>] (dump_stack+0x94/0xa8)
[   81.997602] [<c0ad3300>] (dump_stack) from [<c0313498>] (handle_IPI+0x364/0x39c)
[   82.006650] [<c0313498>] (handle_IPI) from [<c03025d8>] (gic_handle_irq+0x90/0x94)
[   82.015856] [<c03025d8>] (gic_handle_irq) from [<c0301a0c>] (__irq_svc+0x6c/0x90)
[   82.024949] Exception stack(0xee98df30 to 0xee98df78)
[   82.031595] df20:                                     00000000 00062e98 ef6ae448 c03225c0
[   82.041400] df40: ffffe000 c1105df4 c1105e3c 00000002 00000001 c11f7534 c0c727f0 ee98df8c
[   82.051197] df60: ee98df90 ee98df80 c030abd0 c030abd4 60010013 ffffffff
[   82.059422] [<c0301a0c>] (__irq_svc) from [<c030abd4>] (arch_cpu_idle+0x48/0x4c)
[   82.068425] [<c030abd4>] (arch_cpu_idle) from [<c0aeefd0>] (default_idle_call+0x38/0x3c)
[   82.078130] [<c0aeefd0>] (default_idle_call) from [<c038398c>] (do_idle+0x128/0x164)
[   82.087486] [<c038398c>] (do_idle) from [<c0383c88>] (cpu_startup_entry+0x28/0x30)
[   82.096673] [<c0383c88>] (cpu_startup_entry) from [<c0312e80>] (secondary_start_kernel+0x160/0x188)
[   82.108947] [<c0312e80>] (secondary_start_kernel) from [<10302c6c>] (0x10302c6c)
[   82.117993] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

This is fixed in the upstream kernel by 47cdee29ef9d. This fix has a few
issues addressed by c3e2219216c9 and c326f846ebc2a which have been included in this
series.

Tested by setting up the following udev rule:

KERNEL=="sd*", SUBSYSTEMS=="usb", ACTION=="add", ENV{DEVTYPE}=="disk", ENV{MAJOR}=="8", R
UN+="/bin/sh -c 'echo $env{MAJOR}:$env{MINOR} 4096 > /sys/fs/cgroup/blkio/blkio.throttle.
read_bps_device'"

With the udev rule operational, inserting and removing a USB flash drive after ~5 secs.

Ming Lei (3):
  block: move blk_exit_queue into __blk_release_queue
  block: free sched's request pool in blk_cleanup_queue
  blk-mq: remove WARN_ON(!q->elevator) from blk_mq_sched_free_requests

 block/blk-core.c     | 50 ++++++++++++--------------------------------
 block/blk-mq-sched.c | 29 ++++++++++++++++++++++---
 block/blk-mq-sched.h |  1 +
 block/blk-sysfs.c    | 47 ++++++++++++++++++++++++++++-------------
 block/blk.h          | 11 ++++++++--
 block/elevator.c     |  2 +-
 6 files changed, 82 insertions(+), 58 deletions(-)

-- 
2.24.0

