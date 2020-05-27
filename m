Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A9A1E4947
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390763AbgE0QHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389648AbgE0QHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:07:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DC9E208DB;
        Wed, 27 May 2020 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590595633;
        bh=OxoQgxb4FZFAxaWufHmrAaljZWeiUpt2ubzyG38CV3c=;
        h=From:To:Cc:Subject:Date:From;
        b=PkkptuDFs7qOJzKY3TPhk7bcFAcnpDJzukzFxaxI0My7HMZZP0SAboyH1qnFmOyU0
         6SE2ZtDE0/stqPTr6ZUooVAxosMf8KVqsVa5Z0Fu9Bw0kllQ6mkC62g7TALYWjF/K4
         uqqjj+hOh5yN4BaVugcIH5J+VdUghBrpiiITFLJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.125
Date:   Wed, 27 May 2020 18:07:07 +0200
Message-Id: <159059562771248@kroah.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.125 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/include/asm/futex.h                            |    9 -
 arch/powerpc/Kconfig                                    |    2 
 arch/riscv/kernel/setup.c                               |    2 
 arch/x86/kernel/apic/apic.c                             |   27 +--
 arch/x86/kernel/unwind_orc.c                            |    7 
 arch/x86/kvm/svm.c                                      |   13 -
 drivers/acpi/nfit/core.c                                |   17 +-
 drivers/acpi/nfit/nfit.h                                |    6 
 drivers/base/component.c                                |    8 -
 drivers/dma/owl-dma.c                                   |    8 -
 drivers/dma/tegra210-adma.c                             |    2 
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c               |    2 
 drivers/gpu/drm/i915/gvt/display.c                      |   49 ++++++
 drivers/hid/hid-alps.c                                  |    1 
 drivers/hid/hid-ids.h                                   |    7 
 drivers/hid/hid-multitouch.c                            |    3 
 drivers/hid/hid-quirks.c                                |    1 
 drivers/hid/i2c-hid/i2c-hid-core.c                      |    2 
 drivers/i2c/i2c-dev.c                                   |   48 +++---
 drivers/i2c/muxes/i2c-demux-pinctrl.c                   |    1 
 drivers/iio/accel/sca3000.c                             |    2 
 drivers/iio/adc/stm32-adc.c                             |   20 ++
 drivers/iio/adc/stm32-dfsdm-adc.c                       |   23 +--
 drivers/iio/dac/vf610_dac.c                             |    1 
 drivers/iommu/amd_iommu_init.c                          |    9 -
 drivers/ipack/carriers/tpci200.c                        |    1 
 drivers/media/platform/rcar_fdp1.c                      |    2 
 drivers/misc/cardreader/rtsx_pcr.c                      |    3 
 drivers/misc/mei/client.c                               |    2 
 drivers/mtd/nand/spi/core.c                             |    4 
 drivers/mtd/ubi/debug.c                                 |   12 -
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c    |    2 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c          |   63 ++++----
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c      |    6 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c         |   13 +
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c     |    6 
 drivers/net/ethernet/ibm/ibmvnic.c                      |    8 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |    7 
 drivers/net/gtp.c                                       |    9 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    2 
 drivers/nvdimm/btt.c                                    |   33 ++--
 drivers/nvdimm/btt.h                                    |    2 
 drivers/nvdimm/btt_devs.c                               |    8 +
 drivers/platform/x86/asus-nb-wmi.c                      |   24 +++
 drivers/rapidio/devices/rio_mport_cdev.c                |    5 
 drivers/scsi/ibmvscsi/ibmvscsi.c                        |    4 
 drivers/scsi/qla2xxx/qla_attr.c                         |    2 
 drivers/scsi/qla2xxx/qla_mbx.c                          |    2 
 drivers/staging/greybus/uart.c                          |    4 
 drivers/staging/iio/resolver/ad2s1210.c                 |   17 +-
 drivers/staging/most/core.c                             |    2 
 drivers/thunderbolt/icm.c                               |   12 +
 drivers/thunderbolt/switch.c                            |   18 --
 drivers/thunderbolt/tb.c                                |    9 -
 drivers/thunderbolt/tb.h                                |    1 
 drivers/tty/serial/qcom_geni_serial.c                   |   12 -
 drivers/usb/core/message.c                              |    4 
 drivers/vhost/vsock.c                                   |   10 -
 fs/ceph/caps.c                                          |    1 
 fs/configfs/dir.c                                       |    1 
 fs/file.c                                               |    2 
 fs/gfs2/glock.c                                         |    3 
 fs/ubifs/file.c                                         |    6 
 include/linux/padata.h                                  |   13 -
 include/trace/events/rxrpc.h                            |   35 ++++
 include/uapi/linux/ndctl.h                              |    1 
 kernel/padata.c                                         |  114 ++--------------
 lib/Makefile                                            |    2 
 net/rxrpc/input.c                                       |   38 ++++-
 net/rxrpc/rxkad.c                                       |    3 
 scripts/gcc-plugins/Makefile                            |    1 
 scripts/gcc-plugins/gcc-common.h                        |    4 
 security/apparmor/apparmorfs.c                          |    3 
 security/apparmor/audit.c                               |    3 
 security/apparmor/domain.c                              |    3 
 security/integrity/evm/evm_crypto.c                     |    2 
 security/integrity/ima/ima_crypto.c                     |   12 -
 security/integrity/ima/ima_fs.c                         |    3 
 sound/core/pcm_lib.c                                    |    1 
 sound/pci/hda/patch_realtek.c                           |    4 
 sound/pci/ice1712/ice1712.c                             |    3 
 82 files changed, 498 insertions(+), 341 deletions(-)

