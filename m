Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B22481252
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbhL2LyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:54:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45518 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbhL2LyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:54:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE1A614A4;
        Wed, 29 Dec 2021 11:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007FAC36AE7;
        Wed, 29 Dec 2021 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640778860;
        bh=LR8jabQjR9lrgrvRPIunpDc86feWQUIh8scnS1NoGcY=;
        h=From:To:Cc:Subject:Date:From;
        b=NOkHxlEA5NrbVO5HzKjJKZhWwB+G7ZY/5UW2D74VG6CklDFtYOIK7OnMHNjjDwgSz
         sL+hM8HyiF/4cgzPDtNz8YOz5z/kFg6jxF7c1Rjiti796UwC9wSBrtbGRafuIagvTe
         bufNHR+hy3bqtiXionMJQGvh1RKN1OCV+VBCEpDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.89
Date:   Wed, 29 Dec 2021 12:54:16 +0100
Message-Id: <1640778856117230@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.89 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                |    8 
 Documentation/hwmon/lm90.rst                                   |   10 
 Documentation/networking/bonding.rst                           |   11 
 Documentation/sound/hd-audio/models.rst                        |    2 
 Makefile                                                       |    2 
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi                       |    1 
 arch/arm/kernel/entry-armv.S                                   |    8 
 arch/arm64/Kconfig                                             |    3 
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts |    2 
 arch/arm64/kernel/vdso32/Makefile                              |   25 -
 arch/parisc/include/asm/futex.h                                |    4 
 arch/parisc/kernel/syscall.S                                   |    2 
 arch/x86/include/asm/pgtable.h                                 |    4 
 arch/x86/kvm/vmx/vmx.c                                         |    3 
 drivers/char/ipmi/ipmi_msghandler.c                            |   21 -
 drivers/char/ipmi/ipmi_ssif.c                                  |    7 
 drivers/gpio/gpio-dln2.c                                       |   19 -
 drivers/hid/hid-holtek-mouse.c                                 |   15 
 drivers/hid/hid-vivaldi.c                                      |    3 
 drivers/hwmon/Kconfig                                          |    2 
 drivers/hwmon/lm90.c                                           |  171 ++++++----
 drivers/infiniband/hw/hns/hns_roce_srq.c                       |    2 
 drivers/infiniband/hw/qib/qib_user_sdma.c                      |    2 
 drivers/input/mouse/elantech.c                                 |    8 
 drivers/input/touchscreen/atmel_mxt_ts.c                       |    2 
 drivers/input/touchscreen/elants_i2c.c                         |   46 ++
 drivers/input/touchscreen/goodix.c                             |    1 
 drivers/mmc/core/core.c                                        |    7 
 drivers/mmc/core/core.h                                        |    1 
 drivers/mmc/core/host.c                                        |    9 
 drivers/mmc/host/meson-mx-sdhc-mmc.c                           |   16 
 drivers/mmc/host/mmci_stm32_sdmmc.c                            |    2 
 drivers/mmc/host/sdhci-tegra.c                                 |   43 +-
 drivers/net/bonding/bond_options.c                             |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                      |   19 -
 drivers/net/ethernet/marvell/prestera/prestera_main.c          |   16 
 drivers/net/ethernet/micrel/ks8851_par.c                       |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h              |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c       |   12 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c           |    4 
 drivers/net/ethernet/sfc/falcon/rx.c                           |    5 
 drivers/net/ethernet/sfc/rx_common.c                           |    5 
 drivers/net/ethernet/smsc/smc911x.c                            |    5 
 drivers/net/fjes/fjes_main.c                                   |    5 
 drivers/net/hamradio/mkiss.c                                   |    5 
 drivers/net/usb/lan78xx.c                                      |    6 
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                          |   29 -
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c               |    8 
 drivers/pinctrl/stm32/pinctrl-stm32.c                          |    8 
 drivers/platform/x86/intel_pmc_core_pltdrv.c                   |    2 
 drivers/spi/spi-armada-3700.c                                  |    2 
 drivers/tee/optee/shm_pool.c                                   |    6 
 drivers/tee/tee_shm.c                                          |  171 +++-------
 drivers/usb/gadget/function/u_ether.c                          |   15 
 fs/ceph/file.c                                                 |   18 -
 fs/ext4/extents.c                                              |   93 +++--
 fs/f2fs/xattr.c                                                |   11 
 include/linux/tee_drv.h                                        |    4 
 include/linux/virtio_net.h                                     |   25 +
 mm/memory-failure.c                                            |    1 
 mm/mempolicy.c                                                 |    4 
 net/ax25/af_ax25.c                                             |    4 
 net/mac80211/cfg.c                                             |    3 
 net/netfilter/nfnetlink_log.c                                  |    3 
 net/netfilter/nfnetlink_queue.c                                |    3 
 net/phonet/pep.c                                               |    2 
 sound/core/jack.c                                              |    4 
 sound/drivers/opl3/opl3_midi.c                                 |    2 
 sound/pci/hda/patch_realtek.c                                  |   28 +
 sound/soc/codecs/rt5682.c                                      |    4 
 sound/soc/codecs/tas2770.c                                     |    4 
 sound/soc/meson/aiu-encoder-i2s.c                              |   33 -
 sound/soc/meson/aiu-fifo-i2s.c                                 |   19 +
 sound/soc/meson/aiu-fifo.c                                     |    6 
 74 files changed, 669 insertions(+), 393 deletions(-)

