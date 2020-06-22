Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DE5203173
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgFVIIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 04:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgFVIIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 04:08:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B69207F5;
        Mon, 22 Jun 2020 08:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813289;
        bh=SHCChp+bNlXWNoLAsNGuULN4WuQ9DOcslf9/ORLAUaI=;
        h=From:To:Cc:Subject:Date:From;
        b=PBu/4N1wzSXm2axq7XmxtLyhQ282GrhRYcJIiyAvWZbtkntra/gNnNJ1KmRJ8LEaQ
         /OK0rhA0Le7tRcyEeR+Wb71j7ZUkEhZi7FvXpJa9RKTYXT35z4TT4p7vfYhTMJ63Um
         l++JtvnGeyHsg1TZQOQRW2o9p1NTpypJQCFxjHGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.228
Date:   Mon, 22 Jun 2020 10:08:02 +0200
Message-Id: <1592813282186118@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.228 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |   15 -
 arch/arm/kernel/ptrace.c                        |    4 
 arch/arm/mach-tegra/tegra.c                     |    4 
 arch/arm/mm/proc-macros.S                       |    3 
 arch/arm64/include/asm/kvm_host.h               |    6 
 arch/m68k/include/asm/mac_via.h                 |    1 
 arch/m68k/mac/config.c                          |   21 --
 arch/m68k/mac/via.c                             |    6 
 arch/mips/kernel/genex.S                        |    6 
 arch/mips/kernel/mips-cm.c                      |    6 
 arch/mips/kernel/setup.c                        |   10 +
 arch/mips/kernel/time.c                         |   70 +++++++
 arch/powerpc/platforms/cell/spufs/file.c        |  113 +++++++----
 arch/sparc/kernel/ptrace_32.c                   |  228 ++++++++++--------------
 arch/x86/include/asm/cpufeatures.h              |    2 
 arch/x86/include/asm/nospec-branch.h            |    1 
 arch/x86/kernel/cpu/bugs.c                      |   93 ++++++---
 arch/x86/kernel/process.c                       |   28 +-
 arch/x86/kernel/process.h                       |    2 
 arch/x86/kernel/reboot.c                        |    8 
 arch/x86/kernel/time.c                          |    4 
 arch/x86/kernel/vmlinux.lds.S                   |    4 
 arch/x86/kvm/svm.c                              |    2 
 arch/x86/kvm/vmx.c                              |    2 
 arch/x86/mm/init.c                              |    2 
 drivers/acpi/device_pm.c                        |    2 
 drivers/acpi/scan.c                             |   28 ++
 drivers/acpi/sysfs.c                            |    4 
 drivers/clocksource/dw_apb_timer_of.c           |    6 
 drivers/cpuidle/sysfs.c                         |    6 
 drivers/firmware/efi/efivars.c                  |    4 
 drivers/macintosh/windfarm_pm112.c              |   22 +-
 drivers/md/md.c                                 |    3 
 drivers/media/usb/dvb-usb/dibusb-mb.c           |    2 
 drivers/media/usb/go7007/snd-go7007.c           |   35 +--
 drivers/net/can/usb/kvaser_usb.c                |    6 
 drivers/net/ethernet/allwinner/sun4i-emac.c     |    4 
 drivers/net/ethernet/intel/e1000/e1000_main.c   |    4 
 drivers/net/ethernet/intel/e1000e/e1000.h       |    1 
 drivers/net/ethernet/intel/e1000e/netdev.c      |   12 -
 drivers/net/ethernet/intel/igb/e1000_regs.h     |    3 
 drivers/net/ethernet/intel/igb/igb_ethtool.c    |    3 
 drivers/net/ethernet/intel/igb/igb_main.c       |    5 
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c |    2 
 drivers/net/ethernet/nxp/lpc_eth.c              |    3 
 drivers/net/macvlan.c                           |    4 
 drivers/net/phy/marvell.c                       |    2 
 drivers/net/vmxnet3/vmxnet3_ethtool.c           |    2 
 drivers/net/vxlan.c                             |    4 
 drivers/net/wireless/ath/ath9k/hif_usb.c        |   58 ++++--
 drivers/net/wireless/ath/ath9k/hif_usb.h        |    6 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |   10 -
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |    6 
 drivers/net/wireless/ath/ath9k/htc_hst.c        |    3 
 drivers/net/wireless/ath/ath9k/wmi.c            |    5 
 drivers/net/wireless/ath/ath9k/wmi.h            |    3 
 drivers/net/wireless/ath/carl9170/fw.c          |    4 
 drivers/net/wireless/ath/carl9170/main.c        |   21 --
 drivers/net/wireless/b43/main.c                 |    2 
 drivers/net/wireless/b43legacy/main.c           |    1 
 drivers/net/wireless/b43legacy/xmit.c           |    1 
 drivers/net/wireless/mwifiex/cfg80211.c         |   14 -
 drivers/pci/probe.c                             |   24 ++
 drivers/pinctrl/samsung/pinctrl-exynos.c        |    9 
 drivers/power/reset/vexpress-poweroff.c         |    1 
 drivers/pwm/pwm-fsl-ftm.c                       |    2 
 drivers/scsi/scsi_lib.c                         |    4 
 drivers/spi/spi-bcm2835.c                       |    4 
 drivers/spi/spi-bcm2835aux.c                    |    4 
 drivers/spi/spi-dw-mid.c                        |   16 +
 drivers/spi/spi-dw.c                            |   14 -
 drivers/spi/spi-pxa2xx.c                        |    4 
 drivers/spi/spi.c                               |    5 
 drivers/staging/android/ion/ion_heap.c          |    4 
 drivers/video/fbdev/w100fb.c                    |    2 
 drivers/w1/masters/omap_hdq.c                   |   10 -
 fs/btrfs/file-item.c                            |    6 
 fs/btrfs/inode.c                                |    6 
 fs/btrfs/ioctl.c                                |    3 
 fs/btrfs/send.c                                 |   67 +++++++
 fs/btrfs/tree-log.c                             |   15 +
 fs/btrfs/tree-log.h                             |    2 
 fs/ext4/ext4_extents.h                          |    9 
 fs/fat/inode.c                                  |    6 
 fs/fs-writeback.c                               |    1 
 fs/nilfs2/segment.c                             |    2 
 fs/overlayfs/copy_up.c                          |    2 
 fs/proc/inode.c                                 |    2 
 fs/proc/self.c                                  |    2 
 fs/proc/thread_self.c                           |    2 
 include/linux/kgdb.h                            |    2 
 include/linux/sunrpc/gss_api.h                  |    1 
 include/linux/sunrpc/svcauth_gss.h              |    3 
 kernel/cpu_pm.c                                 |    4 
 kernel/debug/debug_core.c                       |    1 
 kernel/sched/fair.c                             |    2 
 lib/mpi/longlong.h                              |    2 
 mm/slub.c                                       |    4 
 net/bluetooth/hci_event.c                       |    1 
 net/ipv6/ipv6_sockglue.c                        |   13 -
 net/netfilter/nft_nat.c                         |    4 
 net/sunrpc/auth_gss/gss_mech_switch.c           |   12 -
 net/sunrpc/auth_gss/svcauth_gss.c               |   18 +
 security/integrity/ima/ima.h                    |    7 
 security/integrity/ima/ima_policy.c             |    3 
 security/smack/smackfs.c                        |   10 +
 sound/core/pcm_native.c                         |    5 
 sound/isa/es1688/es1688.c                       |    4 
 sound/usb/card.c                                |   20 +-
 sound/usb/usbaudio.h                            |    2 
 tools/perf/builtin-probe.c                      |    3 
 tools/perf/util/dso.c                           |   16 +
 tools/perf/util/dso.h                           |    1 
 tools/perf/util/probe-finder.c                  |    1 
 tools/perf/util/symbol.c                        |    2 
 115 files changed, 841 insertions(+), 470 deletions(-)

