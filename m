Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4AD1E4920
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389808AbgE0QDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389427AbgE0QDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:03:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10EF20873;
        Wed, 27 May 2020 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590595415;
        bh=FBDoLwzYE/AgVNrbs6QDMXqgbnFPj53rIyLU1NL+qEc=;
        h=From:To:Cc:Subject:Date:From;
        b=F7lx3htaXX8+M/G21eprIbNOJjPkOin3qMYgZXgyEIR9urO6ZEQKL/Jr81d2XojVK
         E7F6OGF16HkT4xkKr1BEb4fuxZyYjSNnBDfv0OSJY0x3KysFL1JAwXw6q/v6xwxsrW
         HmcW1oom+Ir+DgA6Avo/45OQyLLTADuQ8NR8hARo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.43
Date:   Wed, 27 May 2020 18:03:25 +0200
Message-Id: <159059540415272@kroah.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.43 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |   10 
 arch/arm/include/asm/futex.h                         |    9 
 arch/arm64/kernel/ptrace.c                           |    7 
 arch/powerpc/Kconfig                                 |    2 
 arch/s390/include/asm/pci_io.h                       |   10 
 arch/s390/kernel/machine_kexec_file.c                |    2 
 arch/s390/kernel/machine_kexec_reloc.c               |    1 
 arch/s390/pci/pci_mmio.c                             |  213 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h                      |    1 
 arch/x86/kernel/apic/apic.c                          |   27 +-
 arch/x86/kernel/unwind_orc.c                         |    7 
 arch/x86/kvm/svm.c                                   |   13 -
 arch/x86/kvm/vmx/vmx.c                               |   18 -
 arch/x86/kvm/x86.c                                   |   17 +
 arch/x86/mm/pageattr.c                               |   12 
 drivers/acpi/ec.c                                    |    6 
 drivers/acpi/sleep.c                                 |   15 -
 drivers/base/component.c                             |    8 
 drivers/dax/kmem.c                                   |   14 -
 drivers/dma/dmatest.c                                |    9 
 drivers/dma/owl-dma.c                                |    8 
 drivers/dma/tegra210-adma.c                          |    2 
 drivers/firmware/efi/libstub/tpm.c                   |    5 
 drivers/firmware/efi/tpm.c                           |    5 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    |   17 -
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c         |    4 
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c            |    2 
 drivers/gpu/drm/i915/gvt/display.c                   |   49 +++-
 drivers/gpu/drm/i915/i915_request.c                  |    4 
 drivers/hid/hid-alps.c                               |    1 
 drivers/hid/hid-ids.h                                |    7 
 drivers/hid/hid-multitouch.c                         |    3 
 drivers/hid/hid-quirks.c                             |    1 
 drivers/hid/i2c-hid/i2c-hid-core.c                   |    2 
 drivers/i2c/i2c-core-base.c                          |   22 +
 drivers/i2c/i2c-dev.c                                |   48 ++-
 drivers/i2c/muxes/i2c-demux-pinctrl.c                |    1 
 drivers/iio/accel/sca3000.c                          |    2 
 drivers/iio/adc/stm32-adc.c                          |   20 +
 drivers/iio/adc/stm32-dfsdm-adc.c                    |   36 ++
 drivers/iio/adc/ti-ads8344.c                         |    8 
 drivers/iio/dac/vf610_dac.c                          |    1 
 drivers/iommu/amd_iommu.c                            |    1 
 drivers/iommu/amd_iommu_init.c                       |    9 
 drivers/ipack/carriers/tpci200.c                     |    1 
 drivers/media/platform/rcar_fdp1.c                   |    2 
 drivers/misc/cardreader/rtsx_pcr.c                   |    3 
 drivers/misc/mei/client.c                            |    2 
 drivers/mtd/mtdcore.c                                |    2 
 drivers/mtd/nand/spi/core.c                          |    4 
 drivers/mtd/ubi/debug.c                              |   12 
 drivers/net/ethernet/amazon/ena/ena_netdev.h         |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c |    2 
 drivers/net/ethernet/ibm/ibmvnic.c                   |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    7 
 drivers/net/gtp.c                                    |    9 
 drivers/platform/x86/asus-nb-wmi.c                   |   24 +
 drivers/rapidio/devices/rio_mport_cdev.c             |    5 
 drivers/scsi/ibmvscsi/ibmvscsi.c                     |    4 
 drivers/scsi/qla2xxx/qla_attr.c                      |    5 
 drivers/scsi/qla2xxx/qla_mbx.c                       |    2 
 drivers/staging/greybus/uart.c                       |    4 
 drivers/staging/iio/resolver/ad2s1210.c              |   17 -
 drivers/staging/kpc2000/kpc2000/core.c               |    9 
 drivers/target/target_core_transport.c               |    1 
 drivers/tty/serial/sifive.c                          |    1 
 drivers/usb/core/message.c                           |    4 
 drivers/vhost/vsock.c                                |   10 
 fs/afs/fs_probe.c                                    |   18 -
 fs/afs/fsclient.c                                    |    8 
 fs/afs/vl_probe.c                                    |   18 -
 fs/afs/yfsclient.c                                   |    8 
 fs/ceph/caps.c                                       |    1 
 fs/configfs/dir.c                                    |    1 
 fs/file.c                                            |    2 
 fs/gfs2/glock.c                                      |    3 
 fs/ubifs/auth.c                                      |   17 -
 fs/ubifs/file.c                                      |    6 
 fs/ubifs/replay.c                                    |   13 -
 include/linux/filter.h                               |    8 
 include/net/af_rxrpc.h                               |    2 
 include/net/drop_monitor.h                           |    2 
 include/sound/hda_regmap.h                           |    3 
 include/sound/hdaudio.h                              |    1 
 include/trace/events/rxrpc.h                         |   52 +++-
 kernel/sched/fair.c                                  |   50 ++--
 lib/test_printf.c                                    |   19 +
 lib/vsprintf.c                                       |    7 
 mm/kasan/Makefile                                    |    8 
 mm/kasan/generic.c                                   |    1 
 mm/kasan/tags.c                                      |    1 
 net/core/flow_dissector.c                            |   26 +-
 net/rxrpc/Makefile                                   |    1 
 net/rxrpc/ar-internal.h                              |   25 +-
 net/rxrpc/call_accept.c                              |    2 
 net/rxrpc/call_event.c                               |   22 -
 net/rxrpc/input.c                                    |   44 +++
 net/rxrpc/misc.c                                     |    5 
 net/rxrpc/output.c                                   |    9 
 net/rxrpc/peer_event.c                               |   46 ---
 net/rxrpc/peer_object.c                              |   12 
 net/rxrpc/proc.c                                     |    8 
 net/rxrpc/rtt.c                                      |  195 +++++++++++++++
 net/rxrpc/rxkad.c                                    |    3 
 net/rxrpc/sendmsg.c                                  |   26 --
 net/rxrpc/sysctl.c                                   |    9 
 scripts/gcc-plugins/Makefile                         |    1 
 scripts/gcc-plugins/gcc-common.h                     |    4 
 scripts/gdb/linux/rbtree.py                          |    4 
 scripts/link-vmlinux.sh                              |   28 +-
 security/apparmor/apparmorfs.c                       |    3 
 security/apparmor/audit.c                            |    3 
 security/apparmor/domain.c                           |    3 
 security/integrity/evm/evm_crypto.c                  |   44 +--
 security/integrity/ima/ima_crypto.c                  |   12 
 security/integrity/ima/ima_fs.c                      |    3 
 sound/core/pcm_lib.c                                 |    1 
 sound/hda/hdac_device.c                              |    1 
 sound/hda/hdac_regmap.c                              |  142 ++++++++---
 sound/pci/hda/hda_codec.c                            |   30 +-
 sound/pci/hda/hda_generic.c                          |    6 
 sound/pci/hda/hda_local.h                            |    2 
 sound/pci/hda/patch_analog.c                         |    6 
 sound/pci/hda/patch_ca0132.c                         |   12 
 sound/pci/hda/patch_conexant.c                       |    6 
 sound/pci/hda/patch_hdmi.c                           |    2 
 sound/pci/hda/patch_realtek.c                        |  232 ++++++++++++++++---
 sound/pci/hda/patch_sigmatel.c                       |    4 
 sound/pci/hda/patch_via.c                            |    6 
 sound/pci/ice1712/ice1712.c                          |    3 
 tools/testing/selftests/ftrace/ftracetest            |    8 
 tools/testing/selftests/kvm/include/evmcs.h          |    4 
 tools/testing/selftests/kvm/lib/x86_64/vmx.c         |    3 
 133 files changed, 1450 insertions(+), 599 deletions(-)