Al Viro (1):
      fix multiplication overflow in copy_fdtable()

Alan Stern (1):
      USB: core: Fix misleading driver bug report

Alexander Monakov (1):
      iommu/amd: Fix over-read of ACPI UID from IVRS table

Alexander Usyskin (1):
      mei: release me_cl object reference

Arjun Vynipadath (2):
      cxgb4: free mac_hlist properly
      cxgb4/cxgb4vf: Fix mac_hlist initialization and free

Arnd Bergmann (1):
      ubsan: build ubsan.c more conservatively

Artem Borisov (1):
      HID: alps: Add AUI1657 device ID

Arun Easi (1):
      scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV

Bob Peterson (1):
      Revert "gfs2: Don't demote a glock until its revokes are written"

Brent Lu (1):
      ALSA: pcm: fix incorrect hw_base increase

Christian Gmeiner (1):
      drm/etnaviv: fix perfmon domain interation

Christian Lachner (1):
      ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Xtreme

Christoph Hellwig (1):
      ubifs: remove broken lazytime support

Christophe JAILLET (4):
      i2c: mux: demux-pinctrl: Fix an error handling path in 'i2c_demux_pinctrl_probe()'
      dmaengine: tegra210-adma: Fix an error handling path in 'tegra_adma_probe()'
      iio: sca3000: Remove an erroneous 'get_device()'
      iio: dac: vf610: Fix an error handling path in 'vf610_dac_probe()'

Colin Xu (1):
      drm/i915/gvt: Init DPLL/DDI vreg for virtual display instead of inheritance.

Cristian Ciocaltea (1):
      dmaengine: owl: Use correct lock in owl_dma_get_pchan()

Daniel Jordan (2):
      padata: initialize pd->cpu with effective cpumask
      padata: purge get_cpu and reorder_via_wq from padata_do_serial

Daniel Playfair Cal (1):
      HID: i2c-hid: reset Synaptics SYNA2393 on resume

David Howells (2):
      rxrpc: Trace discarded ACKs
      rxrpc: Fix ack discard

Dexuan Cui (1):
      nfit: Add Hyper-V NVDIMM DSM command set to white list

Doug Berger (2):
      net: bcmgenet: code movement
      net: bcmgenet: abort suspend on error

Dragos Bogdan (1):
      staging: iio: ad2s1210: Fix SPI reading

Fabrice Gasnier (2):
      iio: adc: stm32-adc: fix device used to request dma
      iio: adc: stm32-dfsdm: fix device used to request dma

Frédéric Pierret (fepitre) (1):
      gcc-common.h: Update for GCC 10

Geert Uytterhoeven (1):
      media: fdp1: Fix R-Car M3-N naming in debug message

Greg Kroah-Hartman (1):
      Linux 4.19.125

