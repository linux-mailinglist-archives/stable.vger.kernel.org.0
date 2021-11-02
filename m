Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11754436B2
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 20:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhKBTxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 15:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230457AbhKBTxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 15:53:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B652A60F36;
        Tue,  2 Nov 2021 19:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635882659;
        bh=c9hhfZ7pJsNJTRQC1CnV6jtLswNwajKSEYsB9n9UuCc=;
        h=From:To:Cc:Subject:Date:From;
        b=HX4MLhZjIbIYfm0j+zDrt6oH8O5Qxvyrkkhd17h/UdTeOFptDm1Na8eF943M699uA
         WmSb0OKKCM2MLTDyAifABwb/Fyclzi08KpUdMPLFJWC9wZCCtZBMLFswb9b1sKtpQ1
         2Sr1ODYIB/8iQxRwmPrOVXV4Kq7d+hGG6bKq68xA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.77
Date:   Tue,  2 Nov 2021 20:50:52 +0100
Message-Id: <163588265215580@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.77 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 arch/arm/boot/compressed/decompress.c                     |    3 
 arch/arm/include/asm/uaccess.h                            |    4 
 arch/arm/kernel/vmlinux-xip.lds.S                         |    6 
 arch/arm/mm/proc-macros.S                                 |    1 
 arch/arm/probes/kprobes/core.c                            |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts   |    2 
 arch/arm64/lib/copy_from_user.S                           |   13 +
 arch/arm64/lib/copy_in_user.S                             |   21 +-
 arch/arm64/lib/copy_to_user.S                             |   14 +
 arch/nios2/platform/Kconfig.platform                      |    1 
 arch/powerpc/net/bpf_jit_comp64.c                         |   10 -
 arch/riscv/Kconfig                                        |    6 
 arch/riscv/include/asm/kasan.h                            |    3 
 arch/riscv/kernel/head.S                                  |    1 
 arch/riscv/mm/kasan_init.c                                |    3 
 arch/riscv/net/bpf_jit_core.c                             |    3 
 arch/s390/kvm/interrupt.c                                 |    5 
 arch/s390/kvm/kvm-s390.c                                  |    1 
 drivers/ata/sata_mv.c                                     |    4 
 drivers/base/regmap/regcache-rbtree.c                     |    7 
 drivers/gpio/gpio-xgs-iproc.c                             |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    2 
 drivers/gpu/drm/ttm/ttm_bo_util.c                         |    1 
 drivers/infiniband/core/sa_query.c                        |    5 
 drivers/infiniband/hw/hfi1/pio.c                          |    9 
 drivers/infiniband/hw/mlx5/qp.c                           |    2 
 drivers/infiniband/hw/qib/qib_user_sdma.c                 |   33 ++-
 drivers/mmc/host/cqhci.c                                  |    3 
 drivers/mmc/host/dw_mmc-exynos.c                          |   14 +
 drivers/mmc/host/mtk-sd.c                                 |   38 +--
 drivers/mmc/host/sdhci-esdhc-imx.c                        |   16 +
 drivers/mmc/host/sdhci.c                                  |    6 
 drivers/mmc/host/vub300.c                                 |   18 -
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |  138 ++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/pci.c                 |   25 +-
 drivers/net/ethernet/microchip/lan743x_main.c             |   88 +++++---
 drivers/net/ethernet/microchip/lan743x_main.h             |   20 +-
 drivers/net/ethernet/nxp/lpc_eth.c                        |    5 
 drivers/net/phy/mdio_bus.c                                |    1 
 drivers/net/phy/phy.c                                     |  140 ++++++++------
 drivers/net/usb/lan78xx.c                                 |    6 
 drivers/net/usb/usbnet.c                                  |    5 
 drivers/nfc/port100.c                                     |    4 
 drivers/nvme/host/tcp.c                                   |    9 
 drivers/nvme/target/tcp.c                                 |    2 
 drivers/pinctrl/bcm/pinctrl-ns.c                          |   29 +-
 drivers/pinctrl/pinctrl-amd.c                             |   31 +++
 drivers/reset/reset-brcmstb-rescal.c                      |    2 
 drivers/scsi/ufs/ufs-exynos.c                             |    6 
 fs/ext4/mmp.c                                             |   31 +--
 fs/ext4/super.c                                           |    6 
 fs/io_uring.c                                             |    2 
 fs/ocfs2/suballoc.c                                       |   22 +-
 include/linux/bpf.h                                       |    7 
 include/net/cfg80211.h                                    |    2 
 include/net/tls.h                                         |    9 
 kernel/bpf/arraymap.c                                     |    1 
 kernel/bpf/core.c                                         |   20 +-
 kernel/bpf/syscall.c                                      |   11 -
 kernel/cgroup/cgroup.c                                    |    4 
 mm/khugepaged.c                                           |    7 
 net/batman-adv/bridge_loop_avoidance.c                    |    8 
 net/batman-adv/main.c                                     |   56 ++++-
 net/batman-adv/network-coding.c                           |    4 
 net/batman-adv/translation-table.c                        |    4 
 net/core/dev.c                                            |    6 
 net/core/net-sysfs.c                                      |    4 
 net/ipv4/tcp_bpf.c                                        |   12 +
 net/sctp/sm_statefuns.c                                   |   67 +++---
 net/tipc/crypto.c                                         |   32 ++-
 net/tls/tls_sw.c                                          |   19 +
 net/wireless/core.c                                       |    2 
 net/wireless/core.h                                       |    2 
 net/wireless/mlme.c                                       |   26 +-
 net/wireless/scan.c                                       |    7 
 net/wireless/util.c                                       |   14 -
 tools/perf/builtin-script.c                               |   12 -
 78 files changed, 771 insertions(+), 398 deletions(-)