Al Viro (1):
      fix multiplication overflow in copy_fdtable()

Alain Volmat (1):
      i2c: fix missing pm_runtime_put_sync in i2c_device_probe

Alan Maguire (1):
      ftrace/selftest: make unresolved cases cause failure if --fail-unresolved set

Alan Stern (1):
      USB: core: Fix misleading driver bug report

Alexander Monakov (1):
      iommu/amd: Fix over-read of ACPI UID from IVRS table

Alexander Usyskin (1):
      mei: release me_cl object reference

Artem Borisov (1):
      HID: alps: Add AUI1657 device ID

Arun Easi (1):
      scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV

Aurabindo Pillai (1):
      drm/amd/display: Prevent dpcd reads with passive dongles

Aymeric Agon-Rambosson (1):
      scripts/gdb: repair rb_first() and rb_last()

Babu Moger (1):
      KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c

Bob Peterson (1):
      Revert "gfs2: Don't demote a glock until its revokes are written"

Bodo Stroesser (1):
      scsi: target: Put lun_ref at end of tmr processing

Brent Lu (1):
      ALSA: pcm: fix incorrect hw_base increase

Chris Chiu (1):
      ALSA: hda/realtek - Enable headset mic of ASUS GL503VM with ALC295

Chris Wilson (1):
      drm/i915: Propagate error from completed fences

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