Guenter Roeck (1):
      brcmfmac: abort and release host after error

Gustavo A. R. Silva (1):
      staging: most: core: replace strcpy() by strscpy()

Hans de Goede (2):
      HID: quirks: Add HID_QUIRK_NO_INIT_REPORTS quirk for Dell K12A keyboard-dock
      platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA

Herbert Xu (1):
      padata: Replace delayed timer with immediate workqueue in padata_reorder

James Hilliard (1):
      component: Silence bind error on -EPROBE_DEFER

Jiri Kosina (1):
      HID: alps: ALPS_1657 is too specific; use U1_UNICORN_LEGACY instead

John Hubbard (1):
      rapidio: fix an error in get_user_pages_fast() error handling

Josh Poimboeuf (1):
      x86/unwind/orc: Fix unwind_get_return_address_ptr() for inactive tasks

Juliet Kim (1):
      Revert "net/ibmvnic: Fix EOI when running in XIVE mode"

Kevin Hao (1):
      i2c: dev: Fix the race between the release of i2c_dev and cdev

Klaus Doth (1):
      misc: rtsx: Add short delay after exit from ASPM

Matthias Kaehlcke (1):
      tty: serial: qcom_geni_serial: Fix wrap around of TX buffer

Maxim Petrov (1):
      stmmac: fix pointer check after utilization in stmmac_interrupt

Miaohe Lin (1):
      KVM: SVM: Fix potential memory leak in svm_cpu_init()

Michael Ellerman (1):
      powerpc/64s: Disable STRICT_KERNEL_RWX

Mika Westerberg (1):
      thunderbolt: Drop duplicated get_switch_at_route()

Miquel Raynal (1):
      mtd: spinand: Propagate ECC information to the MTD structure

Navid Emamdoost (1):
      apparmor: Fix use-after-free in aa_audit_rule_init

Oscar Carter (1):
      staging: greybus: Fix uninitialized scalar variable

PeiSen Hou (1):
      ALSA: hda/realtek - Add more fixup entries for Clevo machines

Peter Ujfalusi (2):
      iio: adc: stm32-adc: Use dma_request_chan() instead dma_request_slave_channel()
      iio: adc: stm32-dfsdm: Use dma_request_chan() instead dma_request_slave_channel()

Peter Zijlstra (1):
      x86/uaccess, ubsan: Fix UBSAN vs. SMAP

Qiushi Wu (1):
      rxrpc: Fix a memory leak in rxkad_verify_response()

Quinn Tran (1):
      scsi: qla2xxx: Delete all sessions before unregister local nvme port

Richard Clark (1):
      aquantia: Fix the media type of AQC100 ethernet controller in the driver

Richard Weinberger (1):
      ubi: Fix seq_file usage in detailed_erase_block_info debugfs file

Roberto Sassu (3):
      ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()
      evm: Check also if *tfm is an error pointer in init_desc()
      ima: Fix return value of ima_write_policy()

Russell Currey (1):
      powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE

Scott Bahling (1):
      ALSA: iec1712: Initialize STDSP24 properly when using the model=staudio option

Sebastian Reichel (1):
      HID: multitouch: add eGalaxTouch P80H84 support

Stefano Garzarella (1):
      vhost/vsock: fix packet delivery order to monitoring devices

Thomas Gleixner (2):
      x86/apic: Move TSC deadline timer debug printk
      ARM: futex: Address build warning

Tyrel Datwyler (1):
      scsi: ibmvscsi: Fix WARN_ON during event pool release

Vincent Chen (1):
      riscv: set max_pfn to the PFN of the last page

Vishal Verma (2):
      libnvdimm/btt: Remove unnecessary code in btt_freelist_init
      libnvdimm/btt: Fix LBA masking during 'free list' population

Wei Yongjun (1):
      ipack: tpci200: fix error return code in tpci200_register()

Wu Bo (1):
      ceph: fix double unlock in handle_cap_export()

Xiyu Yang (3):
      configfs: fix config_item refcnt leak in configfs_rmdir()
      apparmor: fix potential label refcnt leak in aa_change_profile
      apparmor: Fix aa_label refcnt leak in policy_update

Yoshiyuki Kurauchi (1):
      gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()

