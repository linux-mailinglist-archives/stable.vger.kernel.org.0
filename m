Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81DA2A02D2
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 11:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgJ3K2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 06:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgJ3K2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 06:28:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E094E20704;
        Fri, 30 Oct 2020 10:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604053688;
        bh=kdv1OM3Ft/tsgGwP4y0onEg+PAv9jxxpv8O/1I6NnNo=;
        h=From:To:Cc:Subject:Date:From;
        b=lgwkfHY5+SgZfOTgC448lpTrfcv11epk0oqeEUGNI8xNUPkRhrxLR1kc8H1stN7bw
         n2V504eK4FCnkR9GNuYTxykzGSWk1y6t/78ZgcvzkXIG1aOA145hfu0t40JXWweVoS
         ASilGfQkof0OmWFgw+x1uDKNAmMdBiRtOvGEQPJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.154
Date:   Fri, 30 Oct 2020 11:28:53 +0100
Message-Id: <160405368022942@kroah.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.154 kernel.

All users of the 4.19 kernel series must upgrade.

Many thanks to Pavel Machek for pointing out that the last 4.19.y
release was "short" a bunch of patches, which results in this "the rest
of the series" release.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/boot/dts/imx6sl.dtsi                                  |    2 
 arch/arm/boot/dts/owl-s500.dtsi                                |    6 
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts              |   10 -
 arch/arm64/boot/dts/qcom/msm8916.dtsi                          |    4 
 arch/arm64/boot/dts/qcom/pm8916.dtsi                           |    2 
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi                         |    4 
 arch/powerpc/include/asm/tlb.h                                 |   13 -
 arch/powerpc/kernel/tau_6xx.c                                  |   96 +++-------
 arch/powerpc/mm/tlb-radix.c                                    |   23 +-
 arch/powerpc/perf/hv-gpci-requests.h                           |    6 
 arch/powerpc/perf/isa207-common.c                              |   10 +
 arch/powerpc/platforms/Kconfig                                 |   14 -
 arch/powerpc/platforms/powernv/opal-dump.c                     |   41 +++-
 arch/x86/kvm/emulate.c                                         |    2 
 block/blk-core.c                                               |    9 
 drivers/clk/at91/clk-main.c                                    |   11 -
 drivers/clk/bcm/clk-bcm2835.c                                  |    4 
 drivers/clk/rockchip/clk-half-divider.c                        |    2 
 drivers/cpufreq/powernv-cpufreq.c                              |    9 
 drivers/crypto/ccp/ccp-ops.c                                   |    2 
 drivers/gpu/drm/virtio/virtgpu_kms.c                           |    2 
 drivers/gpu/drm/virtio/virtgpu_vq.c                            |   10 -
 drivers/i2c/busses/Kconfig                                     |    1 
 drivers/i2c/i2c-core-acpi.c                                    |   11 +
 drivers/infiniband/core/cma.c                                  |   84 +++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c                     |    1 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                     |    1 
 drivers/infiniband/sw/rdmavt/vt.c                              |    4 
 drivers/input/keyboard/ep93xx_keypad.c                         |    4 
 drivers/input/keyboard/omap4-keypad.c                          |    6 
 drivers/input/keyboard/twl4030_keypad.c                        |    8 
 drivers/input/serio/sun4i-ps2.c                                |    9 
 drivers/input/touchscreen/imx6ul_tsc.c                         |   27 +-
 drivers/input/touchscreen/stmfts.c                             |    2 
 drivers/mailbox/mailbox.c                                      |   12 -
 drivers/media/firewire/firedtv-fw.c                            |    6 
 drivers/media/pci/bt8xx/bttv-driver.c                          |   13 +
 drivers/media/pci/saa7134/saa7134-tvaudio.c                    |    3 
 drivers/media/platform/exynos4-is/fimc-isp.c                   |    4 
 drivers/media/platform/exynos4-is/fimc-lite.c                  |    2 
 drivers/media/platform/exynos4-is/media-dev.c                  |    4 
 drivers/media/platform/exynos4-is/mipi-csis.c                  |    4 
 drivers/media/platform/qcom/venus/core.c                       |    5 
 drivers/media/platform/s3c-camif/camif-core.c                  |    5 
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                  |    3 
 drivers/media/platform/sti/delta/delta-v4l2.c                  |    4 
 drivers/media/platform/sti/hva/hva-hw.c                        |    4 
 drivers/media/platform/vsp1/vsp1_drv.c                         |   11 -
 drivers/media/rc/ati_remote.c                                  |    4 
 drivers/media/usb/uvc/uvc_v4l2.c                               |   30 +++
 drivers/memory/fsl-corenet-cf.c                                |    6 
 drivers/memory/omap-gpmc.c                                     |    8 
 drivers/misc/cardreader/rtsx_pcr.c                             |    4 
 drivers/misc/eeprom/at25.c                                     |    2 
 drivers/misc/mic/vop/vop_main.c                                |    2 
 drivers/misc/mic/vop/vop_vringh.c                              |   24 +-
 drivers/mmc/core/sdio_cis.c                                    |    3 
 drivers/net/can/flexcan.c                                      |   34 ++-
 drivers/net/ethernet/korina.c                                  |    4 
 drivers/net/wireless/ath/ath10k/htt_rx.c                       |    8 
 drivers/net/wireless/ath/ath9k/hif_usb.c                       |   19 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c      |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c |    4 
 drivers/net/wireless/marvell/mwifiex/usb.c                     |    3 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c          |   10 -
 drivers/ntb/hw/amd/ntb_hw_amd.c                                |    1 
 drivers/nvme/target/core.c                                     |    3 
 drivers/pci/controller/pcie-iproc-msi.c                        |   13 -
 drivers/pwm/pwm-img.c                                          |    3 
 drivers/rapidio/devices/rio_mport_cdev.c                       |   18 +
 drivers/rpmsg/qcom_smd.c                                       |   32 ++-
 drivers/scsi/ibmvscsi/ibmvfc.c                                 |    1 
 drivers/scsi/mvumi.c                                           |    1 
 drivers/scsi/qedi/qedi_fw.c                                    |   23 +-
 drivers/scsi/qedi/qedi_iscsi.c                                 |    2 
 drivers/scsi/ufs/ufs-qcom.c                                    |    5 
 drivers/tty/ipwireless/network.c                               |    4 
 drivers/tty/ipwireless/tty.c                                   |    2 
 drivers/tty/serial/fsl_lpuart.c                                |    2 
 drivers/usb/class/cdc-acm.c                                    |   23 ++
 drivers/usb/class/cdc-wdm.c                                    |   72 +++++--
 drivers/usb/core/urb.c                                         |   89 +++++----
 drivers/usb/dwc3/dwc3-of-simple.c                              |    1 
 drivers/usb/gadget/function/f_ncm.c                            |    2 
 drivers/usb/gadget/function/f_printer.c                        |   16 +
 drivers/usb/host/ohci-hcd.c                                    |   16 +
 drivers/vfio/pci/vfio_pci_intrs.c                              |    4 
 drivers/vfio/vfio_iommu_type1.c                                |    3 
 drivers/watchdog/sp5100_tco.h                                  |    2 
 drivers/watchdog/watchdog_dev.c                                |    6 
 fs/dlm/config.c                                                |    3 
 fs/ext4/fsmap.c                                                |    3 
 fs/f2fs/sysfs.c                                                |    1 
 fs/ntfs/inode.c                                                |    6 
 fs/ramfs/file-nommu.c                                          |    2 
 fs/reiserfs/inode.c                                            |    3 
 fs/reiserfs/super.c                                            |    8 
 fs/udf/inode.c                                                 |   25 +-
 fs/udf/super.c                                                 |    6 
 fs/xfs/xfs_rtalloc.c                                           |   11 +
 include/linux/overflow.h                                       |    1 
 include/scsi/scsi_common.h                                     |    7 
 include/trace/events/target.h                                  |   12 -
 include/uapi/linux/perf_event.h                                |    2 
 kernel/debug/kdb/kdb_io.c                                      |    8 
 kernel/power/hibernate.c                                       |   11 -
 kernel/sched/core.c                                            |    2 
 kernel/sched/sched.h                                           |   13 +
 lib/crc32.c                                                    |    2 
 net/bluetooth/l2cap_sock.c                                     |    7 
 net/ipv4/ip_gre.c                                              |   15 +
 net/mac80211/cfg.c                                             |    3 
 net/mac80211/sta_info.c                                        |    4 
 net/netfilter/ipvs/ip_vs_ctl.c                                 |    7 
 net/netfilter/nf_conntrack_proto_tcp.c                         |   19 +
 net/netfilter/nf_dup_netdev.c                                  |    1 
 net/netfilter/nft_fwd_netdev.c                                 |    1 
 net/sunrpc/auth_gss/svcauth_gss.c                              |   27 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c                          |    3 
 samples/mic/mpssd/mpssd.c                                      |    4 
 tools/perf/util/intel-pt.c                                     |    8 
 122 files changed, 808 insertions(+), 450 deletions(-)

