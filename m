Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1C11DBA94
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 19:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgETREM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 13:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgETREM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 13:04:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33AE720708;
        Wed, 20 May 2020 17:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589994251;
        bh=x6ph2blM8CrMPdrhD9CGvqpMCXFA67HrYp1MWRHcf20=;
        h=Subject:To:Cc:From:Date:From;
        b=hZuLGDaJry6PJKB02sP1UkRkJ7FN26Kxl0SgELF+vgLCqU6wtr3Bjhc/t2Q3an/DN
         jNHEGrfhFyN61OLai1/oVxV9rqFwZdix+usmZodIsqedXoBrj2yNlhh4psT3bdQRI2
         +nJOFRjo4R+wFytshY7dsU8Y5/0YHZzEpyXXfWF8=
Subject: Linux 4.19.124
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed, 20 May 2020 19:03:42 +0200
Message-ID: <158999422211020@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.124 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |   23 +++--
 arch/arm/boot/dts/dra7.dtsi                       |    4 -
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts  |    4 -
 arch/arm/boot/dts/r8a73a4.dtsi                    |    9 ++
 arch/arm/boot/dts/r8a7740.dtsi                    |    2 
 arch/arm64/boot/dts/renesas/r8a77980.dtsi         |    2 
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts       |    2 
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts    |    2 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi          |    4 -
 arch/arm64/kernel/machine_kexec.c                 |    1 
 arch/riscv/kernel/vdso/Makefile                   |    6 -
 arch/x86/include/asm/stackprotector.h             |    7 +
 arch/x86/kernel/smpboot.c                         |    8 ++
 arch/x86/kernel/unwind_orc.c                      |   16 ++--
 arch/x86/kvm/x86.c                                |    2 
 arch/x86/xen/smp_pv.c                             |    1 
 crypto/lrw.c                                      |    4 -
 crypto/xts.c                                      |    4 -
 drivers/block/virtio_blk.c                        |   86 +++++++++++++++++++---
 drivers/clk/clk.c                                 |    3 
 drivers/clk/rockchip/clk-rk3228.c                 |   17 +---
 drivers/cpufreq/intel_pstate.c                    |    2 
 drivers/dma/mmp_tdma.c                            |    2 
 drivers/dma/pch_dma.c                             |    2 
 drivers/gpu/drm/qxl/qxl_image.c                   |    3 
 drivers/hwmon/da9052-hwmon.c                      |    4 -
 drivers/infiniband/hw/i40iw/i40iw_hw.c            |    2 
 drivers/infiniband/hw/mlx4/qp.c                   |   14 ++-
 drivers/mmc/core/block.c                          |    3 
 drivers/mmc/core/queue.c                          |    3 
 drivers/mmc/host/sdhci-acpi.c                     |   10 +-
 drivers/net/dsa/dsa_loop.c                        |    1 
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c |   16 +++-
 drivers/net/ethernet/huawei/hinic/hinic_main.c    |   16 ----
 drivers/net/ethernet/moxa/moxart_ether.c          |    2 
 drivers/net/ethernet/natsemi/jazzsonic.c          |    6 +
 drivers/net/phy/phy.c                             |    8 +-
 drivers/net/ppp/pppoe.c                           |    3 
 drivers/net/virtio_net.c                          |    6 +
 drivers/pinctrl/intel/pinctrl-baytrail.c          |    1 
 drivers/pinctrl/intel/pinctrl-cherryview.c        |    4 +
 drivers/scsi/sg.c                                 |    4 -
 drivers/usb/core/hub.c                            |    6 +
 drivers/usb/dwc3/gadget.c                         |    3 
 drivers/usb/gadget/configfs.c                     |    3 
 drivers/usb/gadget/legacy/audio.c                 |    4 -
 drivers/usb/gadget/legacy/cdc2.c                  |    4 -
 drivers/usb/gadget/legacy/ncm.c                   |    4 -
 drivers/usb/gadget/udc/net2272.c                  |    2 
 drivers/usb/host/xhci-plat.c                      |    4 -
 drivers/usb/host/xhci-ring.c                      |    4 -
 fs/cifs/cifssmb.c                                 |    2 
 fs/exec.c                                         |    4 -
 fs/gfs2/bmap.c                                    |   16 ++--
 fs/nfs/fscache-index.c                            |    6 +
 fs/nfs/fscache.c                                  |   31 ++++---
 fs/nfs/fscache.h                                  |    8 +-
 include/linux/compiler.h                          |    6 +
 include/linux/fs.h                                |    2 
 include/linux/pnp.h                               |   29 ++-----
 include/linux/tty.h                               |    2 
 include/net/netfilter/nf_conntrack.h              |    2 
 include/net/tcp.h                                 |   13 +++
 include/sound/rawmidi.h                           |    1 
 init/main.c                                       |    2 
 ipc/util.c                                        |   12 +--
 mm/shmem.c                                        |    7 +
 net/core/dev.c                                    |    4 -
 net/core/drop_monitor.c                           |   11 +-
 net/core/netprio_cgroup.c                         |    2 
 net/dsa/dsa2.c                                    |    2 
 net/ipv4/cipso_ipv4.c                             |    6 +
 net/ipv4/route.c                                  |    2 
 net/ipv4/tcp.c                                    |   27 ++++--
 net/ipv4/tcp_input.c                              |    3 
 net/ipv6/calipso.c                                |    3 
 net/ipv6/route.c                                  |    6 +
 net/netfilter/nf_conntrack_core.c                 |    4 -
 net/netfilter/nft_set_rbtree.c                    |   17 ++--
 net/netlabel/netlabel_kapi.c                      |    6 +
 sound/core/rawmidi.c                              |   31 ++++++-
 sound/pci/hda/patch_hdmi.c                        |    2 
 sound/pci/hda/patch_realtek.c                     |   28 ++++++-
 sound/usb/quirks.c                                |    9 +-
 84 files changed, 451 insertions(+), 208 deletions(-)

