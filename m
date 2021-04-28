Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0344D36D7BD
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 14:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbhD1Myj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 08:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239638AbhD1Myg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 08:54:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78AF760241;
        Wed, 28 Apr 2021 12:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619614432;
        bh=bKkGbrhGoVnui/J/0QONuGnBwydgIajSHLYPB+s/NKs=;
        h=From:To:Cc:Subject:Date:From;
        b=EaTlW1JsKGEYD2mgiNCurvTouxcXFkS5btl2Td56fw7CShvpkp+mHGjc4C7tAvxVq
         DeD98sQOefCHEMcW8/Kz3W5OGTESwolRkBvEHwOCwWQoKvW1vLAPX6B4RRVYlqLjQI
         zTz697ddMKCt4VRwDcparu8zj4YrTz9bqjuQYGsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.33
Date:   Wed, 28 Apr 2021 14:53:45 +0200
Message-Id: <16196144259654@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.33 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/boot/dts/omap3.dtsi                            |    3 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts |    2 
 arch/arm64/kernel/probes/kprobes.c                      |    6 
 arch/csky/Kconfig                                       |    2 
 arch/csky/include/asm/page.h                            |    2 
 arch/ia64/mm/discontig.c                                |    6 
 arch/s390/kernel/entry.S                                |    1 
 arch/x86/events/intel/core.c                            |    2 
 arch/x86/events/intel/uncore_snbep.c                    |   61 -
 arch/x86/kernel/crash.c                                 |    2 
 block/ioctl.c                                           |    2 
 drivers/dma/tegra20-apb-dma.c                           |    4 
 drivers/dma/xilinx/xilinx_dpdma.c                       |   31 
 drivers/gpio/gpio-omap.c                                |    9 
 drivers/hid/hid-alps.c                                  |    1 
 drivers/hid/hid-cp2112.c                                |   22 
 drivers/hid/hid-google-hammer.c                         |    2 
 drivers/hid/hid-ids.h                                   |    1 
 drivers/hid/wacom_wac.c                                 |    2 
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h      |    2 
 drivers/net/geneve.c                                    |    6 
 drivers/net/usb/hso.c                                   |    2 
 drivers/net/xen-netback/xenbus.c                        |   12 
 drivers/pinctrl/core.c                                  |   14 
 drivers/pinctrl/intel/pinctrl-lewisburg.c               |    6 
 drivers/soc/qcom/qcom-geni-se.c                         |    3 
 drivers/usb/class/cdc-acm.c                             |    3 
 drivers/vdpa/mlx5/core/mr.c                             |    4 
 drivers/vhost/vdpa.c                                    |    6 
 include/linux/bpf.h                                     |    5 
 include/linux/bpf_verifier.h                            |    3 
 include/linux/platform_data/gpio-omap.h                 |    3 
 kernel/bpf/verifier.c                                   |  774 ++++++++++++----
 kernel/locking/qrwlock.c                                |    7 
 scripts/Makefile.kasan                                  |   12 
 security/keys/trusted-keys/trusted_tpm2.c               |    2 
 tools/arch/ia64/include/asm/barrier.h                   |    3 
 tools/perf/util/auxtrace.c                              |    2 
 tools/perf/util/map.c                                   |    7 
 40 files changed, 744 insertions(+), 295 deletions(-)

Ali Saidi (1):
      locking/qrwlock: Fix ordering in queued_write_lock_slowpath()

Andre Przywara (1):
      arm64: dts: allwinner: Revert SD card CD GPIO for Pine64-LTS

Andrei Matei (1):
      bpf: Allow variable-offset stack access

Andy Shevchenko (1):
      pinctrl: core: Show pin numbers for the controllers with base = 0

Arnd Bergmann (1):
      kasan: fix hwasan build for gcc

Christoph Hellwig (1):
      block: return -EBUSY when there are open partitions in blkdev_reread_part

Daniel Borkmann (2):
      bpf: Refactor and streamline bounds check into helper
      bpf: Tighten speculative pointer arithmetic mask

Dinghao Liu (1):
      dmaengine: tegra20: Fix runtime PM imbalance on error

Douglas Gilbert (1):
      HID cp2112: fix support for multiple gpiochips

Eli Cohen (1):
      vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails

Greg Kroah-Hartman (1):
      Linux 5.10.33

James Bottomley (1):
      KEYS: trusted: Fix TPM reservation for seal/unseal

Jia-Ju Bai (1):
      HID: alps: fix error return code in alps_input_configured()

Jiapeng Zhong (1):
      HID: wacom: Assign boolean values to a bool variable

Jim Mattson (1):
      perf/x86/kvm: Fix Broadwell Xeon stepping in isolation_ucodes[]

Jisheng Zhang (1):
      arm64: kprobes: Restore local irqflag if kprobes is cancelled

Johan Hovold (1):
      net: hso: fix NULL-deref on disconnect regression

John Paul Adrian Glaubitz (1):
      ia64: tools: remove duplicate definition of ia64_mf() on ia64

Kan Liang (1):
      perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3

Laurent Pinchart (2):
      dmaengine: xilinx: dpdma: Fix descriptor issuing on video group
      dmaengine: xilinx: dpdma: Fix race condition in done IRQ

Leo Yan (1):
      perf auxtrace: Fix potential NULL pointer dereference

Michael Brown (1):
      xen-netback: Check for hotplug-status existence before watching

Mike Galbraith (1):
      x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

Oliver Neukum (1):
      USB: CDC-ACM: fix poison/unpoison imbalance

Phillip Potter (1):
      net: geneve: check skb is large enough for IPv4/IPv6 header

Randy Dunlap (2):
      csky: change a Kconfig symbol name to fix e1000 build error
      ia64: fix discontig.c section mismatches

Shawn Guo (1):
      soc: qcom: geni: shield geni_icc_get() for ACPI boot

Shou-Chieh Hsu (1):
      HID: google: add don USB id

Tony Lindgren (2):
      gpio: omap: Save and restore sysconfig
      ARM: dts: Fix swapped mmc order for omap3

Vasily Gorbik (1):
      s390/entry: save the caller of psw_idle

Wan Jiabing (1):
      cavium/liquidio: Fix duplicate argument

Xie Yongji (1):
      vhost-vdpa: protect concurrent access to vhost device iotlb

Yonghong Song (1):
      bpf: Permits pointers on stack for helper calls

Yuanyuan Zhong (1):
      pinctrl: lewisburg: Update number of pins in community

Zhen Lei (1):
      perf map: Fix error return code in maps__clone()