Abhishek Pandit-Subedi (1):
      Bluetooth: Only mark socket zapped after unlocking

Adam Goode (1):
      media: uvcvideo: Ensure all probed info is returned to v4l2

Aditya Pakki (1):
      media: st-delta: Fix reference count leak in delta_run_work

Adrian Hunter (1):
      perf intel-pt: Fix "context_switch event has no tid" error

Al Grant (1):
      perf: correct SNOOPX field offset

Alex Williamson (1):
      vfio/pci: Clear token on bypass registration failure

Alexander Aring (1):
      fs: dlm: fix configfs memory leak

Athira Rajeev (1):
      powerpc/perf: Exclude pmc5/6 from the irrelevant PMU group constraints

Brooke Basile (1):
      ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()

Can Guo (1):
      scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()

Chris Chiu (1):
      rtl8xxxu: prevent potential memory leak

Christian Eggers (1):
      eeprom: at25: set minimum read/write access stride to 1

Christoph Hellwig (1):
      PM: hibernate: remove the bogus call to get_gendisk() in software_resume()

Claudiu Beznea (1):
      clk: at91: clk-main: update key before writing AT91_CKGR_MOR

Colin Ian King (1):
      IB/rdmavt: Fix sizeof mismatch

Cong Wang (1):
      ip_gre: set dev->hard_header_len and dev->needed_headroom properly

