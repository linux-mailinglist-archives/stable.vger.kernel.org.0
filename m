Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B0F2F929E
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbhAQNkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:40:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729105AbhAQNkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:40:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD078206F7;
        Sun, 17 Jan 2021 13:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610890741;
        bh=hICbEAUU1tUUdR4QgFcyjSeZ6Agal29beJ2R0Pz0vq8=;
        h=From:To:Cc:Subject:Date:From;
        b=Il7iCsJXFAR0SWw2bLMIF2SlhGqqVCbfT9Ko/Yi/aZiJXjORUcEa0Ie3N0fl0SPqu
         Y4SXev9xl1uRsST3VW24Tym1/kwNu+kl7mWTvUX8YouUkvnCkxBkI8qwvypm0nk9lm
         RakEtU8oyqL+z35X3688pHAj7SgfhE44nG3WhINQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.168
Date:   Sun, 17 Jan 2021 14:38:56 +0100
Message-Id: <161089073634100@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.168 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm/mach-omap2/omap_device.c                 |    8 -
 arch/arm64/kvm/sys_regs.c                         |    4 
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c          |  113 +++++++++-------------
 block/genhd.c                                     |    9 +
 drivers/base/regmap/regmap-debugfs.c              |    9 +
 drivers/block/Kconfig                             |    1 
 drivers/cpufreq/powernow-k8.c                     |    9 -
 drivers/crypto/chelsio/chtls/chtls_cm.c           |   68 ++++---------
 drivers/dma/mediatek/mtk-hsdma.c                  |    1 
 drivers/dma/xilinx/xilinx_dma.c                   |   11 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c        |    2 
 drivers/hid/wacom_sys.c                           |   35 ++++++
 drivers/i2c/busses/i2c-sprd.c                     |    8 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c    |   26 ++++-
 drivers/iommu/intel_irq_remapping.c               |    2 
 drivers/lightnvm/Kconfig                          |    1 
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h   |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c   |    3 
 drivers/net/ethernet/natsemi/macsonic.c           |   12 +-
 drivers/net/ethernet/natsemi/xtsonic.c            |    7 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |   58 ++++++++---
 drivers/net/usb/cdc_ncm.c                         |    8 +
 drivers/net/wan/Kconfig                           |    1 
 drivers/net/wireless/ath/wil6210/Kconfig          |    1 
 drivers/spi/spi-pxa2xx.c                          |    3 
 drivers/spi/spi-stm32.c                           |    4 
 include/asm-generic/vmlinux.lds.h                 |    5 
 net/8021q/vlan.c                                  |    3 
 net/core/skbuff.c                                 |    6 +
 net/ipv4/ip_output.c                              |    2 
 net/ipv4/ip_tunnel.c                              |   10 -
 net/ipv6/ip6_fib.c                                |    5 
 33 files changed, 267 insertions(+), 174 deletions(-)

Andreas Kemnade (1):
      ARM: OMAP2+: omap_device: fix idling of devices during probe

Arnd Bergmann (4):
      wil6210: select CONFIG_CRC32
      block: rsxx: select CONFIG_CRC32
      lightnvm: select CONFIG_CRC32
      wan: ds26522: select CONFIG_BITREVERSE

Ayush Sawal (6):
      chtls: Fix hardware tid leak
      chtls: Remove invalid set_tcb call
      chtls: Fix panic when route to peer not configured
      chtls: Replace skb_dequeue with skb_peek
      chtls: Added a check to avoid NULL pointer dereference
      chtls: Fix chtls resources release sequence

Chris Wilson (1):
      drm/i915: Fix mismatch between misplaced vma check and vma insert

Christophe JAILLET (2):
      net/sonic: Fix some resource leaks in error handling paths
      dmaengine: mediatek: mtk-hsdma: Fix a resource leak in the error handling path of the probe function

Chunyan Zhang (1):
      i2c: sprd: use a specific timeout to avoid system hang up issue

Colin Ian King (1):
      cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

Dan Carpenter (1):
      regmap: debugfs: Fix a reversed if statement in regmap_debugfs_init()

Dinghao Liu (3):
      iommu/intel: Fix memleak in intel_irq_remapping_alloc
      net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
      net/mlx5e: Fix two double free cases

Fenghua Yu (2):
      x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR
      x86/resctrl: Don't move a task to the same resource group

Florian Westphal (2):
      net: ip: always refragment ip defragmented packets
      net: fix pmtu check in nopmtudisc mode

Greg Kroah-Hartman (1):
      Linux 4.19.168

Jakub Kicinski (1):
      net: vlan: avoid leaks on register_vlan_dev() failures

Jouni K. Seppänen (1):
      net: cdc_ncm: correct overhead in delayed_ndp_size

Lorenzo Bianconi (1):
      iio: imu: st_lsm6dsx: fix edge-trigger interrupts

Lukas Wunner (1):
      spi: pxa2xx: Fix use-after-free on unbind

Marc Zyngier (1):
      KVM: arm64: Don't access PMCR_EL0 when no PMU is available

Ming Lei (1):
      block: fix use-after-free in disk_part_iter_next

Nick Desaulniers (1):
      vmlinux.lds.h: Add PGO and AutoFDO input sections

Ping Cheng (1):
      HID: wacom: Fix memory leakage caused by kfifo_alloc

Roman Guskov (1):
      spi: stm32: FIFO threshold level - fix align packet size

Samuel Holland (2):
      net: stmmac: dwmac-sun8i: Balance internal PHY resource references
      net: stmmac: dwmac-sun8i: Balance internal PHY power

Sean Nyekjaer (1):
      iio: imu: st_lsm6dsx: flip irq return logic

Sean Tranchetti (1):
      net: ipv6: fib: flush exceptions when purging route

Shravya Kumbham (3):
      dmaengine: xilinx_dma: check dma_async_device_register return value
      dmaengine: xilinx_dma: fix incompatible param warning in _child_probe()
      dmaengine: xilinx_dma: fix mixed_enum_type coverity warning

Vasily Averin (1):
      net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

Xiaolei Wang (1):
      regmap: debugfs: Fix a memory leak when calling regmap_attach_dev

Yufeng Mo (1):
      net: hns3: fix the number of queues actually used by ARQ