Adam McCoy (1):
      cifs: fix leaked reference on requeued write

Adrian Hunter (1):
      mmc: block: Fix request completion in the CQE timeout path

Andreas Gruenbacher (1):
      gfs2: Another gfs2_walk_metadata fix

Andy Shevchenko (1):
      pinctrl: baytrail: Enable pin configuration setting for GPIO chip

Arnd Bergmann (3):
      drop_monitor: work around gcc-10 stringop-overflow warning
      nfs: fscache: use timespec64 in inode auxdata
      netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Borislav Petkov (1):
      x86: Fix early boot crash on gcc-10, third try

Chen-Yu Tsai (2):
      arm64: dts: rockchip: Replace RK805 PMIC node name with "pmic" on rk3328 boards
      arm64: dts: rockchip: Rename dwc3 device nodes on rk3399 to make dtc happy

Chris Wilson (1):
      cpufreq: intel_pstate: Only mention the BIOS disabling turbo mode once

Christoph Hellwig (1):
      arm64: fix the flush_icache_range arguments in machine_kexec

Christophe JAILLET (4):
      net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'
      net: moxa: Fix a potential double 'free_irq()'
      usb: gadget: net2272: Fix a memory leak in an error handling path in 'net2272_plat_probe()'
      usb: gadget: audio: Fix a missing error return value in audio_bind()

Cong Wang (1):
      net: fix a potential recursive NETDEV_FEAT_CHANGE

Dan Carpenter (1):
      i40iw: Fix error handling in i40iw_manage_arp_cache()

Dave Wysochanski (2):
      NFS: Fix fscache super_cookie index_key from changing after umount
      NFSv4: Fix fscache cookie aux_data to ensure change_attr is included

Eric Dumazet (2):
      tcp: fix error recovery in tcp_zerocopy_receive()
      tcp: fix SO_RCVLOWAT hangs with fat skbs

Eric W. Biederman (1):
      exec: Move would_dump into flush_old_exec

Eugeniu Rosca (1):
      usb: core: hub: limit HUB_QUIRK_DISABLE_AUTOSUSPEND to USB5534B

Fabio Estevam (1):
      ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries

Florian Fainelli (2):
      net: dsa: Do not make user port errors fatal
      net: dsa: loop: Add module soft dependency

Geert Uytterhoeven (2):
      ARM: dts: r8a73a4: Add missing CMT1 interrupts
      ARM: dts: r8a7740: Add missing extal2 to CPG node

Grace Kao (1):
      pinctrl: cherryview: Add missing spinlock usage in chv_gpio_irq_handler

