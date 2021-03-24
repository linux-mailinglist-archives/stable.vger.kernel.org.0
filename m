Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D03476CB
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 12:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhCXLJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 07:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhCXLIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 07:08:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 887A3619E0;
        Wed, 24 Mar 2021 11:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616584123;
        bh=cMMXiXLOB9hbqnWxkaqkrxu9bhTbLC7mQaxMPP9F7hI=;
        h=From:To:Cc:Subject:Date:From;
        b=kJ4GbboQOtk3zRp/lsfFyI+RIZOhMH1VG6ss3YAjoCsocwTiB4UscHBvVaBCq3Wcd
         QqEOB8emGmD4nY8fqyQeZGg56MZSoekA1k8ZL9VgVEGWCjnS2d6o5v9nRhUUoYhw0P
         3CQ+LoUjAYqwwfCYPGiqgRSHTVlu6GD92+d36knI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.9
Date:   Wed, 24 Mar 2021 12:08:39 +0100
Message-Id: <161658411934125@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.9 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                            |    7 -
 Makefile                                               |    8 -
 arch/powerpc/include/asm/cpu_has_feature.h             |    4 
 arch/powerpc/kernel/vdso32/gettimeofday.S              |   11 +
 arch/riscv/Kconfig                                     |    4 
 arch/riscv/include/asm/sbi.h                           |    4 
 arch/riscv/kernel/setup.c                              |    3 
 arch/s390/include/asm/pci.h                            |    6 -
 arch/s390/kernel/vtime.c                               |    2 
 arch/s390/pci/pci.c                                    |   85 ++++++++++----
 arch/s390/pci/pci_clp.c                                |   40 ------
 arch/s390/pci/pci_event.c                              |   22 +--
 arch/x86/events/intel/core.c                           |    3 
 arch/x86/events/intel/ds.c                             |    2 
 arch/x86/include/asm/processor.h                       |    9 -
 arch/x86/include/asm/thread_info.h                     |   23 +++
 arch/x86/kernel/apic/apic.c                            |    5 
 arch/x86/kernel/apic/io_apic.c                         |   10 +
 arch/x86/kernel/signal.c                               |   24 ----
 drivers/base/power/runtime.c                           |   62 ++++------
 drivers/counter/stm32-timer-cnt.c                      |   55 +++++----
 drivers/firmware/efi/efi.c                             |    3 
 drivers/firmware/efi/vars.c                            |    4 
 drivers/gpio/gpiolib.c                                 |    7 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c     |   34 -----
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |    5 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c |   26 +++-
 drivers/gpu/drm/i915/i915_perf.c                       |   13 --
 drivers/gpu/drm/ttm/ttm_bo.c                           |    2 
 drivers/iio/adc/Kconfig                                |    3 
 drivers/iio/adc/ab8500-gpadc.c                         |    2 
 drivers/iio/adc/ad7949.c                               |    2 
 drivers/iio/adc/qcom-spmi-vadc.c                       |    2 
 drivers/iio/gyro/mpu3050-core.c                        |    2 
 drivers/iio/humidity/hid-sensor-humidity.c             |   12 +-
 drivers/iio/imu/adis16400.c                            |    3 
 drivers/iio/light/hid-sensor-prox.c                    |   13 +-
 drivers/iio/temperature/hid-sensor-temperature.c       |   14 +-
 drivers/iommu/amd/init.c                               |   36 +++---
 drivers/iommu/tegra-smmu.c                             |    7 -
 drivers/nvme/host/core.c                               |   36 ++----
 drivers/nvme/host/rdma.c                               |    7 -
 drivers/nvme/host/tcp.c                                |   16 ++
 drivers/nvme/target/core.c                             |   17 ++
 drivers/pci/hotplug/rpadlpar_sysfs.c                   |   14 +-
 drivers/pci/hotplug/s390_pci_hpc.c                     |    3 
 drivers/scsi/lpfc/lpfc_debugfs.c                       |    4 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                   |    2 
 drivers/scsi/myrs.c                                    |    2 
 drivers/scsi/ufs/ufs-mediatek.c                        |    2 
 drivers/spi/spi-cadence-quadspi.c                      |    1 
 drivers/thunderbolt/switch.c                           |   18 +--
 drivers/thunderbolt/tb.c                               |    4 
 drivers/usb/dwc3/gadget.c                              |   22 ++-
 drivers/usb/gadget/configfs.c                          |   14 +-
 drivers/usb/storage/transport.c                        |    7 +
 drivers/usb/storage/unusual_devs.h                     |   12 ++
 drivers/usb/typec/tcpm/tcpm.c                          |    9 +
 drivers/usb/typec/tps6598x.c                           |    1 
 drivers/usb/usbip/vudc_sysfs.c                         |    2 
 drivers/vfio/Kconfig                                   |    2 
 drivers/vhost/vdpa.c                                   |   20 +--
 fs/afs/dir.c                                           |    1 
 fs/afs/file.c                                          |    1 
 fs/afs/fs_operation.c                                  |    7 -
 fs/afs/inode.c                                         |    1 
 fs/afs/internal.h                                      |    1 
 fs/afs/mntpt.c                                         |    1 
 fs/afs/xattr.c                                         |   31 +----
 fs/btrfs/ctree.c                                       |    2 
 fs/btrfs/inode.c                                       |    2 
 fs/cifs/fs_context.c                                   |    6 -
 fs/cifs/inode.c                                        |   10 +
 fs/cifs/transport.c                                    |    7 +
 fs/ext4/ext4.h                                         |    2 
 fs/ext4/fast_commit.c                                  |    9 +
 fs/ext4/inode.c                                        |   12 +-
 fs/ext4/namei.c                                        |   32 +++++
 fs/ext4/super.c                                        |    2 
 fs/ext4/verity.c                                       |   89 +++++++++-----
 fs/ext4/xattr.c                                        |    2 
 fs/io_uring.c                                          |    6 -
 fs/nfsd/filecache.c                                    |    2 
 fs/nfsd/nfs4proc.c                                     |    2 
 fs/nfsd/nfs4state.c                                    |    2 
 fs/pstore/inode.c                                      |    2 
 fs/select.c                                            |   10 -
 fs/zonefs/super.c                                      |  101 ++++++++++++++---
 include/drm/ttm/ttm_bo_api.h                           |    8 +
 include/linux/efi.h                                    |    6 -
 include/linux/thread_info.h                            |   13 ++
 include/linux/usb_usual.h                              |    2 
 kernel/futex.c                                         |    3 
 kernel/irq/manage.c                                    |    4 
 kernel/jump_label.c                                    |    8 +
 kernel/static_call.c                                   |   11 +
 kernel/time/alarmtimer.c                               |    2 
 kernel/time/hrtimer.c                                  |    2 
 kernel/time/posix-cpu-timers.c                         |    2 
 net/qrtr/qrtr.c                                        |    2 
 net/sunrpc/svc.c                                       |    6 -
 net/sunrpc/svc_xprt.c                                  |    4 
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c             |    6 -
 sound/firewire/dice/dice-stream.c                      |    5 
 sound/pci/hda/hda_generic.c                            |    2 
 sound/pci/hda/patch_realtek.c                          |   16 ++
 sound/soc/codecs/ak4458.c                              |    1 
 sound/soc/codecs/ak5558.c                              |    1 
 sound/soc/codecs/lpass-va-macro.c                      |   28 ++--
 sound/soc/codecs/lpass-wsa-macro.c                     |   20 +--
 sound/soc/codecs/wcd934x.c                             |    6 +
 sound/soc/fsl/fsl_ssi.c                                |    6 -
 sound/soc/generic/simple-card-utils.c                  |   13 +-
 sound/soc/intel/boards/bytcr_rt5640.c                  |    2 
 sound/soc/qcom/lpass-cpu.c                             |    2 
 sound/soc/qcom/sdm845.c                                |    6 -
 sound/soc/sof/intel/hda-dsp.c                          |    2 
 sound/soc/sof/intel/hda.c                              |    1 
 sound/usb/mixer_quirks.c                               |    4 
 119 files changed, 814 insertions(+), 517 deletions(-)