Alexandre Ghiti (1):
      riscv: Fix asan-stack clang build

Alexey Denisov (1):
      lan743x: fix endianness when accessing descriptors

Andrew Lunn (4):
      phy: phy_ethtool_ksettings_get: Lock the phy for consistency
      phy: phy_ethtool_ksettings_set: Move after phy_start_aneg
      phy: phy_start_aneg: Add an unlocked version
      phy: phy_ethtool_ksettings_set: Lock the PHY while changing settings

Arnd Bergmann (4):
      ARM: 9134/1: remove duplicate memcpy() definition
      ARM: 9138/1: fix link warning with XIP + frame-pointer
      ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype
      ARM: 9141/1: only warn about XIP address when not compile testing

Björn Töpel (1):
      riscv, bpf: Fix potential NULL dereference

Chanho Park (1):
      scsi: ufs: ufs-exynos: Correct timeout value setting registers

Chen Lu (1):
      riscv: fix misalgned trap vector base address

Christian König (1):
      drm/ttm: fix memleak in ttm_transfered_destroy

Clément Bœsch (1):
      arm64: dts: allwinner: h5: NanoPI Neo 2: Fix ethernet node

Daniel Jordan (2):
      net/tls: Fix flipped sign in tls_err_abort() calls
      net/tls: Fix flipped sign in async_wait.err assignment

Gautham Ananthakrishna (1):
      ocfs2: fix race between searching chunks and release journal_head from buffer_head

Greg Kroah-Hartman (1):
      Linux 5.10.77

Guenter Roeck (1):
      nios2: Make NIOS2_DTB_SOURCE_BOOL depend on !COMPILE_TEST

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit

Halil Pasic (2):
      KVM: s390: clear kicked_mask before sleeping again
      KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu

Ido Schimmel (1):
      mlxsw: pci: Recycle received packet upon allocation failure

Jaehoon Chung (1):
      mmc: dw_mmc: exynos: fix the finding clock sample value

Janusz Dziedzic (1):
      cfg80211: correct bridge/4addr mode check

Jim Quinlan (1):
      reset: brcmstb-rescal: fix incorrect polarity of status bit