Greg Kroah-Hartman (1):
      Linux 4.19.124

Guillaume Nault (1):
      pppoe: only process PADT targeted at local interfaces

Heiner Kallweit (1):
      net: phy: fix aneg restart in phy_ethtool_set_eee

Hugh Dickins (1):
      shmem: fix possible deadlocks on shmlock_user_lock

Ilie Halip (1):
      riscv: fix vdso build with lld

Jack Morgenstein (1):
      IB/mlx4: Test return value of calls to ib_get_cached_pkey

Jason Gunthorpe (1):
      pnp: Use list_for_each_entry() instead of open coding

Jesus Ramos (1):
      ALSA: usb-audio: Add control message quirk delay for Kingston HyperX headset

Jim Mattson (1):
      KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

John Stultz (1):
      dwc3: Remove check for HWO flag in dwc3_gadget_ep_reclaim_trb_sg()

Josh Poimboeuf (1):
      x86/unwind/orc: Fix error handling in __unwind_start()

Justin Swartz (1):
      clk: rockchip: fix incorrect configuration of rk3228 aclk_gpu* clocks

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix race in monitor detection during probe

Kai-Heng Feng (2):
      ALSA: hda/realtek - Fix S3 pop noise on Dell Wyse
      Revert "ALSA: hda/realtek: Fix pop noise on ALC225"

Kelly Littlepage (1):
      net: tcp: fix rx timestamp behavior for tcp_recvmsg

Kishon Vijay Abraham I (1):
      ARM: dts: dra7: Fix bus_dma_limit for PCIe

Kyungtae Kim (1):
      USB: gadget: fix illegal array access in binding with UDC

Li Jun (1):
      usb: host: xhci-plat: keep runtime active when removing host

Linus Torvalds (7):
      gcc-10 warnings: fix low-hanging fruit
      Stop the ad-hoc games with -Wno-maybe-initialized
      gcc-10: disable 'zero-length-bounds' warning for now
      gcc-10: disable 'array-bounds' warning for now
      gcc-10: disable 'stringop-overflow' warning for now
      gcc-10: disable 'restrict' warning for now
      gcc-10: avoid shadowing standard library 'free()' in crypto

Lubomir Rintel (1):
      dmaengine: mmp_tdma: Reset channel error on release

Luo bin (1):
      hinic: fix a bug of ndo_stop

Maciej Żenczykowski (1):
      Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"

Madhuparna Bhowmik (1):
      dmaengine: pch_dma.c: Avoid data race between probe and irq handler

Marc Zyngier (1):
      clk: Unlink clock if failed to prepare or enable

Masahiro Yamada (1):
      kbuild: compute false-positive -Wmaybe-uninitialized cases in Kconfig

Michael S. Tsirkin (1):
      virtio_net: fix lockdep warning on 32 bit

Paolo Abeni (2):
      netlabel: cope with NULL catmap
      net: ipv4: really enforce backoff for redirects

Raul E Rangel (1):
      mmc: sdhci-acpi: Add SDHCI_QUIRK2_BROKEN_64_BIT_DMA for AMDI0040

Samu Nuutamo (1):
      hwmon: (da9052) Synchronize access with mfd

Sergei Trofimovich (1):
      Makefile: disallow data races on gcc-10 as well

Sriharsha Allenki (1):
      usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list

Stefan Hajnoczi (1):
      virtio-blk: handle block_device_operations callbacks after hot unplug

Stefano Brivio (1):
      netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()

Takashi Iwai (2):
      ALSA: hda/realtek - Limit int mic boost for Thinkpad T530
      ALSA: rawmidi: Fix racy buffer resize under concurrent accesses

Vasily Averin (2):
      drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()
      ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Veerabhadrarao Badiganti (1):
      mmc: core: Check request type before completing the request

Wei Yongjun (2):
      usb: gadget: legacy: fix error return code in gncm_bind()
      usb: gadget: legacy: fix error return code in cdc_bind()

Wu Bo (1):
      scsi: sg: add sg_remove_request in sg_write

Yoshihiro Shimoda (1):
      arm64: dts: renesas: r8a77980: Fix IPMMU VIP[01] nodes

Zefan Li (1):
      netprio_cgroup: Fix unlimited memory leak of v2 cgroups