Adrian Hunter (1):
      perf symbols: Fix debuginfo search for Ubuntu

Al Viro (1):
      sparc32: fix register window handling in genregs32_[gs]et()

Alexander Sverdlin (1):
      macvlan: Skip loopback packets in RX handler

Anders Roxell (1):
      power: vexpress: add suppress_bind_attrs to true

Andy Shevchenko (2):
      spi: No need to assign dummy value in spi_unregister_controller()
      spi: dw: Zero DMA Tx and Rx configurations on stack

Anthony Steinhauser (3):
      x86/speculation: Prevent rogue cross-process SSBD shutdown
      x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.
      x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for indirect branches.

Ard Biesheuvel (1):
      efi/efivars: Add missing kobject_put() in sysfs entry creation error path

Arvind Sankar (1):
      x86/mm: Stop printing BRK addresses

Ashok Raj (1):
      PCI: Program MPS for RCiEP devices

Bob Haarman (1):
      x86_64: Fix jiffies ODR violation

Casey Schaufler (1):
      Smack: slab-out-of-bounds in vsscanf

Christian Lamparter (1):
      carl9170: remove P2P_GO support

Christoph Hellwig (1):
      staging: android: ion: use vmap instead of vm_map_ram

Christophe JAILLET (1):
      video: fbdev: w100fb: Fix a potential double free.