Dan Carpenter (2):
      evm: Fix a small race in init_desc()
      drm/etnaviv: Fix a leak in submit_pin_objects()

Daniel Borkmann (1):
      bpf: Avoid setting bpf insns pages read-only when prog is jited

Daniel Playfair Cal (1):
      HID: i2c-hid: reset Synaptics SYNA2393 on resume

David Hildenbrand (1):
      device-dax: don't leak kernel memory to user space after unloading kmem

David Howells (4):
      afs: Don't unlock fetched data pages until the op completes successfully
      rxrpc: Fix the excessive initial retransmission timeout
      rxrpc: Trace discarded ACKs
      rxrpc: Fix ack discard

Dragos Bogdan (1):
      staging: iio: ad2s1210: Fix SPI reading

Eric Biggers (1):
      ubifs: fix wrong use of crypto_shash_descsize()

Ewan D. Milne (1):
      scsi: qla2xxx: Do not log message when reading port speed via sysfs

Fabrice Gasnier (2):
      iio: adc: stm32-adc: fix device used to request dma
      iio: adc: stm32-dfsdm: fix device used to request dma

Frédéric Pierret (fepitre) (1):
      gcc-common.h: Update for GCC 10

Gavin Shan (1):
      net/ena: Fix build warning in ena_xdp_set()

Geert Uytterhoeven (1):
      media: fdp1: Fix R-Car M3-N naming in debug message

Gerald Schaefer (1):
      s390/kaslr: add support for R_390_JMP_SLOT relocation type

Greg Kroah-Hartman (1):
      Linux 5.4.43

Gregory CLEMENT (1):
      iio: adc: ti-ads8344: Fix channel selection

Hans de Goede (2):
      HID: quirks: Add HID_QUIRK_NO_INIT_REPORTS quirk for Dell K12A keyboard-dock
      platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA

Ilya Dryomov (1):
      vsprintf: don't obfuscate NULL and error pointers

Jakub Sitnicki (1):
      flow_dissector: Drop BPF flow dissector prog ref on netns cleanup

James Hilliard (1):
      component: Silence bind error on -EPROBE_DEFER

Jian-Hong Pan (2):
      ALSA: hda/realtek - Enable headset mic of ASUS UX550GE with ALC295
      ALSA: hda/realtek: Enable headset mic of ASUS UX581LV with ALC295

Jiri Kosina (1):
      HID: alps: ALPS_1657 is too specific; use U1_UNICORN_LEGACY instead

Joerg Roedel (1):
      iommu/amd: Call domain_flush_complete() in update_domain()

John Hubbard (1):
      rapidio: fix an error in get_user_pages_fast() error handling

Josh Poimboeuf (1):
      x86/unwind/orc: Fix unwind_get_return_address_ptr() for inactive tasks

Juliet Kim (1):
      ibmvnic: Skip fatal error reset after passive init

Kailang Yang (2):
      ALSA: hda/realtek - Add supported new mute Led for HP
      ALSA: hda/realtek - Add HP new mute led supported for ALC236

Kees Cook (1):
      kbuild: Remove debug info from kallsyms linking

Keno Fischer (1):
      arm64: Fix PTRACE_SYSEMU semantics

Kevin Hao (1):
      i2c: dev: Fix the race between the release of i2c_dev and cdev