Andrea Righi (1):
      Input: elantech - fix stack out of bound access in elantech_change_report_id()

Andrew Cooper (1):
      x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

Andrey Ryabinin (1):
      mm: mempolicy: fix THP allocations escaping mempolicy restrictions

Ard Biesheuvel (1):
      ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling

Benjamin Tissoires (1):
      HID: holtek: fix mouse probing

Bradley Scott (2):
      ALSA: hda/realtek: Amp init fixup for HP ZBook 15 G6
      ALSA: hda/realtek: Add new alc285-hp-amp-init model

Chao Yu (1):
      f2fs: fix to do sanity check on last xattr entry in __f2fs_setxattr()

Christian Brauner (1):
      ceph: fix up non-directory creation in SGID directories

Colin Ian King (1):
      ALSA: drivers: opl3: Fix incorrect use of vp->state

Derek Fang (1):
      ASoC: rt5682: fix the wrong jack type detected

Dongliang Mu (1):
      spi: change clk_disable_unprepare to clk_unprepare

Fabien Dessenne (1):
      pinctrl: stm32: consider the GPIO offset to expose all the GPIO lines

Fernando Fernandez Mancera (1):
      bonding: fix ad_actor_system option setting to default

Greg Jesionowski (1):
      net: usb: lan78xx: add Allied Telesis AT29M2-AF

Greg Kroah-Hartman (1):
      Linux 5.10.89

Guenter Roeck (6):
      hwmon: (lm90) Fix usage of CONFIG2 register in detect function
      hwmon: (lm90) Add basic support for TI TMP461
      hwmon: (lm90) Introduce flag indicating extended temperature support
      hwmon: (lm90) Drop critical attribute support for MAX6654
      hwmom: (lm90) Fix citical alarm status for MAX6680/MAX6681
      hwmon: (lm90) Do not report 'busy' status bit as alarm

Guodong Liu (1):
      pinctrl: mediatek: fix global-out-of-bounds issue

Hans de Goede (1):
      Input: goodix - add id->model mapping for the "9111" model

Heiner Kallweit (1):
      igb: fix deadlock caused by taking RTNL in RPM resume path

Ignacy Gawędzki (1):
      netfilter: fix regression in looped (broad|multi)cast's MAC handling

Jens Wiklander (1):
      tee: handle lookup of shm with reference count 0