Cristian Ciocaltea (1):
      ARM: dts: owl-s500: Fix incorrect PPI interrupt specifiers

Dan Aloni (1):
      svcrdma: fix bounce buffers for unaligned offsets and multiple pages

Dan Carpenter (3):
      rpmsg: smd: Fix a kobj leak in in qcom_smd_parse_edge()
      Input: imx6ul_tsc - clean up some errors in imx6ul_tsc_resume()
      memory: omap-gpmc: Fix a couple off by ones

Daniel Thompson (1):
      kdb: Fix pager search for multi-line strings

Darrick J. Wong (2):
      ext4: limit entries returned when counting fsmap records
      xfs: make sure the rt allocator doesn't run off the end

Dinghao Liu (7):
      watchdog: Fix memleak in watchdog_cdev_register
      watchdog: Use put_device on error
      media: vsp1: Fix runtime PM imbalance on error
      media: platform: s3c-camif: Fix runtime PM imbalance on error
      media: platform: sti: hva: Fix runtime PM imbalance on error
      media: bdisp: Fix runtime PM imbalance on error
      media: venus: core: Fix runtime PM imbalance in venus_probe

Dirk Behme (1):
      i2c: rcar: Auto select RESET_CONTROLLER

Doug Horn (1):
      Fix use after free in get_capset_info callback.

Eli Billauer (1):
      usb: core: Solve race condition in anchor cleanup functions

Eric Biggers (1):
      reiserfs: only call unlock_new_inode() if I_NEW

Finn Thain (2):
      powerpc/tau: Check processor type before enabling TAU interrupt
      powerpc/tau: Disable TAU between measurements

Francesco Ruggeri (1):
      netfilter: conntrack: connection timeout after re-register

Greg Kroah-Hartman (1):
      Linux 4.19.154

Guenter Roeck (1):
      watchdog: sp5100: Fix definition of EFCH_PM_DECODEEN3

Hamish Martin (1):
      usb: ohci: Default to per-port over-current protection

Hans de Goede (1):
      i2c: core: Restore acpi_walk_dep_device_list() getting called after registering the ACPI i2c devs

Hauke Mehrtens (1):
      pwm: img: Fix null pointer access in probe

Horia Geantă (1):
      ARM: dts: imx6sl: fix rng node

Jamie Iles (1):
      f2fs: wait for sysfs kobject removal before freeing f2fs_sb_info

Jan Kara (3):
      udf: Limit sparing table size
      udf: Avoid accessing uninitialized data on failed inode read
      reiserfs: Fix memory leak in reiserfs_parse_options()

Jason Gunthorpe (2):
      RDMA/cma: Remove dead code for kernel rdmacm multicast
      RDMA/cma: Consolidate the destruction of a cma_multicast in one place

Jassi Brar (1):
      mailbox: avoid timer start from callback

Jernej Skrabec (1):
      ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix dcdc1 regulator

Jing Xiangfeng (3):
      rapidio: fix the missed put_device() for rio_mport_add_riodev
      scsi: mvumi: Fix error return in mvumi_io_attach()
      scsi: ibmvfc: Fix error return in ibmvfc_probe()

Joakim Zhang (1):
      can: flexcan: flexcan_chip_stop(): add error handling and propagate error value

Johan Hovold (1):
      USB: cdc-acm: handle broken union descriptors

Juri Lelli (1):
      sched/features: Fix !CONFIG_JUMP_LABEL case

Kaige Li (1):
      NTB: hw: amd: fix an issue about leak system resources

Kajol Jain (1):
      powerpc/perf/hv-gpci: Fix starting index value