Alan Stern (1):
      usb-storage: Add quirk to defeat Kindle's automatic unload

Alexander Shiyan (1):
      ASoC: fsl_ssi: Fix TDM slot setup for I2S mode

Alexandru Ardelean (1):
      iio: adc: adi-axi-adc: add proper Kconfig dependencies

Andy Shevchenko (1):
      gpiolib: Assign fwnode to parent's if no primary one provided

Ard Biesheuvel (1):
      efi: use 32-bit alignment for efi_guid_t literals

Aurelien Aptel (1):
      cifs: warn and fail if trying to use rootfs without the config option

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Invoke power_supply_changed for tcpm-source-psy-

Calvin Hou (1):
      drm/amd/display: Correct algorithm for reversed gamma

Chao Yu (1):
      zonefs: fix to update .i_wr_refcnt correctly in zonefs_open_zone()

Christian König (1):
      drm/ttm: make ttm_bo_unpin more defensive

Christoph Hellwig (1):
      nvme: fix Write Zeroes limitations

Christophe JAILLET (1):
      scsi: mpt3sas: Do not use GFP_KERNEL in atomic context

Christophe Leroy (2):
      powerpc/vdso32: Add missing _restgpr_31_x to fix build failure
      powerpc: Force inlining of cpu_has_feature() to avoid build failure

