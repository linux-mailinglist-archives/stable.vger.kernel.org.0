Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B268F38D583
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 13:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhEVLFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 07:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhEVLFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 07:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD8B1613AD;
        Sat, 22 May 2021 11:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621681451;
        bh=W4kFSC255xLwa1xH2fuuL51CzfylwwxHmT8mT0P7eeI=;
        h=From:To:Cc:Subject:Date:From;
        b=rZSa9GAFeLOyam3O8ZGODmIsrciMZvIvLnwG5vXXrnjoNmCPgCrh+xqeYuOiKPkxQ
         sXnLEBW0A46z1sN9YPFopXZtKP174mIjE0c4jsNZ4Y/9EX3pbboBKa+I/FUT8EAVtP
         pniAlmPblVjuK4IU1J+x/6MbGUKm7EoeP8TH1XaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.12.6
Date:   Sat, 22 May 2021 13:04:05 +0200
Message-Id: <162168144569109@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.12.6 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/kernel/asm-offsets.c                           |    3 
 arch/arm/kernel/smccc-call.S                            |   11 +
 arch/arm/kernel/suspend.c                               |   19 ++
 arch/riscv/include/asm/ftrace.h                         |   14 +
 arch/riscv/kernel/mcount.S                              |   10 -
 arch/riscv/kernel/vdso/Makefile                         |   12 -
 arch/um/Kconfig.debug                                   |    1 
 arch/um/kernel/Makefile                                 |    1 
 arch/um/kernel/dyn.lds.S                                |    6 
 arch/um/kernel/gmon_syms.c                              |   16 --
 arch/um/kernel/uml.lds.S                                |    6 
 arch/x86/lib/msr-smp.c                                  |    4 
 drivers/bus/mhi/core/boot.c                             |   51 +++---
 drivers/bus/mhi/core/internal.h                         |    1 
 drivers/bus/mhi/core/pm.c                               |    2 
 drivers/dma/dw-edma/dw-edma-core.c                      |   11 -
 drivers/gpio/gpiolib-acpi.c                             |   14 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       |   51 ++++++
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         |    5 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |    4 
 drivers/gpu/drm/i915/display/intel_dp.c                 |   13 +
 drivers/input/touchscreen/elants_i2c.c                  |   44 +++++-
 drivers/input/touchscreen/silead.c                      |   44 +++++-
 drivers/misc/kgdbts.c                                   |   26 +--
 drivers/net/ethernet/chelsio/cxgb4/sge.c                |   16 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c        |    7 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |   14 -
 drivers/net/wireless/cisco/airo.c                       |  117 ++++++++--------
 drivers/nvme/target/admin-cmd.c                         |    6 
 drivers/pci/controller/dwc/pcie-tegra194.c              |    2 
 drivers/pci/controller/pci-thunder-ecam.c               |    2 
 drivers/pci/controller/pci-thunder-pem.c                |   13 -
 drivers/pci/hotplug/acpiphp_glue.c                      |    1 
 drivers/pci/pci.h                                       |    6 
 drivers/platform/chrome/cros_ec_typec.c                 |    5 
 drivers/scsi/lpfc/lpfc_sli.c                            |   11 +
 drivers/target/target_core_user.c                       |    4 
 drivers/usb/host/sl811-hcd.c                            |    9 -
 fs/block_dev.c                                          |   20 ++
 fs/ceph/caps.c                                          |    1 
 fs/ceph/export.c                                        |    8 +
 fs/ceph/inode.c                                         |   13 +
 fs/ceph/mds_client.c                                    |    7 
 fs/ceph/super.h                                         |   24 +++
 fs/f2fs/segment.c                                       |    5 
 fs/nfs/inode.c                                          |    7 
 lib/stackdepot.c                                        |    6 
 net/bridge/br_netlink.c                                 |    5 
 net/hsr/hsr_forward.c                                   |    4 
 net/ipv6/ip6_gre.c                                      |    7 
 net/ipv6/ip6_tunnel.c                                   |    3 
 net/ipv6/ip6_vti.c                                      |    1 
 net/ipv6/sit.c                                          |    5 
 net/sunrpc/xprtrdma/svc_rdma_sendto.c                   |    8 -
 scripts/recordmcount.pl                                 |    2 
 sound/pci/hda/hda_generic.c                             |   16 +-
 57 files changed, 499 insertions(+), 227 deletions(-)