Jiacheng Shi (1):
      RDMA/hns: Replace kfree() with kvfree()

Jiasheng Jiang (7):
      HID: potential dereference of null pointer
      qlcnic: potential dereference null pointer of rx_queue->page_ring
      fjes: Check for error irq
      drivers: net: smc911x: Check for error irq
      net: ks8851: Check for error irq
      sfc: Check null pointer of rx_queue->page_ring
      sfc: falcon: Check null pointer of rx_queue->page_ring

Johan Hovold (1):
      platform/x86: intel_pmc_core: fix memleak on registration failure

Johannes Berg (1):
      mac80211: fix locking in ieee80211_start_ap error path

John David Anglin (2):
      parisc: Correct completer in lws start
      parisc: Fix mask used to select futex spinlock

Johnny Chuang (1):
      Input: elants_i2c - do not check Remark ID on eKTH3900/eKTH5312

José Expósito (2):
      IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()
      Input: atmel_mxt_ts - fix double free in mxt_read_info_block

Lin Ma (3):
      ax25: NPD bug when detaching AX25 device
      hamradio: defer ax25 kfree after unregister_netdev
      hamradio: improve the incomplete fix to avoid NPD

Liu Shixin (1):
      mm/hwpoison: clear MF_COUNT_INCREASED before retrying get_any_page()

Marian Postevca (1):
      usb: gadget: u_ether: fix race in setting MAC address in setup phase

Martin Blumenstingl (3):
      ASoC: meson: aiu: fifo: Add missing dma_coerce_mask_and_coherent()
      ASoC: meson: aiu: Move AIU_I2S_MISC hold setting to aiu-fifo-i2s
      mmc: meson-mx-sdhc: Set MANUAL_STOP for multi-block SDIO commands

Martin Haaß (1):
      ARM: dts: imx6qdl-wandboard: Fix Ethernet support

Martin Povišer (1):
      ASoC: tas2770: Fix setting of high sample rates

Mian Yousaf Kaukab (1):
      ipmi: ssif: initialize ssif_info->client early

Nick Desaulniers (2):
      arm64: vdso32: drop -no-integrated-as flag
      arm64: vdso32: require CROSS_COMPILE_COMPAT for gcc+bfd

Noralf Trønnes (1):
      gpio: dln2: Fix interrupts when replugging the device

Phil Elwell (1):
      pinctrl: bcm2835: Change init order for gpio hogs

Prathamesh Shete (1):
      mmc: sdhci-tegra: Fix switch to HS400ES mode

Robert Marko (1):
      arm64: dts: allwinner: orangepi-zero-plus: fix PHY mode

Rémi Denis-Courmont (1):
      phonet/pep: refuse to enable an unbound pipe

Sean Christopherson (2):
      KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU
      KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state

Sumit Garg (1):
      tee: optee: Fix incorrect page free bug

Thadeu Lima de Souza Cascardo (2):
      ipmi: bail out if init_srcu_struct fails
      ipmi: fix initialization when workqueue allocation fails

Ulf Hansson (1):
      mmc: core: Disable card detect during shutdown

Werner Sembach (1):
      ALSA: hda/realtek: Fix quirk for Clevo NJ51CU

Willem de Bruijn (2):
      net: accept UFOv6 packages in virtio_net_hdr_to_skb
      net: skip virtio_net_hdr_set_proto if protocol already set

Wu Bo (1):
      ipmi: Fix UAF when uninstall ipmi_si and ipmi_msghandler module

Xiaoke Wang (1):
      ALSA: jack: Check the return value of kstrdup()

Yann Gautier (1):
      mmc: mmci: stm32: clear DLYB_CR after sending tuning command

Yevhen Orlov (1):
      net: marvell: prestera: fix incorrect return of port_find

Zhang Yi (3):
      ext4: prevent partial update of the extent blocks
      ext4: check for out-of-order index extents in ext4_valid_extent_entries()
      ext4: check for inconsistent extents between index and leaf block