Chuhong Yuan (2):
      ALSA: es1688: Add the missed snd_card_free()
      media: go7007: fix a miss of snd_card_free

Colin Ian King (1):
      media: dvb: return -EREMOTEIO on i2c transfer failure.

Daniel Thompson (1):
      kgdb: Fix spurious true from in_dbg_master()

Dmitry Osipenko (1):
      ARM: tegra: Correct PL310 Auxiliary Control Register initialization

Douglas Anderson (2):
      kgdb: Prevent infinite recursive entries to the debugger
      kernel/cpu_pm: Fix uninitted local in cpu_pm

Eric W. Biederman (1):
      proc: Use new_inode not new_inode_pseudo

Filipe Manana (2):
      btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums
      Btrfs: fix unreplayable log after snapshot delete + parent dir fsync

Finn Thain (1):
      m68k: mac: Don't call via_flush_cache() on Mac IIfx

Fredrik Strupe (1):
      ARM: 8977/1: ptrace: Fix mask for thumb breakpoint hook

Greg Kroah-Hartman (1):
      Linux 4.4.228

Guoqing Jiang (1):
      md: don't flush workqueue unconditionally in md_open

H. Nikolaus Schaller (1):
      w1: omap-hdq: cleanup to add missing newline for some dev_dbg

Hangbin Liu (1):
      ipv6: fix IPV6_ADDRFORM operation logic

Harshad Shirwadkar (1):
      ext4: fix EXT_MAX_EXTENT/INDEX to check for zeroed eh_max

Hill Ma (1):
      x86/reboot/quirks: Add MacBook6,1 reboot quirk

Hsin-Yu Chao (1):
      Bluetooth: Add SCO fallback for invalid LMP parameters error

Ido Schimmel (1):
      vxlan: Avoid infinite loop when suppressing NS messages with invalid options

Jarod Wilson (1):
      igb: improve handling of disconnected adapters

Jens Axboe (1):
      sched/fair: Don't NUMA balance for kthreads

Jeremy Kerr (1):
      powerpc/spufs: fix copy_to_user while atomic

Jia-Ju Bai (1):
      net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()

Jiaxun Yang (1):
      PCI: Don't disable decoding when mmio_always_on is set

Johannes Thumshirn (1):
      scsi: return correct blkprep status code in case scsi_init_io() fails.

Jonathan Bakker (1):
      pinctrl: samsung: Save/restore eint_mask over suspend for EINT_TYPE GPIOs

Kai-Heng Feng (1):
      igb: Report speed and duplex as unknown when device is runtime suspended

Kees Cook (1):
      e1000: Distribute switch variables for initialization

Krzysztof Struczynski (1):
      ima: Fix ima digest hash table key calculation

Larry Finger (3):
      b43legacy: Fix case where channel status is corrupted
      b43: Fix connection problem with WPA3
      b43_legacy: Fix connection problem with WPA3