Colin Ian King (2):
      ALSA: usb-audio: Fix unintentional sign extension issue
      usbip: Fix incorrect double assignment to udc->ud.tcp_rx

Damien Le Moal (2):
      zonefs: Fix O_APPEND async write handling
      zonefs: prevent use of seq files as swap file

Dan Carpenter (2):
      scsi: lpfc: Fix some error codes in debugfs
      iio: adis16400: Fix an error code in adis16400_initial_setup()

Daniel Kobras (1):
      sunrpc: fix refcount leak for rpc auth modules

Daniel Vetter (1):
      drm/ttm: Warn on pinning without holding a reference

David Howells (2):
      afs: Fix accessing YFS xattrs on a non-YFS server
      afs: Stop listxattr() from listing "afs.*" attributes

David Sterba (1):
      btrfs: fix slab cache flags for free space tree bitmap

Dillon Varone (1):
      drm/amd/display: Remove MPC gamut remap logic for DCN30

Dinghao Liu (1):
      iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler

Dmitry Osipenko (1):
      iommu/tegra-smmu: Make tegra_smmu_probe_device() to handle all IOMMU phandles

Elias Rudberg (1):
      usb: typec: Remove vdo[3] part of tps6598x_rx_identity_reg struct

Eric Biggers (1):
      ext4: fix error handling in ext4_end_enable_verity()

Fabrice Gasnier (2):
      counter: stm32-timer-cnt: fix ceiling write max value
      counter: stm32-timer-cnt: fix ceiling miss-alignment with reload register

Filipe Manana (1):
      btrfs: fix race when cloning extent buffer during rewind of an old root

Gautam Dawar (1):
      vhost_vdpa: fix the missing irq_bypass_unregister_producer() invocation

Geert Uytterhoeven (1):
      RISC-V: Fix out-of-bounds accesses in init_resources()

Gerald Schaefer (1):
      s390/vtime: fix increased steal time accounting

Greg Kroah-Hartman (3):
      MAINTAINERS: move some real subsystems off of the staging mailing list
      MAINTAINERS: move the staging subsystem to lists.linux.dev
      Linux 5.11.9

Hans de Goede (1):
      ASoC: Intel: bytcr_rt5640: Fix HP Pavilion x2 10-p0XX OVCD current threshold

Harshad Shirwadkar (1):
      ext4: fix rename whiteout with fast commit

Heinrich Schuchardt (1):
      RISC-V: correct enum sbi_ext_rfence_fid

Hui Wang (1):
      ALSA: hda: generic: Fix the micmute led init state

J. Bruce Fields (1):
      nfsd: don't abort copies early

Jan Kara (1):
      ext4: fix timer use-after-free on failed mount

Jason Gunthorpe (1):
      vfio: IOMMU_API should be selected

Jens Axboe (1):
      io_uring: ensure that SQPOLL thread is started for exit

Jeremy Szu (3):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP 840 G8
      ALSA: hda/realtek: fix mute/micmute LEDs for HP 440 G8
      ALSA: hda/realtek: fix mute/micmute LEDs for HP 850 G8

Jim Lin (1):
      usb: gadget: configfs: Fix KASAN use-after-free

Joe Korty (1):
      NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

Joerg Roedel (3):
      iommu/amd: Don't call early_amd_iommu_init() when AMD IOMMU is disabled
      iommu/amd: Keep track of amd_iommu_irq_remap state
      iommu/amd: Move Stoney Ridge check to detect_ivrs()

Johan Hovold (1):
      x86/apic/of: Fix CPU devicetree-node lookups

Jonathan Albrieux (1):
      iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel

Jonathan Cameron (1):
      iio:adc:stm32-adc: Add HAS_IOMEM dependency

Jonathan Marek (2):
      ASoC: codecs: lpass-va-macro: mute/unmute all active decimators
      ASoC: codecs: lpass-wsa-macro: fix RX MIX input controls

Kan Liang (2):
      perf/x86/intel: Fix a crash caused by zero PEBS status
      perf/x86/intel: Fix unchecked MSR access error caused by VLBR_EVENT

Kefeng Wang (1):
      riscv: Correct SPARSEMEM configuration

Linus Walleij (1):
      iio: adc: ab8500-gpadc: Fix off by 10 to 3

Lv Yunlong (2):
      scsi: myrs: Fix a double free in myrs_cleanup()
      firmware/efi: Fix a use after bug in efi_mem_reserve_persistent