Arnd Bergmann (5):
      x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes
      airo: work around stack usage warning
      kgdb: fix gcc-11 warning on indentation
      usb: sl811-hcd: improve misleading indentation
      PCI: thunder: Fix compile testing

Bhaumik Bhatt (1):
      bus: mhi: core: Download AMSS image from appropriate function

Bodo Stroesser (1):
      scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found

Chuck Lever (1):
      svcrdma: Don't leak send_ctxt on Send errors

Darren Powell (1):
      amdgpu/pm: Prevent force of DCEFCLK on NAVI10 and SIENNA_CICHLID

Dinghao Liu (1):
      PCI: tegra: Fix runtime PM imbalance in pex_ep_event_pex_rst_deassert()

Eric Dumazet (4):
      ip6_gre: proper dev_{hold|put} in ndo_[un]init methods
      sit: proper dev_{hold|put} in ndo_[un]init methods
      ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods
      ipv6: remove extra dev_hold() for fallback tunnels

Feilong Lin (1):
      ACPI / hotplug / PCI: Fix reference count leak in enable_slot()

Greg Kroah-Hartman (1):
      Linux 5.12.6

Gustavo Pimentel (1):
      dmaengine: dw-edma: Fix crash on loading/unloading driver

Hans de Goede (3):
      Input: elants_i2c - do not bind to i2c-hid compatible ACPI instantiated devices
      Input: silead - add workaround for x86 BIOS-es which bring the chip up in a stuck state
      gpiolib: acpi: Add quirk to ignore EC wakeups on Dell Venue 10 Pro 5055

Hui Wang (1):
      ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP

James Smart (1):
      scsi: lpfc: Fix illegal memory access on Abort IOCBs

Jeff Layton (3):
      ceph: fix fscache invalidation
      ceph: don't clobber i_snap_caps on non-I_NEW inode
      ceph: don't allow access to MDS-private inodes

Johannes Berg (2):
      um: Mark all kernel symbols as local
      um: Disable CONFIG_GCOV with MODULES

Keith Busch (1):
      nvmet: remove unsupported command noise

Linus Torvalds (1):
      drm/i915/display: fix compiler warning about array overrun

Manivannan Sadhasivam (1):
      ARM: 9075/1: kernel: Fix interrupted SMC calls

Nathan Chancellor (3):
      riscv: Use $(LD) instead of $(CC) to link vDSO
      scripts/recordmcount.pl: Fix RISC-V regex for clang
      riscv: Workaround mcount name prior to clang-13

Phillip Potter (1):
      net: hsr: check skb can contain struct hsr_ethhdr in fill_frame_info

Prashant Malani (1):
      platform/chrome: cros_ec_typec: Add DP mode check

Rodrigo Siqueira (1):
      drm/amd/display: Fix two cursor duplication when using overlay

Trond Myklebust (2):
      NFS: Fix fscache invalidation in nfs_set_cache_invalid()
      NFS: NFS_INO_REVAL_PAGECACHE should mark the change attribute invalid

Yannick Vignon (1):
      net: stmmac: Do not enable RX FIFO overflow interrupts

Yi Chen (1):
      f2fs: fix to avoid NULL pointer dereference

Zhang Zhengming (1):
      bridge: Fix possible races between assigning rx_handler_data and setting IFF_BRIDGE_PORT bit

Zqiang (1):
      lib: stackdepot: turn depot_lock spinlock to raw_spinlock

louis.wang (1):
      ARM: 9066/1: ftrace: pause/unpause function graph tracer in cpu_suspend()

yangerkun (1):
      block: reexpand iov_iter after read/write

Íñigo Huguet (1):
      net:CXGB4: fix leak if sk_buff is not used