Keita Suzuki (2):
      misc: rtsx: Fix memory leak in rtsx_pci_probe
      brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

Krzysztof Kozlowski (5):
      Input: ep93xx_keypad - fix handling of platform_get_irq() error
      Input: omap4-keypad - fix handling of platform_get_irq() error
      Input: twl4030_keypad - fix handling of platform_get_irq() error
      Input: sun4i-ps2 - fix handling of platform_get_irq() error
      memory: fsl-corenet-cf: Fix handling of platform_get_irq() error

Leon Romanovsky (1):
      overflow: Include header file with SIZE_MAX declaration

Lijun Ou (1):
      RDMA/hns: Set the unsupported wr opcode

Lorenzo Colitti (1):
      usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.

Mark Tomlinson (1):
      PCI: iproc: Set affinity mask on MSI interrupts

Martijn de Gouw (1):
      SUNRPC: fix copying of multiple pages in gss_read_proxy_verf()

Matthew Wilcox (Oracle) (1):
      ramfs: fix nommu mmap with gaps in the page cache

Mauro Carvalho Chehab (2):
      media: saa7134: avoid a shift overflow
      usb: dwc3: simple: add support for Hikey 970

Michal Simek (1):
      arm64: dts: zynqmp: Remove additional compatible string for i2c IPs

Navid Emamdoost (1):
      clk: bcm2835: add missing release if devm_clk_hw_register fails

Nicholas Piggin (1):
      powerpc/64s/radix: Fix mm_cpumask trimming race vs kthread_use_mm

Nilesh Javali (2):
      scsi: qedi: Protect active command list to avoid list corruption
      scsi: qedi: Fix list_del corruption while removing active I/O

Oliver Neukum (2):
      media: ati_remote: sanity check for both endpoints
      USB: cdc-wdm: Make wdm_flush() interruptible and add wdm_fsync().

Pablo Neira Ayuso (1):
      netfilter: nf_fwd_netdev: clear timestamp in forwarding path

Pali Rohár (1):
      mmc: sdio: Check for CISTPL_VERS_1 buffer size

Pavel Machek (2):
      crypto: ccp - fix error handling
      media: firewire: fix memory leak

Peilin Ye (1):
      ipvs: Fix uninit-value in do_ip_vs_set_ctl()

Peng Fan (1):
      tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

Qiushi Wu (4):
      media: sti: Fix reference count leaks
      media: exynos4-is: Fix several reference count leaks due to pm_runtime_get_sync
      media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync
      media: exynos4-is: Fix a reference count leak

Robert Hoo (1):
      KVM: x86: emulating RDPID failure shall return #UD rather than #GP

Roman Bolshakov (1):
      scsi: target: core: Add CONTROL field for trace events

Rustam Kovhaev (1):
      ntfs: add check for mft record size in superblock

Sherry Sun (2):
      mic: vop: copy data to kernel space then write to io memory
      misc: vop: add round_up(x,4) for vring_size to avoid kernel panic

Souptick Joarder (1):
      rapidio: fix error handling path

Srikar Dronamraju (1):
      cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_reboot_notifier

Stephan Gerhold (2):
      arm64: dts: qcom: pm8916: Remove invalid reg size from wcd_codec
      arm64: dts: qcom: msm8916: Fix MDP/DSI interrupts

Stephen Boyd (1):
      clk: rockchip: Initialize hw to error to avoid undefined behavior

Tetsuo Handa (2):
      block: ratelimit handle_bad_sector() message
      mwifiex: don't call del_timer_sync() on uninitialized timer

Thomas Pedersen (1):
      mac80211: handle lack of sband->bitrates in rates

Tobias Jordan (1):
      lib/crc32.c: fix trivial typo in preprocessor condition

Tong Zhang (1):
      tty: ipwireless: fix error handling

Valentin Vidic (1):
      net: korina: cast KSEG0 address to pointer in kfree

Vasant Hegde (1):
      powerpc/powernv/dump: Fix race while processing OPAL dump

Vincent Mailhol (1):
      usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

Wang Yufen (1):
      brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

Weihang Li (1):
      RDMA/hns: Fix missing sq_sig_type when querying QP

Xiaolong Huang (1):
      media: media/pci: prevent memory leak in bttv_probe

Xiaoyang Xu (1):
      vfio iommu type1: Fix memory leak in vfio_iommu_type1_pin_pages

YueHaibing (2):
      Input: stmfts - fix a & vs && typo
      memory: omap-gpmc: Fix build error without CONFIG_OF

Zekun Shen (1):
      ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

Zqiang (1):
      usb: gadget: function: printer: fix use-after-free in __lock_acquire

zhenwei pi (1):
      nvmet: fix uninitialized work for zero kato

