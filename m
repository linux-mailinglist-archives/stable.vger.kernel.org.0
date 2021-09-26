Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9554188CB
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhIZMvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231583AbhIZMvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:51:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7880F60FC2;
        Sun, 26 Sep 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632660608;
        bh=TCJe430afNxAk1Mi95GqHLBR69i5xB2FxhaW/WNSAlI=;
        h=From:To:Cc:Subject:Date:From;
        b=lDfluHX2iyjgYwNSPdQJulFzGqK2XA6QIg0AykymjKDxdM4PMMwwyay3K1ecsnjXf
         TmaD9nx98l6lnY0DsFT+kCCLNKSIN4yM95EdQTbOcaJ7PLvTQ5dG0drxIGVcMQRPlj
         0BxH3Ac8X5mCB/renpO5oYO0jFYB0lkcAaQnfn1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.149
Date:   Sun, 26 Sep 2021 14:49:53 +0200
Message-Id: <1632660593161124@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.149 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm/include/asm/ftrace.h                     |    3 
 arch/arm/include/asm/insn.h                       |    8 +-
 arch/arm/include/asm/module.h                     |   10 ++
 arch/arm/kernel/ftrace.c                          |   46 ++++++++++--
 arch/arm/kernel/insn.c                            |   19 ++---
 arch/arm/kernel/module-plts.c                     |   49 ++++++++++---
 arch/arm/mm/init.c                                |    6 +
 arch/arm64/kernel/cacheinfo.c                     |    7 -
 arch/mips/kernel/cacheinfo.c                      |    7 -
 arch/riscv/kernel/cacheinfo.c                     |    7 -
 arch/s390/pci/pci_mmio.c                          |    2 
 arch/um/drivers/virtio_uml.c                      |    4 -
 arch/x86/kernel/cpu/cacheinfo.c                   |    7 -
 block/blk-throttle.c                              |    1 
 drivers/acpi/pci_mcfg.c                           |   20 +++++
 drivers/dma/Kconfig                               |    2 
 drivers/dma/acpi-dma.c                            |   10 +-
 drivers/dma/sprd-dma.c                            |    1 
 drivers/dma/xilinx/xilinx_dma.c                   |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 
 drivers/net/phy/phy-c45.c                         |    5 -
 drivers/net/phy/phy_device.c                      |    5 -
 drivers/parisc/dino.c                             |   18 ++---
 drivers/pci/controller/pci-aardvark.c             |   71 ++++++++++++++++++--
 drivers/pci/ecam.c                                |   10 ++
 drivers/pci/pci-bridge-emul.c                     |   25 +++----
 drivers/pci/pci-bridge-emul.h                     |   78 +++++++++++-----------
 drivers/pwm/pwm-img.c                             |   16 ----
 drivers/pwm/pwm-lpc32xx.c                         |   10 +-
 drivers/pwm/pwm-rockchip.c                        |   14 ---
 drivers/pwm/pwm-stm32-lp.c                        |    2 
 drivers/rtc/Kconfig                               |    1 
 drivers/staging/rtl8192u/r8192U_core.c            |    2 
 drivers/thermal/samsung/exynos_tmu.c              |    1 
 drivers/tty/vt/vt.c                               |   31 +++++++-
 fs/btrfs/volumes.c                                |    7 +
 fs/ceph/caps.c                                    |    2 
 fs/ceph/file.c                                    |   32 ++++-----
 fs/nilfs2/sysfs.c                                 |   26 +++----
 fs/nilfs2/the_nilfs.c                             |    9 +-
 include/linux/cacheinfo.h                         |   18 -----
 include/linux/kvm_host.h                          |   11 ---
 include/linux/pci-ecam.h                          |    1 
 include/linux/thermal.h                           |    5 -
 kernel/profile.c                                  |   21 +++--
 kernel/sys.c                                      |    7 -
 lib/Kconfig.debug                                 |    1 
 net/9p/trans_virtio.c                             |    4 -
 net/sctp/input.c                                  |    3 
 net/sctp/sm_make_chunk.c                          |   13 ++-
 security/apparmor/apparmorfs.c                    |    3 
 virt/kvm/kvm_main.c                               |    5 -
 54 files changed, 408 insertions(+), 266 deletions(-)