Linus Walleij (1):
      ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE

Lukas Wunner (5):
      spi: bcm2835aux: Fix controller unregister order
      spi: dw: Fix controller unregister order
      spi: Fix controller unregister order
      spi: pxa2xx: Fix controller unregister order
      spi: bcm2835: Fix controller unregister order

Marc Zyngier (1):
      KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts

Marcos Paulo de Souza (1):
      btrfs: send: emit file capabilities after chown

Masahiro Yamada (1):
      kbuild: force to build vmlinux if CONFIG_MODVERSION=y

Masami Hiramatsu (1):
      perf probe: Do not show the skipped events

Masashi Honma (1):
      ath9k_htc: Silence undersized packet warnings

Michael Ellerman (1):
      drivers/macintosh: Fix memleak in windfarm_pm112 driver

Michał Mirosław (1):
      ALSA: pcm: disallow linking stream to itself

Nathan Chancellor (1):
      lib/mpi: Fix 64-bit MIPS build with Clang

NeilBrown (2):
      sunrpc: svcauth_gss_register_pseudoflavor must reject duplicate registrations.
      sunrpc: clean up properly in gss_mech_unregister()

OGAWA Hirofumi (1):
      fat: don't allow to mount if the FAT length == 0

Omar Sandoval (1):
      btrfs: fix error handling when submitting direct I/O bio

Pablo Neira Ayuso (1):
      netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported

Pali Rohár (1):
      mwifiex: Fix memory corruption in dump_station

Paolo Bonzini (1):
      KVM: nSVM: leave ASID aside in copy_vmcb_control_area

Punit Agrawal (1):
      e1000e: Relax condition to trigger reset for ME workaround

Qiujun Huang (4):
      ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
      ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
      ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
      ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Qiushi Wu (2):
      ACPI: sysfs: Fix reference count leak in acpi_sysfs_add_hotplug_profile()
      cpuidle: Fix three reference count leaks

Rafael J. Wysocki (1):
      ACPI: PM: Avoid using power resources if there are none for D0

Roberto Sassu (1):
      ima: Directly assign the ima_default_policy pointer to ima_rules

Ryusuke Konishi (1):
      nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

Sasha Levin (1):
      spi: dw: fix possible race condition

Sean Christopherson (1):
      KVM: nVMX: Consult only the "basic" exit reason when routing nested exit

Serge Semin (5):
      spi: dw: Enable interrupts in accordance with DMA xfer mode
      clocksource: dw_apb_timer_of: Fix missing clockevent timers
      mips: cm: Fix an invalid error code of INTVN_*_ERR
      mips: Add udelay lpj numbers adjustment
      spi: dw: Return any value retrieved from the dma_transfer callback

Stefan Agner (1):
      pwm: fsl-ftm: Use flat regmap cache

Takashi Iwai (1):
      ALSA: usb-audio: Fix inconsistent card PM state after resume

Tejun Heo (1):
      cgroup, blkcg: Prepare some symbols for module and !CONFIG_CGROUP usages

Thomas Lendacky (1):
      x86/speculation: Add support for STIBP always-on preferred mode

Tiezhu Yang (1):
      MIPS: Make sparse_init() using top-down allocation

Waiman Long (1):
      x86/speculation: Change misspelled STIPB to STIBP

Wang Hai (1):
      mm/slub: fix a memory leak in sysfs_slab_add()

Wei Yongjun (1):
      net: lpc-enet: fix error return code in lpc_mii_init()

Xiaolong Huang (1):
      can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices

Xie XiuQi (1):
      ixgbe: fix signed-integer-overflow warning

YuanJunQing (1):
      MIPS: Fix IRQ tracing when call handle_fpe() and handle_msa_fpe()

Yunjian Wang (1):
      net: allwinner: Fix use correct return type for ndo_start_xmit()

Yuxuan Shui (1):
      ovl: initialize error in ovl_copy_xattr

Zhao Qiang (1):
      net: phy: marvell: Limit 88m1101 autoneg errata to 88E1145 as well.

