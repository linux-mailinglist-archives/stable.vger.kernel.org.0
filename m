Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7861E4910
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgE0QCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729090AbgE0QCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:02:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A13F220776;
        Wed, 27 May 2020 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590595352;
        bh=i6o2C71NpoXq6yP3umOAi7l0U6XJaURT7HsLkH2GC4o=;
        h=From:To:Cc:Subject:Date:From;
        b=bIWpt4E8uytcdUN0yl8fytFBTeKDAYU/buYv391jLWSawfs9AfLlv4Jy4csVFIvPj
         UCG7QZPa0c98Wu0Qdr02OwyB/VtPQUGSVXmBhhyA2p6DzauEZn+3dHx0i/2lDMYfUd
         A2b0fVzezx3c0CSmW2Un6nSiIPAB9yyIpKKWhgz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.6.15
Date:   Wed, 27 May 2020 18:02:17 +0200
Message-Id: <159059533626130@kroah.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.6.15 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |   10 
 arch/arc/configs/hsdk_defconfig                      |    1 
 arch/arm/Kconfig                                     |    1 
 arch/arm/include/asm/futex.h                         |    9 
 arch/arm64/Kconfig                                   |    1 
 arch/arm64/kernel/ptrace.c                           |    7 
 arch/powerpc/Kconfig                                 |    2 
 arch/s390/include/asm/pci_io.h                       |   10 
 arch/s390/kernel/machine_kexec_file.c                |    2 
 arch/s390/kernel/machine_kexec_reloc.c               |    1 
 arch/s390/pci/pci_mmio.c                             |  213 ++++++++++++++++++-
 arch/sh/include/uapi/asm/sockios.h                   |    2 
 arch/sparc/mm/srmmu.c                                |    6 
 arch/x86/Kconfig                                     |    1 
 arch/x86/kernel/apic/apic.c                          |   27 +-
 arch/x86/kernel/unwind_orc.c                         |    7 
 drivers/acpi/ec.c                                    |    6 
 drivers/acpi/sleep.c                                 |   15 -
 drivers/base/component.c                             |    8 
 drivers/base/core.c                                  |   55 +++-
 drivers/base/platform.c                              |    2 
 drivers/dax/kmem.c                                   |   14 -
 drivers/dma/dmatest.c                                |    9 
 drivers/dma/idxd/device.c                            |    7 
 drivers/dma/idxd/irq.c                               |   26 +-
 drivers/dma/owl-dma.c                                |    8 
 drivers/dma/tegra210-adma.c                          |    2 
 drivers/firmware/efi/libstub/tpm.c                   |    5 
 drivers/firmware/efi/tpm.c                           |    5 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    |   17 -
 drivers/gpu/drm/amd/display/dc/core/dc.c             |    5 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c         |    4 
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c            |    2 
 drivers/gpu/drm/i915/gvt/display.c                   |   49 +++-
 drivers/gpu/drm/i915/i915_request.c                  |    4 
 drivers/hid/hid-alps.c                               |    1 
 drivers/hid/hid-ids.h                                |    8 
 drivers/hid/hid-lg-g15.c                             |    4 
 drivers/hid/hid-multitouch.c                         |    3 
 drivers/hid/hid-quirks.c                             |    1 
 drivers/hid/i2c-hid/i2c-hid-core.c                   |    2 
 drivers/i2c/i2c-core-base.c                          |   22 +
 drivers/i2c/i2c-dev.c                                |   48 ++--
 drivers/i2c/muxes/i2c-demux-pinctrl.c                |    1 
 drivers/iio/accel/sca3000.c                          |    2 
 drivers/iio/adc/stm32-adc.c                          |    8 
 drivers/iio/adc/stm32-dfsdm-adc.c                    |   21 -
 drivers/iio/adc/ti-ads8344.c                         |    8 
 drivers/iio/dac/vf610_dac.c                          |    1 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c         |    7 
 drivers/iommu/amd_iommu.c                            |   17 +
 drivers/iommu/amd_iommu_init.c                       |    9 
 drivers/iommu/iommu.c                                |   17 -
 drivers/ipack/carriers/tpci200.c                     |    1 
 drivers/misc/cardreader/rtsx_pcr.c                   |    3 
 drivers/misc/mei/client.c                            |    2 
 drivers/mtd/mtdcore.c                                |    2 
 drivers/mtd/nand/spi/core.c                          |    4 
 drivers/mtd/ubi/debug.c                              |   12 -
 drivers/net/ethernet/amazon/ena/ena_netdev.h         |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c |    2 
 drivers/net/ethernet/ibm/ibmvnic.c                   |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    7 
 drivers/net/gtp.c                                    |    9 
 drivers/pinctrl/qcom/pinctrl-msm.c                   |   25 ++
 drivers/platform/x86/asus-nb-wmi.c                   |   24 ++
 drivers/rapidio/devices/rio_mport_cdev.c             |    5 
 drivers/scsi/ibmvscsi/ibmvscsi.c                     |    4 
 drivers/scsi/qla2xxx/qla_attr.c                      |    5 
 drivers/scsi/qla2xxx/qla_mbx.c                       |    2 
 drivers/staging/greybus/uart.c                       |    4 
 drivers/staging/iio/resolver/ad2s1210.c              |   17 +
 drivers/staging/kpc2000/kpc2000/core.c               |    9 
 drivers/staging/wfx/scan.c                           |    4 
 drivers/target/target_core_transport.c               |    1 
 drivers/tty/serial/sifive.c                          |    1 
 drivers/usb/core/message.c                           |    4 
 drivers/vhost/vsock.c                                |   10 
 drivers/virtio/virtio_balloon.c                      |  107 +++++----
 fs/afs/fs_probe.c                                    |   18 -
 fs/afs/fsclient.c                                    |    8 
 fs/afs/vl_probe.c                                    |   18 -
 fs/afs/yfsclient.c                                   |    8 
 fs/ceph/caps.c                                       |    1 
 fs/configfs/dir.c                                    |    1 
 fs/file.c                                            |    2 
 fs/gfs2/glock.c                                      |    3 
 fs/overlayfs/export.c                                |    3 
 fs/splice.c                                          |    2 
 fs/ubifs/auth.c                                      |   17 -
 fs/ubifs/file.c                                      |    6 
 fs/ubifs/replay.c                                    |   13 -
 include/linux/platform_device.h                      |    1 
 include/net/af_rxrpc.h                               |    2 
 include/net/drop_monitor.h                           |    2 
 include/trace/events/rxrpc.h                         |   52 +++-
 init/Kconfig                                         |    3 
 kernel/bpf/syscall.c                                 |   17 +
 kernel/bpf/verifier.c                                |    4 
 kernel/sched/fair.c                                  |   50 ++--
 kernel/trace/bpf_trace.c                             |    6 
 lib/test_printf.c                                    |   19 +
 lib/vsprintf.c                                       |    7 
 mm/kasan/Makefile                                    |    8 
 mm/kasan/generic.c                                   |    1 
 mm/kasan/tags.c                                      |    1 
 mm/z3fold.c                                          |   11 
 net/core/flow_dissector.c                            |   26 +-
 net/rxrpc/Makefile                                   |    1 
 net/rxrpc/ar-internal.h                              |   25 +-
 net/rxrpc/call_accept.c                              |    2 
 net/rxrpc/call_event.c                               |   22 -
 net/rxrpc/input.c                                    |   44 +++
 net/rxrpc/misc.c                                     |    5 
 net/rxrpc/output.c                                   |    9 
 net/rxrpc/peer_event.c                               |   46 ----
 net/rxrpc/peer_object.c                              |   12 -
 net/rxrpc/proc.c                                     |    8 
 net/rxrpc/rtt.c                                      |  195 +++++++++++++++++
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
 security/integrity/ima/ima_crypto.c                  |   12 -
 security/integrity/ima/ima_fs.c                      |    3 
 sound/core/pcm_lib.c                                 |    1 
 sound/pci/hda/patch_realtek.c                        |  162 ++++++++++++++
 sound/pci/ice1712/ice1712.c                          |    3 
 tools/bootconfig/main.c                              |   10 
 tools/testing/selftests/bpf/prog_tests/mmap.c        |   13 +
 tools/testing/selftests/bpf/progs/test_mmap.c        |    8 
 tools/testing/selftests/ftrace/ftracetest            |    8 
 tools/testing/selftests/kvm/Makefile                 |   29 ++
 tools/testing/selftests/kvm/include/evmcs.h          |    4 
 tools/testing/selftests/kvm/lib/x86_64/vmx.c         |    3 
 142 files changed, 1488 insertions(+), 567 deletions(-)

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