Alex Sverdlin (4):
      ARM: 9077/1: PLT: Move struct plt_entries definition to header
      ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
      ARM: 9079/1: ftrace: Add MODULE_PLTS support
      ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE

Anand Jain (1):
      btrfs: fix lockdep warning while mounting sprout fs

Andy Shevchenko (2):
      apparmor: remove duplicate macro list_entry_is_head()
      dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Arnd Bergmann (1):
      thermal/core: Fix thermal_cooling_device_register() prototype

Cyrill Gorcunov (1):
      prctl: allow to setup brk for et_dyn executables

Dan Carpenter (1):
      thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()

David Hildenbrand (1):
      s390/pci_mmio: fully validate the VMA before calling follow_pte()

Florian Fainelli (1):
      ARM: Qualify enabling of swiotlb_init()

Greg Kroah-Hartman (1):
      Linux 5.4.149

Grzegorz Jaszczyk (1):
      PCI: pci-bridge-emul: Fix big-endian support

Guenter Roeck (2):
      parisc: Move pci_dev_is_behind_card_dino to where it is used
      drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Jeff Layton (2):
      ceph: request Fw caps before updating the mtime in ceph_write_iter
      ceph: lockdep annotations for try_nonblocking_invalidate

Johannes Berg (2):
      um: virtio_uml: fix memory leak on init failures
      dmaengine: ioat: depends on !UML

Jongsung Kim (1):
      net: stmmac: reset Tx desc base address before restarting Tx

Li Jinlin (1):
      blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Lukas Bulwahn (1):
      Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Marcelo Ricardo Leitner (2):
      sctp: validate chunk size in __rcv_asconf_lookup
      sctp: add param size validation for SCTP_PARAM_SET_PRIMARY

Nanyong Sun (6):
      nilfs2: fix memory leak in nilfs_sysfs_create_device_group
      nilfs2: fix NULL pointer in nilfs_##name##_attr_release
      nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

Nathan Chancellor (1):
      staging: rtl8192u: Fix bitwise vs logical operator in TranslateRxSignalStuff819xUsb()

Pali Rohár (3):
      PCI: aardvark: Indicate error in 'val' when config read fails
      PCI: pci-bridge-emul: Add PCIe Root Capabilities Register
      PCI: aardvark: Fix reporting CRS value

Pavel Skripkin (1):
      profiling: fix shift-out-of-bounds bugs

Petr Oros (1):
      phy: avoid unnecessary link-up delay in polling mode

Radhey Shyam Pandey (1):
      dmaengine: xilinx_dma: Set DMA mask for coherent APIs

Radim Krčmář (1):
      KVM: remember position in kvm->vcpus array

Thomas Gleixner (1):
      drivers: base: cacheinfo: Get rid of DEFINE_SMP_CALL_CACHE_FUNCTION()

Tuan Phan (1):
      PCI/ACPI: Add Ampere Altra SOC MCFG quirk

Uwe Kleine-König (4):
      pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered
      pwm: img: Don't modify HW state in .remove() callback
      pwm: rockchip: Don't modify HW state in .remove() callback
      pwm: stm32-lp: Don't modify HW state in .remove() callback

Xie Yongji (1):
      9p/trans_virtio: Remove sysfs file on probe failure

Yu-Tung Chang (1):
      rtc: rx8010: select REGMAP_I2C

Zhen Lei (1):
      nilfs2: use refcount_dec_and_lock() to fix potential UAF

Zou Wei (1):
      dmaengine: sprd: Add missing MODULE_DEVICE_TABLE

nick black (1):
      console: consume APC, DM, DCS