Johan Hovold (2):
      mmc: vub300: fix control-message timeouts
      net: lan78xx: fix division by zero in send path

Johannes Berg (2):
      cfg80211: scan: fix RCU in cfg80211_add_nontrans_list()
      cfg80211: fix management registrations locking

Jonas Gorski (1):
      gpio: xgs-iproc: fix parsing of ngpios property

Krzysztof Kozlowski (1):
      nfc: port100: fix using -ERRNO as command type mask

Lexi Shao (1):
      ARM: 9132/1: Fix __get_user_check failure with ARM KASAN images

Liu Jian (1):
      tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function

Mark Zhang (1):
      RDMA/sa_query: Use strscpy_pad instead of memcpy to copy a string

Max VA (1):
      tipc: fix size validations for the MSG_CRYPTO type

Michael Chan (1):
      net: Prevent infinite while loop in skb_tx_hash()

Mike Marciniszyn (2):
      IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields
      IB/hfi1: Fix abba locking issue with sc_disable()

Naveen N. Rao (1):
      powerpc/bpf: Fix BPF_MOD when imm == 1

Nick Desaulniers (1):
      ARM: 9133/1: mm: proc-macros: ensure *_tlb_fns are 4B aligned

Oliver Neukum (1):
      usbnet: sanity check for maxpacket

Patrisious Haddad (1):
      RDMA/mlx5: Set user priority for DCT

Pavel Begunkov (1):
      io_uring: don't take uring_lock during iowq cancel

Pavel Skripkin (2):
      Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
      net: batman-adv: fix error handling

Quanyang Wang (1):
      cgroup: Fix memory leak caused by missing cgroup_bpf_offline

Rafał Miłecki (1):
      Revert "pinctrl: bcm: ns: support updated DT binding as syscon subnode"

Rakesh Babu (1):
      octeontx2-af: Display all enabled PF VF rsrc_alloc entries.

Robin Murphy (1):
      arm64: Avoid premature usercopy failure

Rongwei Wang (1):
      mm, thp: bail out early in collapse_file for writeback page

Sachi King (1):
      pinctrl: amd: disable and mask interrupts on probe

Sagi Grimberg (1):
      nvme-tcp: fix H2CData PDU send accounting (again)

Shawn Guo (1):
      mmc: sdhci: Map more voltage level to SDHCI_POWER_330

Song Liu (1):
      perf script: Check session->header.env.arch before using it

Thelford Williams (1):
      drm/amdgpu: fix out of bounds write

Theodore Ts'o (1):
      ext4: fix possible UAF when remounting r/o a mmp-protected file system

Toke Høiland-Jørgensen (1):
      bpf: Fix potential race in tail call compatibility check

Trevor Woerner (1):
      net: nxp: lpc_eth.c: avoid hang when bringing interface down

Varun Prakash (3):
      nvmet-tcp: fix data digest pointer calculation
      nvme-tcp: fix data digest pointer calculation
      nvme-tcp: fix possible req->offset corruption

Wang Hai (1):
      usbnet: fix error return code in usbnet_probe()

Wenbin Mei (2):
      mmc: cqhci: clear HALT state after CQE enable
      mmc: mediatek: Move cqhci init behind ungate clock

Xin Long (7):
      net-sysfs: initialize uid and gid before calling net_ns_get_ownership
      sctp: use init_tag from inithdr for ABORT chunk
      sctp: fix the processing for INIT_ACK chunk
      sctp: fix the processing for COOKIE_ECHO chunk
      sctp: add vtag check in sctp_sf_violation
      sctp: add vtag check in sctp_sf_do_8_5_1_E_sa
      sctp: add vtag check in sctp_sf_ootb

Xu Kuohai (1):
      bpf: Fix error usage of map_fd and fdget() in generic_map_update_batch()

Yang Yingliang (1):
      regmap: Fix possible double-free in regcache_rbtree_exit()

Yuiko Oshino (2):
      net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails
      net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent

Zheyu Ma (1):
      ata: sata_mv: Fix the error handling of mv_chip_id()