Masahiro Yamada (1):
      kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL again

Meng Li (1):
      spi: cadence: set cqspi to the driver_data field of struct device

Mika Westerberg (2):
      thunderbolt: Initialize HopID IDAs in tb_switch_alloc()
      thunderbolt: Increase runtime PM reference count on DP tunnel discovery

Niklas Schnelle (3):
      s390/pci: refactor zpci_create_device()
      s390/pci: remove superfluous zdev->zbus check
      s390/pci: fix leak of PCI device structure

Oleg Nesterov (3):
      kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()
      x86: Move TS_COMPAT back to asm/thread_info.h
      x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()

Olga Kornievskaia (1):
      NFSD: fix dest to src mount in inter-server COPY

Pan Bian (1):
      ext4: stop inode update before return

Pan Xiuli (1):
      ASoC: SOF: intel: fix wrong poll bits in dsp power down

Pavel Skripkin (1):
      net/qrtr: fix __netdev_alloc_skb call

Peter Zijlstra (1):
      static_call: Fix static_call_update() sanity check

Pierre-Louis Bossart (1):
      ASoC: SOF: Intel: unregister DMIC device on probe error

Rafael J. Wysocki (1):
      Revert "PM: runtime: Update device status before letting suppliers suspend"

Sagi Grimberg (5):
      nvme-tcp: fix misuse of __smp_processor_id with preemption enabled
      nvme-tcp: fix possible hang when failing to set io queues
      nvme-tcp: fix a NULL deref when receiving a 0-length r2t PDU
      nvmet: don't check iosqes,iocqes for discovery controllers
      nvme-rdma: fix possible hang when failing to set io queues

Sameer Pujar (1):
      ASoC: simple-card-utils: Do not handle device clock

Shawn Guo (1):
      efivars: respect EFI_UNSUPPORTED return from firmware

Shengjiu Wang (2):
      ASoC: ak4458: Add MODULE_DEVICE_TABLE
      ASoC: ak5558: Add MODULE_DEVICE_TABLE

Shijie Luo (1):
      ext4: fix potential error in ext4_do_update_inode

Srinivas Kandagatla (3):
      ASoC: qcom: sdm845: Fix array out of bounds access
      ASoC: qcom: sdm845: Fix array out of range on rx slim channels
      ASoC: codecs: wcd934x: add a sanity check in set channel map

Srinivasa Rao Mandadapu (1):
      ASoC: qcom: lpass-cpu: Fix lpass dai ids parse

Stefano Garzarella (2):
      vhost-vdpa: fix use-after-free of v->config_ctx
      vhost-vdpa: set v->config_ctx to NULL if eventfd_ctx_fdget() fails

Steve French (1):
      cifs: fix allocation size on newly created files

Sung Lee (1):
      drm/amd/display: Copy over soc values before bounding box creation

Takashi Sakamoto (1):
      ALSA: dice: fix null pointer dereference when node is disconnected

Tetsuo Handa (1):
      pstore: Fix warning in pstore_kill_sb()

Thomas Gleixner (2):
      x86/ioapic: Ignore IRQ2 again
      genirq: Disable interrupts for force threaded handlers

Timo Rothenpieler (1):
      svcrdma: disable timeouts on rdma backchannel

Trond Myklebust (1):
      nfsd: Don't keep looking up unhashed files in the nfsd file cache

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix potential drc_name corruption in store functions

Umesh Nerlige Ramappa (1):
      i915/perf: Start hrtimer only if sampling the OA buffer

Vincent Whitchurch (1):
      cifs: Fix preauth hash corruption

Wesley Cheng (2):
      usb: dwc3: gadget: Allow runtime suspend if UDC unbinded
      usb: dwc3: gadget: Prevent EP queuing while stopping transfers

Wilfried Wessner (1):
      iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask

William Breathitt Gray (1):
      counter: stm32-timer-cnt: Report count function when SLAVE_MODE_DISABLED

Xiaoliang Yu (2):
      ALSA: hda/realtek: apply pin quirk for XiaomiNotebook Pro
      ALSA: hda/realtek: Apply headset-mic quirks for Xiaomi Redmibook Air

Ye Xiang (3):
      iio: hid-sensor-humidity: Fix alignment issue of timestamp channel
      iio: hid-sensor-prox: Fix scale not correct issue
      iio: hid-sensor-temperature: Fix issues of timestamp channel

dongjian (1):
      scsi: ufs: ufs-mediatek: Correct operator & -> &&

zhangyi (F) (2):
      ext4: find old entry again if failed to rename whiteout
      ext4: do not try to set xattr into ea_inode if value is empty