Andrii Nakryiko (1):
      bpf: Prevent mmap()'ing read-only maps as writable

Arnd Bergmann (1):
      sh: include linux/time_types.h for sockios

Artem Borisov (1):
      HID: alps: Add AUI1657 device ID

Arun Easi (1):
      scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV

Aurabindo Pillai (1):
      drm/amd/display: Prevent dpcd reads with passive dongles

Aymeric Agon-Rambosson (1):
      scripts/gdb: repair rb_first() and rb_last()

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

Dan Carpenter (5):
      ovl: potential crash in ovl_fid_to_fh()
      evm: Fix a small race in init_desc()
      drm/etnaviv: Fix a leak in submit_pin_objects()
      staging: wfx: unlock on error path
      iio: imu: st_lsm6dsx: unlock on error in st_lsm6dsx_shub_write_raw()

Daniel Borkmann (2):
      bpf: Restrict bpf_probe_read{, str}() only to archs where they work
      bpf: Add bpf_probe_read_{user, kernel}_str() to do_refine_retval_range

Daniel Playfair Cal (1):
      HID: i2c-hid: reset Synaptics SYNA2393 on resume

Dave Jiang (1):
      dmaengine: idxd: fix interrupt completion after unmasking

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

Eugeniy Paltsev (1):
      ARC: [plat-hsdk]: fix USB regression