Klaus Doth (1):
      misc: rtsx: Add short delay after exit from ASPM

Loïc Yhuel (1):
      tpm: check event log version before reading final events

Marco Elver (1):
      kasan: disable branch tracing for core runtime

Masahiro Yamada (2):
      kbuild: avoid concurrency issue in parallel building dtbs and dtbs_check
      net: drop_monitor: use IS_REACHABLE() to guard net_dm_hw_report()

Maxim Petrov (1):
      stmmac: fix pointer check after utilization in stmmac_interrupt

Miaohe Lin (1):
      KVM: SVM: Fix potential memory leak in svm_cpu_init()

Michael Ellerman (1):
      powerpc/64s: Disable STRICT_KERNEL_RWX

Michał Mirosław (1):
      ALSA: hda - constify and cleanup static NodeID tables

Mike Pozulp (1):
      ALSA: hda/realtek: Add quirk for Samsung Notebook

Miquel Raynal (1):
      mtd: spinand: Propagate ECC information to the MTD structure

Navid Emamdoost (1):
      apparmor: Fix use-after-free in aa_audit_rule_init

Niklas Schnelle (1):
      s390/pci: Fix s390_mmio_read/write with MIO

Oscar Carter (1):
      staging: greybus: Fix uninitialized scalar variable

PeiSen Hou (1):
      ALSA: hda/realtek - Add more fixup entries for Clevo machines

Peter Ujfalusi (2):
      iio: adc: stm32-adc: Use dma_request_chan() instead dma_request_slave_channel()
      iio: adc: stm32-dfsdm: Use dma_request_chan() instead dma_request_slave_channel()

Peter Xu (1):
      KVM: selftests: Fix build for evmcs.h

Phil Auld (1):
      sched/fair: Fix enqueue_task_fair() warning some more

Philipp Rudo (1):
      s390/kexec_file: fix initrd location for kdump kernel

Pierre-Louis Bossart (1):
      ALSA: hda: patch_realtek: fix empty macro usage in if block

Qiushi Wu (1):
      rxrpc: Fix a memory leak in rxkad_verify_response()

Quinn Tran (1):
      scsi: qla2xxx: Delete all sessions before unregister local nvme port

Rafael J. Wysocki (1):
      ACPI: EC: PM: Avoid flushing EC work when EC GPE is inactive

Ricardo Ribalda Delgado (1):
      mtd: Fix mtd not registered due to nvmem name collision

Richard Clark (1):
      aquantia: Fix the media type of AQC100 ethernet controller in the driver

Richard Weinberger (1):
      ubi: Fix seq_file usage in detailed_erase_block_info debugfs file

Rick Edgecombe (1):
      x86/mm/cpa: Flush direct map alias during cpa

Roberto Sassu (3):
      ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()
      evm: Check also if *tfm is an error pointer in init_desc()
      ima: Fix return value of ima_write_policy()

Russell Currey (1):
      powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE

Sagar Shrikant Kadam (1):
      tty: serial: add missing spin_lock_init for SiFive serial console

Scott Bahling (1):
      ALSA: iec1712: Initialize STDSP24 properly when using the model=staudio option

Sebastian Reichel (1):
      HID: multitouch: add eGalaxTouch P80H84 support

Stefano Garzarella (1):
      vhost/vsock: fix packet delivery order to monitoring devices

Takashi Iwai (1):
      ALSA: hda: Manage concurrent reg access more properly

Thomas Gleixner (2):
      x86/apic: Move TSC deadline timer debug printk
      ARM: futex: Address build warning

Tyrel Datwyler (1):
      scsi: ibmvscsi: Fix WARN_ON during event pool release

Vincent Guittot (2):
      sched/fair: Reorder enqueue/dequeue_task_fair path
      sched/fair: Fix reordering of enqueue/dequeue_task_fair()

Vladimir Murzin (1):
      dmaengine: dmatest: Restore default for channel

Wei Yongjun (2):
      staging: kpc2000: fix error return code in kp2000_pcie_probe()
      ipack: tpci200: fix error return code in tpci200_register()

Wu Bo (1):
      ceph: fix double unlock in handle_cap_export()

Xiyu Yang (3):
      configfs: fix config_item refcnt leak in configfs_rmdir()
      apparmor: fix potential label refcnt leak in aa_change_profile
      apparmor: Fix aa_label refcnt leak in policy_update

Yoshiyuki Kurauchi (1):
      gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()