Ewan D. Milne (1):
      scsi: qla2xxx: Do not log message when reading port speed via sysfs

Fabian Schindlatz (1):
      HID: logitech: Add support for Logitech G11 extra keys

Fabrice Gasnier (2):
      iio: adc: stm32-adc: fix device used to request dma
      iio: adc: stm32-dfsdm: fix device used to request dma

Frédéric Pierret (fepitre) (1):
      gcc-common.h: Update for GCC 10

Gavin Shan (1):
      net/ena: Fix build warning in ena_xdp_set()

Gerald Schaefer (1):
      s390/kaslr: add support for R_390_JMP_SLOT relocation type

Greg Kroah-Hartman (1):
      Linux 5.6.15

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

Joerg Roedel (3):
      iommu: Fix deferred domain attachment
      iommu/amd: Do not loop forever when trying to increase address space
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

Michael Ellerman (1):
      powerpc/64s: Disable STRICT_KERNEL_RWX

Michael S. Tsirkin (1):
      virtio-balloon: Revert "virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM"

Mike Pozulp (1):
      ALSA: hda/realtek: Add quirk for Samsung Notebook

Mike Rapoport (2):
      sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()
      sparc32: fix page table traversal in srmmu_nocache_init()

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

Peter Xu (1):
      KVM: selftests: Fix build for evmcs.h

Phil Auld (1):
      sched/fair: Fix enqueue_task_fair() warning some more

Philipp Rudo (1):
      s390/kexec_file: fix initrd location for kdump kernel

Qiushi Wu (1):
      rxrpc: Fix a memory leak in rxkad_verify_response()

Quinn Tran (1):
      scsi: qla2xxx: Delete all sessions before unregister local nvme port

Rafael J. Wysocki (1):
      ACPI: EC: PM: Avoid flushing EC work when EC GPE is inactive

Raul E Rangel (1):
      iommu/amd: Fix get_acpihid_device_id()

Ricardo Ribalda Delgado (1):
      mtd: Fix mtd not registered due to nvmem name collision

Richard Clark (1):
      aquantia: Fix the media type of AQC100 ethernet controller in the driver

Richard Weinberger (1):
      ubi: Fix seq_file usage in detailed_erase_block_info debugfs file

Roberto Sassu (3):
      ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()
      evm: Check also if *tfm is an error pointer in init_desc()
      ima: Fix return value of ima_write_policy()

Roman Li (1):
      drm/amd/display: fix counter in wait_for_no_pipes_pending

Sagar Shrikant Kadam (1):
      tty: serial: add missing spin_lock_init for SiFive serial console

Saravana Kannan (2):
      driver core: Fix SYNC_STATE_ONLY device link implementation
      driver core: Fix handling of SYNC_STATE_ONLY + STATELESS device links

Sasha Levin (1):
      Revert "driver core: platform: Initialize dma_parms for platform devices"

Scott Bahling (1):
      ALSA: iec1712: Initialize STDSP24 properly when using the model=staudio option

Sebastian Reichel (1):
      HID: multitouch: add eGalaxTouch P80H84 support

Shuah Khan (1):
      selftests: fix kvm relocatable native/cross builds and installs

Stefano Garzarella (1):
      vhost/vsock: fix packet delivery order to monitoring devices

Steven Rostedt (VMware) (1):
      tools/bootconfig: Fix apply_xbc() to return zero on success

Tetsuo Handa (1):
      pipe: Fix pipe_full() test in opipe_prep().

Thomas Gleixner (2):
      x86/apic: Move TSC deadline timer debug printk
      ARM: futex: Address build warning

Tyrel Datwyler (1):
      scsi: ibmvscsi: Fix WARN_ON during event pool release

Uladzislau Rezki (1):
      z3fold: fix use-after-free when freeing handles

Venkata Narendra Kumar Gutta (1):
      pinctrl: qcom: Add affinity callbacks to msmgpio IRQ chip

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

Yunfeng Ye (1):
      tools/bootconfig: Fix resource leak in apply_xbc()

